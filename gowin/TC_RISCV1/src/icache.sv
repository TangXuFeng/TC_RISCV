module icache(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] addr,
    output logic [31:0] instr,

    input  logic [31:0] mem_rdata,
    input  logic        mem_ready,
    output logic        mem_read,
    output logic [31:0] mem_addr
);

    // 4-bit set index => 16 sets
    // 4-way associative
    // 2 words per cache line => 8-byte line size
    localparam SET_BITS         = 4;
    localparam SET_COUNT        = 1 << SET_BITS;
    localparam WAYS             = 4;
    localparam WORDS_PER_LINE   = 2;
    localparam LINE_OFFSET_BITS = 3;
    localparam TAG_BITS         = 32 - SET_BITS - LINE_OFFSET_BITS;

    typedef logic [TAG_BITS-1:0] tag_t;
    typedef logic [SET_BITS-1:0] index_t;
    typedef logic [LINE_OFFSET_BITS-1:0] offset_t;

    logic [TAG_BITS-1:0] tag_array [0:SET_COUNT-1][0:WAYS-1];
    logic                valid     [0:SET_COUNT-1][0:WAYS-1];
    logic [31:0]         data_array[0:SET_COUNT-1][0:WAYS-1][0:WORDS_PER_LINE-1];
    logic [1:0]          repl_ptr  [0:SET_COUNT-1];

    typedef enum logic [1:0] {IDLE, FETCH_WORD0, FETCH_WORD1, RESET} state_t;
    state_t state;
    logic [5:0] reset_ptr;

    logic [31:0] ref_line_base;
    tag_t        ref_tag;
    index_t      ref_index;
    offset_t     ref_offset;
    logic [31:0] fill_word0;

    wire [LINE_OFFSET_BITS-1:0] offset = addr[LINE_OFFSET_BITS-1:0];
    wire [SET_BITS-1:0]         index  = addr[LINE_OFFSET_BITS + SET_BITS - 1:LINE_OFFSET_BITS];
    wire [TAG_BITS-1:0]         tag    = addr[31:LINE_OFFSET_BITS + SET_BITS];
    wire [31:0]                 line_base = {addr[31:3], 3'b000};

    logic [WAYS-1:0] way_hit;
    logic [1:0]       hit_way;
    logic             hit;

    always_comb begin
        way_hit = '0;
        for (int w = 0; w < WAYS; w++) begin
            way_hit[w] = valid[index][w] && (tag_array[index][w] == tag);
        end

        hit = |way_hit;
        hit_way = 0;
        for (int w = 0; w < WAYS; w++) begin
            if (way_hit[w]) begin
                hit_way = w;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instr         <= 32'b0;
            mem_read      <= 1'b0;
            mem_addr      <= 32'b0;
            state         <= RESET;
            reset_ptr     <= 6'b0;
            ref_line_base <= 32'b0;
            ref_tag       <= '0;
            ref_index     <= '0;
            ref_offset    <= '0;
            fill_word0    <= 32'b0;
        end else begin
            case (state)
                RESET: begin
                    logic [3:0] clear_set = reset_ptr[5:2];
                    logic [1:0] clear_way = reset_ptr[1:0];

                    valid[clear_set][clear_way] <= 1'b0;
                    tag_array[clear_set][clear_way] <= '0;
                    data_array[clear_set][clear_way][0] <= 32'b0;
                    data_array[clear_set][clear_way][1] <= 32'b0;
                    repl_ptr[clear_set] <= 2'b00;

                    if (mem_ready) begin
                        mem_read <= 1'b1;
                        mem_addr <= addr;
                        instr <= mem_rdata;
                    end

                    if (reset_ptr == SET_COUNT * WAYS - 1) begin
                        state <= IDLE;
                    end
                    reset_ptr <= reset_ptr + 1;
                end

                IDLE: begin
                    mem_read <= 1'b0;
                    if (hit) begin
                        instr <= data_array[index][hit_way][offset[2]];
                    end else begin
                        ref_line_base <= line_base;
                        ref_tag       <= tag;
                        ref_index     <= index;
                        ref_offset    <= offset;
                        mem_addr      <= line_base;
                        mem_read      <= 1'b1;
                        state         <= FETCH_WORD0;
                    end
                end

                FETCH_WORD0: begin
                    mem_read <= 1'b1;
                    mem_addr <= ref_line_base;
                    if (mem_ready) begin
                        fill_word0 <= mem_rdata;
                        mem_addr <= ref_line_base + 32'd4;
                        state <= FETCH_WORD1;
                    end
                end

                FETCH_WORD1: begin
                    mem_read <= 1'b1;
                    mem_addr <= ref_line_base + 32'd4;
                    if (mem_ready) begin
                        logic [1:0] way = repl_ptr[ref_index];
                        data_array[ref_index][way][0] <= fill_word0;
                        data_array[ref_index][way][1] <= mem_rdata;
                        tag_array[ref_index][way] <= ref_tag;
                        valid[ref_index][way] <= 1'b1;
                        repl_ptr[ref_index] <= repl_ptr[ref_index] + 1;

                        instr <= ref_offset[2] ? mem_rdata : fill_word0;
                        mem_read <= 1'b0;
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
