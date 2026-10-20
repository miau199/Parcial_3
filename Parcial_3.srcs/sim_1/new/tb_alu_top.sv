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

    // Generador de reloj (100 MHz -> periodo 10 ns)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        a_in = 0;
        b_in = 0;
        alu_ctrl_in = 0;

        // Reset
        #20;
        rst_n = 1;
        #10;

        // 1. Prueba de Suma (000): 15 + 27 = 42
        @(posedge clk);
        a_in = 16'd15; b_in = 16'd27; alu_ctrl_in = 3'b000;

        // 2. Prueba de Resta (001): 50 - 20 = 30
        @(posedge clk);
        a_in = 16'd50; b_in = 16'd20; alu_ctrl_in = 3'b001;

        // 3. Prueba de Resta con Cero (001): 10 - 10 = 0 (Flag Z = 1)
        @(posedge clk);
        a_in = 16'd10; b_in = 16'd10; alu_ctrl_in = 3'b001;

        // 4. Prueba de AND (010): 0x00FF & 0x0F0F = 0x000F
        @(posedge clk);
        a_in = 16'h00FF; b_in = 16'h0F0F; alu_ctrl_in = 3'b010;

        // 5. Prueba de OR (011): 0x00F0 | 0x0F00 = 0x0FF0
        @(posedge clk);
        a_in = 16'h00F0; b_in = 16'h0F00; alu_ctrl_in = 3'b011;

        // 6. Prueba de Multiplicador (100): 12 * 11 = 132
        @(posedge clk);
        a_in = 16'd12; b_in = 16'd11; alu_ctrl_in = 3'b100;

        // 7. Prueba de Limpieza a Cero (111): resultado = 0
        @(posedge clk);
        a_in = 16'hAAAA; b_in = 16'h5555; alu_ctrl_in = 3'b111;

        #40;
        $finish;
    end
endmodule
