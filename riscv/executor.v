// 执行器模块接口定义
module executor    (
    // 指令
    input              clk
    ,input              rst_n
    ,input      [31:0]  instruction
    ,input      [6:0]   opcode
    ,input      [2:0]   funct3
    ,input      [6:0]   funct7
    ,input      [31:0]  immediate
    //寄存器
    ,input      [31:0]  rs1_data
    ,input      [31:0]  rs2_data
    ,output reg [31:0]  rd_data
    //程序指针
    ,input      [31:0]  pc
    ,output reg [31:0]  pc_next
    //内存
    ,output reg [31:0]  address
    ,input      [31:0]  read_data
    ,output reg [31:0]  write_data
    ,output reg         write_data_sig
    ,input              wait_sig

    ,output reg         exception
    ,output reg [31:0]  exception_code
);

    wire [31:0] pc_inc, add_o, pc_mod_o;
    wire [31:0] sub_o, slt_o, sltu_o, xor_o, or_o, and_o, sll_o, srl_o, sra_o;
    reg  [31:0] add_a, add_b,  pc_mod, cmp_a, cmp_b;
    reg  [31:0] sub_a, sub_b, slt_a, slt_b, sltu_a, sltu_b, xor_a, xor_b;
    reg  [31:0] or_a, or_b, and_a, and_b, sll_a, srl_a, sra_a;
    reg  [4:0]  sll_shamt, srl_shamt, sra_shamt;
    reg  [2:0]  cmp_lsx;
    wire        cmp_o;



    reg [31:0] mul_a,mul_b;
    // 1. 无符号乘法
    wire [63:0] mul_u  = rs1_data * rs2_data;
    // 2. 有符号乘法
    wire [63:0] mul_s  = $signed(rs1_data) * $signed(rs2_data);
    // 3. 有符号 × 无符号
    wire [63:0] mul_su = $signed(rs1_data) * rs2_data;


    // 用于正常程序指针自增
    assign pc_inc = pc + ((opcode[1:0]!=2'b11) ? 32'h2 : 32'h4);

    // 加法器
    assign add_o = add_a + add_b;

    // 对最低位清零
    assign pc_mod_o = pc_mod & ~32'b1;

    // 减法
    assign sub_o = sub_a - sub_b;

    // SLT 有符号比较
    assign slt_o = ($signed(slt_a) < $signed(slt_b)) ? 32'b1 : 32'b0;

    // SLTU 无符号比较
    assign sltu_o = (sltu_a < sltu_b) ? 32'b1 : 32'b0;

    // XOR
    assign xor_o = xor_a ^ xor_b;

    // OR
    assign or_o = or_a | or_b;

    // AND
    assign and_o = and_a & and_b;

    // SLL (逻辑左移)
    assign sll_o = sll_a << sll_shamt;

    // SRL (逻辑右移)
    assign srl_o = srl_a >> srl_shamt;

    // SRA (算术右移)
    assign sra_o = $signed(sra_a) >>> sra_shamt;

    // 分支比较逻辑
    assign cmp_o = cmp_lsx[0] ^ (
        (cmp_lsx[2] == 1'b0) ? (cmp_a == cmp_b) :
                   (cmp_lsx[1] == 1'b0) ? ($signed(cmp_a) < $signed(cmp_b)) :
                                          (cmp_a < cmp_b)
    );

    always @(*) begin
        // 默认值
        pc_next        = pc_inc;
        rd_data        = 32'b0;
        address   = 32'b0;
        write_data  = 32'b0;
        write_data_sig  = 1'b0;

        add_a = 32'b0; add_b = 32'b0;
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

        //异常设置
        exception = 1'b1;
        exception_code = 32'h2;


        case(opcode[6:2])
            5'b00000: begin // LOAD
                if(instruction == 32'b0)begin 
                    exception =1'b1; // 全0 非法指令

                end else begin
                    add_a      = rs1_data;
                    add_b      = immediate;
                    address = add_o;
                    write_data_sig = 1'b0;
                    case(funct3)
                        3'b000:begin
                            rd_data = {{24{read_data[7]}}, read_data[7:0]}; // LB
                            exception = 1'b0;
                        end
                        3'b001:begin
                            rd_data = {{16{read_data[15]}}, read_data[15:0]}; // LH
                            exception = 1'b0;
                        end
                        3'b010:begin
                            rd_data = read_data; // LW

                            exception = 1'b0;
                        end
                        3'b100:begin
                            rd_data = {24'b0, read_data[7:0]}; // LBU
                            exception = 1'b0;
                        end
                        3'b101:begin
                            rd_data = {16'b0, read_data[15:0]}; // LHU
                            exception = 1'b0;
                        end
                    endcase
                end
            end
            5'b00011:begin //fence , fence.i
                if(instruction[11:7]==5'b0 && instruction[19:15] == 5'b0 )begin
                    if(funct3 == 3'b0 && immediate[11:8]==4'b0)begin
                        //什么都不会发生,因为没有流水线,没有需要屏障的地方
                        exception = 1'b0;
                    end else if(funct3 == 3'b001 && immediate[11:0]==12'b0)begin
                        //同样什么都不会发生
                        exception = 1'b0;

                    end 
                end
            end

            5'b01101: begin // LUI
                rd_data = immediate;
                exception = 1'b0;

            end


            5'b00100: begin // I-type 算术逻辑
                case(funct3)
                    3'b000: begin // ADDI
                        add_a = rs1_data;
                        add_b = immediate;
                        rd_data = add_o;
                        exception = 1'b0;

                    end

                    3'b010: begin // SLTI
                        slt_a = rs1_data;
                        slt_b = immediate;
                        rd_data = slt_o;
                        exception = 1'b0;

                    end

                    3'b011: begin // SLTIU
                        sltu_a = rs1_data;
                        sltu_b = immediate;
                        rd_data = sltu_o;
                        exception = 1'b0;

                    end

                    3'b100: begin // XORI
                        xor_a = rs1_data;
                        xor_b = immediate;
                        rd_data = xor_o;
                        exception = 1'b0;

                    end

                    3'b110: begin // ORI
                        or_a = rs1_data;
                        or_b = immediate;
                        rd_data = or_o;
                        exception = 1'b0;

                    end

                    3'b111: begin // ANDI
                        and_a = rs1_data;
                        and_b = immediate;
                        rd_data = and_o;
                        exception = 1'b0;

                    end

                    3'b001: begin // SLLI
                        sll_a     = rs1_data;
                        sll_shamt = immediate[4:0];
                        rd_data   = sll_o;
                        exception = 1'b0;

                    end

                    3'b101: begin // SRLI / SRAI
                        if(funct7 == 7'b0100000) begin
                            sra_a     = rs1_data;
                            sra_shamt = immediate[4:0];
                            rd_data   = sra_o; // SRAI
                            exception = 1'b0;

                        end else begin
                            srl_a     = rs1_data;
                            srl_shamt = immediate[4:0];
                            rd_data   = srl_o; // SRLI
                            exception = 1'b0;

                        end
                    end
                endcase
            end

            5'b00101: begin // AUIPC
                add_a = pc;
                add_b = immediate;
                rd_data = add_o;
                exception = 1'b0;

            end

            5'b01000: begin // STORE
                add_a      = rs1_data;
                add_b      = immediate;
                address  = add_o;
                write_data_sig    = 1'b1;
                case(funct3)
                    3'b000:begin
                        write_data = {read_data[31:8], rs2_data[7:0]}; // SB
                        exception = 1'b0;

                    end
                    3'b001:begin
                        write_data = {read_data[31:16], rs2_data[15:0]}; // SH
                        exception = 1'b0;

                    end
                    3'b010:begin write_data = rs2_data; // SW

                        exception = 1'b0;
                    end
                endcase
            end

            5'b01100: begin // R-type 算术逻辑
                case(funct3)
                    3'b000:  
                        case(funct7)
                            7'b0000000:begin //ADD
                                add_a = rs1_data; add_b = rs2_data;
                                rd_data = add_o;
                                exception = 1'b0;

                            end
                            7'b0100000:begin //SUB
                                sub_a = rs1_data; sub_b = rs2_data;
                                rd_data = sub_o;
                                exception = 1'b0;

                            end     
                            7'b0000001:begin
                                rd_data = mul_u[31:0];
                                exception = 1'b0;

                            end
                        endcase

                    3'b001: begin // SLL
                        case(funct7)
                            7'b0000000: begin
                                sll_a = rs1_data; sll_shamt = rs2_data[4:0];
                                rd_data = sll_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = mul_u[63:31];
                                exception = 1'b0;

                            end
                        endcase
                    end
                    3'b010: begin // SLT
                        case(funct7)
                            7'b0000000: begin
                                slt_a = rs1_data; slt_b = rs2_data;
                                rd_data = slt_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = mul_su[63:31];
                                exception = 1'b0;

                            end
                        endcase
                    end
                    3'b011: begin // SLTU
                        case(funct7)
                            7'b0000000: begin
                                sltu_a = rs1_data; sltu_b = rs2_data;
                                rd_data = sltu_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = mul_u[63:31];
                                exception = 1'b0;

                            end
                        endcase
                    end
                    3'b100: begin // XOR
                        case(funct7)
                            7'b0000000: begin
                                xor_a = rs1_data; xor_b = rs2_data;
                                rd_data = xor_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = (rs2_data == 32'b0)?32'hFFFFFFFF : $signed(rs1_data) / $signed(rs2_data);
                                exception = 1'b0;

                            end
                        endcase
                    end

                    3'b101: begin // SRL / SRA
                        case(funct7)
                            7'b0000000: begin
                                srl_a = rs1_data; srl_shamt = rs2_data[4:0];
                                rd_data = srl_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = (rs2_data == 32'b0)?32'hFFFFFFFF : rs1_data / rs2_data;
                                exception = 1'b0;

                            end
                            7'b0100000: begin
                                sra_a = rs1_data; sra_shamt = rs2_data[4:0];
                                rd_data = sra_o;
                                exception = 1'b0;

                            end
                        endcase
                    end
                    3'b110: begin // OR
                        case(funct7)
                            7'b0000000: begin
                                or_a = rs1_data; or_b = rs2_data;
                                rd_data = or_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = (rs2_data == 32'b0)?rs1_data :  $signed(rs1_data) % $signed(rs2_data);
                                exception = 1'b0;

                            end                      
                        endcase
                    end
                    3'b111: begin // AND
                        case(funct7)
                            7'b0000000: begin
                                and_a = rs1_data; and_b = rs2_data;
                                rd_data = and_o;
                                exception = 1'b0;

                            end
                            7'b0000001:begin
                                rd_data = (rs2_data == 32'b0)?rs1_data : rs1_data % rs2_data;
                                exception = 1'b0;

                            end                        
                        endcase
                    end
                endcase
            end

            5'b11000: begin // Branch
                cmp_a   = rs1_data;
                cmp_b   = rs2_data;
                cmp_lsx = funct3;
                add_a = pc;
                add_b = immediate;
                if(cmp_o) pc_next = add_o;
                exception = 1'b0;

            end

            5'b11001: begin // JALR
                if(funct3 == 3'b000) begin
                    rd_data = pc_inc;
                    add_a = rs1_data;
                    add_b = immediate;
                    pc_mod  = add_o;
                    pc_next = pc_mod_o;
                    exception = 1'b0;

                end
            end



            5'b11011: begin // JAL
                rd_data = pc_inc;
                add_a = pc;
                add_b = immediate;
                pc_next = add_o;
                exception = 1'b0;

            end

            5'b11100:begin //ecall ebreak
                if(instruction[11:7]==5'b0 && instruction[19:16] == 4'b0 && funct3 ==5'b0 && immediate[11:0] == 12'b0 )begin
                    exception = 1'b1;
                    if(immediate[0] ==0)begin
                        exception_code = 32'd11; // ecall
                    end else begin
                        exception_code = 32'd3; // ebreak
                    end
                end else begin
                    exception =1'b1;
                    exception_code = 32'h2;
                end
            end

            5'b11111:begin
                if(instruction == 32'hFFFFFFFF)begin
                    exception =1'b1;
                    exception_code = 32'h2; // 全1 非法指令
                end
            end


            default:begin
                exception = 1'b1;
                exception_code = 32'h2; // 非法指令
            end
        endcase
    end
endmodule
