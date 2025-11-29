ALU Project - Phase 1

Course: CMP 101 - Logic Design
Institution: Cairo University - Faculty of Engineering - Computer Engineering Department
Academic Year: 1st Year

Team Members:
- Mohamed Osama
- Yousuf Safwat
- Yousef Sayed
- Yasmine Ismail

------------------------------------------------------------
What This Project Does
------------------------------------------------------------
We built a 4-bit Arithmetic Logic Unit (ALU) using Verilog HDL that runs on the DE1-SoC FPGA board. 
The ALU takes two 4-bit numbers as inputs through switches on the board and performs four operations, 
displaying the result on LEDs.

------------------------------------------------------------
Operations (4 Total)
------------------------------------------------------------
1. Addition
   - Adds two 4-bit numbers.
   - Produces a 5-bit result including carry-out.
   - Carry-out is displayed on LEDR[8].
   - Uses the 4-bit ripple-carry adder internally.

2. Subtraction
   - Computes A - B using the 2’s complement method.
   - If result is negative: LEDR[8] = 1 (sign bit).
   - LEDs[3:0] show the magnitude.
   - Internally uses the 4-bit adder after complementing B.

3. Multiplication
   - Multiplies two 4-bit numbers using partial products.
   - Generates an 8-bit output displayed on LEDR[7:0].
   - LEDR[8] is unused.
   - Internally uses multiple adders to sum partial products.

4. Average
   - Computes floor((A + B) / 2).
   - Addition carry-out is shown on LEDR[8].
   - LEDs[3:0] show the average.
   - Internally: add → right shift → output.

------------------------------------------------------------
Internal Tool Used by Most Operations (Not an Operation)
------------------------------------------------------------
Full Adder / Ripple-Carry Adder
- The 1-bit full adder and 4-bit ripple adder are NOT operations.
- They are internal building blocks used by:
  • Addition
  • Subtraction
  • Multiplication (partial product accumulation)
  • Average (sum before shifting)

The full adder is just a tool the ALU uses to build real operations.

------------------------------------------------------------
Inputs (Switches)
------------------------------------------------------------
SW[3:0]  → A (first number)
SW[7:4]  → B (second number)
SW[9:8]  → Operation selector

Operation Select Codes:
00 → Addition
01 → Subtraction
10 → Multiplication
11 → Average

------------------------------------------------------------
Output (LEDs)
------------------------------------------------------------
LEDR[3:0]   → Main result (lower bits)
LEDR[7:4]   → Upper bits (used in multiplication only)
LEDR[8]     → Special flag depending on operation:
              • Addition  → Carry-out
              • Subtraction → Sign bit (1 = negative)
              • Multiplication → Not used
              • Average → Carry-out from A+B

------------------------------------------------------------
What We Learned
------------------------------------------------------------
- Building a real ALU on hardware reinforces binary arithmetic concepts.
- Learned Verilog HDL and FPGA workflow (simulation → synthesis → programming).
- Understood how complex operations are built from simple logic blocks.
- Gained experience in debugging hardware-based arithmetic modules.

------------------------------------------------------------
References
------------------------------------------------------------
1. Digital Design and Computer Architecture – Harris & Harris
2. Digital Design – Morris Mano
3. Intel DE1-SoC User Manual
4. Verilog HDL Reference Manual
5. Nandland Verilog Tutorials

Version: 1.0
