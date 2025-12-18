// 单周期 RISC-V 核心（简化版）
// 支持：R/I（算术逻辑）、U（LUI/AUIPC）、J（JAL）、I（JALR）、B（分支）、LOAD/STORE

module core #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS = 32'h0
)(
    input          clk,
  input          rst_n,
  input  [31:0]  instruction,
  input  [31:0]  memory_read_data,   // 数据存储器读出的数据
  output [31:0]  pc,
  output [31:0]  memory_address,     // 数据存储器地址
  output [31:0]  memory_write_data,  // 数据存储器写数据
  output         memory_read,        // 数据存储器读使能
  output         memory_write        // 数据存储器写使能
);

// 跳转相关
wire [31:0] pc_next;

// 寄存器文件接口
wire [4:0]  rs1_address;
wire [4:0]  rs2_address;
wire [31:0] rs1_data;
wire [31:0] rs2_data;

// 解码器输出
wire [6:0]  opcode;
wire [4:0]  rd;
wire [2:0]  funct3;
wire [6:0]  funct7;
wire [31:0] immediate;
wire        opcode_c_mode;

// 执行器输出
wire [31:0] rd_data;

// 程序指针
pc #(
    .RST_PC_ADDRESS(RST_PC_ADDRESS)
) pc_inst (
    .clk(clk),
           .rst_n(rst_n),
           .pc(pc),
           .pc_next(pc_next)
);

// 寄存器文件
regfile regfile_inst (
    .rd_address(rd),
                      .rs1_address(rs1_address),
                      .rs2_address(rs2_address),
                      .rd_data(rd_data),       // 写回数据
                      .rs1_data(rs1_data),
                      .rs2_data(rs2_data),
                      .clk(clk),
                      .rst_n(rst_n)
);

// 指令解码器
instruction_decoder instruction_decoder_inst (
    .instruction(instruction),
                                              .opcode(opcode),
                                              .rd(rd),
                                              .funct3(funct3),
                                              .rs1_address(rs1_address),
                                              .rs2_address(rs2_address),
                                              .funct7(funct7),
                                              .immediate(immediate),
                                              .opcode_c_mode(opcode_c_mode)
);

// 执行器
executor executor_inst (
    .clk(clk),
                        .rst_n(rst_n),
                        .opcode(opcode),
                        .funct3(funct3),
                        .funct7(funct7),
                        .immediate(immediate),
                        .rs1_data(rs1_data),
                        .rs2_data(rs2_data),
                        .pc(pc),
                        .opcode_c_mode(opcode_c_mode),
                        .memory_wait(1'b0),              // 简化版暂时不考虑访存等待
                        .memory_read_data(memory_read_data),

                        // 输出端口
                        .pc_next(pc_next),
                        .rd_data(rd_data),
                        .mem_address(memory_address),
                        .mem_write_data(memory_write_data),
                        .mem_read(memory_read),
                        .mem_write(memory_write)
);

endmodule
