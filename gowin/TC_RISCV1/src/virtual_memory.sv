module virtual_memory #(
    parameter int DEPTH = 256,
    parameter int LATENCY = 4,
    parameter int INIT_CYCLES = 2
)(
    input  logic         clk,
    input  logic         rst_n,
    input  logic         rd_req,
    input  logic         wr_req,
    input  logic [31:0]  addr,
    input  logic [7:0]   wdata,
    output logic [7:0]   rdata,
    output logic         ready
);

localparam int ADDR_BITS = $clog2(DEPTH);

typedef enum logic [1:0] {
    S_RESET,
    S_IDLE,
    S_BUSY
} state_t;

logic [7:0]                  mem [0:DEPTH-1];
logic [ADDR_BITS-1:0]        addr_reg;
logic [7:0]                  wdata_reg;
logic                        op_read;
logic [1:0]                  state;
logic [$clog2(LATENCY+1)-1:0] delay_cnt;
logic [$clog2(INIT_CYCLES+1)-1:0] init_cnt;
logic [7:0]                  rdata_reg;

assign rdata = rdata_reg;
assign ready = (state == S_IDLE) && (init_cnt >= INIT_CYCLES);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state      <= S_RESET;
        init_cnt   <= '0;
        delay_cnt  <= '0;
        addr_reg   <= '0;
        wdata_reg  <= '0;
        op_read    <= 1'b0;
        rdata_reg  <= '0;
    end else begin
        case (state)
            S_RESET: begin
                if (init_cnt < INIT_CYCLES) begin
                    init_cnt <= init_cnt + 1;
                end
                if (init_cnt >= INIT_CYCLES) begin
                    state <= S_IDLE;
                end
            end

            S_IDLE: begin
                if (rd_req || wr_req) begin
                    addr_reg  <= addr[ADDR_BITS-1:0];
                    wdata_reg <= wdata;
                    op_read   <= rd_req && !wr_req;
                    delay_cnt <= LATENCY - 1;
                    state     <= S_BUSY;
                end
            end

            S_BUSY: begin
                if (delay_cnt == 0) begin
                    if (op_read) begin
                        rdata_reg <= mem[addr_reg];
                    end else begin
                        mem[addr_reg] <= wdata_reg;
                    end
                    state <= S_IDLE;
                end else begin
                    delay_cnt <= delay_cnt - 1;
                end
            end

            default: state <= S_RESET;
        endcase
    end
end

endmodule
