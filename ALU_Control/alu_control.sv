module alu_control (
    input  logic [2:0] alu_op,      // operation class from main_control
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,     // instruction[31:25]: shift qualifier (I-type)
    input  logic       fn7_5,       // instruction[30]: SUB / SRA qualifier (R-type)
    output logic [4:0] control_out
);

    localparam logic [4:0] ADD  = 5'b00000;
    localparam logic [4:0] SUB  = 5'b00001;
    localparam logic [4:0] XOR_ = 5'b00010;
    localparam logic [4:0] OR_  = 5'b00011;
    localparam logic [4:0] AND_ = 5'b00100;
    localparam logic [4:0] SLL  = 5'b00101;
    localparam logic [4:0] SRL  = 5'b00110;
    localparam logic [4:0] SRA  = 5'b00111;
    localparam logic [4:0] SLT  = 5'b01000;
    localparam logic [4:0] SLTU = 5'b01001;
    localparam logic [4:0] BEQ  = 5'b01010;
    localparam logic [4:0] BNE  = 5'b01011;
    localparam logic [4:0] BLT  = 5'b01100;
    localparam logic [4:0] BGE  = 5'b01101;
    localparam logic [4:0] BLTU = 5'b01110;
    localparam logic [4:0] BGEU = 5'b01111;

    always_comb begin
        control_out = ADD;

        case (alu_op)
            3'b000: begin                       // R-type
                case (fn3)
                    3'b000: control_out = fn7_5 ? SUB : ADD;
                    3'b001: control_out = SLL;
                    3'b010: control_out = SLT;
                    3'b011: control_out = SLTU;
                    3'b100: control_out = XOR_;
                    3'b101: control_out = fn7_5 ? SRA : SRL;
                    3'b110: control_out = OR_;
                    3'b111: control_out = AND_;
                    default: control_out = ADD;
                endcase
            end

            3'b001: begin                       // I-type ALU (no SUB)
                case (fn3)
                    3'b000: control_out = ADD;
                    3'b001: control_out = SLL;
                    3'b010: control_out = SLT;
                    3'b011: control_out = SLTU;
                    3'b100: control_out = XOR_;
                    3'b101: control_out = (imm11_5 == 7'h20) ? SRA : SRL;
                    3'b110: control_out = OR_;
                    3'b111: control_out = AND_;
                    default: control_out = ADD;
                endcase
            end

            3'b010: control_out = ADD;          // Load
            3'b011: control_out = ADD;          // Store

            3'b100: begin                       // Branch
                case (fn3)
                    3'b000: control_out = BEQ;
                    3'b001: control_out = BNE;
                    3'b100: control_out = BLT;
                    3'b101: control_out = BGE;
                    3'b110: control_out = BLTU;
                    3'b111: control_out = BGEU;
                    default: control_out = ADD;
                endcase
            end

            3'b110: control_out = ADD;          // JAL / LUI
            default: control_out = ADD;
        endcase
    end

endmodule
