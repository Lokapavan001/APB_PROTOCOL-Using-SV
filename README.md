# APB Slave Verification (SystemVerilog)

This repository contains a self-contained **SystemVerilog testbench** for verifying an **APB Slave** design using a layered, class-based approach (no UVM). It includes test scenarios for full functional correctness, random traffic, and error injection.

---

##  File Structure

apb_sv_verification/
│
├── apbdesign.sv # RTL - APB Slave design
│
├── interface.sv # SystemVerilog interface for APB signals
│
├── transaction.sv # Transaction class (stimulus abstraction)
├── generator.sv # Generates stimulus
├── driver.sv # Drives signals to DUT
├── monitor.sv # Captures bus activity
├── scoreboard.sv # Compares actual vs expected output
├── predictor.sv # Predicts expected DUT output
├── environment.sv # Connects all components
├── package.sv # Package file for includes and declarations
│
├── full_test.sv # Directed test for full write-read flow
├── random_write_read_test.sv # Randomized read/write test
├── slave_error_test.sv # Test with injected protocol errors
│
└── top.sv # Testbench top modul



---

## 🧱 Testbench Architecture

This testbench follows a modular, layered architecture inspired by UVM:

top.sv
└── environment.sv
├── interface.sv
├── generator.sv
├── driver.sv
├── monitor.sv
├── predictor.sv
├── scoreboard.sv
└── transaction.sv


Each test (e.g., `full_test`, `random_write_read_test`) instantiates and controls the environment.

---

##  Tests Included

- **full_test.sv**: Directed write and read sequence with known data.
- **random_write_read_test.sv**: Randomized address and data transactions.
- **slave_error_test.sv**: Intentionally malformed inputs to check error handling.

---

## How to Run

### Compile and simulate using your simulator VCS):

```bash
# For Synopsys VCS (example):
vcs -full64 -sverilog -debug_all +acc +vpi -timescale=1ns/1ps \
  apbdesign.sv interface.sv transaction.sv generator.sv driver.sv monitor.sv \
  predictor.sv scoreboard.sv environment.sv package.sv top.sv full_test.sv

 Replace full_test.sv with random_write_read_test.sv or slave_error_test.sv as needed.
./simv
