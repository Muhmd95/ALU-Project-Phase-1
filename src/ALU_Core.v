module ALU_Core (
    input  [3:0] A,      // 4-bit Input A
    input  [3:0] B,      // 4-bit Input B
    input  [1:0] OpCode, // Select Operation (00, 01, 10, 11)
    output reg [7:0] Result  // 8-bit Output
);

    // TODO: Write your logic here using "always @(*)"
    // Use a case statement to check OpCode

endmodule