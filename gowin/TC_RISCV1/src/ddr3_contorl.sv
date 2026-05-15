//ai写的,仅供参考，未测试

module ddr3_ctrl #(
    parameter ADDR_WIDTH = 28,   // 线性地址宽度
    parameter ROW_WIDTH  = 14,
    parameter COL_WIDTH  = 10,
    parameter BANK_WIDTH = 3,
    parameter DATA_WIDTH = 16
)(
    input  logic            clk,        // 控制器工作时钟（已与 DDR 时钟域处理好）
    input  logic            rst_n,

    // 用户侧简单接口
    input  logic            app_req_valid,
    input  logic            app_req_write,   // 0=读,1=写
    input  logic [ADDR_WIDTH-1:0] app_req_addr,
    input  logic [63:0]      app_req_wdata,   // 一次请求 64bit，内部拆成多拍
    output logic             app_req_ready,

    output logic             app_rdata_valid,
    output logic [63:0]      app_rdata,

    // DDR3 芯片侧（对上你图里的信号名）
    output logic [13:0]      DDR3_A,      // A0..A13
    output logic [2:0]       DDR3_BA,     // BA0..BA2
    output logic             DDR3_WE,
    output logic             DDR3_RAS,
    output logic             DDR3_CAS,
    output logic             DDR3_RST,
    output logic             DDR3_CS0,
    output logic             DDR3_ODT0,
    output logic             DDR3_CKE0,
    output logic             DDR3_CK_P,
    output logic             DDR3_CK_N,

    inout  logic [15:0]      DDR3_DQ,
    inout  logic             DDR3_DQSL_P,
    inout  logic             DDR3_DQSL_N,
    inout  logic             DDR3_DQSU_P,
    inout  logic             DDR3_DQSU_N,
    output logic             DDR3_UDM,
    output logic             DDR3_LDM

    // VREF/VDD/VSS 等电源相关不在逻辑里管
);
localparam CMD_NOP  = 3'b111;
localparam CMD_ACT  = 3'b011;
localparam CMD_READ = 3'b101;
localparam CMD_WRITE= 3'b100;
localparam CMD_PRE  = 3'b010;
localparam CMD_REF  = 3'b001;
localparam CMD_MRS  = 3'b000;

logic [2:0] cmd;  // 映射到 RAS/CAS/WE
always_comb begin
    case (cmd)
        CMD_NOP:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b111;
        CMD_ACT:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b011;
        CMD_READ:  {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b101;
        CMD_WRITE: {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b100;
        CMD_PRE:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b010;
        CMD_REF:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b001;
        CMD_MRS:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b000;
        default:   {DDR3_RAS, DDR3_CAS, DDR3_WE} = 3'b111;
    endcase
end
typedef enum logic [3:0] {
    ST_RESET,
    ST_INIT,
    ST_IDLE,
    ST_ACT,
    ST_WAIT_TRCD,
    ST_READ,
    ST_WRITE,
    ST_WAIT_CL,
    ST_WAIT_WR,
    ST_PRE,
    ST_WAIT_TRP,
    ST_REF,
    ST_WAIT_TRFC
} state_t;

state_t state, next_state;

logic [15:0] timer;  // 通用等待计数器
logic [ROW_WIDTH-1:0]  cur_row;
logic [BANK_WIDTH-1:0] cur_bank;
logic [COL_WIDTH-1:0] cur_col;

// 简单线性地址拆分：高位 row，中间 bank，低位 col
logic [ROW_WIDTH-1:0]  addr_row  = app_req_addr[ADDR_WIDTH-1 -: ROW_WIDTH];
logic [BANK_WIDTH-1:0] addr_bank = app_req_addr[COL_WIDTH +: BANK_WIDTH];
logic [COL_WIDTH-1:0] addr_col  = app_req_addr[COL_WIDTH-1:0];
localparam tRCD  = 8;   // ACT 到 READ/WRITE
localparam tRP   = 8;   // PRE 到 ACT
localparam tRAS  = 20;  // ACT 到 PRE
localparam tRFC  = 80;  // REF 周期
localparam tCL   = 8;   // CAS Latency
localparam tCWL  = 6;   // CAS Write Latency
localparam tWR   = 8;   // 写恢复
localparam tREFI = 7800; // 刷新间隔（按时钟换算）
logic [15:0] ref_cnt;
logic        ref_req;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ref_cnt <= 0;
        ref_req <= 0;
    end else begin
        if (ref_cnt >= tREFI) begin
            ref_cnt <= 0;
            ref_req <= 1;
        end else if (state == ST_REF) begin
            ref_req <= 0;
        end else begin
            ref_cnt <= ref_cnt + 1;
        end
    end
end
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= ST_RESET;
        DDR3_RST  <= 1'b0;
        DDR3_CKE0 <= 1'b0;
        DDR3_CS0  <= 1'b0;
        cmd       <= CMD_NOP;
        app_req_ready  <= 1'b0;
        app_rdata_valid<= 1'b0;
    end else begin
        state <= next_state;
        // timer 递减
        if (timer != 0)
            timer <= timer - 1;
    end
end

always @(*) begin
    next_state      = state;
    cmd             = CMD_NOP;
    app_req_ready   = 1'b0;
    app_rdata_valid = 1'b0;

    case (state)
        ST_RESET: begin
            // 上电复位一段时间
            // 然后进入初始化状态
            next_state = ST_INIT;
        end

        ST_INIT: begin
            // 这里按 JEDEC 流程发 MRS、ZQCL 等
            // 简化：假装已经初始化完
            DDR3_RST  = 1'b1;
            DDR3_CKE0 = 1'b1;
            next_state = ST_IDLE;
        end

        ST_IDLE: begin
            app_req_ready = 1'b1;
            if (ref_req) begin
                // 做刷新
                cmd        = CMD_PRE; // PREA
                DDR3_A[10] = 1'b1;    // A10=1 表示 PREA
                timer      = tRP;
                next_state = ST_WAIT_TRP;
            end else if (app_req_valid) begin
                // 接收请求，记录地址
                cur_row  = addr_row;
                cur_bank = addr_bank;
                cur_col  = addr_col;

                // 直接 ACT
                DDR3_A   = addr_row;
                DDR3_BA  = addr_bank;
                cmd      = CMD_ACT;
                timer    = tRCD;
                next_state = ST_WAIT_TRCD;
            end
        end

        ST_WAIT_TRCD: begin
            if (timer == 0) begin
                if (app_req_write) begin
                    // 写
                    DDR3_A   = {4'b0000, cur_col}; // 简化
                    DDR3_BA  = cur_bank;
                    cmd      = CMD_WRITE;
                    timer    = tCWL;
                    next_state = ST_WRITE;
                end else begin
                    // 读
                    DDR3_A   = {4'b0000, cur_col};
                    DDR3_BA  = cur_bank;
                    cmd      = CMD_READ;
                    timer    = tCL;
                    next_state = ST_READ;
                end
            end
        end

        ST_READ: begin
            if (timer == 0) begin
                // 这里从 PHY 取数据，简化成占位
                app_rdata       = 64'hDEADBEEF_DEADBEEF;
                app_rdata_valid = 1'b1;

                // 读完直接 PRE
                DDR3_A[10] = 1'b0; // 单 Bank PRE
                DDR3_BA    = cur_bank;
                cmd        = CMD_PRE;
                timer      = tRP;
                next_state = ST_WAIT_TRP;
            end
        end

        ST_WRITE: begin
            if (timer == 0) begin
                // 这里把 app_req_wdata 分拍送到 DQ，略
                // 写完等 tWR 再 PRE
                timer      = tWR;
                next_state = ST_WAIT_WR;
            end
        end

        ST_WAIT_WR: begin
            if (timer == 0) begin
                DDR3_A[10] = 1'b0;
                DDR3_BA    = cur_bank;
                cmd        = CMD_PRE;
                timer      = tRP;
                next_state = ST_WAIT_TRP;
            end
        end

        ST_WAIT_TRP: begin
            if (timer == 0) begin
                if (ref_req) begin
                    // 发 REF
                    cmd        = CMD_REF;
                    timer      = tRFC;
                    next_state = ST_WAIT_TRFC;
                end else begin
                    next_state = ST_IDLE;
                end
            end
        end

        ST_WAIT_TRFC: begin
            if (timer == 0) begin
                next_state = ST_IDLE;
            end
        end

        default: next_state = ST_IDLE;
    endcase
end

endmodule