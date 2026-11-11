module alu(
    input  logic [31:0] a, b,        // operands
    input  logic [2:0]  alucontrol,  // operation selector
    output logic [31:0] result       // operation result
);

    always_comb begin
        case (alucontrol)
            3'b000:  result = a + b;                              // Add
            3'b001:  result = a - b;                              // Subtract
            3'b010:  result = a & b;                              // AND
            3'b011:  result = a | b;                              // OR
            3'b101:  result = {31'b0, ($signed(a) < $signed(b))}; // SLT
            default: result = 32'b0;                              // unused codes
        endcase
    end

endmodule
