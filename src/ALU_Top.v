//---------------------------------------------------------
// ALU_Top Template
// Connects FPGA switches to ALU core
//---------------------------------------------------------
module ALU_Top(
    input  [9:0] SW,
    output [7:0] LEDR
);

    // Input assignments
    wire [3:0] A  = SW[3:0];
    wire [3:0] B  = SW[7:4];
    wire [1:0] OP = SW[9:8];

    // Output wire
    wire [7:0] Y;

    // Instantiate the ALU Core
    ALU_Core core_unit (
        .A(A),
        .B(B),
        .OP(OP),
        .Y(Y)
    );

    // Drive the LEDs
    assign LEDR = Y;

endmodule
