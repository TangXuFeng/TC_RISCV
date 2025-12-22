module riscv (
    input  clk
    ,input  rst_n
    ,output done
);

    // Core <-> dual_load_memory (I-port)
    wire [31:0] pc;
    wire [31:0] instruction;

    // Core <-> memory / dual_load_memory (D-port)
    wire [31:0] d_addr;
    wire [31:0] d_wdata;
    wire [31:0] d_rdata;
    wire        d_ren;
    wire        d_wen;

    // dual_load_memory outputs
    wire [31:0] dlm_rdata;
    wire        dlm_selected;

    // memory outputs
    wire [31:0] mem_rdata;
    wire        mem_selected;

    wire        exception; //异常信号
    wire [31:0] exception_code;

    core #(
        .RST_PC_ADDRESS(32'h0000_0000)
    ) u_core (
        .clk            (clk)
        ,.rst_n          (rst_n)
        ,.pc             (pc)
        ,.instruction    (instruction)   // 来自 dual_load_memory

        ,.address        (d_addr)
        ,.read_data      (d_rdata)       // 来自 memory 或 dual_load_memory
        ,.write_data     (d_wdata)
        ,.write_data_sig (d_wen)
        ,.exception      (exception)
        ,.exception_code    (exception_code)
    );

    dual_load_memory #(
        .MMIO_BASE_MEMORY(32'h8000_0000),
        .MMIO_MASK_MEMORY(32'hFFFF_FF00) //掩码长度和内存大小有关,2^8=256byte
    ) u_dual_load_memory (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc         (pc),           // CPU 取指地址
        .instruction(instruction),  // 指令读出

        .address    (d_addr),       // CPU 数据地址
        .read_data  (dlm_rdata),    // 数据读出
        .write_data (d_wdata),      // CPU 写数据
        .write_data_sig (d_wen),        // CPU 写信号

        .selected   (dlm_selected)  // 地址命中
    );

    memory #(
        .MMIO_BASE_MEMORY(32'h9000_0000),
        .MMIO_MASK_MEMORY(32'hFFFF_FF00) //大内存综合器做不出来
    ) u_memory (
        .clk        (clk)
        ,.rst_n      (rst_n)

        ,.address    (d_addr)
        ,.read_data  (mem_rdata)
        ,.write_data (d_wdata)
        ,.write_data_sig         (d_wen)
        ,.selected   (mem_selected)
    );

    // 选择从哪个设备读取
    assign d_rdata = dlm_selected ? dlm_rdata 
                     :mem_selected ? mem_rdata
                     :32'b0;


endmodule
