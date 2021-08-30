module Hazard_Detection(
    ID_EX_MEMRead_i,
    ID_EX_RDaddr_i,
    IF_ID_RS1addr_i,
    IF_ID_RS2addr_i,
    PCWrite_o,
    IF_ID_Write_o,
    Stall_o
);

input ID_EX_MEMRead_i;
input [4:0] ID_EX_RDaddr_i;
input [4:0] IF_ID_RS1addr_i;
input [4:0] IF_ID_RS2addr_i;
output reg PCWrite_o;
output reg IF_ID_Write_o;
output reg Stall_o;

always@( ID_EX_MEMRead_i or ID_EX_RDaddr_i or IF_ID_RS1addr_i or IF_ID_RS2addr_i )
begin
    // only handles the lw hazard
    if (ID_EX_MEMRead_i && (ID_EX_RDaddr_i == IF_ID_RS1addr_i || ID_EX_RDaddr_i == IF_ID_RS2addr_i )) 
    begin
        Stall_o <= 1;
        IF_ID_Write_o <= 0;
        PCWrite_o <= 0;
    end
    else 
    begin
        Stall_o <= 0;
        IF_ID_Write_o <= 1;
        PCWrite_o <= 1;
    end
end
endmodule