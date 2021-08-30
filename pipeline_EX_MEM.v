module EX_MEM
(
    clk_i,
    // PIPELINE REGISTER
    pc_i, // may change to another ALU output when implementing beq
    Zero_i,
    ALUresult_i,
    RS2data_i,
    RDaddr_i,
    pc_o,
    Zero_o,
    ALUresult_o,
    RS2data_o,
    RDaddr_o,
    /**

    Pipline Control Signals

    **/
    //MEM stage control signals
    MemWrite_i,
    MemRead_i,
    MemWrite_o,
    MemRead_o,
    //WB stage control signals
    MemtoReg_i,
    RegWrite_i,
    MemtoReg_o,
    RegWrite_o,

    /////////// Memory Stall ///////////
    MemStall_i
);

// Ports
input               clk_i;
// Pipeline Registers
input       [31:0]  pc_i;
input       [31:0]  ALUresult_i;
input       [31:0]  RS2data_i;
input       [4:0]   RDaddr_i;
input               Zero_i;
output reg  [31:0]  pc_o;
output reg  [31:0]  ALUresult_o;
output reg  [31:0]  RS2data_o;
output reg  [4:0]   RDaddr_o;
output reg          Zero_o;

  /////////// Memory Stall ///////////
input MemStall_i;

/**

Pipline Control Signals###

**/
//MEM stage control signal
input               MemWrite_i;
input               MemRead_i;
output reg          MemWrite_o;
output reg          MemRead_o;
//WB stage control signal
input               MemtoReg_i;
input               RegWrite_i;
output reg          MemtoReg_o;
output reg          RegWrite_o;


always@( posedge clk_i) 
begin
  if(~MemStall_i)
  begin
    pc_o <= pc_i;
    ALUresult_o <= ALUresult_i;
    RS2data_o <= RS2data_i;
    RDaddr_o <= RDaddr_i;
    Zero_o <= Zero_i;
    /**

    Pipline Control Signals###

    **/
    //MEM stage control signals
    MemWrite_o <= MemWrite_i;
    MemRead_o <= MemRead_i;
    // WB stage control signals
    MemtoReg_o <= MemtoReg_i;
    RegWrite_o <= RegWrite_i;
  end
end
endmodule