// 单周期 RISC-V 核心（简化版）
// 支持：R/I（算术逻辑）、U（LUI/AUIPC）、J（JAL）、I（JALR）、B（分支）

//输出PC指针,取指,译码,读寄存器,[读内存],执行,写入寄存器,[写入内存]

module core #(
    // 重置后程序指针位置
    parameter RST_PC_ADDRESS=32'h0
)(
     input  [31:0] instruction
    ,output [31:0] pc
    ,input          clk
    ,input          rst_n
);


    wire [31:0] jump_pc;
    wire j;

    wire [4:0] rd_address,rs1_address,rs2_address;
    wire [31:0] rd_value,rs1_value,rs2_value;

    // 程序指针
    pc  #(
        .RST_PC_ADDRESS(RST_PC_ADDRESS)
    )pc_inst (
         .jump_pc(jump_pc)
        ,.j(j)
        ,.pc(pc)
        ,.clk(clk)
        ,.rst_n(rst_n)
    );

    //寄存器文件
    regfile regfile_inst (
        .rd_address(rd_address)
        ,.rs1_address(rs1_address)
        ,.rs2_address(rs2_address)
        ,.rd_value(rd_value)
        ,.rs1_value(rs1_value)
        ,.rs2_value(rs2_value)
        ,.clk(clk)
        ,.rst_n(rst_n)
    );

    //指令解码器
    instruction_decoder instruction_decoder_inst(
         .instruction(instruction)
        ,.state(state)
        ,.opcode(opcode)
        ,.rd(rd)
        ,.funct3(funct3)
        ,.rs1_address(rs1_address)
        ,.rs2_address(rs2_address)
        ,.funct7(funct7)
        ,.immediate(immediate)
    );














endmodule
