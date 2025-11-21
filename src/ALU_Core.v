//---------------------------------------------------------
// ALU_Core Template 
//---------------------------------------------------------
// All operation modules go here.
// TODO markers show where you must add your logic.
//---------------------------------------------------------


//---------------------------------------------------------
// TODO: 1. ADDER MODULE (4-bit to 8-bit)
//---------------------------------------------------------
module Add4bit(
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] Y
);
    // TODO: implement addition logic here
endmodule



//---------------------------------------------------------
// TODO: 2. SUBTRACTOR MODULE (A - B)
//---------------------------------------------------------
module Sub4bit(
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] Y
);
    // TODO: implement subtraction logic here
endmodule



//---------------------------------------------------------
// TODO: 3. MULTIPLIER MODULE (4x4 → 8 bits)
//---------------------------------------------------------
module Mul4bit(
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] Y
);
    // TODO: implement multiplication logic here
endmodule



//---------------------------------------------------------
// TODO: 4. FOURTH OPERATION MODULE
//---------------------------------------------------------
module Op4(
    input  [3:0] A,
    input  [3:0] B,   // keep B input even if unused
    output [7:0] Y
);
    // TODO: implement your 4th operation here
endmodule



//---------------------------------------------------------
// MAIN ALU CORE
//---------------------------------------------------------
module ALU_Core(
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] OP,
    output reg [7:0] Y
);

    // Wires to hold module outputs
    wire [7:0] add_out;
    wire [7:0] sub_out;
    wire [7:0] mul_out;
    wire [7:0] op4_out;

    // Instantiate submodules
    Add4bit u_add (.A(A), .B(B), .Y(add_out));
    Sub4bit u_sub (.A(A), .B(B), .Y(sub_out));
    Mul4bit u_mul (.A(A), .B(B), .Y(mul_out));
    Op4     u_op4 (.A(A), .B(B), .Y(op4_out));



    //-----------------------------------------------------
    // IMPORTANT: ALWAYS BLOCK GOES HERE
    // This selects which operation goes to output Y
    //-----------------------------------------------------
    always @(*) begin
        case (OP)
            2'b00: Y = add_out;   // addition
            2'b01: Y = sub_out;   // subtraction
            2'b10: Y = mul_out;   // multiplication
            2'b11: Y = op4_out;   // your 4th operation
            default: Y = 8'b0;
        endcase
    end

endmodule
