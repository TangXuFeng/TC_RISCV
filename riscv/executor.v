// 执行器模块接口定义
module executor    (
    input              clk
    ,input              rst_n
    ,input      [31:0]  opcode_decode
    ,input      [31:0]  instruction
    ,input      [5:0]   opcode
    ,input      [2:0]   funct3
    ,input      [6:0]   funct7
    ,input      [31:0]  immediate
    ,input      [31:0]  rs1_data
    ,input      [31:0]  rs2_data

    ,input      [31:0]  read_data
    ,input      [31:0]  pc

    ,input              wait_sig

    ,output reg [31:0]  pc_next
    ,output reg [31:0]  rd_data
    ,output reg [31:0]  alu_result
    ,output reg [31:0]  address
    ,output reg [31:0]  write_data
    ,output reg         write_data_sig

    ,output reg [31:0] internal_interrupts //内部中断
);

    wire [7:0] f3 = 7'b1 << funct3;

    wire [31:0] pc_inc;
    // 用于正常程序指针自增
    assign pc_inc = pc + ((opcode[1:0]!=2'b11) ? 32'h2 : 32'h4);



    wire [31:0] alu_result;
    reg [31:0] alu_a,alu_b;
    reg [4:0]  alu_op;

    parameter alu_eq=5'b10000;
    parameter alu_xor=5'b10000;
    parameter alu_or=5'b10000;
    parameter alu_and=5'b10000;
    parameter alu_sll=5'b10000;
    parameter alu_srl=5'b10000;
    parameter alu_sra=5'b10000;

    parameter alu_add=5'b01000;
    parameter alu_sub=5'b01001;
    parameter alu_slt=5'b01010;
    parameter alu_sltu=5'b01011;


    parameter alu_mul=5'b10000;
    parameter alu_mulh=5'b10000;
    parameter alu_mulhsu=5'b10000;
    parameter alu_mulhu=5'b10000;

    parameter alu_div=5'b10000;
    parameter alu_divu=5'b10000;
    parameter alu_rem=5'b10000;
    parameter alu_remu=5'b10000;

    parameter alu_nop=5'b11111;

    alu alu_inst(
        .alu_a(alu_a)
        ,.alu_b(alu_b)
        ,.alu_op(alu_op)
        ,.alu_result(alu_result)
    );


    always @(*) begin
        write_data_sig=1'b0;//除非写入内存,否则不应该是1
        alu_a = rs1_data;//基本都是rs1
        alu_b = rs2_data;//少数情况下是immediate或者其它
        rd_data = alu_result;//大部分都是alu的结果
        alu_op = alu_nop;//默认提供32'b0


        if(opcode_decode[0])begin
            // LOAD
            alu_b   = immediate;
            alu_op  = alu_add;
            address = alu_result;
            if(f3[0]) rd_data = {{24{read_data[7]}}, read_data[7:0]}; // LB
            if(f3[1]) rd_data = {{16{read_data[15]}}, read_data[15:0]}; // LH
            if(f3[2]) rd_data = read_data; // LW
            if(f3[4]) rd_data = {24'b0, read_data[7:0]}; // LBU
            if(f3[5]) rd_data = {16'b0, read_data[15:0]}; // LHU
        end


        if(opcode_decode[3])begin
            //fence , fence.i
            if(instruction[11:7]==5'b0 && instruction[19:15] == 5'b0 )begin
                if(f3[0] && immediate[11:8]==4'b0)begin
                    //什么都不会发生,因为没有流水线,没有需要屏障的地方
                end else if(f3[1] && immediate[11:0]==12'b0)begin
                    //同样什么都不会发生
                end 
            end
        end


        if(opcode_decode[4]) begin // I-type 算术逻辑
            alu_b = immediate;
            if(f3[0]) alu_op = alu_add;
            if(f3[2]) alu_op = alu_slt;
            if(f3[3]) alu_op = alu_sltu;
            if(f3[4]) alu_op = alu_xor;
            if(f3[6]) alu_op = alu_or;
            if(f3[7]) alu_op = alu_and;

            if(f3[1]) begin 
                alu_b  = immediate[4:0];
                alu_op = alu_sll;
            end

            if(funct7 == 7'b0100000) begin
                alu_b  = immediate[4:0];
                alu_op = alu_srl;
            end
            if(f3[5]&&funct7 == 7'b00000000)begin
                alu_b  = immediate[4:0];
                alu_op = alu_sra;
            end
        end


        if(opcode_decode[5]) begin // AUIPC
            alu_a = pc;
            alu_b = immediate;
        end


        if(opcode_decode[8]) begin // STORE
            alu_b      = immediate;
            address    = alu_result;
            write_data_sig    = 1'b1;
            if(f3[0]) write_data = {read_data[31:8], rs2_data[7:0]}; // SB
            if(f3[1]) write_data = {read_data[31:16], rs2_data[15:0]}; // SH
            if(f3[2]) write_data = rs2_data; // SW
        end


        if(opcode_decode[12]) begin // R-type 算术逻辑
            if(funct7 == 7'b0000000)begin
                if(f3[0])alu_op=alu_add;
                if(f3[1])begin
                    alu_b= rs2_data[4:0];
                    alu_op=alu_sll;
                end

                if(f3[2])alu_op=alu_slt;
                if(f3[3])alu_op=alu_sltu;
                if(f3[4])alu_op=alu_xor;
                if(f3[5])begin
                    alu_b=rs2_data[4:0];
                    alu_op=alu_srl;
                end
                if(f3[6])alu_op = alu_or;
                if(f3[7])alu_op=alu_and;
            end

            if(funct7 == 7'b00000001)begin
                if(f3[0]) alu_op=alu_mul;
                if(f3[1]) alu_op=alu_mulh;
                if(f3[2]) alu_op=alu_mulhsu;
                if(f3[3]) alu_op=alu_mulhu;
                if(f3[4]) alu_op=alu_div;
                if(f3[5]) alu_op=alu_divu;
                if(f3[6]) alu_op=alu_rem;
                if(f3[7]) alu_op=alu_remu;
            end

            if(funct7 == 7'b0100000)begin
                if(f3[0]) alu_op=alu_sub;
                if(f3[5])begin
                    alu_b=rs2_data[4:0];
                    alu_op=alu_sra;
                end
            end
        end


        if(opcode_decode[13]) begin // LUI
            rd_data = immediate;
        end


        if(opcode_decode[24]) begin // Branch
            alu_op = funct3[2]?(funct3[1]?alu_slt:alu_sltu):alu_eq;
            if(funct3[0]^alu_result[0]) pc_next = pc+immediate;
        end


        if(opcode_decode[25]&&f3[0]) begin // JALR
                rd_data = pc_inc;
                alu_b = immediate;
                pc_next = {alu_result[31:1],1'b0};//可能出现地址不对齐,指令要求
        end


        if(opcode_decode[27]) begin // JAL
            rd_data = pc_inc;
            alu_a = pc;
            alu_b = immediate;
            pc_next = alu_result;
        end


        if(opcode_decode[28])begin //ecall ebreak
            if(instruction[11:7]==5'b0 && instruction[19:16] == 4'b0 
                && funct3 ==3'b0 && immediate[11:0] == 12'b0 )begin
                if(immediate[0] ==0)begin
                    internal_interrupts = 32'h8000000d; // ecall
                end else begin
                    internal_interrupts = 32'h80000003; // ebreak
                end
            end else begin
            end
        end

    end
endmodule
