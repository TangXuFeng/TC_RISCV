#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINES  4096
#define MAX_LABELS 2048
#define MAX_LINE_LEN 256
int debug=0;
int line_2=0;
typedef struct {
    char name[64];
    unsigned addr;
} Label;

typedef struct {
    char text[MAX_LINE_LEN];
    unsigned addr;
} Line;

static Line  g_lines[MAX_LINES];
static int   g_line_count = 0;

static Label g_labels[MAX_LABELS];
static int   g_label_count = 0;

// FIX: trim() 增强，去掉 \r
static void trim(char *s) {
    char *p = s;
    while (*p && isspace((unsigned char)*p)) p++;
    if (p != s) memmove(s, p, strlen(p)+1);

    int len = (int)strlen(s);
    while (len > 0 && (s[len-1] == '\r' || isspace((unsigned char)s[len-1]))) {
        s[len-1] = '\0';
        len--;
    }
}

static void strip_comment(char *s) {
    for (int i = 0; s[i]; ++i) {
        if (s[i] == '#') { s[i] = '\0'; break; }
        if (s[i] == '/' && s[i+1] == '/') { s[i] = '\0'; break; }
    }
}

static int find_label(const char *name) {
    for (int i = 0; i < g_label_count; ++i) {
        if (strcmp(g_labels[i].name, name) == 0) return i;
    }
    return -1;
}

static void add_label(const char *name, unsigned addr) {
    if (g_label_count >= MAX_LABELS) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Too many labels\n");
        exit(1);
    }
    if (find_label(name) >= 0) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Duplicate label: %s\n", name);
        exit(1);
    }
    strncpy(g_labels[g_label_count].name, name, 63);
    g_labels[g_label_count].name[63] = '\0';
    g_labels[g_label_count].addr = addr;
    g_label_count++;
}

static int parse_reg(const char *tok) {
    if (tok[0] != 'x' && tok[0] != 'X') { 
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Bad register: %s\n", tok);
        exit(1);
    }
    int n = atoi(tok+1);
    if (n < 0 || n > 31) { 
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Register out of range: %s\n", tok);
        exit(1);
    }
    return n;
}

static int parse_imm(const char *tok) {
    if (tok[0] == '0' && (tok[1] == 'x' || tok[1] == 'X'))
        return (int)strtol(tok, NULL, 16);
    return (int)strtol(tok, NULL, 10);
}

static int tokenize(char *line, char *tokens[], int max_tokens) {
    int count = 0;
    char *p = line;
    while (*p && count < max_tokens) {
        while (*p && isspace((unsigned char)*p)) p++;
        if (!*p) break;
        tokens[count++] = p;
        while (*p && !isspace((unsigned char)*p) && *p != ',') p++;
        if (*p == ',') { *p = '\0'; p++; }
        else if (*p) { *p = '\0'; p++; }
    }
    return count;
}

// ------------------ RV32I 编码函数 ------------------

static unsigned encode_r(int rd, int rs1, int rs2, int funct3, int funct7, int opcode) {
    return ((unsigned)funct7 << 25) |
        ((unsigned)rs2 << 20) |
        ((unsigned)rs1 << 15) |
        ((unsigned)funct3 << 12) |
        ((unsigned)rd << 7) |
        opcode;
}

static unsigned encode_i(int rd, int rs1, int imm, int funct3, int opcode) {
    if (imm < -2048 || imm > 2047) { 
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "I-type immediate out of range: %d\n", imm); 
        exit(1); 
    }
    unsigned uimm = (unsigned)(imm & 0xfff);
    return (uimm << 20) |
        ((unsigned)rs1 << 15) |
        ((unsigned)funct3 << 12) |
        ((unsigned)rd << 7) |
        opcode;
}

static unsigned encode_s(int rs1, int rs2, int imm, int funct3, int opcode) {
    if (imm < -2048 || imm > 2047) { 
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "S-type immediate out of range: %d\n", imm); 
        exit(1); 
    }
    unsigned uimm = (unsigned)(imm & 0xfff);
    unsigned imm_hi = (uimm >> 5) & 0x7f;
    unsigned imm_lo = uimm & 0x1f;
    return (imm_hi << 25) |
        ((unsigned)rs2 << 20) |
        ((unsigned)rs1 << 15) |
        ((unsigned)funct3 << 12) |
        (imm_lo << 7) |
        opcode;
}

static unsigned encode_b(int rs1, int rs2, int offset, int funct3, int opcode) {
    if (offset & 1) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Branch offset not aligned: %d\n", offset);
        exit(1);
    }
    if (offset < -4096 || offset > 4094) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Branch offset out of range: %d\n", offset); 
        exit(1); 
    }
    int imm = offset ;
    unsigned bit12   = (imm >> 12) & 1;
    unsigned bit10_5 = (imm >> 5) & 0x3f;
    unsigned bit4_1  = (imm >> 1) & 0xf;
    unsigned bit11   = (imm >> 11) & 1;

    return (bit12 << 31) |
        (bit10_5 << 25) |
        ((unsigned)rs2 << 20) |
        ((unsigned)rs1 << 15) |
        ((unsigned)funct3 << 12) |
        (bit4_1 << 8) |
        (bit11 << 7) |
        opcode;
}

static unsigned encode_u(int rd, int imm, int opcode) {
    if (imm & 0xfff) { 
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "U-type immediate must be 20-bit aligned: 0x%x\n", imm);
        exit(1);
    }
    unsigned uimm = (unsigned)(imm & 0xfffff000);
    return uimm | ((unsigned)rd << 7) | opcode;
}

static unsigned encode_j(int rd, int offset, int opcode) {
    if (offset & 1) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "JAL offset not aligned: %d\n", offset);
        exit(1);
    }
    if (offset < -(1<<20) || offset > ((1<<20)-2)) { 
        printf("# %s\n", g_lines[line_2].text);

        fprintf(stderr, "JAL offset out of range: %d\n", offset); 
        exit(1);
    }
    int imm = offset >> 1;

    unsigned bit20    = (imm >> 20-1) & 1;
    unsigned bit10_1  = (imm >> 1 -1) & 0x3F;
    unsigned bit11    = (imm >> 11-1) & 1;
    unsigned bit19_12 = (imm >> 12 -1)& 0xFF;

    return (bit20 << 31) |
        (bit19_12 << 12) |
        (bit11 << 20) |
        (bit10_1 << 21) |
        ((unsigned)rd << 7) |
        opcode;
}

static unsigned get_label_addr(const char *name) {
    int idx = find_label(name);
    if (idx < 0) {
        printf("# %s\n", g_lines[line_2].text);
        fprintf(stderr, "Unknown label: %s\n", name);
        exit(1);
    }
    return g_labels[idx].addr;
}

// FIX: label 解析增强，允许前面有空格、TAB、行尾有 \r
static int is_label_def(const char *line, char *out_name) {
    const char *p = line;

    while (*p && isspace((unsigned char)*p)) p++;

    const char *start = p;
    while (*p && (isalnum((unsigned char)*p) || *p == '_' || *p == '.')) p++;

    if (*p == ':') {
        int len = (int)(p - start);
        if (len > 0 && len < 63) {
            memcpy(out_name, start, len);
            out_name[len] = '\0';
            return 1;
        }
    }
    return 0;
}

static void parse_mem_operand(const char *tok, int *out_imm, int *out_rs) {
    const char *paren = strchr(tok, '(');
    if (!paren) {
        printf("# %s\n", g_lines[line_2].text);

        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    char imm_str[64];
    int len = (int)(paren - tok);
    memcpy(imm_str, tok, len);
    imm_str[len] = '\0';

    const char *reg_str = paren + 1;
    const char *end_paren = strchr(reg_str, ')');
    if (!end_paren) {
        printf("# %s\n", g_lines[line_2].text);

        fprintf(stderr, "Bad mem operand: %s\n", tok);
        exit(1);
    }
    char reg_buf[32];
    len = (int)(end_paren - reg_str);
    memcpy(reg_buf, reg_str, len);
    reg_buf[len] = '\0';

    *out_imm = parse_imm(imm_str);
    *out_rs  = parse_reg(reg_buf);
}

// ------------------ 第一遍扫描 ------------------

static void first_pass(FILE *fp) {
    char buf[MAX_LINE_LEN];
    unsigned pc = 0;

    while (fgets(buf, sizeof(buf), fp)) {
        strip_comment(buf);
        trim(buf);
        if (buf[0] == '\0') continue;

        if (strncmp(buf, ".org", 4) == 0 && isspace((unsigned char)buf[4])) {
            char *p = buf + 4;
            while (*p && isspace((unsigned char)*p)) p++;
            pc = parse_imm(p);
            continue;
        }

        char label_name[64];
        if (is_label_def(buf, label_name)) {
            add_label(label_name, pc);

            char *colon = strchr(buf, ':');
            colon++;
            while (*colon && isspace((unsigned char)*colon)) colon++;

            if (*colon == '\0') continue;

            strncpy(g_lines[g_line_count].text, colon, MAX_LINE_LEN-1);
            g_lines[g_line_count].addr = pc;
            g_line_count++;
            pc += 4;
        } else {
            strncpy(g_lines[g_line_count].text, buf, MAX_LINE_LEN-1);
            g_lines[g_line_count].addr = pc;
            g_line_count++;
            pc += 4;
        }
    }
}

// ------------------ 第二遍生成机器码 ------------------

static void second_pass(FILE *out) {
    for (int i = 0; i < g_line_count; ++i) {
        line_2=i;
        char line_buf[MAX_LINE_LEN];
        strncpy(line_buf, g_lines[i].text, MAX_LINE_LEN-1);
        trim(line_buf);
        if (line_buf[0] == '\0') continue;

        char *tokens[8];
        int ntok = tokenize(line_buf, tokens, 8);
        if (ntok <= 0) continue;

        char *mn = tokens[0];
        for (char *p = mn; *p; ++p) *p = tolower(*p);

        unsigned pc = g_lines[i].addr;
        unsigned inst = 0;

        // ------------------ R 型 ------------------
        if (!strcmp(mn,"add")||!strcmp(mn,"sub")||!strcmp(mn,"and")||
                !strcmp(mn,"or") ||!strcmp(mn,"xor")||!strcmp(mn,"slt")||
                !strcmp(mn,"sltu")||!strcmp(mn,"sll")||!strcmp(mn,"srl")||
                !strcmp(mn,"sra")) {

            int rd  = parse_reg(tokens[1]);
            int rs1 = parse_reg(tokens[2]);
            int rs2 = parse_reg(tokens[3]);

            int funct3=0, funct7=0, opcode=0x33;

            if(!strcmp(mn,"add")){funct3=0;funct7=0;}
            if(!strcmp(mn,"sub")){funct3=0;funct7=0x20;}
            if(!strcmp(mn,"sll")){funct3=1;funct7=0;}
            if(!strcmp(mn,"slt")){funct3=2;funct7=0;}
            if(!strcmp(mn,"sltu")){funct3=3;funct7=0;}
            if(!strcmp(mn,"xor")){funct3=4;funct7=0;}
            if(!strcmp(mn,"srl")){funct3=5;funct7=0;}
            if(!strcmp(mn,"sra")){funct3=5;funct7=0x20;}
            if(!strcmp(mn,"or")){funct3=6;funct7=0;}
            if(!strcmp(mn,"and")){funct3=7;funct7=0;}

            inst = encode_r(rd, rs1, rs2, funct3, funct7, opcode);

            if (debug) {
                fprintf(out,
                        "# R-type pc=0x%08x rd=%d rs1=%d rs2=%d funct3=%d funct7=0x%x opcode=0x%x\n",
                        pc, rd, rs1, rs2, funct3, funct7, opcode);
            }
        }

        // ------------------ I 型 ------------------
        else if (!strcmp(mn,"addi")||!strcmp(mn,"andi")||!strcmp(mn,"ori")||
                !strcmp(mn,"xori")||!strcmp(mn,"slti")||!strcmp(mn,"sltiu")||
                !strcmp(mn,"jalr")||
                !strcmp(mn,"lb")||!strcmp(mn,"lh")||!strcmp(mn,"lw")||
                !strcmp(mn,"lbu")||!strcmp(mn,"lhu")||!strcmp(mn,"slli")||
                !strcmp(mn,"srli")
                ) {

            int rd, rs1, imm, funct3, opcode;

            if (!strcmp(mn,"lb")||!strcmp(mn,"lh")||!strcmp(mn,"lw")||
                    !strcmp(mn,"lbu")||!strcmp(mn,"lhu")) {

                rd = parse_reg(tokens[1]);
                parse_mem_operand(tokens[2], &imm, &rs1);
                opcode = 0x03;

                if(!strcmp(mn,"lb"))funct3=0;
                if(!strcmp(mn,"lh"))funct3=1;
                if(!strcmp(mn,"lw"))funct3=2;
                if(!strcmp(mn,"lbu"))funct3=4;
                if(!strcmp(mn,"lhu"))funct3=5;
            }
            else if (!strcmp(mn,"jalr")) {
                rd  = parse_reg(tokens[1]);
                rs1 = parse_reg(tokens[2]);
                imm = parse_imm(tokens[3]);
                opcode = 0x67;
                funct3 = 0;
            }
            else {
                rd  = parse_reg(tokens[1]);
                rs1 = parse_reg(tokens[2]);
                imm = parse_imm(tokens[3]);
                opcode = 0x13;

                if(!strcmp(mn,"addi"))funct3=0;
                if(!strcmp(mn,"slli"))funct3=1;
                if(!strcmp(mn,"slti"))funct3=2;
                if(!strcmp(mn,"sltiu"))funct3=3;
                if(!strcmp(mn,"xori"))funct3=4;
                if(!strcmp(mn,"srli"))funct3=5;
                if(!strcmp(mn,"ori"))funct3=6;
                if(!strcmp(mn,"andi"))funct3=7;
            }

            inst = encode_i(rd, rs1, imm, funct3, opcode);

            if (debug) {
                fprintf(out,
                        "# I-type pc=0x%08x rd=%d rs1=%d imm=%d (0x%x) funct3=%d opcode=0x%x\n",
                        pc, rd, rs1, imm, imm & 0xfff, funct3, opcode);
            }
        }

        // ------------------ S 型 ------------------
        else if (!strcmp(mn,"sb")||!strcmp(mn,"sh")||!strcmp(mn,"sw")) {
            int rs2 = parse_reg(tokens[1]);
            int rs1, imm;
            parse_mem_operand(tokens[2], &imm, &rs1);

            int opcode = 0x23;
            int funct3 = (!strcmp(mn,"sb")?0:!strcmp(mn,"sh")?1:2);

            inst = encode_s(rs1, rs2, imm, funct3, opcode);

            if (debug) {
                fprintf(out,
                        "# S-type pc=0x%08x rs1=%d rs2=%d imm=%d funct3=%d opcode=0x%x\n",
                        pc, rs1, rs2, imm, funct3, opcode);
            }
        }

        // ------------------ B 型 ------------------
        else if (!strcmp(mn,"beq")||!strcmp(mn,"bne")||
                !strcmp(mn,"blt")||!strcmp(mn,"bge")||
                !strcmp(mn,"bltu")||!strcmp(mn,"bgeu")) {

            int rs1 = parse_reg(tokens[1]);
            int rs2 = parse_reg(tokens[2]);
            unsigned target = get_label_addr(tokens[3]);
            int offset = (int)target - (int)pc;

            int opcode = 0x63;
            int funct3;

            if(!strcmp(mn,"beq"))funct3=0;
            if(!strcmp(mn,"bne"))funct3=1;
            if(!strcmp(mn,"blt"))funct3=4;
            if(!strcmp(mn,"bge"))funct3=5;
            if(!strcmp(mn,"bltu"))funct3=6;
            if(!strcmp(mn,"bgeu"))funct3=7;

            inst = encode_b(rs1, rs2, offset, funct3, opcode);

            if (debug) {
                fprintf(out,
                        "# B-type pc=0x%08x rs1=%d rs2=%d offset=%d (0x%x) funct3=%d opcode=0x%x\n",
                        pc, rs1, rs2, offset, offset, funct3, opcode);
            }
        }

        // ------------------ JAL ------------------
        else if (!strcmp(mn,"jal")) {
            int rd = parse_reg(tokens[1]);
            unsigned target = get_label_addr(tokens[2]);
            int offset = (int)target - (int)pc;

            inst = encode_j(rd, offset, 0x6f);

            if (debug) {
                fprintf(out,
                        "# J-type pc=0x%08x rd=%d offset=%d (0x%x) opcode=0x6f\n",
                        pc, rd, offset, offset);
            }
        }

        // ------------------ U 型 ------------------
        else if (!strcmp(mn,"lui")||!strcmp(mn,"auipc")) {
            int rd = parse_reg(tokens[1]);
            int imm = parse_imm(tokens[2]);
            int opcode = (!strcmp(mn,"lui")?0x37:0x17);

            inst = encode_u(rd, imm, opcode);

            if (debug) {
                fprintf(out,
                        "# U-type pc=0x%08x rd=%d imm=0x%x opcode=0x%x\n",
                        pc, rd, imm, opcode);
            }
        }

        else {
            fprintf(stderr, "Unknown mnemonic at PC 0x%x: %s\n", pc, mn);
            exit(1);
        }


        // 源码回显，方便对照调试
        fprintf(out, "# %s\n", g_lines[i].text);
        // 输出机器码
        fprintf(out, "0x%08x\n", inst);

        fprintf(out,"\n");
    }
}

int main(int argc, char **argv) {
    if (argc < 3 ) {
        fprintf(stderr, "Usage: %s input.s output.hex\n", argv[0]);
        return 1;
    }

    const char *in_path  = argv[1];
    const char *out_path = argv[2];

    for(int i = 3;i < argc ; i++){
        if(strcmp(argv[i],"debug")==0){
            debug=1;
            continue;
        }


        fprintf(stderr, "Usage: %s input.s output.hex\n", argv[0]);
        printf("参数找不到: %s\n即将异常退出\n",argv[i]);
        return 1;
    }

    printf("debug is %s \n",debug?"on":"off");

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

