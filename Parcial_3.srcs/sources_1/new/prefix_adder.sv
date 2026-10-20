// prefix_adder.sv - Sumador por prefijos configurable (Default 8 bits, instanciable a 16/32)
module prefix_adder #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);
    logic [WIDTH-1:0] p_loc, g_loc;
    logic [WIDTH:0]   c;

    // Paso 1: Generación y propagación local
    assign p_loc = a ^ b;
    assign g_loc = a & b;

    assign c[0] = cin;

    // Red de prefijos para cómputo rápido de acarreos paralelos
    genvar i, j;
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_carry
            logic [i:0] g_step;
            logic [i:0] p_step;

            // Nivel inicial
            assign g_step[0] = g_loc[i];
            assign p_step[0] = p_loc[i];

            // Propagación de prefijos paralelos hacia cada posición
            logic carry_accum;
            always_comb begin
                carry_accum = g_loc[i];
                for (int k = i - 1; k >= 0; k--) begin
                    logic p_chain;
                    p_chain = 1'b1;
                    for (int m = i; m > k; m--) begin
                        p_chain = p_chain & p_loc[m];
                    end
                    carry_accum = carry_accum | (p_chain & g_loc[k]);
                end
                // Incluir acarreo de entrada
                c[i+1] = carry_accum | ((&p_loc[i:0]) & cin);
            end
        end
    endgenerate

    // Paso final de suma
    assign sum  = p_loc ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];
endmodule