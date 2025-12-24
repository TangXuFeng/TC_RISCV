module alu #(
    parameter ENABLE_RV32M=0 //勇士,真的要生成硬件乘法器吗?
)(
    input  [31:0] alu_a
    ,input  [31:0] alu_b
    ,input  [4:0]  alu_op

    ,output reg [31:0] alu_result
);


    parameter alu_add=  5'b00000;
    parameter alu_sll=  5'b00001;
    parameter alu_slt=  5'b00010;
    parameter alu_sltu= 5'b00011;
    parameter alu_xor=  5'b00100;
    parameter alu_srl=  5'b00101;
    parameter alu_or=   5'b00110;
    parameter alu_and=  5'b00111;
    
    parameter alu_sub=5'b01000;
    parameter alu_sra=  5'b01101;

    parameter alu_eq=5'b11000;

    parameter alu_mul=5'b10000;
    parameter alu_mulh=5'b10001;
    parameter alu_mulhsu=5'b10010;
    parameter alu_mulhu=5'b10011;
    parameter alu_div=5'b10100;
    parameter alu_divu=5'b10101;
    parameter alu_rem=5'b10110;
    parameter alu_remu=5'b10111;

    reg [63:0] tmp;
    always @(*)begin
        alu_result = 32'b0;
        tmp = 64'b0;

        if(alu_op==alu_add || alu_op==alu_sub)alu_result = alu_a + alu_op[3]?-alu_b:alu_b;
        if(alu_op[4:3] == 2'b00)begin
            case(alu_op[2:0])
                3'b001:alu_result = alu_a << alu_b[4:0];
                3'b010:alu_result = $signed(alu_a) < $signed(alu_b)?32'b1:32'b0; 
                3'b011:alu_result = alu_a < alu_b ? 32'b1:32'b0;
                3'b100:alu_result = alu_a ^ alu_b;
                3'b101:alu_result = alu_a >> alu_b[4:0];
                3'b110:alu_result = alu_a | alu_b;
                3'b111:alu_result = alu_a & alu_b;
            endcase
        end
        if(alu_op==alu_sra) alu_result =  $signed(alu_a) >>> alu_b[4:0]; 
        if(alu_op==alu_eq)  alu_result = alu_a == alu_b ? 32'b1:32'b0;


        // 乘法器和除法器后续再弄成中断处理多周期除法器
        //generate
            //TC实现中为了节约几个乘法器和除法器
            //对输入先判断是否是负数
            //然后取绝对值(如果是负数,就取反,变成正数)
            //计算后,根据输入符号判断是否需要再次取负
            //负数乘除正数结果为负数,需要取负恢复结果正确性
            //负数乘除负数,正数乘除正数结果为正,无需取负
            if(ENABLE_RV32M)begin
                if(alu_op[4:3]==2'b10)begin
                    case(alu_op[2:0])
                        3'b000,3'b001:tmp = (alu_a*alu_b);
                        3'b010:tmp = $signed(alu_a) * alu_b;
                        3'b011:tmp = $signed(alu_a) * $signed(alu_b);

                        3'b100:tmp = (alu_b == 0) ? 32'hFFFFFFFF : $signed(alu_a) / $signed(alu_b);
                        3'b101:tmp = (alu_b == 0) ? 32'hFFFFFFFF : alu_a / alu_b;
                        3'b110:tmp = (alu_b == 0) ? alu_a : $signed(alu_a) % $signed(alu_b);
                        3'b111:tmp = (alu_b == 0) ? alu_a : alu_a % alu_b;
                    endcase
                    if(alu_op[2:0]==3'b0 || alu_op[2:1]==3'b10)alu_result=tmp[31:0];
                    else alu_result=tmp[63:0];
                end
            end else begin
                //留给中断处理
            end
        //endgenerate


    end
endmodule

