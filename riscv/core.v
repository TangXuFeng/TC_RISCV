// 单周期 RISC-V 核心（简化版）
// 支持：R/I（算术逻辑）、U（LUI/AUIPC）、J（JAL）、I（JALR）、B（分支）

module core #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS=32'h0
)(
    input          clk
    ,input          rst_n
    ,input  [31:0]  instruction
    ,output [31:0]  pc
);

// 跳转相关
wire [31:0] pc_next;

// 寄存器文件接口
wire [4:0]  rd_address;
wire [4:0]  rs1_address;
wire [4:0]  rs2_address;
wire [31:0] rd_data;
wire [31:0] rs1_data;
wire [31:0] rs2_data;

// 解码器输出
wire [2:0]  funct3;
wire [6:0]  funct7;
wire [31:0] immediate;
wire [6:0]  opcode;
wire [4:0]  rd;
wire        opcode_c_mode;

// 执行器输出
wire [31:0] mem_addr_out;
wire [31:0] mem_wdata_out;
wire        mem_read_out;
wire        mem_write_out;
wire [31:0] writeback_data;

// 内存接口（访存阶段）
wire [31:0] memory_address;
wire        memory_read;
wire        memory_write;
wire [31:0] memory_write_data;
wire [31:0] memory_read_data;

// 程序指针
pc  #(
    .RST_PC_ADDRESS(RST_PC_ADDRESS)
) pc_inst (
     .clk(clk)
    ,.rst_n(rst_n)
    ,.pc(pc)
    ,.pc_next(pc_next)
);

// 寄存器文件
regfile regfile_inst (
    .rd_address(rd_address)
    ,.rs1_address(rs1_address)
    ,.rs2_address(rs2_address)
    ,.rd_data(rd_data)
    ,.rs1_data(rs1_data)
    ,.rs2_data(rs2_data)
    ,.clk(clk)
    ,.rst_n(rst_n)
);

// 指令解码器
instruction_decoder instruction_decoder_inst (
    .instruction(instruction)
    ,.opcode(opcode)
    ,.rd(rd)
    ,.funct3(funct3)
    ,.rs1_address(rs1_address)
    ,.rs2_address(rs2_address)
    ,.funct7(funct7)
    ,.immediate(immediate)
    ,.opcode_c_mode(opcode_c_mode)
);

// 执行器
executor executor_inst (
    .clk(clk)
    ,.rst_n(rst_n)
    ,.rd_data(rd_data)         // 寄存器写回数据
    ,.rs1_data(rs1_data)       // 源寄存器1数据
    ,.rs2_data(rs2_data)       // 源寄存器2数据
    ,.pc(pc)                   // 当前地址指针
    ,.opcode_c_mode(opcode_c_mode)
    ,.memory_address(memory_address)       // 访存地址
    ,.memory_read(memory_read)             // 访存读使能
    ,.memory_write(memory_write)           // 访存写使能
    ,.memory_write_data(memory_write_data) // 访存写数据
    ,.memory_read_data(memory_read_data)   // 访存读数据

    // 输出端口
    ,.pc_next(pc_next)
    ,.mem_addr_out(mem_addr_out)
    ,.mem_wdata_out(mem_wdata_out)
    ,.mem_read_out(mem_read_out)
    ,.mem_write_out(mem_write_out)
    ,.writeback_data(writeback_data)
);

endmodule
