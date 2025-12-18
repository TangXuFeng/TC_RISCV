// 指令解码器 (合并多个 case 分支)
module instruction_decoder(
    input  [31:0] instruction
    ,output reg [6:0]  opcode
    ,output reg [4:0]  rd
    ,output reg [2:0]  funct3
    ,output reg [4:0]  rs1_address
    ,output reg [4:0]  rs2_address
    ,output reg [6:0]  funct7
    ,output reg [31:0] immediate
    ,output reg        opcode_c_mode
);

always @(*) begin
    // 默认值
    opcode       = instruction[6:0];
    rd           = 5'b0;
    funct3       = 3'b0;
    rs1_address  = 5'b0;
    rs2_address  = 5'b0;
    funct7       = 7'b0;
    immediate    = 32'b0;

    // 压缩指令直接忽略
    if (instruction[1:0] != 2'b11) begin
        opcode = 7'b0;
        opcode_c_mode = 1'b1;
        //如果要实现压缩指令,这里需要重新处理opcode,解压到长指令

    end else begin
    case (instruction[6:2])
    // U 型指令：LUI / AUIPC
    5'b01101, 5'b00101: begin
        rd        = instruction[11:7];
        immediate = {instruction[31:12], 12'b0};
    end

    // J 型指令：JAL
    5'b11011: begin
        rd        = instruction[11:7];
        immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20],
        instruction[30:25], instruction[24:21], 1'b0};
    end

    // I 型指令：JALR / LOAD / ALU Imm
    5'b11001, 5'b00000, 5'b00100: begin
        rd           = instruction[11:7];
        rs1_address  = instruction[19:15];
        funct3       = instruction[14:12];
        immediate    = {{20{instruction[31]}}, instruction[31:20]};
    end

    // S 型指令：STORE
    5'b01000: begin
        rs1_address  = instruction[19:15];
        rs2_address  = instruction[24:20];
        funct3       = instruction[14:12];
        immediate    = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    end

    // B 型指令：BRANCH
    5'b11000: begin
        rs1_address  = instruction[19:15];
        rs2_address  = instruction[24:20];
        funct3       = instruction[14:12];
        immediate    = {{19{instruction[31]}}, instruction[31], instruction[7],
        instruction[30:25], instruction[11:8], 1'b0};
    end

    // R 型指令：ALU Reg
    5'b01100: begin
        rd           = instruction[11:7];
        rs1_address  = instruction[19:15];
        rs2_address  = instruction[24:20];
        funct3       = instruction[14:12];
        funct7       = instruction[31:25];
    end

    default: begin
    // 其他未实现指令保持默认
    end
    endcase
    end
end

endmodule
