`timescale 1ns / 1ps

module tb_alu_top;
    logic        clk;
    logic        rst_n;
    logic [15:0] a_in;
    logic [15:0] b_in;
    logic [2:0]  alu_ctrl_in;
    logic [15:0] result_out;
    logic [3:0]  flags_out;

    alu_top uut (.*);

    // Reloj a 100 MHz (Periodo = 10 ns)
    always #5 clk = ~clk;

    // Volcado a Verdi
    initial begin
        $fsdbDumpfile("ondas_proyecto.fsdb");
        $fsdbDumpvars(0, tb_alu_top, "+all");
    end

    initial begin
        clk = 0;
        rst_n = 0;
        a_in = 0;
        b_in = 0;
        alu_ctrl_in = 0;

        #20;
        rst_n = 1;
        #10;

        // Iniciar captura de actividad SAIF
        $set_toggle_region(tb_alu_top.uut);
        $toggle_start();

        // 1. Suma
        @(posedge clk); a_in = 16'd15; b_in = 16'd27; alu_ctrl_in = 3'b000;
        // 2. Resta
        @(posedge clk); a_in = 16'd50; b_in = 16'd20; alu_ctrl_in = 3'b001;
        // 3. Resta con flag Z
        @(posedge clk); a_in = 16'd10; b_in = 16'd10; alu_ctrl_in = 3'b001;
        // 4. AND
        @(posedge clk); a_in = 16'h00FF; b_in = 16'h0F0F; alu_ctrl_in = 3'b010;
        // 5. OR
        @(posedge clk); a_in = 16'h00F0; b_in = 16'h0F00; alu_ctrl_in = 3'b011;
        // 6. Multiplicador
        @(posedge clk); a_in = 16'd12; b_in = 16'd11; alu_ctrl_in = 3'b100;
        // 7. Limpieza a cero
        @(posedge clk); a_in = 16'hAAAA; b_in = 16'h5555; alu_ctrl_in = 3'b111;

        #40;
        // Finalizar captura SAIF
        $toggle_stop();
        $toggle_report("actividad.saif", 1.0e-9, tb_alu_top.uut);

        $finish;
    end
endmodule
