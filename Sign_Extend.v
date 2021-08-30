`define R_Type 7'b0110011
`define I_Type 7'b0010011
`define LW     7'b0000011
`define SW     7'b0100011
`define BEQ    7'b1100011

module Sign_Extend(
    instruction_i,
    data_o
);
input [31:0] instruction_i;
output reg [31:0] data_o;



always@(instruction_i)
begin
case (instruction_i[6:0])
    `R_Type: begin
        data_o <= { { 20{ instruction_i[31] } }, instruction_i[31:20] };
        end    
    `I_Type: begin
        data_o <= { { 20{ instruction_i[31] } }, instruction_i[31:20] };
        end
    `LW: begin
        data_o <= { { 20{ instruction_i[31] } }, instruction_i[31:20] }; 
        end    
    `SW: begin
        data_o <= { { 20{ instruction_i[31] } }, instruction_i[31:25], instruction_i[11:7]};
        end    
    `BEQ: begin
        data_o <= { { 19{ instruction_i[31] } }, instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0};
        end    
    default:begin
        data_o <= {32{1'b0}};
        end    
endcase
end


endmodule