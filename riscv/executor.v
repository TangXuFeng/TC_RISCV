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
    ,input      [31:0]  memory_address
    ,input              memory_read
    ,input              memory_write
    ,input      [31:0]  memory_write_data
    ,input      [31:0]  memory_read_data

    // 输出信号（示例，可根据设计需求调整）
    ,output reg [31:0]  pc_next
    ,output reg [31:0]  rd_data
    ,output reg [31:0]  mem_addr_out    // 输出给内存的地址
    ,output reg [31:0]  mem_wdata_out   // 输出给内存的写数据
    ,output reg         mem_read_out    // 内存读使能
    ,output reg         mem_write_out   // 内存写使能
    ,output reg [31:0]  writeback_data  // 写回寄存器的数据
);

wire [31:0] pc_inc,add_1_o,add_2_o,pc_mod_o;
reg  [31:0] add_1_a, add_1_b, add_2_a, add_2_b, pc_mod, cmp_a, cmp_b;
reg  [2:0]  cmp_lsx;
wire        cmp_o;

alu alu_inst(
     .pc(pc)
    ,.pc_inc(pc_inc)
    ,.add_1_a(add_1_a)
    ,.add_1_b(add_1_b)
    ,.add_1_o(add_1_o)
    ,.add_2_a(add_2_a)
    ,.add_2_b(add_2_b)
    ,.add_2_o(add_2_o)
    ,.pc_mod(pc_mod)
    ,.pc_mod_o(pc_mod_o)
    ,.cmp_a(cmp_a)
    ,.cmp_b(cmp_b)
    ,.cmp_lsx(cmp_lsx)
    ,.cmp_o(cmp)
);

// 为了节省加法器开销,所有运算都走ALU
always @(*)begin

    pc_next=pc_inc;

    add_1_a = 32'b0;
    add_1_b = 32'b0;
    add_2_a = 32'b0;
    add_2_b = 32'b0;
    pc_mod  = 32'b0;
    cmp_a   = 32'b0;
    cmp_b   = 32'b0;
    cmp_lsx = 3'b000;

    rd_data = 32'b0;
    case(opcode[6:2])

        // lui rd, immediate        x[rd] = sext(immediate[31:12] << 12)
        5'b01011:begin
            rd_data = immediate;
        end

        // auipc rd, immediate        x[rd] = pc + sext(immediate[31:12] << 12)
        5'b00101:begin
            add_1_a = pc;
            add_1_b = immediate;
            rd_data = add_1_o;
        end

         // jal rd, offset        x[rd] = pc+4; pc += sext(offset)
        5'b11011:begin
            rd_data = pc_inc;
            add_1_a = pc;
            add_1_b = immediate;
            pc_next = add_1_o;
        end

        // jalr rd, offset(rs1)        t=pc+4; pc=(x[rs1]+sext(offset))&∼1; x[rd]=t
        5'b11001:begin
            if(funct3 == 3'b0) begin
                rd_data=pc_inc;
                add_1_a = rs1_data;
                add_1_b = immediate;
                pc_mod  = add_1_o;
                pc_next = pc_mod_o;
            end
        end

        // beq rs1, rs2, offset        if (rs1 == rs2) pc += sext(offset)
        // 以及其它共6条B指令
        5'b11000:begin
            cmp_a = rs1_data;
            cmp_b = rs2_data;
            cmp_lsx = funct3;
            add_1_a = pc;
            add_1_b = immediate;
            if(cmp_o)begin
                pc_next = add_1_o;
            end
        end

        // lb rd, offset(rs1)        x[rd] = sext(M[x[rs1] + sext(offset)][7:0])
        // 读内存指令
        5'b00000:begin
            add_1_a = rs1_data;
            add_1_b = immediate;
            //todo 还需要做
        end

        default:begin

        end
    endcase
end


endmodule
