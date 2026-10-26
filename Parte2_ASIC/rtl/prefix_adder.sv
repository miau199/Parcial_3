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

    assign p_loc = a ^ b;
    assign g_loc = a & b;
    assign c[0]  = cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_carry
            always_comb begin
                logic carry_accum;
                carry_accum = g_loc[i];
                for (int k = i - 1; k >= 0; k--) begin
                    logic p_chain;
                    p_chain = 1'b1;
                    for (int m = i; m > k; m--) begin
                        p_chain = p_chain & p_loc[m];
                    end
                    carry_accum = carry_accum | (p_chain & g_loc[k]);
                end
                c[i+1] = carry_accum | ((&p_loc[i:0]) & cin);
            end
        end
    endgenerate

    assign sum  = p_loc ^ c[WIDTH-1:0];
    assign cout = c[WIDTH];
endmodule
