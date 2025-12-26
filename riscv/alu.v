module alu #(
    parameter ENABLE_RV32M=0 //勇士,真的要生成硬件乘法器吗?
)(
    input  [31:0] alu_a
    ,input  [31:0] alu_b
    ,input  [5:0]  alu_op

    ,output reg [31:0] alu_result
);
    //alu_op:
    //条件判断1'b1,funct7[0]  ,funct7[5],funct3[2:0]



    reg [63:0] tmp;

    wire eq  = alu_a == alu_b;
    wire lt  = $signed(alu_a) < $signed(alu_b);
    wire ltu = alu_a < alu_b;

    always @(*)begin
        alu_result = 32'b0;
        tmp = 64'b0;
        if(alu_op[5]==1'b1)begin

            //beq  000 a=b
            //bne  001 a!=b 
            //bge  101 a>=b signed
            //bgeu 111 a>=b unsigned
            //blt  100 a<b  signed
            //bltu 110 a<b  unsigned           
            alu_result = (alu_op[0]^(alu_op[2]?(alu_op[1]?lt:ltu):eq))?32'b1:32'b0;

        end else begin
            if(alu_op[4] == 1'b0)begin
                case(alu_op[2:0])
                    3'b000:alu_result = alu_a + (alu_op[3]?-alu_b +1:alu_b); //add sub
                    3'b001:alu_result = alu_a << alu_b[4:0]; //sll
                    3'b010:alu_result = lt?32'b1:32'b0; 
                    3'b011:alu_result = ltu ? 32'b1:32'b0;
                    3'b100:alu_result = alu_a ^ alu_b;
                    3'b101:alu_result = alu_op[3]?$signed(alu_a) >>> alu_b[4:0]:alu_a >> alu_b[4:0];
                    3'b110:alu_result = alu_a | alu_b;
                    3'b111:alu_result = alu_a & alu_b;
                endcase
            end


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
    end
endmodule

