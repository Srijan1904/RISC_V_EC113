module aludec(
    input  logic       opb5,        // instruction bit [5] of opcode
    input  logic [2:0] funct3,      // funct3 field of instruction
    input  logic       funct7b5,    // bit 5 of funct7 field
    input  logic [1:0] ALUOp,       // high-level ALU operation
    output logic [2:0] ALUControl   // ALU operation code
);

    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5;   // 1 only for R-type SUB

    always_comb begin
        case (ALUOp)
            2'b00:   ALUControl = 3'b000;   // LW, SW: add
            2'b01:   ALUControl = 3'b001;   // BEQ: subtract
            default: begin                  // R-type and I-type arithmetic
                case (funct3)
                    3'b000:  ALUControl = RtypeSub ? 3'b001 : 3'b000; // SUB / ADD, ADDI
                    3'b010:  ALUControl = 3'b101;                     // SLT, SLTI
                    3'b110:  ALUControl = 3'b011;                     // OR, ORI
                    3'b111:  ALUControl = 3'b010;                     // AND, ANDI
                    default: ALUControl = 3'b000;
                endcase
            end
        endcase
    end

endmodule
