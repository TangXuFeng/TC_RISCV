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

    ,output reg [31:0]  pc_next
    ,output reg [31:0]  rd_data
    ,output reg [31:0]  address
    ,output reg [31:0]  write_data
    ,output reg         write_data_sig

    ,output reg [31:0] internal_interrupts //内部中断
);

    wire [7:0] f3 = 7'b1 << funct3;

    wire [31:0] pc_inc;
    // 用于正常程序指针自增
    assign pc_inc = pc + ((opcode[1:0]!=2'b11) ? 32'h2 : 32'h4);



    reg [31:0] alu_a,alu_b;
    reg [5:0]  alu_op;
    wire [31:0]  alu_result;


    alu alu_inst(
        .alu_a(alu_a)
        ,.alu_b(alu_b)
        ,.alu_op(alu_op)
        ,.alu_result(alu_result)
    );
    wire [31:0] tmp;
    always @(*) begin
        write_data_sig=1'b0;//除非写入内存,否则不应该是1
        alu_a = rs1_data;//基本都是rs1
        alu_b = rs2_data;//少数情况下是immediate或者其它
        rd_data = alu_result;//大部分都是alu的结果
        alu_op = {1'b0,funct7==7'b0000001,funct7==7'b0100000,funct3};//默认提供32'b0
        address = 32'b0;
        write_data = 32'b0;

        if(opcode_decode[0])begin
            // LOAD
            alu_b   = immediate;
            alu_op = {1'b0,funct7==7'b0000001,funct7==7'b0100000,3'b000};
            address = alu_result & ~ 32'b11;
            if(f3[0]==1'b0) tmp = read_data >> alu_result[1:0];
            if(f3[0]==1'b1) tmp = read_data >> alu_result[1];
            tmp = read_data>>alu_result[1:0];
            if(f3[0]) rd_data = {{24{read_data[7]}}, tmp[7:0]}; // LB
            if(f3[1]) rd_data = {{16{read_data[15]}}, tmp[15:0]}; // LH
            if(f3[2]) rd_data = read_data; // LW
            if(f3[4]) rd_data = {24'b0, tmp[7:0]}; // LBU
            if(f3[5]) rd_data = {16'b0, tmp[15:0]}; // LHU
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
            if(funct3 == 3'b001|| funct3 == 3'b101)alu_op = {1'b0,1'b0,immediate[10],funct3};
            alu_b = immediate;
        end


        if(opcode_decode[5]) begin // AUIPC
            alu_a = pc;
            alu_b = immediate;
        end


        if(opcode_decode[8]) begin // STORE
            alu_b      = immediate;
            address    = alu_result & ~32'b11;
            write_data_sig    = 1'b1;
            alu_op = {1'b0,funct7==7'b0000001,funct7==7b'0100000,3'b000};

            if(f3[0])begin

                write_data = alu_result[1:0]==2'b0?
                             {read_data[31:8], rs2_data[7:0]} // SB
                             :alu_result[1:0]==2'b1?{read_data[31:16], rs2_data[7:0],read_data[7:0]}
                             :alu_result[1:0]==2'b10?{read_data[31:24], rs2_data[7:0],read_data[15:8]}
                             :alu_result[1:0]==2'b11?{rs2_data[7:0],read_data[23:16]}
                                                  :32'b0;
            end
            if(f3[1])begin
                write_data = alu_result[1]==1'b0?
                             {read_data[31:16], rs2_data[15:0]} // SB
                             :alu_result[1]==1'b1?{rs2_data[15:0],read_data[15:0]}
                                                  :32'b0;
 
            end
            if(f3[2]) write_data = rs2_data; // SW
        end


        if(opcode_decode[12]) begin // R-type 算术逻辑
            // 没什么需要做的
        end


        if(opcode_decode[13]) begin // LUI
            rd_data = immediate;
        end


        if(opcode_decode[24]) begin // Branch
            alu_op = {1'b1,funct7==7'b0000001,funct7==7b'0100000,funct3};


            if(alu_result[0]) pc_next = pc+immediate[31:1];
        end


        if(opcode_decode[25]&&f3[0]) begin // JALR
            rd_data = pc_inc;
            alu_b = immediate;
            alu_op = {1'b0,funct7==7'b0000001,funct7==7b'0100000,3'b000};
            pc_next = {alu_result[31:1],1'b0};//可能出现地址不对齐,指令要求
        end


        if(opcode_decode[27]) begin // JAL
            rd_data = pc_inc;
            alu_a = pc;
            alu_b = immediate;
            alu_op = {1'b0,funct7==7'b0000001,funct7==7b'0100000,3'b000};
            pc_next = {alu_result[31:1],1'b0};
        end


        if(opcode_decode[28])begin //ecall ebreak
            if(instruction[11:7]==5'b0 && instruction[19:16] == 4'b0 
                && funct3 ==3'b0 && immediate[11:0] == 12'b0 )begin
                    if(immediate[0] ==0)begin
                        internal_interrupts = 32'h8000000b; // ecall
                    end else begin
                        internal_interrupts = 32'h80000003; // ebreak
                    end
                end else begin
                end
        end
    end
endmodule
