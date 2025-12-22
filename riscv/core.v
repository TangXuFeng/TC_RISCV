// 单周期 RISC-V 核心（简化版）
// 支持：R/I（算术逻辑）、U（LUI/AUIPC）、J（JAL）、I（JALR）、B（分支）、LOAD/STORE

module core #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS = 32'h0
)(
    input          clk
    ,input          rst_n
    ,output [31:0]  pc          //程序指针,传递给双加载内存
    ,input  [31:0]  instruction //指令

    ,output [31:0]  address     // 数据存储器地址
    ,input  [31:0]  read_data   // 数据存储器读出的数据
    ,output [31:0]  write_data  // 数据存储器写数据
    ,output         write_data_sig       // 1=写,通过地址判断是否读写
    ,output         exception
    ,output         exception_code
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

    // 执行器输出
    wire [31:0] rd_data;

    // 程序指针
    pc #(
        .RST_PC_ADDRESS(RST_PC_ADDRESS)
    ) pc_inst (
        .clk(clk)
        ,.rst_n(rst_n)
        ,.pc(pc)
        ,.pc_next(pc_next)
    );

    // 寄存器文件
    regfile regfile_inst (
        .clk(clk)
        ,.rst_n(rst_n)
        ,.rd_address(rd)
        ,.rs1_address(rs1_address)
        ,.rs2_address(rs2_address)
        ,.rd_data(rd_data)       // 写回数据
        ,.rs1_data(rs1_data)
        ,.rs2_data(rs2_data)
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
    );

    // 执行器
    executor executor_inst (
        .clk(clk)
        ,.rst_n(rst_n)
        ,.instruction(instruction)
        ,.opcode(opcode)
        ,.funct3(funct3)
        ,.funct7(funct7)
        ,.immediate(immediate)
        ,.rs1_data(rs1_data)
        ,.rs2_data(rs2_data)
        ,.pc(pc)
        ,.wait_sig(1'b0)              

        ,.pc_next(pc_next)
        ,.rd_data(rd_data)
        
        ,.address(address)
        ,.read_data(read_data)
        ,.write_data(write_data)
        ,.write_data_sig(write_data_sig)
        ,.exception(exception)
        ,.exception_code(exception_code)
    );

endmodule
