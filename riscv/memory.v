module memory #(
    parameter MMIO_BASE_MEMORY = 32'h80000000 //基地址
    parameter MMIO_MASK_MEMORY = 32'hFFF00000 //掩码 20bit = 1MB
)(
    input               clk,
    ,input              rst_n

    ,input              rw       // 0=读, 1=写
    ,input      [31:0]  address
    ,input      [31:0]  write_data

    ,output     [31:0]  read_data // 异步读
    ,output             interruped_0 //0号异常,内存不对齐:
    ,output             selected //选中信号
    ,output             no_buffer //通知cache不能被缓存
);
    //定义内存大小
    localparam MEM_SIZE = (~MMIO_MASK_MEMORY)+1;
    reg [31:0] mem [MEM_SIZE:0];

    assign selected = (address & MMIO_MASK_MEMORY)==MMIO_BASE_MEMORY;
    assign interruped_0 = address[1:0] !=2'b0;
    assign no_buffer = selected? 1'b0:1'b0; //可以被缓存

    //读取,并且低位地址必须等于0
    assign read_data = (selected && rw == 1'b0 && address[1:0]==0 ) ? mem[word_index] : 32'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            //假装重置了
            mem[0]=32'b0;
        end else if (selected &&rw == 1'b1 && address[1:0] == 2'b00) begin
            mem[word_index] <= write_data;
        end
    end

endmodule
