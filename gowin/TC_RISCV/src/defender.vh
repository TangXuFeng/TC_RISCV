// ============================================================
// RISC-V Base Opcode Map (inst[6:0], inst[1:0] = 2'b11)
// ============================================================

// inst[6:5] = 00
`define OPCODE_LOAD        5'b00000
`define OPCODE_LOAD_FP     5'b00001
`define OPCODE_CUSTOM_0    5'b00010
`define OPCODE_MISC_MEM    5'b00011
`define OPCODE_OP_IMM      5'b00100
`define OPCODE_AUIPC       5'b00101
`define OPCODE_OP_IMM_32   5'b00110
`define OPCODE_48B_0       5'b00111   // >32b

// inst[6:5] = 01
`define OPCODE_STORE       5'b01000
`define OPCODE_STORE_FP    5'b01001
`define OPCODE_CUSTOM_1    5'b01010
`define OPCODE_AMO         5'b01011
`define OPCODE_OP          5'b01100
`define OPCODE_LUI         5'b01101
`define OPCODE_OP_32       5'b01110
`define OPCODE_64B         5'b01111   // >32b

// inst[6:5] = 10
`define OPCODE_MADD        5'b10000
`define OPCODE_MSUB        5'b10001
`define OPCODE_NMSUB       5'b10002
`define OPCODE_NMADD       5'b10011
`define OPCODE_OP_FP       5'b10100
`define OPCODE_OP_V        5'b10101
`define OPCODE_CUSTOM_2    5'b10110
`define OPCODE_48B_1       5'b10111   // >32b

// inst[6:5] = 11
`define OPCODE_BRANCH      5'b11000
`define OPCODE_JALR        5'b11001
`define OPCODE_RESERVED    5'b11010
`define OPCODE_JAL         5'b11011
`define OPCODE_SYSTEM      5'b11100
`define OPCODE_OP_VE       5'b11101
`define OPCODE_CUSTOM_3    5'b11110
`define OPCODE_80B         5'b11111   // >=80b

