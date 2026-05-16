module control(
    input  logic [4:0] opcode,
    output logic       reg_do_write_ctrl,
    output logic       alu_op1_ctrl,
    output logic       alu_op2_ctrl,
    output logic [4:0] alu_ctrl,
    output logic [3:0] mem_ctrl,
    output logic       mem_do_write_ctrl,
    output logic [1:0] reg_wr_src_ctrl,
    output logic [2:0] comp_ctrl,
    output logic       do_branch,
    output logic       do_jump
);
    always_comb begin
        case (opcode)
            5'b11001: begin // R-type
                reg_do_write_ctrl = 1;
                alu_op1_ctrl   = 0;
                alu_op2_ctrl   = 0;
                mem_do_write_ctrl = 0;
                mem_ctrl  = 4'b0000;
                do_branch = 0;
                do_jump   = 0;
            end
            5'b00100: begin // I-type
                reg_do_write_ctrl = 1;
                alu_op1_ctrl   = 0;
                alu_op2_ctrl   = 1;
                mem_do_write_ctrl = 0;
                mem_ctrl  = 4'b0000;
                do_branch = 0;
                do_jump   = 0;
            end
            5'b11000: begin // B-type
                reg_do_write_ctrl = 0;
                alu_op1_ctrl   = 0;
                alu_op2_ctrl   = 0;
                mem_do_write_ctrl = 0;
                mem_ctrl  = 4'b0000;
                do_branch = 1;
                do_jump   = 0;
            end
            default: begin
                reg_do_write_ctrl = 0;
                alu_op1_ctrl   = 0;
                alu_op2_ctrl   = 0;
                mem_do_write_ctrl = 0;
                mem_ctrl  = 4'b0000;
                do_branch = 0;
                do_jump   = 0;
            end
        endcase
    end
endmodule
