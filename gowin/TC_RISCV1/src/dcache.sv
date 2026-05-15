module dcache(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    input  logic [31:0] load_addr,
    output logic [31:0] load_data,
    output logic        load_forward,
    output logic        write_pending,
    output logic [31:0] write_addr,
    output logic [31:0] write_data,
    input  logic        commit_write
);

    localparam WB_ENTRIES = 4;

    typedef struct packed {
        logic        valid;
        logic [31:0] addr;
        logic [31:0] data;
        logic [7:0]  seq;
    } wb_entry_t;

    wb_entry_t write_buf[0:WB_ENTRIES-1];
    logic [1:0] wb_head;
    logic [1:0] wb_tail;
    logic [2:0] wb_count;
    logic [7:0] seq_ctr;

    function automatic int find_buffer_index(input logic [31:0] addr_in);
        find_buffer_index = -1;
        for (int i = 0; i < WB_ENTRIES; i++) begin
            if (write_buf[i].valid && write_buf[i].addr == addr_in) begin
                find_buffer_index = i;
            end
        end
    endfunction

    always_comb begin
        load_forward = 1'b0;
        load_data = 32'b0;
        write_pending = (wb_count != 0);
        write_addr = 32'b0;
        write_data = 32'b0;

        if (wb_count != 0) begin
            write_addr = write_buf[wb_head].addr;
            write_data = write_buf[wb_head].data;
        end

        logic [7:0] best_seq = 8'b0;
        for (int i = 0; i < WB_ENTRIES; i++) begin
            if (write_buf[i].valid && write_buf[i].addr == load_addr) begin
                if (!load_forward || write_buf[i].seq > best_seq) begin
                    load_forward = 1'b1;
                    load_data = write_buf[i].data;
                    best_seq = write_buf[i].seq;
                end
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_head <= 2'b00;
            wb_tail <= 2'b00;
            wb_count <= 3'b000;
            seq_ctr <= 8'b0;
            for (int i = 0; i < WB_ENTRIES; i++) begin
                write_buf[i].valid <= 1'b0;
                write_buf[i].addr  <= 32'b0;
                write_buf[i].data  <= 32'b0;
                write_buf[i].seq   <= 8'b0;
            end
        end else begin
            int existing_idx = find_buffer_index(addr);
            if (we) begin
                if (existing_idx != -1) begin
                    write_buf[existing_idx].data <= wdata;
                    write_buf[existing_idx].seq <= seq_ctr;
                    seq_ctr <= seq_ctr + 1;
                end else if (wb_count < WB_ENTRIES) begin
                    write_buf[wb_tail].valid <= 1'b1;
                    write_buf[wb_tail].addr  <= addr;
                    write_buf[wb_tail].data  <= wdata;
                    write_buf[wb_tail].seq   <= seq_ctr;
                    wb_tail <= wb_tail + 1;
                    wb_count <= wb_count + 1;
                    seq_ctr <= seq_ctr + 1;
                end else begin
                    // buffer full: replace the oldest entry to keep progress
                    write_buf[wb_head].valid <= 1'b1;
                    write_buf[wb_head].addr  <= addr;
                    write_buf[wb_head].data  <= wdata;
                    write_buf[wb_head].seq   <= seq_ctr;
                    wb_head <= wb_head + 1;
                    wb_tail <= wb_tail + 1;
                    seq_ctr <= seq_ctr + 1;
                end
            end

            if (commit_write && wb_count > 0) begin
                write_buf[wb_head].valid <= 1'b0;
                wb_head <= wb_head + 1;
                wb_count <= wb_count - 1;
            end
        end
    end
endmodule
