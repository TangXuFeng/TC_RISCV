#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINES  4096
#define MAX_LABELS 2048
#define MAX_LINE_LEN 256

typedef struct {
    char name[64];
    unsigned addr;
} Label;

typedef struct {
    char text[MAX_LINE_LEN];
    unsigned addr;
} Line;

// 全局缓存：两遍解析用
static Line  g_lines[MAX_LINES];
static int   g_line_count = 0;

static Label g_labels[MAX_LABELS];
static int   g_label_count = 0;

// 工具函数：去掉行首尾空白
static void trim(char *s) {
    char *p = s;
    while (*p && isspace((unsigned char)*p)) p++;
    if (p != s) memmove(s, p, strlen(p)+1);
    int len = (int)strlen(s);
    while (len > 0 && isspace((unsigned char)s[len-1])) {
        s[len-1] = '\0';
        len--;
    }
}

// 工具：移除注释（以 '#' 或 '//' 开头）
static void strip_comment(char *s) {
    for (int i = 0; s[i]; ++i) {
        if (s[i] == '#') { s[i] = '\0'; break; }
        if (s[i] == '/' && s[i+1] == '/') { s[i] = '\0'; break; }
    }
}

// 查 label，没有则返回 -1
static int find_label(const char *name) {
    for (int i = 0; i < g_label_count; ++i) {
        if (strcmp(g_labels[i].name, name) == 0) return i;
    }
    return -1;
}

static void add_label(const char *name, unsigned addr) {
    if (g_label_count >= MAX_LABELS) {
        fprintf(stderr, "Too many labels\n");
        exit(1);
    }
    if (find_label(name) >= 0) {
        fprintf(stderr, "Duplicate label: %s\n", name);
        exit(1);
    }
    strncpy(g_labels[g_label_count].name, name, sizeof(g_labels[g_label_count].name)-1);
    g_labels[g_label_count].name[sizeof(g_labels[g_label_count].name)-1] = '\0';
    g_labels[g_label_count].addr = addr;
    g_label_count++;
}

// 解析寄存器 xN
static int parse_reg(const char *tok) {
    if (tok[0] != 'x' && tok[0] != 'X') {
        fprintf(stderr, "Bad register: %s\n", tok);
        exit(1);
    }
    int n = atoi(tok+1);
    if (n < 0 || n > 31) {
        fprintf(stderr, "Register out of range: %s\n", tok);
        exit(1);
    }
    return n;
}

// 解析立即数（十进制或 0x十六进制）
static int parse_imm(const char *tok) {
    if (tok[0] == '0' && (tok[1] == 'x' || tok[1] == 'X')) {
        return (int)strtol(tok, NULL, 16);
    } else {
        return (int)strtol(tok, NULL, 10);
    }
}

// 分割一行成 token（简单版，不支持引号之类）
static int tokenize(char *line, char *tokens[], int max_tokens) {
    int count = 0;
    char *p = line;
    while (*p && count < max_tokens) {
        while (*p && isspace((unsigned char)*p)) p++;
        if (!*p) break;
        tokens[count++] = p;
        while (*p && !isspace((unsigned char)*p) && *p != ',' ) p++;
        if (*p == ',' ) { *p = '\0'; p++; }
        else if (*p) { *p = '\0'; p++; }
    }
    return count;
}

// R 型编码
static unsigned encode_r(int rd, int rs1, int rs2, int funct3, int funct7, int opcode) {
    unsigned inst = 0;
    inst |= ((unsigned)funct7 & 0x7f) << 25;
    inst |= ((unsigned)rs2 & 0x1f) << 20;
    inst |= ((unsigned)rs1 & 0x1f) << 15;
    inst |= ((unsigned)funct3 & 0x7) << 12;
    inst |= ((unsigned)rd & 0x1f) << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// I 型编码
static unsigned encode_i(int rd, int rs1, int imm, int funct3, int opcode) {
    unsigned uimm = (unsigned)(imm & 0xfff); // 12位
    unsigned inst = 0;
    inst |= uimm << 20;
    inst |= ((unsigned)rs1 & 0x1f) << 15;
    inst |= ((unsigned)funct3 & 0x7) << 12;
    inst |= ((unsigned)rd & 0x1f) << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// S 型编码
static unsigned encode_s(int rs1, int rs2, int imm, int funct3, int opcode) {
    unsigned uimm = (unsigned)(imm & 0xfff);
    unsigned imm_hi = (uimm >> 5) & 0x7f;
    unsigned imm_lo = uimm & 0x1f;
    unsigned inst = 0;
    inst |= imm_hi << 25;
    inst |= ((unsigned)rs2 & 0x1f) << 20;
    inst |= ((unsigned)rs1 & 0x1f) << 15;
    inst |= ((unsigned)funct3 & 0x7) << 12;
    inst |= imm_lo << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// B 型编码
static unsigned encode_b(int rs1, int rs2, int offset, int funct3, int opcode) {
    if (offset & 0x1) {
        fprintf(stderr, "Branch offset not aligned: %d\n", offset);
        exit(1);
    }
    int imm = offset >> 1; // 移除 bit0
    unsigned bit12   = (imm >> 11) & 0x1;
    unsigned bit10_5 = (imm >> 5) & 0x3f;
    unsigned bit4_1  = (imm >> 1) & 0xf;
    unsigned bit11   = imm & 0x1;

    unsigned inst = 0;
    inst |= bit12 << 31;
    inst |= bit10_5 << 25;
    inst |= ((unsigned)rs2 & 0x1f) << 20;
    inst |= ((unsigned)rs1 & 0x1f) << 15;
    inst |= ((unsigned)funct3 & 0x7) << 12;
    inst |= bit4_1 << 8;
    inst |= bit11 << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// U 型编码
static unsigned encode_u(int rd, int imm, int opcode) {
    unsigned uimm = (unsigned)(imm & 0xfffff000);
    unsigned inst = 0;
    inst |= uimm;
    inst |= ((unsigned)rd & 0x1f) << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// J 型编码
static unsigned encode_j(int rd, int offset, int opcode) {
    if (offset & 0x1) {
        fprintf(stderr, "JAL offset not aligned: %d\n", offset);
        exit(1);
    }
    int imm = offset >> 1; // 去掉 bit0

    unsigned bit20    = (imm >> 19) & 0x1;
    unsigned bit10_1  = (imm >> 9) & 0x3ff;
    unsigned bit11    = (imm >> 8) & 0x1;
    unsigned bit19_12 = imm & 0xff;

    unsigned inst = 0;
    inst |= bit20 << 31;
    inst |= bit19_12 << 12;
    inst |= bit11 << 20;
    inst |= bit10_1 << 21;
    inst |= ((unsigned)rd & 0x1f) << 7;
    inst |= ((unsigned)opcode & 0x7f);
    return inst;
}

// 查 label 地址（不存在则报错）
static unsigned get_label_addr(const char *name) {
    int idx = find_label(name);
    if (idx < 0) {
        fprintf(stderr, "Unknown label: %s\n", name);
        exit(1);
    }
    return g_labels[idx].addr;
}

// 判断是否是 label 定义（比如 "loop:"）
static int is_label_def(const char *line, char *out_name) {
    const char *p = line;
    while (*p && isspace((unsigned char)*p)) p++;
    const char *start = p;
    while (*p && (isalnum((unsigned char)*p) || *p == '_' || *p == '.')) p++;
    if (*p == ':' && p > start) {
        int len = (int)(p - start);
        if (len >= 63) len = 63;
        memcpy(out_name, start, len);
        out_name[len] = '\0';
        return 1;
    }
    return 0;
}

// 解析 load/store 的 offset(rs) 形式，比如 "0(x1)" "-4(x2)" 等
static void parse_mem_operand(const char *tok, int *out_imm, int *out_rs) {
    const char *p = tok;
    // 找 '('
    const char *paren = strchr(p, '(');
    if (!paren) {
        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    char imm_str[64];
    int len = (int)(paren - p);
    if (len <= 0 || len >= (int)sizeof(imm_str)) {
        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    memcpy(imm_str, p, len);
    imm_str[len] = '\0';

    const char *reg_str = paren + 1;
    const char *end_paren = strchr(reg_str, ')');
    if (!end_paren) {
        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    char reg_buf[32];
    len = (int)(end_paren - reg_str);
    if (len <= 0 || len >= (int)sizeof(reg_buf)) {
        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    memcpy(reg_buf, reg_str, len);
    reg_buf[len] = '\0';

    *out_imm = parse_imm(imm_str);
    *out_rs  = parse_reg(reg_buf);
}

// 第一遍：读入文件、记录每行 + label → 地址
static void first_pass(FILE *fp) {
    char buf[MAX_LINE_LEN];
    unsigned pc = 0;

    while (fgets(buf, sizeof(buf), fp)) {
        if (g_line_count >= MAX_LINES) {
            fprintf(stderr, "Too many lines\n");
            exit(1);
        }
        strip_comment(buf);
        trim(buf);
        if (buf[0] == '\0') continue;

        // 处理 .org 简单版：".org 0x100" 或 ".org 256"
        if (strncmp(buf, ".org", 4) == 0 && isspace((unsigned char)buf[4])) {
            char *p = buf + 4;
            while (*p && isspace((unsigned char)*p)) p++;
            if (!*p) {
                fprintf(stderr, "Bad .org directive\n");
                exit(1);
            }
            int org = parse_imm(p);
            pc = (unsigned)org;
            continue;
        }

        // label 定义
        char label_name[64];
        if (is_label_def(buf, label_name)) {
            add_label(label_name, pc);
            // 看冒号后是否还有指令
            char *colon = strchr(buf, ':');
            colon++;
            while (*colon && isspace((unsigned char)*colon)) colon++;
            if (*colon == '\0') {
                // 这一行只有 label，不增加 PC
                continue;
            } else {
                // 冒号后还有指令，作为本行的内容
                strncpy(g_lines[g_line_count].text, colon, MAX_LINE_LEN-1);
                g_lines[g_line_count].text[MAX_LINE_LEN-1] = '\0';
                g_lines[g_line_count].addr = pc;
                g_line_count++;
                pc += 4;
            }
        } else {
            // 普通指令行
            strncpy(g_lines[g_line_count].text, buf, MAX_LINE_LEN-1);
            g_lines[g_line_count].text[MAX_LINE_LEN-1] = '\0';
            g_lines[g_line_count].addr = pc;
            g_line_count++;
            pc += 4;
        }
    }
}

// 第二遍：根据指令文本 + label 表，输出机器码
static void second_pass(FILE *out) {
    for (int i = 0; i < g_line_count; ++i) {
        char line_buf[MAX_LINE_LEN];
        strncpy(line_buf, g_lines[i].text, sizeof(line_buf)-1);
        line_buf[sizeof(line_buf)-1] = '\0';
        trim(line_buf);
        if (line_buf[0] == '\0') continue;

        char *tokens[8];
        int ntok = tokenize(line_buf, tokens, 8);
        if (ntok <= 0) continue;

        char *mn = tokens[0];
        for (char *p = mn; *p; ++p) *p = (char)tolower((unsigned char)*p);

        unsigned pc = g_lines[i].addr;
        unsigned inst = 0;

        // ===== R 型 =====
        if (!strcmp(mn, "add") || !strcmp(mn, "sub") ||
            !strcmp(mn, "and") || !strcmp(mn, "or")  ||
            !strcmp(mn, "xor") || !strcmp(mn, "slt") ||
            !strcmp(mn, "sltu")|| !strcmp(mn, "sll") ||
            !strcmp(mn, "srl") || !strcmp(mn, "sra")) {

            if (ntok != 4) {
                fprintf(stderr, "R-type format: %s\n", g_lines[i].text);
                exit(1);
            }
            int rd  = parse_reg(tokens[1]);
            int rs1 = parse_reg(tokens[2]);
            int rs2 = parse_reg(tokens[3]);

            int funct3 = 0, funct7 = 0, opcode = 0x33;

            if (!strcmp(mn, "add"))  { funct3=0b000; funct7=0b0000000; }
            if (!strcmp(mn, "sub"))  { funct3=0b000; funct7=0b0100000; }
            if (!strcmp(mn, "sll"))  { funct3=0b001; funct7=0b0000000; }
            if (!strcmp(mn, "slt"))  { funct3=0b010; funct7=0b0000000; }
            if (!strcmp(mn, "sltu")) { funct3=0b011; funct7=0b0000000; }
            if (!strcmp(mn, "xor"))  { funct3=0b100; funct7=0b0000000; }
            if (!strcmp(mn, "srl"))  { funct3=0b101; funct7=0b0000000; }
            if (!strcmp(mn, "sra"))  { funct3=0b101; funct7=0b0100000; }
            if (!strcmp(mn, "or"))   { funct3=0b110; funct7=0b0000000; }
            if (!strcmp(mn, "and"))  { funct3=0b111; funct7=0b0000000; }

            inst = encode_r(rd, rs1, rs2, funct3, funct7, opcode);
        }
        // ===== I 型算术 / JALR / Load =====
        else if (!strcmp(mn, "addi") || !strcmp(mn, "andi") ||
                 !strcmp(mn, "ori")  || !strcmp(mn, "xori") ||
                 !strcmp(mn, "slti") || !strcmp(mn, "sltiu")||
                 !strcmp(mn, "jalr") ||
                 !strcmp(mn, "lb")   || !strcmp(mn, "lh")   ||
                 !strcmp(mn, "lw")   || !strcmp(mn, "lbu")  ||
                 !strcmp(mn, "lhu")) {

            int rd, rs1, imm, funct3, opcode;

            // load: rd, imm(rs1)
            if (!strcmp(mn, "lb") || !strcmp(mn, "lh") ||
                !strcmp(mn, "lw") || !strcmp(mn, "lbu")||
                !strcmp(mn, "lhu")) {

                if (ntok != 3) {
                    fprintf(stderr, "Load format: %s\n", g_lines[i].text);
                    exit(1);
                }
                rd = parse_reg(tokens[1]);
                parse_mem_operand(tokens[2], &imm, &rs1);
                opcode = 0x03;
                if (!strcmp(mn, "lb"))  funct3=0b000;
                if (!strcmp(mn, "lh"))  funct3=0b001;
                if (!strcmp(mn, "lw"))  funct3=0b010;
                if (!strcmp(mn, "lbu")) funct3=0b100;
                if (!strcmp(mn, "lhu")) funct3=0b101;
            }
            // jalr: rd, rs1, imm
            else if (!strcmp(mn, "jalr")) {
                if (ntok != 4) {
                    fprintf(stderr, "jalr format: %s\n", g_lines[i].text);
                    exit(1);
                }
                rd  = parse_reg(tokens[1]);
                rs1 = parse_reg(tokens[2]);
                imm = parse_imm(tokens[3]);
                opcode = 0x67;
                funct3 = 0b000;
            }
            // I 算术
            else {
                if (ntok != 4) {
                    fprintf(stderr, "I-type format: %s\n", g_lines[i].text);
                    exit(1);
                }
                rd  = parse_reg(tokens[1]);
                rs1 = parse_reg(tokens[2]);
                imm = parse_imm(tokens[3]);
                opcode = 0x13;

                if (!strcmp(mn, "addi"))  funct3=0b000;
                if (!strcmp(mn, "slti"))  funct3=0b010;
                if (!strcmp(mn, "sltiu")) funct3=0b011;
                if (!strcmp(mn, "xori"))  funct3=0b100;
                if (!strcmp(mn, "ori"))   funct3=0b110;
                if (!strcmp(mn, "andi"))  funct3=0b111;
            }

            inst = encode_i(rd, rs1, imm, funct3, opcode);
        }
        // ===== S 型 Store =====
        else if (!strcmp(mn, "sb") || !strcmp(mn, "sh") || !strcmp(mn, "sw")) {
            if (ntok != 3) {
                fprintf(stderr, "Store format: %s\n", g_lines[i].text);
                exit(1);
            }
            int rs2 = parse_reg(tokens[1]);
            int rs1, imm;
            parse_mem_operand(tokens[2], &imm, &rs1);
            int opcode = 0x23;
            int funct3;
            if (!strcmp(mn, "sb")) funct3=0b000;
            if (!strcmp(mn, "sh")) funct3=0b001;
            if (!strcmp(mn, "sw")) funct3=0b010;

            inst = encode_s(rs1, rs2, imm, funct3, opcode);
        }
        // ===== B 型 Branch =====
        else if (!strcmp(mn, "beq")  || !strcmp(mn, "bne") ||
                 !strcmp(mn, "blt")  || !strcmp(mn, "bge") ||
                 !strcmp(mn, "bltu") || !strcmp(mn, "bgeu")) {
            if (ntok != 4) {
                fprintf(stderr, "Branch format: %s\n", g_lines[i].text);
                exit(1);
            }
            int rs1 = parse_reg(tokens[1]);
            int rs2 = parse_reg(tokens[2]);
            const char *label = tokens[3];
            unsigned target = get_label_addr(label);
            int offset = (int)target - (int)pc;

            int opcode = 0x63;
            int funct3;
            if (!strcmp(mn, "beq"))  funct3=0b000;
            if (!strcmp(mn, "bne"))  funct3=0b001;
            if (!strcmp(mn, "blt"))  funct3=0b100;
            if (!strcmp(mn, "bge"))  funct3=0b101;
            if (!strcmp(mn, "bltu")) funct3=0b110;
            if (!strcmp(mn, "bgeu")) funct3=0b111;

            inst = encode_b(rs1, rs2, offset, funct3, opcode);
        }
        // ===== JAL =====
        else if (!strcmp(mn, "jal")) {
            if (ntok != 3) {
                fprintf(stderr, "jal format: %s\n", g_lines[i].text);
                exit(1);
            }
            int rd = parse_reg(tokens[1]);
            const char *label = tokens[2];
            unsigned target = get_label_addr(label);
            int offset = (int)target - (int)pc;
            inst = encode_j(rd, offset, 0x6f);
        }
        // ===== LUI / AUIPC =====
        else if (!strcmp(mn, "lui") || !strcmp(mn, "auipc")) {
            if (ntok != 3) {
                fprintf(stderr, "U-type format: %s\n", g_lines[i].text);
                exit(1);
            }
            int rd  = parse_reg(tokens[1]);
            int imm = parse_imm(tokens[2]);
            int opcode = (!strcmp(mn, "lui")) ? 0x37 : 0x17;
            inst = encode_u(rd, imm, opcode);
        }
        else {
            fprintf(stderr, "Unknown mnemonic at PC 0x%x: %s\n", pc, mn);
            exit(1);
        }

        fprintf(out, "# %s\n", g_lines[i].text);

        fprintf(out, "0x%08x\n", inst);
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s input.s output.hex\n", argv[0]);
        return 1;
    }

    const char *in_path  = argv[1];
    const char *out_path = argv[2];

    FILE *fin = fopen(in_path, "r");
    if (!fin) {
        perror("fopen input");
        return 1;
    }

    first_pass(fin);
    fclose(fin);

    FILE *fout = fopen(out_path, "w");
    if (!fout) {
        perror("fopen output");
        return 1;
    }

    second_pass(fout);
    fclose(fout);

    return 0;
}
