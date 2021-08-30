module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

integer            i, j;
wire [22:0] real_tag_i; 
wire is_valid_i;
wire dirty_i;
assign real_tag_i = tag_i[22:0];
assign is_valid_i = tag_i[24];
assign dirty_i = tag_i [23];
//LRU Reg
reg  used[0:15][0:1];
//

// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
                used[i][j] <= 1'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        //Handle write of 2-way associative cache + LRU
        if(hit_o) begin
            if(hit_0) begin
              // write to set 0
                data[addr_i][0] <= data_i;
                tag[addr_i][0] <= tag_i;
                //set used bit
                used[addr_i][0] = 1'b1;
                //clear used bit of the other set
                used[addr_i][1] = 1'b0;
            end
            else if (hit_1) begin
         // write to set 1
                data[addr_i][1] <= data_i;
                tag[addr_i][1] <= tag_i;
                //set used bit
                used[addr_i][1] = 1'b1;
                //clear used bit of the other set
                used[addr_i][0] = 1'b0;
            end
        end
        else begin
            if(~used[addr_i][0]) begin
                // write to set 0
                data[addr_i][0] <= data_i;
                tag[addr_i][0] <= tag_i;
                //set used bit
                used[addr_i][0] = 1'b1;
                //clear used bit of the other set
                used[addr_i][1] = 1'b0;
            end
            else if(~used[addr_i][1])
            begin
                // write to set 1
                data[addr_i][1] <= data_i;
                tag[addr_i][1] <= tag_i;
                //set used bit
                used[addr_i][1] = 1'b1;
                //clear used bit of the other set
                used[addr_i][0] = 1'b0;
            end
        end
    end
end

// Read Data      
wire hit_0;
wire hit_1;
wire [255:0] data_LRU;
wire [24:0] tag_LRU;
wire [255:0] data_hit;
wire [24:0] tag_hit;
assign hit_0 = ((tag[addr_i][0][22:0] == real_tag_i) && tag[addr_i][0][24] == 1'b1);
assign hit_1 = ((tag[addr_i][1][22:0] == real_tag_i) && tag[addr_i][1][24] == 1'b1);
assign hit_o =  hit_0 || hit_1;
assign data_LRU = used[addr_i][0] ? data[addr_i][1] : data[addr_i][0];
assign tag_LRU = used[addr_i][0] ? tag[addr_i][1] : tag[addr_i][0];
assign data_hit = (hit_0) ? data[addr_i][0] : data[addr_i][1];
assign tag_hit = (hit_0) ? data[addr_i][0] : data[addr_i][1];
assign tag_o = (hit_o) ? tag_hit : tag_LRU;
assign data_o = (hit_o) ? data_hit : data_LRU;

endmodule
