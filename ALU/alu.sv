module alu #(parameter int DATA_WIDTH = 32)(
    input  logic [4:0]            alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,
    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero      // branch condition true
);

    always_comb begin
        case (alu_control)
            // Example mappings (Please provide the ALU Control Table for exact mappings)
            5'b00000: alu_out = rs1_data + rs2_data; // ADD
            5'b01000: alu_out = rs1_data - rs2_data; // SUB
            5'b00001: alu_out = rs1_data << rs2_data[4:0]; // SLL
            5'b00010: alu_out = ($signed(rs1_data) <$signed(rs2_data)) ? 1 : 0; // SLT
            5'b00011: alu_out = (rs1_data < rs2_data) ? 1 : 0; // SLTU
            5'b00100: alu_out = rs1_data ^ rs2_data; // XOR
            5'b00101: alu_out = rs1_data >> rs2_data[4:0]; // SRL
            5'b0
