module imm_generator(
    input  logic [11:0] imm_input,       // decoder `imm`
    input  logic [2:0]  fn3,
    input  logic [6:0]  opcode,
    input  logic [19:0] imm_input_uj,    // decoder `imm_uj`
    output logic [31:0] imm_output
);

    always_comb begin
        case (opcode)
            // I-type (ALU I-instructions, Loads, JALR) and S-type (Stores)
            // (Assumes Decoder packs S-type inst[31:25] and inst[11:7] into imm_input)
            7'b0010011, 7'b0000011, 7'b1100111, 7'b0100011: begin
                imm_output = {{20{imm_input[11]}}, imm_input};
            end
            
            // B-type (Branches)
            // (Assumes Decoder packs the 12 branch bits into imm_input)
            // RISC-V branches shift the immediate left by 1 (LSB is 0)
            7'b1100011: begin
                imm_output = {{19{imm_input[11]}}, imm_input, 1'b0};
            end
            
            // U-type (LUI, AUIPC)
            // imm_input_uj corresponds to instruction[31:12], shifted left by 12
            7'b0110111, 7'b0010111: begin
                imm_output = {imm_input_uj, 12'b0};
            end
            
            // J-type (JAL)
            // J-immediate shuffling from instruction[31:12] (imm_input_uj)
            // imm[20] = inst[31] = imm_input_uj[19]
            // imm[19:12] = inst[19:12] = imm_input_uj[7:0]
            // imm[11] = inst[20] = imm_input_uj[8]
            // imm[10:1] = inst[30:21] = imm_input_uj[18:9]
            7'b1101111: begin
                imm_output = {{11{imm_input_uj[19]}}, imm_input_uj[19], imm_input_uj[7:0], imm_input_uj[8], imm_input_uj[18:9], 1'b0};
            end
            
            default: begin
                imm_output = 32'b0;
            end
        endcase
    end

endmodule
