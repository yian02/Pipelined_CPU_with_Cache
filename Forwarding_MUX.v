module Forwarding_MUX(
    port00_i,
    port01_i,
    port10_i,
    select_i,
    data_o
);

input [31:0] port00_i;
input [31:0] port01_i;
input [31:0] port10_i;
input [1:0]  select_i;

output reg [31:0] data_o;

always@(port00_i or port01_i or port10_i or select_i)
begin
    case (select_i)
        2'b00: 
        begin
            data_o <= port00_i;
        end
        2'b01:
        begin
            data_o <= port01_i;
        end
        2'b10:
        begin
            data_o <= port10_i;
        end
    endcase
end

endmodule