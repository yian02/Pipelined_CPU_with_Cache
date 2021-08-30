`define R_Type 7'b0110011
`define I_Type 7'b0010011
`define LW     7'b0000011
`define SW     7'b0100011
`define BEQ    7'b1100011

module Control(
    clk_i,
    Op_i,
    Stall_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    // to supprot data memory
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

input clk_i;
input [6:0] Op_i;
input Stall_i;
output reg [1:0] ALUOp_o;
output reg ALUSrc_o;
output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg Branch_o;


always@(Op_i or Stall_i)
//always@(posedge clk_i)
begin
    if(Stall_i == 1)
    begin
        RegWrite_o <= 1'b0;
        MemtoReg_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        Branch_o <=1'b0;
    end
    else
    begin
        case (Op_i)
            `R_Type: begin
                    ALUSrc_o <= 1'b0;
                    RegWrite_o <= 1'b1;
                    ALUOp_o <= 2'b00;
                    MemtoReg_o <= 1'b0;
                    MemRead_o <= 1'b0;
                    MemWrite_o <= 1'b0;
                    Branch_o <=1'b0;
                end    
            `I_Type: begin
                    ALUSrc_o <= 1'b1;
                    RegWrite_o <= 1'b1;
                    ALUOp_o <=2'b10;
                    MemtoReg_o <= 1'b0;
                    MemRead_o <= 1'b0;
                    MemWrite_o <= 1'b0;
                    Branch_o <=1'b0;
                end
            `LW: begin//not done
                    ALUSrc_o <= 1'b1;
                    RegWrite_o <= 1'b1;
                    ALUOp_o <=2'b10;
                    MemtoReg_o <= 1'b1;
                    MemRead_o <= 1'b1;
                    MemWrite_o <= 1'b0;
                    Branch_o <=1'b0;
                end    
            `SW: begin//not done
                    ALUSrc_o <= 1'b1;
                    RegWrite_o <= 1'b0;
                    ALUOp_o <=2'b10;
                    MemtoReg_o <= 1'b0;
                    MemRead_o <= 1'b0;
                    MemWrite_o <= 1'b1;
                    Branch_o <=1'b0;
                end    
            `BEQ: begin//not done
                    ALUSrc_o <= 1'b1;
                    RegWrite_o <= 1'b0;
                    ALUOp_o <=2'b10;
                    MemtoReg_o <= 1'b0;
                    MemRead_o <= 1'b0;
                    MemWrite_o <= 1'b0;
                    Branch_o <=1'b1;
                end    
            default:begin
                    RegWrite_o <= 1'b0;
                    MemtoReg_o <= 1'b0;
                    MemRead_o <= 1'b0;
                    MemWrite_o <= 1'b0;
                    Branch_o <=1'b0;
                end    
        endcase
    end
end

endmodule