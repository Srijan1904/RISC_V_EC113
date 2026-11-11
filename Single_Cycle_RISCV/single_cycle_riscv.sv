module single_cycle_riscv (
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction, // from instruction memory (addressed by `address`)
    input  logic [31:0] mem_out,     // from data memory
    output logic [31:0] rs2_data,    // store data
    output logic [31:0] alu_out,     // data memory address
    output logic        mem_write,
    output logic        mem_read,
    output logic [2:0]  fn3,         // load / store width
    output logic [6:0]  opcode,
    output logic [31:0] address      // PC
);

    // Internal connecting wires
    logic [31:0] pc_new;
    logic        and_out_ex;
    logic [31:0] pc_ex_out;
    
    logic [31:0] rs1_data;
    logic [31:0] imm_out;
    logic [6:0]  imm11_5;
    logic        fn7_5;
    logic [2:0]  aluop;
    logic [1:0]  memtoreg;
    logic        branch;
    logic        alu_src;
    logic        mux_inp;
    
    logic [31:0] wb_data;

    // 1. IF Stage (Instruction Fetch)
    if_stage if_inst (
        .clk             (clk),
        .reset           (reset),
        .stall           (stall),
        .and_out         (and_out_ex),
        .pc_signed_offset(pc_ex_out),
        .address         (address),
        .pc_new          (pc_new)
    );

    // 2. ID Stage (Instruction Decode)
    id_stage id_inst (
        .clk             (clk),
        .reset           (reset),
        .stall           (stall),
        .instruction     (instruction),
        .wb_data         (wb_data),
        .rs1_data        (rs1_data),
        .rs2_data        (rs2_data),
        .imm_out         (imm_out),
        .opcode_out_d    (opcode),
        .imm11_5         (imm11_5),
        .fn3_out_d       (fn3),
        .fn7_5           (fn7_5),
        .aluop           (aluop),
        .memtoreg        (memtoreg),
        .branch          (branch),
        .mem_write       (mem_write),
        .mem_read        (mem_read),
        .alu_src         (alu_src),
        .mux_inp         (mux_inp)
    );

    // 3. EX Stage (Execute)
    ex_stage ex_inst (
        .rs1_data        (rs1_data),
        .rs2_data        (rs2_data),
        .imm_out         (imm_out),
        .address         (address),
        .branch          (branch),
        .alu_src         (alu_src),
        .fn7_5           (fn7_5),
        .mux_inp         (mux_inp),
        .fn3             (fn3),
        .imm11_5         (imm11_5),
        .aluop           (aluop),
        .opcode          (opcode),
        .and_out_ex      (and_out_ex),
        .alu_out         (alu_out),
        .pc_ex_out       (pc_ex_out)
    );

    // 4. WB Stage Logic (Write Back)
    // Selects the data to be written back to the register file
    always_comb begin
        if (opcode == 7'b1101111 || opcode == 7'b1100111) begin 
            // JAL or JALR: write PC + 4 to destination register
            wb_data = pc_new;
        end else if (memtoreg == 2'b01) begin 
            // Load instruction: write data from memory
            wb_data = mem_out;
        end else begin 
            // R-type, I-type ALU, U-type: write ALU result
            wb_data = alu_out;
        end
    end

endmodule
