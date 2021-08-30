module MEM_WB
(
    clk_i,
    RDaddr_i,
    ALUresult_i,
    MEMdata_i,
    RDaddr_o,
    ALUresult_o,
    MEMdata_o,
    /**

    Pipline Control Signals

    **/    
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
input   [4:0]       RDaddr_i;
input   [31:0]      ALUresult_i;
input   [31:0]      MEMdata_i;
output reg  [4:0]   RDaddr_o;
output reg  [31:0]  ALUresult_o;
output reg  [31:0]  MEMdata_o;

 /////////// Memory Stall ///////////
input   MemStall_i;

/**

Pipline Control Signals###

**/
//WB stage control signal
input       MemtoReg_i;
input       RegWrite_i;
output reg  MemtoReg_o;
output reg  RegWrite_o;

always@(posedge clk_i) 
begin
    if(~MemStall_i)
    begin
        RDaddr_o <= RDaddr_i;
        ALUresult_o <= ALUresult_i;
        MEMdata_o <= MEMdata_i;
        /**

        Pipline Control Signals###

        **/
        // WB stage control signals
        MemtoReg_o <= MemtoReg_i;
        RegWrite_o <= RegWrite_i;
    end
    else 
    begin
        RegWrite_o<=1'b0;
    end
end
endmodule