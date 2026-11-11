module wb_stage(
    input  logic [31:0] mem_out,          // data from data memory
    input  logic [31:0] alu_out,
    input  logic [31:0] return_addr,      // PC + 4
    input  logic [31:0] imm_out,          // LUI immediate
    input  logic [31:0] pc_signed_offset, // PC + upper immediate (AUIPC)
    input  logic [1:0]  memtoreg,
    input  logic [6:0]  opcode_out_d,
    output logic [31:0] wb_data
);

    always_comb begin
        case (opcode_out_d)
            7'b1101111,               // JAL
            7'b1100111: begin         // JALR
                wb_data = return_addr; 
            end
            
            7'b0110111: begin         // LUI
                wb_data = imm_out;
            end
            
            7'b0010111: begin         // AUIPC
                wb_data = pc_signed_offset;
            end
            
            default: begin
                // Standard R-type, I-type ALU, and Loads
                // memtoreg == 2'b01 typically selects memory data
                if (memtoreg == 2'b01) begin
                    wb_data = mem_out;
                end else begin
                    wb_data = alu_out;
                end
            end
        endcase
    end

endmodule
