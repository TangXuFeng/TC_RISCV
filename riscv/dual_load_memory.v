//双加载内存
module dual_load_memory #(
    parameter MMIO_BASE_MEMORY = 32'h80000000 //基地址
    ,parameter MMIO_MASK_MEMORY = 32'hFFFFFF00 //掩码
)(
    input               clk
    ,input              rst_n
    ,input      [31:0]  pc
    ,output     [31:0]  instruction
    
    ,input      [31:0]  address
    ,output     [31:0]  read_data // 异步读
    ,input      [31:0]  write_data
    ,input              write_data_sig // 1=写
    ,output             selected //选中信号
);
    //定义内存大小
    localparam MEM_SIZE = (~MMIO_MASK_MEMORY)>>2 +1;
    reg [31:0] mem [0:MEM_SIZE];
    wire selected_instruction= (address & MMIO_MASK_MEMORY)==MMIO_BASE_MEMORY;
    assign selected = (address & MMIO_MASK_MEMORY)==MMIO_BASE_MEMORY;

    assign instruction=(selected_instruction ) ? mem[address[31:2]] : 32'b0;

    //读取,并且低位地址必须等于0
    assign read_data = (selected ) ? mem[address[31:2]] : 32'b0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            //假装重置了
            mem[0]=32'b0;
        end else if (selected &&write_data_sig == 1'b1 ) begin
            mem[address[31:2]] <= write_data;
        end
    end

endmodule
