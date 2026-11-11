module register_file(
    input  logic [4:0]  rs1_sel, rs2_sel,  // read addresses
    input  logic        reg_write,         // write enable
    input  logic        clk,
    input  logic        reset,             // Asynchronous, active high
    input  logic [31:0] wb_data,           // write data
    input  logic [4:0]  rd_sel,            // write address
    output logic [31:0] rs1_data, rs2_data // read data
);

    // 32 registers, each 32 bits wide
    logic [31:0] registers [31:0];

    // Write Port and Asynchronous Reset[cite: 10]
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (reg_write && rd_sel != 5'b00000) begin
            // Write to the specified register, unless it is x0 (which stays 0)
            registers[rd_sel] <= wb_data;
        end
    end

    // Read Ports (Combinational)
    // Register 0 always reads as 32-bit zero
    assign rs1_data = (rs1_sel == 5'b00000) ? 32'b0 : registers[rs1_sel];
    assign rs2_data = (rs2_sel == 5'b00000) ? 32'b0 : registers[rs2_sel];

endmodule
