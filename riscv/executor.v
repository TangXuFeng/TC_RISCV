// 执行器模块接口定义
module executor
(
    // 输入信号
    input              clk
    ,input              rst_n
    ,input      [6:0]   opcode
    ,input      [2:0]   funct3
    ,input      [6:0]   funct7
    ,input      [31:0]  immediate
    ,input      [31:0]  rs1_data
    ,input      [31:0]  rs2_data
    ,input      [31:0]  pc
    ,input              opcode_c_mode
    ,input              memory_wait
    ,input      [31:0]  memory_read_data

    // 输出信号
    ,output reg [31:0]  pc_next
    ,output reg [31:0]  rd_data
    ,output reg [31:0]  mem_address
    ,output reg [31:0]  mem_write_data
    ,output reg         mem_read
    ,output reg         mem_write
);

wire [31:0] pc_inc, add_1_o, add_2_o, pc_mod_o;
wire [31:0] sub_o, slt_o, sltu_o, xor_o, or_o, and_o, sll_o, srl_o, sra_o;
reg  [31:0] add_1_a, add_1_b, add_2_a, add_2_b, pc_mod, cmp_a, cmp_b;
reg  [31:0] sub_a, sub_b, slt_a, slt_b, sltu_a, sltu_b, xor_a, xor_b;
reg  [31:0] or_a, or_b, and_a, and_b, sll_a, srl_a, sra_a;
reg  [4:0]  sll_shamt, srl_shamt, sra_shamt;
reg  [2:0]  cmp_lsx;
wire        cmp_o;

alu alu_inst(
    .pc(pc), .opcode_c_mode(opcode_c_mode),
             .pc_inc(pc_inc),
             .add_1_a(add_1_a), .add_1_b(add_1_b), .add_1_o(add_1_o),
             .add_2_a(add_2_a), .add_2_b(add_2_b), .add_2_o(add_2_o),
             .pc_mod(pc_mod), .pc_mod_o(pc_mod_o),
             .cmp_a(cmp_a), .cmp_b(cmp_b), .cmp_lsx(cmp_lsx), .cmp_o(cmp_o),
             .sub_a(sub_a), .sub_b(sub_b), .sub_o(sub_o),
             .slt_a(slt_a), .slt_b(slt_b), .slt_o(slt_o),
             .sltu_a(sltu_a), .sltu_b(sltu_b), .sltu_o(sltu_o),
             .xor_a(xor_a), .xor_b(xor_b), .xor_o(xor_o),
             .or_a(or_a), .or_b(or_b), .or_o(or_o),
             .and_a(and_a), .and_b(and_b), .and_o(and_o),
             .sll_a(sll_a), .sll_shamt(sll_shamt), .sll_o(sll_o),
             .srl_a(srl_a), .srl_shamt(srl_shamt), .srl_o(srl_o),
             .sra_a(sra_a), .sra_shamt(sra_shamt), .sra_o(sra_o)
);

always @(*) begin
// 默认值
pc_next        = pc_inc;
rd_data        = 32'b0;
mem_address   = 32'b0;
mem_write_data  = 32'b0;
mem_read   = 1'b0;
mem_write  = 1'b0;

add_1_a = 32'b0; add_1_b = 32'b0;
add_2_a = 32'b0; add_2_b = 32'b0;
pc_mod  = 32'b0;
cmp_a   = 32'b0; cmp_b = 32'b0; cmp_lsx = 3'b000;
sub_a   = 32'b0; sub_b = 32'b0;
slt_a   = 32'b0; slt_b = 32'b0;
sltu_a  = 32'b0; sltu_b = 32'b0;
xor_a   = 32'b0; xor_b = 32'b0;
or_a    = 32'b0; or_b  = 32'b0;
and_a   = 32'b0; and_b = 32'b0;
sll_a   = 32'b0; sll_shamt = 5'b0;
srl_a   = 32'b0; srl_shamt = 5'b0;
sra_a   = 32'b0; sra_shamt = 5'b0;

case(opcode[6:2])
    5'b01101: begin // LUI
    rd_data = immediate;
    end

    5'b00101: begin // AUIPC
    add_1_a = pc;
    add_1_b = immediate;
    rd_data = add_1_o;
    end

    5'b11011: begin // JAL
    rd_data = pc_inc;
    add_1_a = pc;
    add_1_b = immediate;
    pc_next = add_1_o;
    end

    5'b11001: begin // JALR
    if(funct3 == 3'b000) begin
        rd_data = pc_inc;
    add_1_a = rs1_data;
    add_1_b = immediate;
    pc_mod  = add_1_o;
    pc_next = pc_mod_o;
    end
    end

    5'b11000: begin // Branch
    cmp_a   = rs1_data;
    cmp_b   = rs2_data;
    cmp_lsx = funct3;
    add_1_a = pc;
    add_1_b = immediate;
    if(cmp_o) pc_next = add_1_o;
    end

    5'b00000: begin // LOAD
    add_1_a      = rs1_data;
    add_1_b      = immediate;
    mem_address = add_1_o;
    mem_read = 1'b1;
    case(funct3)
    3'b000: rd_data = {{24{memory_read_data[7]}}, memory_read_data[7:0]}; // LB
    3'b001: rd_data = {{16{memory_read_data[15]}}, memory_read_data[15:0]}; // LH
    3'b010: rd_data = memory_read_data; // LW
    3'b100: rd_data = {24'b0, memory_read_data[7:0]}; // LBU
    3'b101: rd_data = {16'b0, memory_read_data[15:0]}; // LHU
    endcase
    end
    5'b01000: begin // STORE
    add_1_a      = rs1_data;
    add_1_b      = immediate;
    mem_address  = add_1_o;
    mem_write    = 1'b1;
    case(funct3)
    3'b000: mem_write_data = {24'b0, rs2_data[7:0]}; // SB
    3'b001: mem_write_data = {16'b0, rs2_data[15:0]}; // SH
    3'b010: mem_write_data = rs2_data; // SW
    endcase
    end


    5'b01100: begin // R-type 算术逻辑
    case(funct3)
    3'b000: begin // ADD / SUB
    if(funct7 == 7'b0100000) begin
        sub_a = rs1_data; sub_b = rs2_data;
    rd_data = sub_o;
    end else begin
    add_1_a = rs1_data; add_1_b = rs2_data;
    rd_data = add_1_o;
    end
    end
    3'b001: begin // SLL
    sll_a = rs1_data; sll_shamt = rs2_data[4:0];
    rd_data = sll_o;
    end
    3'b010: begin // SLT
    slt_a = rs1_data; slt_b = rs2_data;
    rd_data = slt_o;
    end
    3'b011: begin // SLTU
    sltu_a = rs1_data; sltu_b = rs2_data;
    rd_data = sltu_o;
    end
    3'b100: begin // XOR
    xor_a = rs1_data; xor_b = rs2_data;
    rd_data = xor_o;
    end
    3'b101: begin // SRL / SRA
    if(funct7 == 7'b0100000) begin
        sra_a = rs1_data; sra_shamt = rs2_data[4:0];
    rd_data = sra_o;
    end else begin
    srl_a = rs1_data; srl_shamt = rs2_data[4:0];
    rd_data = srl_o;
    end
    end
    3'b110: begin // OR
    or_a = rs1_data; or_b = rs2_data;
    rd_data = or_o;
    end
    3'b111: begin // AND
    and_a = rs1_data; and_b = rs2_data;
    rd_data = and_o;
    end
    endcase
    end

 5'b00100: begin // I-type 算术逻辑
    case(funct3)
        3'b000: begin // ADDI
            add_1_a = rs1_data;
            add_1_b = immediate;
            rd_data = add_1_o;
        end

        3'b010: begin // SLTI
            slt_a = rs1_data;
            slt_b = immediate;
            rd_data = slt_o;
        end

        3'b011: begin // SLTIU
            sltu_a = rs1_data;
            sltu_b = immediate;
            rd_data = sltu_o;
        end

        3'b100: begin // XORI
            xor_a = rs1_data;
            xor_b = immediate;
            rd_data = xor_o;
        end

        3'b110: begin // ORI
            or_a = rs1_data;
            or_b = immediate;
            rd_data = or_o;
        end

        3'b111: begin // ANDI
            and_a = rs1_data;
            and_b = immediate;
            rd_data = and_o;
        end

        3'b001: begin // SLLI
            sll_a     = rs1_data;
            sll_shamt = immediate[4:0];
            rd_data   = sll_o;
        end

        3'b101: begin // SRLI / SRAI
            if(funct7 == 7'b0100000) begin
                sra_a     = rs1_data;
                sra_shamt = immediate[4:0];
                rd_data   = sra_o; // SRAI
            end else begin
                srl_a     = rs1_data;
                srl_shamt = immediate[4:0];
                rd_data   = srl_o; // SRLI
            end
        end
    endcase
end
endcase

end
endmodule
