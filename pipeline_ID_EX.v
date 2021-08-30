module ID_EX
(
    clk_i,
    // Pipeline Registers
    pc_i,       // 32 bits
    RS1data_i,  // 32 bits
    RS2data_i,  // 32 bits
    RDaddr_i,   // 5 bits
    sign_ext_i, // 32 bits
    pc_o,       // 32 bits
    RS1data_o,  // 32 bits
    RS2data_o,  // 32 bits
    RDaddr_o,   // 5 bits
    sign_ext_o, // 32 bits
    /**

    Pipline Control Signals

    **/
    //EXE stage control signals
    ALUsrc_i,
    ALUOp_i,
    instruction_i,
    ALUsrc_o,
    ALUOp_o,
    instruction_o,
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
input                   clk_i;
// Pipeline Registers
input       [31:0]      pc_i;
input       [31:0]      RS1data_i;  // 32 bits
input       [31:0]      RS2data_i;  // 32 bits
input       [4:0]       RDaddr_i;   // 5 bits
input       [31:0]      sign_ext_i;
output reg  [31:0]      pc_o;
output reg  [31:0]      RS1data_o;  // 32 bits
output reg  [31:0]      RS2data_o;  // 32 bits
output reg  [4:0]       RDaddr_o;   // 5 bits
output reg  [31:0]      sign_ext_o;

 /////////// Memory Stall ///////////
input MemStall_i;

/**

Pipline Control Signals###

**/
//EX stage control signal
input       ALUsrc_i;
input       [1:0]       ALUOp_i;
input       [31:0]      instruction_i;
output reg  ALUsrc_o;
output reg  [1:0]       ALUOp_o;
output reg  [31:0]      instruction_o;
//MEM stage control signal
input                   MemWrite_i;
input                   MemRead_i;
output reg              MemWrite_o;
output reg              MemRead_o;
//WB stage control signal
input                   MemtoReg_i;
input                   RegWrite_i;
output reg              MemtoReg_o;
output reg              RegWrite_o;


always@(posedge clk_i) 
begin
    if(~MemStall_i)
    begin
        pc_o <= pc_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        RDaddr_o <= RDaddr_i;
        sign_ext_o <= sign_ext_i;
        /**

        Pipline Control Signals###

        **/
        //EX stage control signals
        ALUsrc_o <= ALUsrc_i;
        ALUOp_o <= ALUOp_i;
        instruction_o <= instruction_i;
        //MEM stage control signals
        MemWrite_o <= MemWrite_i;
        MemRead_o <= MemRead_i;
        // WB stage control signals
        MemtoReg_o <= MemtoReg_i;
        RegWrite_o <= RegWrite_i;
    end
end

endmodule