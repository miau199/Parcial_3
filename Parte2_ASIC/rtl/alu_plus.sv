module alu_plus #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [2:0]       alu_control,
    output logic [WIDTH-1:0] result,
    output logic [3:0]       flags // {N, Z, C, V}
);
    wire is_sub = alu_control[0];
    wire [WIDTH-1:0] b_operand = is_sub ? ~b : b;

    wire [WIDTH-1:0] adder_sum;
    wire             adder_cout;

    prefix_adder #(.WIDTH(WIDTH)) u_prefix_adder (
        .a   (a),
        .b   (b_operand),
        .cin (is_sub),
        .sum (adder_sum),
        .cout(adder_cout)
    );

    wire [(2*WIDTH)-1:0] mult_full = a * b;
    wire [WIDTH-1:0]     mult_res  = mult_full[WIDTH-1:0];

    wire en_and = (alu_control == 3'b010);
    wire en_or  = (alu_control == 3'b011);

    wire [WIDTH-1:0] and_bus;
    wire [WIDTH-1:0] or_bus;

    assign and_bus = en_and ? (a & b) : {WIDTH{1'bz}};
    assign or_bus  = en_or  ? (a | b) : {WIDTH{1'bz}};

    assign result = (alu_control == 3'b000) ? adder_sum :
                    (alu_control == 3'b001) ? adder_sum :
                    (alu_control == 3'b010) ? and_bus   :
                    (alu_control == 3'b011) ? or_bus    :
                    (alu_control == 3'b100) ? mult_res  :
                    (alu_control == 3'b111) ? {WIDTH{1'b0}} : {WIDTH{1'b0}};

    logic flag_n, flag_z, flag_c, flag_v;

    assign flag_n = result[WIDTH-1];
    assign flag_z = (result == {WIDTH{1'b0}});
    assign flag_c = (~alu_control[2] & ~alu_control[1]) & adder_cout;
    assign flag_v = (~alu_control[2] & ~alu_control[1]) & 
                    ~(a[WIDTH-1] ^ b_operand[WIDTH-1]) & 
                    (a[WIDTH-1] ^ adder_sum[WIDTH-1]);

    assign flags = {flag_n, flag_z, flag_c, flag_v};

endmodule
