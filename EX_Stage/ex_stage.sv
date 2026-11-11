module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,    // current PC
    input  logic        branch,
    input  logic        alu_src,    // 0 = rs2_data, 1 = imm_out
    input  logic        fn7_5,
    input  logic        mux_inp,    // 1 = JALR
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,
    output logic        and_out_ex, // branch / jump taken
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out   // branch / jump target
);

    // Internal signals
    logic [31:0] alu_b;
    logic [4:0]  alu_ctrl_sig;
    logic        zero_flag;

    // ALU operand B selection: imm_out when alu_src is 1, else rs2_data[cite: 5]
    assign alu_b = alu_src ? imm_out : rs2_data;

    // ALU Control instantiation[cite: 5]
    alu_control alu_ctrl_inst (
        .alu_op     (aluop),
        .fn3        (fn3),
        .imm11_5    (imm11_5),
        .fn7_5      (fn7_5),
        .control_out(alu_ctrl_sig)
    );

    // ALU instantiation[cite: 5]
    alu #(.DATA_WIDTH(32)) alu_inst (
        .alu_control(alu_ctrl_sig),
        .rs1_data   (rs1_data),
        .rs2_data   (alu_b),
        .alu_out    (alu_out),
        .zero       (zero_flag)
    );

    // Branch / Jump Target Calculation
    // For JALR (mux_inp = 1), target is rs1_data + imm_out. 
    // For branches and JAL, target is address (PC) + imm_out.[cite: 5]
    assign pc_ex_out = mux_inp ? (rs1_data + imm_out) : (address + imm_out);

    // Branch / Jump taken logic
    // The ALU's zero output acts as the branch condition[cite: 5]
    assign and_out_ex = branch & zero_flag;

endmodule
