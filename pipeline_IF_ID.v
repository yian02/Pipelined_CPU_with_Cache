module IF_ID
(
    clk_i,
    pc_i,
    IF_ID_Write_i,
    Flush_i,
    pc_o,
    instruction_i,
    instruction_o,

    /////////// Memory Stall ///////////
    MemStall_i
);

// Ports
input                   clk_i;
input       [31:0]      pc_i;
input       [31:0]      instruction_i;
input                   IF_ID_Write_i;
input                   Flush_i;
output reg  [31:0]      pc_o;
output reg  [31:0]      instruction_o;

 /////////// Memory Stall ///////////
input MemStall_i;

always@( posedge clk_i) 
begin
        if(IF_ID_Write_i == 1 && ~MemStall_i)
        begin
            pc_o <= pc_i;
            instruction_o <= instruction_i;
        end
        if(Flush_i == 1)
        begin
            pc_o <= 32'b0;
            instruction_o <= 32'b0;
        end
end
endmodule