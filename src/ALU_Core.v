//---------------------------------------------------------
// ALU_Core Template 
//---------------------------------------------------------
// All operation modules go here.
// TODO markers show where you must add your logic.
//---------------------------------------------------------


//---------------------------------------------------------
// TODO: 1. ADDER MODULE (4-bit to 8-bit)
//---------------------------------------------------------
module Add1bit(input A,input B,input CIN,output SUM,output COUT);
    assign SUM = A^B^C;
    assign COUT = (A&B) | (A&CIN) | (B&CIN);
endmodule

module Add4bit(input[3:0] A,input[3:0] B,output[3:0] SUM,output COUT);
    wire c0,c1,c2;
    Add1bit a1 (.A(A[0]),.B(B[0]),.CIN(1'b0),.SUM(SUM[0]),.COUT(c0));
    Add1bit a1 (.A(A[1]),.B(B[1]),.CIN(c0),.SUM(SUM[1]),.COUT(c1));
    Add1bit a1 (.A(A[2]),.B(B[2]),.CIN(c1),.SUM(SUM[2]),.COUT(c2));
    Add1bit a1 (.A(A[3]),.B(B[3]),.CIN(c2),.SUM(SUM[3]),.COUT(COUT));
endmodule



//---------------------------------------------------------
// TODO: 2. SUBTRACTOR MODULE (A - B)
//---------------------------------------------------------
module Sub4bit(input  [3:0] A,input  [3:0] B,output [7:0] Y);
    // TODO: implement subtraction logic here
endmodule



//---------------------------------------------------------
// TODO: 3. MULTIPLIER MODULE (4x4 → 8 bits)
//---------------------------------------------------------
module Mul4bit(input  [3:0] A,input  [3:0] B,output [7:0] Y);
    // TODO: implement multiplication logic here
endmodule



//---------------------------------------------------------
// TODO: 4. FOURTH OPERATION MODULE
//---------------------------------------------------------
module Op4(input  [3:0] A,input  [3:0] B,output [7:0] Y); // keep B input even if unused
    // TODO: implement your 4th operation here
endmodule



//---------------------------------------------------------
// MAIN ALU CORE
//---------------------------------------------------------
module ALU_Core(input[3:0] A,input[3:0] B,input[1:0] OP,input CIN,output reg [7:0] Y);

    // Wires to hold module outputs
    wire [3:0] add_out;
    wire [3:0] sub_out;
    wire [3:0] mul_out;
    wire [3:0] op4_out;
    wire COUT;

    // Instantiate submodules
    Add4bit u_add (.A(A), .B(B), .SUM(add_out), .COUT(COUT));
    Sub4bit u_sub (.A(A), .B(B), .Y(sub_out));
    Mul4bit u_mul (.A(A), .B(B), .Y(mul_out));
    Op4     u_op4 (.A(A), .B(B), .Y(op4_out));



    //-----------------------------------------------------
    // IMPORTANT: ALWAYS BLOCK GOES HERE
    // This selects which operation goes to output Y
    //-----------------------------------------------------
    always @(*) begin
        case (OP)
            2'b00: Y = {3'b000,COUT,add_out};   // addition
            2'b01: Y = sub_out;   // subtraction
            2'b10: Y = mul_out;   // multiplication
            2'b11: Y = op4_out;   // your 4th operation
            default: Y = 8'b0;
        endcase
    end

endmodule
