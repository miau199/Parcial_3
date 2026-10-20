// alu_top.sv - Wrapper síncrono registrado para síntesis
module alu_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] a_in,
    input  logic [15:0] b_in,
    input  logic [2:0]  alu_ctrl_in,
    output logic [15:0] result_out,
    output logic [3:0]  flags_out
);
    // Registros de entrada
    logic [15:0] a_reg, b_reg;
    logic [2:0]  ctrl_reg;

    // Conexión combinacional del núcleo
    logic [15:0] alu_result_comb;
    logic [3:0]  alu_flags_comb;

    // Proceso síncrono
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg       <= 16'h0000;
            b_reg       <= 16'h0000;
            ctrl_reg    <= 3'b000;
            result_out  <= 16'h0000;
            flags_out   <= 4'b0000;
        end else begin
            a_reg       <= a_in;
            b_reg       <= b_in;
            ctrl_reg    <= alu_ctrl_in;
            result_out  <= alu_result_comb;
            flags_out   <= alu_flags_comb;
        end
    end

    // Instancia de la ALU configurada a 16 bits
    alu_plus #(.WIDTH(16)) u_alu_inst (
        .a          (a_reg),
        .b          (b_reg),
        .alu_control(ctrl_reg),
        .result     (alu_result_comb),
        .flags      (alu_flags_comb)
    );

endmodule
