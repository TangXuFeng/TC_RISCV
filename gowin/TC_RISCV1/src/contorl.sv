module control(
    input  logic [6:0] opcode,
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_write,
    output logic       mem_read,
    output logic       branch
);
    always_comb begin
        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1;
                alu_src   = 0;
                mem_write = 0;
                mem_read  = 0;
                branch    = 0;
            end
            7'b0010011: begin // I-type
                reg_write = 1;
                alu_src   = 1;
                mem_write = 0;
                mem_read  = 0;
                branch    = 0;
            end
            7'b1100011: begin // B-type
                reg_write = 0;
                alu_src   = 0;
                mem_write = 0;
                mem_read  = 0;
                branch    = 1;
            end
            default: begin
                reg_write = 0;
                alu_src   = 0;
                mem_write = 0;
                mem_read  = 0;
                branch    = 0;
            end
        endcase
    end
endmodule
