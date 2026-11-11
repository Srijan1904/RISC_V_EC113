module id_stage(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,      // data to write back (from the WB stage)
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,
    output logic [6:0]  opcode_out_d,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3_out_d,
    output logic        fn7_5,
    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,
    output logic        mux_inp
);

    // Internal wires connecting the Decoder to other sub-modules
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [11:0] imm;
    logic [19:0] imm_uj;

    // 1. Decoder
    decoder decoder_inst (
        .instruction (instruction),
        .rs1         (rs1),
        .rs2         (rs2),
        .rd          (rd),
        .opcode      (opcode_out_d),
        .imm11_5     (imm11_5),
        .fn3         (fn3_out_d),
        .imm         (imm),
        .imm_uj      (imm_uj),
        .fn7_5       (fn7_5)
    );

    // 2. Immediate Generator
    imm_generator imm_gen_inst (
        .instruction (instruction),
        .opcode      (opcode_out_d),
        .imm_out     (imm_out)
    );

    // 3. Register File
    // Note: rd_wb (Write Address) and reg_write (Write Enable) are typically 
    // needed from the WB stage but aren't in this module's input list.
    register_file reg_file_inst (
        .clk         (clk),
        .reset       (reset),
        .read_reg1   (rs1),
        .read_reg2   (rs2),
        // .write_reg  (rd_wb_in),       // Needs to come from WB stage
        // .reg_write  (reg_write_in),   // Needs to come from WB stage
        .write_data  (wb_data),
        .read_data1  (rs1_data),
        .read_data2  (rs2_data)
    );

    // 4. Main Control
    main_control main_ctrl_inst (
        .opcode      (opcode_out_d),
        .aluop       (aluop),
        .memtoreg    (memtoreg),
        .branch      (branch),
        .mem_write   (mem_write),
        .mem_read    (mem_read),
        .alu_src     (alu_src),
        .mux_inp     (mux_inp)
        // .reg_write(reg_write_out)     // Usually generated here to pass down pipeline
    );

endmodule
