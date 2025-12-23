// 特别注意: 这个文件是ai生成的,还没加入进去.
//
// 中断控制器还没做
//
//
module trap_controller (
    input  wire        clk,
    input  wire        rst,

    // 当前指令的 PC（用于写 mepc）
    input  wire [31:0] current_pc,

    // CSR 寄存器接口（来自 CSR 文件）
    input  wire [31:0] csr_mstatus,
    input  wire [31:0] csr_mie,
    input  wire [31:0] csr_mtvec,

    // 内部中断
    input  wire        irq_msip,   // 软件中断
    input  wire        irq_mtip,   // 定时器中断

    // 外部中断（来自外部中断控制器）
    input  wire        irq_ext,        // 外部中断 pending
    input  wire [7:0]  irq_ext_id,     // 外部中断 ID
    output reg         irq_ext_complete, // CPU 完成外部中断

    // 输出到 CSR 文件
    output reg         trap_taken,
    output reg [31:0]  trap_cause,
    output reg [31:0]  trap_mepc,
    output reg [31:0]  trap_mstatus_new,

    // 输出给 PC 选择器
    output reg [31:0]  trap_vector
);

    // mstatus 位
    wire MIE  = csr_mstatus[3];   // 全局中断使能
    wire MPIE = csr_mstatus[7];   // 保存的 MIE

    // mie 位
    wire MSIE = csr_mie[3];       // 软件中断使能
    wire MTIE = csr_mie[7];       // 定时器中断使能
    wire MEIE = csr_mie[11];      // 外部中断使能

    // 中断 pending 条件
    wire msip_pending = irq_msip & MSIE;
    wire mtip_pending = irq_mtip & MTIE;
    wire meip_pending = irq_ext  & MEIE;

    // 优先级：外部 > 定时器 > 软件
    always @(*) begin
        trap_taken = 1'b0;
        trap_cause = 32'b0;
        trap_vector = 32'b0;
        irq_ext_complete = 1'b0;

        if (MIE) begin
            if (meip_pending) begin
                trap_taken = 1'b1;
                trap_cause = 32'h8000000B;   // Machine External Interrupt
                trap_vector = csr_mtvec;
            end else if (mtip_pending) begin
                trap_taken = 1'b1;
                trap_cause = 32'h80000007;   // Machine Timer Interrupt
                trap_vector = csr_mtvec;
            end else if (msip_pending) begin
                trap_taken = 1'b1;
                trap_cause = 32'h80000003;   // Machine Software Interrupt
                trap_vector = csr_mtvec;
            end
        end

        // 外部中断完成信号（进入 trap 时发出）
        if (trap_taken && meip_pending)
            irq_ext_complete = 1'b1;
    end

    // 写 CSR（时序逻辑）
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trap_mepc <= 0;
            trap_mstatus_new <= 0;
        end else if (trap_taken) begin
            // 保存 PC
            trap_mepc <= current_pc;

            // 更新 mstatus：MIE -> MPIE，MIE 清零
            trap_mstatus_new <= csr_mstatus;
            trap_mstatus_new[7] <= MIE;  // MPIE = MIE
            trap_mstatus_new[3] <= 1'b0; // MIE = 0
        end
    end

endmodule
