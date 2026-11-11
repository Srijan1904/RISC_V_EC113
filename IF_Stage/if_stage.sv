module if_stage (
    input  logic        clk,
    input  logic        reset,          // Asynchronous, active high
    input  logic        stall,          // Hold the PC
    input  logic        and_out,        // 1 = take branch/jump target
    input  logic [31:0] pc_signed_offset, // Branch / jump target address
    output logic [31:0] address,        // Current PC
    output logic [31:0] pc_new          // PC + 4
);

    logic [31:0] next_pc;

    // Next PC calculation: PC + 4[cite: 7]
    assign pc_new = address + 32'd4;

    // Next PC selection mux
    // If and_out is 1, take the branch/jump target (pc_signed_offset).
    // Otherwise, take PC + 4 (pc_new)[cite: 7].
    assign next_pc = and_out ? pc_signed_offset : pc_new;

    // Program Counter Register
    // Asynchronous, active high reset[cite: 7]
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            address <= 32'b0; // Or standard reset address like 32'h00000000
        end else if (!stall) begin // Only update PC if not stalled[cite: 7]
            address <= next_pc;
        end
        // If stall is 1, address holds its current value implicitly[cite: 7]
    end

endmodule
