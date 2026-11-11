module decoder(
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,   // instruction[31:25] (I-type ALU only)
    output logic [2:0]  fn3,
    output logic [11:0] imm,       // I / S / B immediate bits
    output logic [19:0] imm_uj,    // U / J immediate bits
    output logic        fn7_5      // instruction[30] (R-type only)
);

    // Extracting fields from the 32-bit RISC-V instruction
    assign opcode  = instruction[6:0];
    assign rd      = instruction[11:7];
    assign fn3     = instruction[14:12];
    assign rs1     = instruction[19:15];
    assign rs2     = instruction[24:20];
    
    // Immediate and function fields based on the specification
    assign imm11_5 = instruction[31:25];
    assign imm     = instruction[31:20];
    assign imm_uj  = instruction[31:12];
    assign fn7_5   = instruction[30];

endmodule
