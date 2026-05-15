module soc(
    input logic clk,
    input logic rst_n,
    input logic mem_ready,
    output logic [31:0] mem_addr,
    inout logic [31:0] mem_data,
    output logic mem_write,
    output logic mem_read
);



    core u_core(
        .clk(clk),
        .rst_n(rst_n),
        .mem_ready(mem_ready),
        .mem_addr(mem_addr),
        .mem_data(mem_data),
        .mem_write(mem_write),
        .mem_read(mem_read)
    );



endmodule