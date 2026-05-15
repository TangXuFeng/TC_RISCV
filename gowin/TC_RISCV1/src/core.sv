module core(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        mem_ready,
    input  logic [31:0] rst_pc,
    output logic [31:0] mem_addr,
    inout  logic [31:0] mem_data,
    output logic        mem_write,
    output logic        mem_read
);
    logic [31:0] pc, next_pc;
    logic [31:0] instr;
    logic [6:0]  opcode;
    logic [4:0]  rs1, rs2, rd;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [31:0] r1, r2;
    logic [31:0] imm;
    logic        reg_write, alu_src, branch;
    logic        core_mem_write_cmd, core_mem_read_cmd;
    logic [31:0] alu_b, alu_y;
    logic        zero;

    logic [31:0] load_data_reg;
    logic [31:0] core_mem_addr;
    logic [31:0] core_mem_wdata;
    logic [31:0] core_mem_rdata;
    logic        load_forward;
    logic [31:0] load_forward_data;
    logic        dcache_write_pending;
    logic [31:0] dcache_write_addr;
    logic [31:0] dcache_write_data;
    logic        dcache_commit;

    logic [31:0] bus_addr;
    logic [31:0] bus_wdata;
    logic        bus_read;
    logic        bus_write;

    logic        icache_req;
    logic [31:0] icache_addr;
    logic        icache_mem_ready;

    typedef enum logic [1:0] {ARB_IDLE, ARB_LOAD, ARB_ICACHE, ARB_STORE} arb_state_t;
    arb_state_t arb_state;

    assign core_mem_addr = alu_y;
    assign core_mem_wdata = r2;
    assign core_mem_rdata = load_forward ? load_forward_data : load_data_reg;
    assign bus_addr = (arb_state == ARB_LOAD)  ? core_mem_addr :
                      (arb_state == ARB_ICACHE) ? icache_addr :
                      (arb_state == ARB_STORE) ? dcache_write_addr : 32'b0;
    assign bus_wdata = (arb_state == ARB_STORE) ? dcache_write_data : 32'b0;
    assign mem_addr = bus_addr;
    assign mem_write = (arb_state == ARB_STORE);
    assign mem_read  = (arb_state == ARB_LOAD) || (arb_state == ARB_ICACHE);
    assign mem_data  = mem_write ? bus_wdata : 32'bz;
    assign icache_mem_ready = (arb_state == ARB_ICACHE) ? mem_ready : 1'b0;

    icache u_icache(
        .clk(clk),
        .rst_n(rst_n),
        .addr(pc),
        .instr(instr),
        .mem_rdata(mem_data),
        .mem_ready(icache_mem_ready),
        .mem_read(icache_req),
        .mem_addr(icache_addr)
    );

    dcache u_dcache(
        .clk(clk),
        .rst_n(rst_n),
        .we(core_mem_write_cmd),
        .addr(alu_y),
        .wdata(r2),
        .load_addr(alu_y),
        .load_data(load_forward_data),
        .load_forward(load_forward),
        .write_pending(dcache_write_pending),
        .write_addr(dcache_write_addr),
        .write_data(dcache_write_data),
        .commit_write(dcache_commit)
    );

    pc u_pc(
        .clk(clk),
        .rst_n(rst_n),
        .rst_pc(rst_pc),
        .next_pc(next_pc),
        .pc(pc)
    );
    regfile u_rf(
        .clk(clk),
        .rst_n(rst_n),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wdata(core_mem_read_cmd ? core_mem_rdata : alu_y),
        .r1(r1),
        .r2(r2)
    );
    decode u_dec(
        .instr(instr),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );
    immgen u_imm(
        .instr(instr),
        .imm(imm)
    );
    control u_ctrl(
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_write(core_mem_write_cmd),
        .mem_read(core_mem_read_cmd),
        .branch(branch)
    );
    alu u_alu(
        .a(r1),
        .b(alu_b),
        .ctrl(funct3),
        .y(alu_y),
        .zero(zero)
    );
    branch_unit u_branch(
        .branch(branch),
        .zero(zero),
        .pc(pc),
        .imm(imm),
        .next_pc(next_pc)
    );

    assign alu_b = alu_src ? imm : r2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            arb_state <= ARB_IDLE;
            load_data_reg <= 32'b0;
            dcache_commit <= 1'b0;
        end else begin
            dcache_commit <= 1'b0;
            case (arb_state)
                ARB_IDLE: begin
                    if (core_mem_read_cmd && !load_forward) begin
                        arb_state <= ARB_LOAD;
                    end else if (icache_req) begin
                        arb_state <= ARB_ICACHE;
                    end else if (dcache_write_pending) begin
                        arb_state <= ARB_STORE;
                    end else begin
                        arb_state <= ARB_IDLE;
                    end
                end

                ARB_LOAD: begin
                    if (mem_ready) begin
                        load_data_reg <= mem_data;
                        arb_state <= ARB_IDLE;
                    end
                end

                ARB_ICACHE: begin
                    if (mem_ready) begin
                        arb_state <= ARB_IDLE;
                    end
                end

                ARB_STORE: begin
                    if (mem_ready) begin
                        dcache_commit <= 1'b1;
                        arb_state <= ARB_IDLE;
                    end
                end

                default: begin
                    arb_state <= ARB_IDLE;
                end
            endcase
        end
    end
endmodule
