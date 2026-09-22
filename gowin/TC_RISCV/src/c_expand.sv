module c_expand(
    input  logic [31:0] instr,
    output logic        is_c,
    output logic [31:0] instr32
);

    logic [15:0] c;
    logic [31:0] expanded;

    function automatic logic [31:0] make_itype(
        input logic [11:0] imm,
        input logic [4:0]  rs1,
        input logic [2:0]  funct3,
        input logic [4:0]  rd,
        input logic [4:0]  op5
    );
        make_itype = {imm, rs1, funct3, rd, {op5, 2'b11}};
    endfunction

    function automatic logic [31:0] make_rtype(
        input logic [6:0]  funct7,
        input logic [4:0]  rs2,
        input logic [4:0]  rs1,
        input logic [2:0]  funct3,
        input logic [4:0]  rd
    );
        make_rtype = {funct7, rs2, rs1, funct3, rd, 2'b11};
    endfunction

    function automatic logic [31:0] make_stype(
        input logic [11:0] imm,
        input logic [4:0]  rs2,
        input logic [4:0]  rs1,
        input logic [2:0]  funct3
    );
        make_stype = {imm[11:5], rs2, rs1, funct3, imm[4:0], 2'b00};
    endfunction

    function automatic logic [31:0] make_btype(
        input logic [12:0] imm,
        input logic [4:0]  rs2,
        input logic [4:0]  rs1,
        input logic [2:0]  funct3
    );
        make_btype = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], 1'b0};
    endfunction

    always_comb begin
        c = instr[15:0];
        is_c = instr[1:0] != 2'b11;

        if (!is_c) begin
            expanded = instr;
        end else begin
            unique casez ({c[15:13], c[1:0]})

                5'b00000: begin // C.ADDI4SPN
                    expanded = make_itype(
                        {2'b00, c[12], c[6:5], c[11:10], c[9:7], 2'b00},
                        5'd2,
                        3'b000,
                        5'd8 + c[4:2],
                        5'b00100
                    );
                end

                5'b01000: begin // C.LW
                    expanded = make_itype(
                        {6'b0, c[5], c[12:10], 2'b00},
                        5'd8 + c[9:7],
                        3'b010,
                        5'd8 + c[4:2],
                        5'b00000
                    );
                end

                5'b11000: begin // C.SW
                    expanded = make_stype(
                        {6'b0, c[5], c[12:10], 2'b00},
                        5'd8 + c[4:2],
                        5'd8 + c[9:7],
                        3'b010
                    );
                end

                5'b01001: begin // C.ADDI
                    expanded = make_itype(
                        {{6{c[12]}}, c[12], c[6:2]},
                        c[11:7],
                        3'b000,
                        c[11:7],
                        5'b00100
                    );
                end

                5'b11001: begin // C.BEQZ
                    expanded = make_btype(
                        {{5{c[12]}}, c[12], c[6:5], c[2], c[11:10], c[4:3], 1'b0},
                        5'd0,
                        5'd8 + c[9:7],
                        3'b000
                    );
                end

                5'b10010: begin // C.MV / C.ADD
                    if (c[6:2] == 5'b00000) begin
                        expanded = make_rtype(7'b0000000, 5'd0, 5'd8 + c[9:7], 3'b000, 5'd8 + c[4:2]);
                    end else begin
                        expanded = make_rtype(7'b0000000, 5'd8 + c[6:2], 5'd8 + c[9:7], 3'b000, 5'd8 + c[4:2]);
                    end
                end

                5'b10011: begin // C.ADD
                    expanded = make_rtype(7'b0000000, 5'd8 + c[6:2], c[11:7], 3'b000, c[11:7]);
                end

                5'b10001: begin // C.ADDI16SP
                    expanded = make_itype(
                        {{6{c[12]}}, c[12], c[6:2]},
                        5'd2,
                        3'b000,
                        5'd2,
                        5'b00100
                    );
                end

                default: begin
                    expanded = 32'h00000013; // NOP
                end
            endcase
        end

        instr32 = expanded;
    end
endmodule
