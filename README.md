# ALU Project - Phase 1

**Course:** CMP 101 - Logic Design<br>
**Institution:** Cairo University - Faculty of Engineering - Computer Engineering Department<br>
**Academic Year:** 1st Year<br>
**Deadline:** Monday, December 1, 2025

---

## 📋 Project Overview

This project implements a **4-bit Arithmetic Logic Unit (ALU)** using Verilog HDL, designed for deployment on the DE1-SoC FPGA development board. The ALU performs four different operations on two 4-bit operands, with inputs controlled via onboard switches and outputs displayed on LEDs.

### 👥 Team Members

- Mohamed Osama
- Yousuf Safwat
- Yousef Sayed 
- Yasmine Ismail

---

## 🎯 Features

The ALU supports **four operations**:

1. **Addition** (4-bit + 4-bit → 5-bit result with carry)
2. **Subtraction** (4-bit - 4-bit → 4-bit result with sign)
3. **Multiplication** (4-bit × 4-bit → 8-bit result)
4. **Average** (⌊(A + B) / 2⌋ → 4-bit result)

---

## 🔌 Hardware Interface

### Input Mapping (10 Switches)
| Switch Range | Purpose | Description |
|--------------|---------|-------------|
| `SW[3:0]` | Operand A | First 4-bit input |
| `SW[7:4]` | Operand B | Second 4-bit input |
| `SW[9:8]` | Operation Select | 2-bit operation code |

### Operation Selection
| `SW[9:8]` | Operation | Output Format |
|-----------|-----------|---------------|
| `00` | Addition | `{000, COUT, SUM[3:0]}` |
| `01` | Subtraction | `{000, SIGN, RESULT[3:0]}` |
| `10` | Multiplication | `PRODUCT[7:0]` |
| `11` | Average | `{0000, AVG[3:0]}` |

### Output Mapping (8 LEDs)
| LED Range | Purpose |
|-----------|---------|
| `LEDR[7:0]` | 8-bit result output |

---

## 🏗️ Architecture & Design

### System Block Diagram

> 🖼️ **[INSERT IMAGE: Top-level ALU system diagram showing SW inputs, ALU_Top, ALU_Core, and LEDR outputs]**

### Module Hierarchy

```
ALU_Top (Top-level wrapper)
    └── ALU_Core (Main ALU logic)
            ├── Add4bit (4-bit Adder)
            │     └── Add1bit (1-bit Full Adder) × 4
            ├── Sub4bit (4-bit Subtractor)
            │     └── Add4bit (for 2's complement)
            ├── Mul4bit (4-bit Multiplier)
            │     └── Add4bit (for partial product addition) × 3
            └── Average4bit (Average Calculator)
                  └── Add4bit (for sum, then shift right)
```

---

## 🔧 Module Descriptions

### 1. **1-bit Full Adder (`Add1bit`)**

**Purpose:** Basic building block for all arithmetic operations.

**Logic:**
- `SUM = A ⊕ B ⊕ CIN`
- `COUT = (A·B) + (A·CIN) + (B·CIN)`

**Circuit Diagram:**

> 🖼️ **[INSERT IMAGE: 1-bit full adder schematic with XOR and AND gates]**

**Truth Table:**
| A | B | CIN | SUM | COUT |
|---|---|-----|-----|------|
| 0 | 0 | 0   | 0   | 0    |
| 0 | 0 | 1   | 1   | 0    |
| 0 | 1 | 0   | 1   | 0    |
| 0 | 1 | 1   | 0   | 1    |
| 1 | 0 | 0   | 1   | 0    |
| 1 | 0 | 1   | 0   | 1    |
| 1 | 1 | 0   | 0   | 1    |
| 1 | 1 | 1   | 1   | 1    |

---

### 2. **4-bit Ripple Carry Adder (`Add4bit`)**

**Purpose:** Adds two 4-bit numbers with carry propagation.

**Implementation:** Cascaded chain of four 1-bit full adders.

**Circuit Diagram:**

> 🖼️ **[INSERT IMAGE: 4-bit ripple carry adder showing carry chain c0→c1→c2→COUT]**

**Example:**
- Input: `A = 4'b1010 (10)`, `B = 4'b0110 (6)`, `CIN = 0`
- Output: `SUM = 4'b0000 (0)`, `COUT = 1` → Result: 16

---

### 3. **4-bit Subtractor (`Sub4bit`)**

**Purpose:** Computes A - B using 2's complement method with sign handling.

**Algorithm:**
1. Compute 1's complement of B: `B_COMP = ~B`
2. Add A + B_COMP + 1 (2's complement subtraction)
3. Check carry output: `SIGN = ~CARRY` (1 if result is negative)
4. If negative, convert result to magnitude using 2's complement

**Circuit Diagram:**

> 🖼️ **[INSERT IMAGE: Subtractor block diagram showing 2's complement logic and conditional complement]**

**Example Cases:**
- **Positive Result:** `A=9, B=3` → `RESULT=6, SIGN=0`
- **Negative Result:** `A=3, B=9` → `RESULT=6, SIGN=1` (represents -6)

---

### 4. **4-bit Multiplier (`Mul4bit`)**

**Purpose:** Multiplies two 4-bit numbers producing an 8-bit result.

**Implementation:** Array multiplier using partial products.

**Algorithm:**
1. Generate 4 partial products using AND gates
2. Align partial products by shifting
3. Add partial products using three 4-bit adders

**Partial Products:**
```
      A3 A2 A1 A0
    × B3 B2 B1 B0
    ─────────────
      A3B0 A2B0 A1B0 A0B0  (MULTI0)
   A3B1 A2B1 A1B1 A0B1     (MULTI1)
 A3B2 A2B2 A1B2 A0B2       (MULTI2)
A3B3 A2B3 A1B3 A0B3        (MULTI3)
```

**Circuit Diagram:**

> 🖼️ **[INSERT IMAGE: 4x4 array multiplier showing AND gate array and adder tree]**

**Example:**
- Input: `A = 4'b0101 (5)`, `B = 4'b0011 (3)`
- Output: `Y = 8'b00001111 (15)`

---

### 5. **Average Calculator (`Average4bit`)**

**Purpose:** Computes the average of two 4-bit numbers: ⌊(A + B) / 2⌋

**Algorithm:**
1. Add A + B using 4-bit adder (produces 5-bit sum with carry)
2. Shift right by 1 position (divide by 2): `{COUT, SUM[3:1]}`

**Circuit Diagram:**

> 🖼️ **[INSERT IMAGE: Average module showing adder and right shift operation]**

**Example:**
- Input: `A = 4'b1010 (10)`, `B = 4'b0110 (6)`
- Sum: `5'b10000 (16)`
- Average: `4'b1000 (8)`

---

### 6. **ALU Core (`ALU_Core`)**

**Purpose:** Main control unit that selects operation based on OP input.

**Implementation:** Uses a multiplexer (case statement) to route the selected operation to output.

**Block Diagram:**

> 🖼️ **[INSERT IMAGE: ALU_Core showing all operation modules feeding into 4:1 MUX controlled by OP]**

**Control Logic:**
```verilog
case (OP)
    2'b00: Addition
    2'b01: Subtraction
    2'b10: Multiplication
    2'b11: Average
endcase
```

---

## 📊 Testing & Validation

### Test Cases

#### Addition Tests
| A (SW[3:0]) | B (SW[7:4]) | OP | Expected Output | Notes |
|-------------|-------------|----|--------------------|-------|
| `0101` (5) | `0011` (3) | `00` | `00001000` (8) | Basic addition |
| `1111` (15) | `0001` (1) | `00` | `00010000` (16) | Carry generation |
| `1111` (15) | `1111` (15) | `00` | `00011110` (30) | Maximum sum |

#### Subtraction Tests
| A (SW[3:0]) | B (SW[7:4]) | OP | Expected Output | Notes |
|-------------|-------------|----|--------------------|-------|
| `1001` (9) | `0011` (3) | `01` | `00000110` (6) | Positive result |
| `0011` (3) | `1001` (9) | `01` | `00010110` (6 w/ sign) | Negative result (-6) |
| `0101` (5) | `0101` (5) | `01` | `00000000` (0) | Zero result |

#### Multiplication Tests
| A (SW[3:0]) | B (SW[7:4]) | OP | Expected Output | Notes |
|-------------|-------------|----|--------------------|-------|
| `0101` (5) | `0011` (3) | `10` | `00001111` (15) | Basic multiplication |
| `1111` (15) | `1111` (15) | `10` | `11100001` (225) | Maximum product |
| `0000` (0) | `1111` (15) | `10` | `00000000` (0) | Zero multiplication |

#### Average Tests
| A (SW[3:0]) | B (SW[7:4]) | OP | Expected Output | Notes |
|-------------|-------------|----|--------------------|-------|
| `1010` (10) | `0110` (6) | `11` | `00001000` (8) | Even average |
| `1111` (15) | `1111` (15) | `11` | `00001111` (15) | Same values |
| `0001` (1) | `0000` (0) | `11` | `00000000` (0) | Floor division |

### FPGA Testing Procedure

> 🖼️ **[INSERT IMAGE: Photo of DE1-SoC board with labeled switches and LEDs]**

1. Upload the compiled `.sof` file to the DE1-SoC board
2. Set operands using `SW[3:0]` and `SW[7:4]`
3. Select operation using `SW[9:8]`
4. Read result from `LEDR[7:0]`
5. Verify against expected values

---

## 📁 Project Structure

```
ALU-Project-Phase-1/
│
├── README.md                 # This file
├── ALU_Core.v               # Main ALU logic and operation modules
├── ALU_Top.v                # Top-level FPGA interface module
├── ALU_Project.qpf          # Quartus project file
├── ALU_Project.qsf          # Quartus settings file
├── simulation/              # Testbench files
│   └── ALU_tb.v
├── docs/                    # Documentation and diagrams
│   ├── circuit_diagrams/
│   └── presentation.pdf
└── output_files/            # Compiled bitstream
    └── ALU_Project.sof
```

---

## 🚀 How to Run

### Prerequisites
- Intel Quartus Prime (Lite Edition recommended)
- DE1-SoC FPGA Board
- USB Blaster cable

### Compilation Steps
1. Open Quartus Prime
2. Load the project file `ALU_Project.qpf`
3. Compile the design: **Processing → Start Compilation**
4. Check for errors in the compilation report

### Programming the FPGA
1. Connect the DE1-SoC board via USB Blaster
2. Open the Programmer: **Tools → Programmer**
3. Add the `.sof` file from `output_files/`
4. Click **Start** to program the device

### Running the Design
1. Use switches `SW[3:0]` to set operand A
2. Use switches `SW[7:4]` to set operand B
3. Use switches `SW[9:8]` to select operation
4. Observe the result on LEDs `LEDR[7:0]`

---

## 📸 Demonstration

> 🖼️ **[INSERT IMAGE: FPGA board showing example operation - Addition of 5+3]**

> 🖼️ **[INSERT IMAGE: FPGA board showing multiplication example 15×15]**

> 🖼️ **[INSERT IMAGE: FPGA board showing subtraction with negative result]**

---

## 🎓 Key Learning Outcomes

1. **Digital Logic Design:** Understanding and implementing fundamental building blocks (adders, multipliers)
2. **Verilog HDL:** Structural and behavioral modeling techniques
3. **FPGA Development:** Synthesis, place-and-route, and hardware testing
4. **Arithmetic Circuits:** Ripple carry addition, 2's complement subtraction, array multiplication
5. **Modular Design:** Hierarchical design approach for complex systems

---

## 🔮 Future Enhancements (Phase 2)

Phase 2 will include:
- Sequential logic implementation
- 7-segment display output
- Status flags (Zero, Carry, Overflow, Sign)
- Extended operation set
- Multi-cycle operations

---

## 📚 References

1. "Digital Design and Computer Architecture" - Harris & Harris
2. "Digital Design" - Morris Mano
3. Intel DE1-SoC User Manual
4. Verilog HDL Reference Manual
5. [NANAD Land](https://nandland.com/learn-verilog/)

---

**Project Status:** ✅ Phase 1 Complete<br>
**Last Updated:** November 2025<br>
**Version:** 1.0
