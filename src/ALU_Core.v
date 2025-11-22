//---------------------------------------------------------
// ALU_Core Template 
//---------------------------------------------------------
// All operation modules go here.
// TODO markers show where you must add your logic.
//---------------------------------------------------------


//---------------------------------------------------------
// DONE: 1. ADDER MODULE (4-bit to 8-bit)
//---------------------------------------------------------
module Add1bit(input A,input B,input CIN,output SUM,output COUT);
    assign SUM = A^B^CIN;
    assign COUT = (A&B) | (A&CIN) | (B&CIN);
endmodule

module Add4bit(input[3:0] A,input[3:0] B,input CIN,output[3:0] SUM,output COUT);
    wire c0,c1,c2;
    Add1bit a1 (.A(A[0]),.B(B[0]),.CIN(CIN),.SUM(SUM[0]),.COUT(c0));
    Add1bit a2 (.A(A[1]),.B(B[1]),.CIN(c0),.SUM(SUM[1]),.COUT(c1));
    Add1bit a3 (.A(A[2]),.B(B[2]),.CIN(c1),.SUM(SUM[2]),.COUT(c2));
    Add1bit a4 (.A(A[3]),.B(B[3]),.CIN(c2),.SUM(SUM[3]),.COUT(COUT));
endmodule



//---------------------------------------------------------
// DONE: 2. SUBTRACTOR MODULE (A - B)
//---------------------------------------------------------
module Sub4bit(input  [3:0] A,input  [3:0] B,output [3:0] RESULT, output SIGN);
    wire [3:0] B_COMP, FIRST, S_XOR;
    wire CARRY, DUMMY;
    assign B_COMP = ~B;
    Add4bit SUBTRACT (.A(A), .B(B_COMP),.CIN(1'b1), .SUM(FIRST), .COUT(CARRY));
    assign SIGN = ~CARRY;
    assign S_XOR = FIRST ^ {4{SIGN}};
    Add4bit COMPLEMENT (.A(4'b0000), .B(S_XOR),.CIN(SIGN), .SUM(RESULT), .COUT(DUMMY));
endmodule



//---------------------------------------------------------
// DONE: 3. MULTIPLIER MODULE (4x4 → 8 bits)
//---------------------------------------------------------
module Mul4bit(input  [3:0] A,input  [3:0] B,output [7:0] Y);
    wire[3:0] MULTI0, MULTI1, MULTI2, MULTI3, OUT0, OUT1, OUT2;
    wire C0, C1, C2;

    assign MULTI0 = {1'b0, A[3] & B[0], A[2] & B[0], A[1] & B[0]};
    assign MULTI1 = {A[3] & B[1], A[2] & B[1], A[1] & B[1], A[0] & B[1]};
    assign MULTI2 = {A[3] & B[2], A[2] & B[2], A[1] & B[2], A[0] & B[2]};
    assign MULTI3 = {A[3] & B[3], A[2] & B[3], A[1] & B[3], A[0] & B[3]};

    Add4bit M1 (.A(MULTI0), .B(MULTI1), .CIN(0), .SUM(OUT0), .COUT(C0));
    Add4bit M2 (.A({C0, OUT0[3:1]}), .B(MULTI2), .CIN(0), .SUM(OUT1), .COUT(C1));
    Add4bit M3 (.A({C1, OUT1[3:1]}), .B(MULTI3), .CIN(0), .SUM(OUT2), .COUT(C2));

    assign Y = {C2, OUT2, OUT1[0], OUT0[0], A[0] & B[0]};

endmodule


//==============================
// DONE: 4. AVERAGE MODULE (A + B >> 1)
//==============================
module Average4bit(input[3:0] A,input[3:0] B,output[3:0] avg);
    wire cout;
    wire [3:0] sum;

    Add4bit ADD(A, B, 1'b0, sum, cout);
    assign avg = {cout, sum[3:1]};
endmodule



//---------------------------------------------------------
// MAIN ALU CORE
//---------------------------------------------------------
module ALU_Core(input[3:0] A,input[3:0] B,input[1:0] OP,output reg [7:0] Y);

    // Wires to hold module outputs
    wire [3:0] add_out;
    wire [3:0] sub_out;
    wire [7:0] mul_out;
    wire [3:0] avg_out;
    wire COUT,SIGN;

    // Instantiate submodules
    Add4bit u_add (.A(A), .B(B), .CIN(1'b0), .SUM(add_out), .COUT(COUT));
    Sub4bit u_sub (.A(A), .B(B), .RESULT(sub_out), .SIGN(SIGN));
    Mul4bit u_mul (.A(A), .B(B), .Y(mul_out));
    Average4bit u_avg (.A(A), .B(B), .avg(avg_out));



    //-----------------------------------------------------
    // IMPORTANT: ALWAYS BLOCK GOES HERE
    // This selects which operation goes to output Y
    //-----------------------------------------------------
    always @(*) begin
        case (OP)
            2'b00: Y = {3'b000,COUT,add_out};   // addition
            2'b01: Y = {3'b000,SIGN,sub_out};   // subtraction
            2'b10: Y = mul_out;   // multiplication
            2'b11: Y = {4'b0000,avg_out};   // average 
            default: Y = 8'b0;
        endcase
    end

endmodule
