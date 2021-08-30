module Forwarding_Unit(
    clk_i,
    EX_RS1_i,
    EX_RS2_i,
    WB_RD_i,
    WB_RegWrite_i,
    MEM_RD_i,
    MEM_RegWrite_i,
    ForwardA_o,
    ForwardB_o
);

input       clk_i;
input [4:0] EX_RS1_i;
input [4:0] EX_RS2_i;
input [4:0] WB_RD_i;
input       WB_RegWrite_i;
input [4:0] MEM_RD_i;
input       MEM_RegWrite_i;

output reg [1:0] ForwardA_o;
output reg [1:0] ForwardB_o;

always@( posedge clk_i or EX_RS1_i or EX_RS2_i or WB_RD_i or WB_RegWrite_i or MEM_RD_i or MEM_RegWrite_i )
begin
    // Forward A
    if( MEM_RegWrite_i && (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS1_i) )
    begin
        ForwardA_o <= 2'b10;
    end
    else if( WB_RegWrite_i && (! ( MEM_RegWrite_i && (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS1_i) )  ) && (WB_RD_i == EX_RS1_i) ) 
    begin
        ForwardA_o <= 2'b01;
    end
    else begin
        ForwardA_o <= 2'b00;
    end

    // Forward B
    if( MEM_RegWrite_i && (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS2_i) )
    begin
        ForwardB_o <= 2'b10;
    end
    else if(WB_RegWrite_i && (! ( MEM_RegWrite_i && (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS2_i) )  ) && (WB_RD_i == EX_RS2_i))
    begin
        ForwardB_o <= 2'b01;
    end
    else begin
        ForwardB_o <= 2'b00;
    end
end

endmodule