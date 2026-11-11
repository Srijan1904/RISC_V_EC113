module alu_control (
    input  logic [2:0] alu_op,     // operation class from main_control
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,    // instruction[31:25]: shift qualifier (I-type)
    input  logic       fn7_5,      // instruction[30]: SUB / SRA qualifier (R-type)
    output logic [4:0] control_out
);

    always_comb begin
        case (alu_op)
            3'b000: begin // R-type
                case (fn3)
                    3'b000: control_out = fn7_5 ? 5'b01000 : 5'b00000; // SUB : ADD
                    3'b001: control_out = 5'b00001; // SLL
                    3'b010: control_out = 5'b00010; // SLT
                    3'b011: control_out = 5'b00011; // SLTU
                    3'b100: control_out = 5'b00100; // XOR
                    3'b101: control_out = fn7_5 ? 5'b01101 : 5'b00101; // SRA : SRL
                    3'b110: control_out = 5'b00110; // OR
                    3'b111: control_out = 5'b00111; // AND
                endcase
            end
            
            3'b001: begin // I-type ALU
                case (fn3)
                    3'b000: control_out = 5'b00000; // ADD (no SUB for I-type)
                    3'b001: control_out = 5'b00001; // SLLI
                    3'b010: control_out = 5'b00010; // SLTI
                    3'b011: control_out = 5'b00011; // SLTIU
                    3'b100: control_out = 5'b00100; // XORI
                    3'b101: control_out = (imm11_5 == 7'h20) ? 5'b01101 : 5'b00101; // SRAI : SRLI
                    3'b110: control_out = 5'b00110; // ORI
                    3'b111: control_out = 5'b00111; // ANDI
                endcase
            end
            
            3'b010: control_out = 5'b00000; // Load: ADD
            3'b011: control_out = 5'b00000; // Store: ADD
            
            // Assume Branch mapping based on standard RISC-V (B-type) if needed later
            // 3'b100: control_out = ... 
            
            default: control_
