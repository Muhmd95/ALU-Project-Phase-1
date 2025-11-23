//---------------------------------------------------------
// ALU_Top FILE
//---------------------------------------------------------
module ALU_Top(
    input  [9:0] SW,
    output [7:0] LEDR
);

    // INPUT ASSIGNMENT
    wire [3:0] A  = SW[3:0];
    wire [3:0] B  = SW[7:4];
    wire [1:0] OP = SW[9:8];

    // OUTPUT WIRE
    wire [7:0] Y;

    // INSTANT ALU CORE
    ALU_Core core_unit (
        .A(A),
        .B(B),
        .OP(OP),
        .Y(Y)
    );

    // LEDs
    assign LEDR = Y;

endmodule
