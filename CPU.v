module CPU
(
    clk_i, 
    rst_i,
    start_i,

    mem_data_i, 
    mem_ack_i,
    mem_data_o,
    mem_addr_o,
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

//wires
wire [255:0] mem_data;
wire [31:0] mem_addr;
wire mem_enable;
wire mem_write;


// Memory
input [255:0] mem_data_i;
input mem_ack_i;
output [255:0] mem_data_o ;
output [31:0] mem_addr_o;
output mem_enable_o;
output mem_write_o;

assign mem_data_o = mem_data;
assign mem_addr_o = mem_addr;
assign mem_enable_o = mem_enable;
assign mem_write_o = mem_write;

dcache_controller dcache(
    // System clock, reset and stall
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    // to Data Memory interface        
    .mem_data_i     (mem_data_i), 
    .mem_ack_i      (mem_ack_i),     
    .mem_data_o     (mem_data), 
    .mem_addr_o     (mem_addr),     
    .mem_enable_o   (mem_enable), 
    .mem_write_o    (mem_write), 
    
    // to CPU interface    
    .cpu_data_i     (EX_MEM.RS2data_o), 
    .cpu_addr_i     (EX_MEM.ALUresult_o),     
    .cpu_MemRead_i  (EX_MEM.MemRead_o), 
    .cpu_MemWrite_i (EX_MEM.MemWrite_o), 
    .cpu_data_o     (), 
    .cpu_stall_o    ()
);


Control Control(
    .clk_i      (clk_i),
    .Op_i       (IF_ID.instruction_o[6:0]),
    .Stall_i    (Hazard_Detection.Stall_o),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o ()
);

Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (PC_Src.data_o),
    .PCWrite_i  (Hazard_Detection.PCWrite_o),
	.stall_i	(dcache.cpu_stall_o),
    .pc_o       ()
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    ()
);

Registers Registers(
    .clk_i       (clk_i),
    .RS1addr_i   (IF_ID.instruction_o [19:15]),
    .RS2addr_i   (IF_ID.instruction_o [24:20]),
    .RDaddr_i    (MEM_WB.RDaddr_o), 
    .RDdata_i    (MUX_MemtoReg.data_o),
    .RegWrite_i  (MEM_WB.RegWrite_o),
    .RS1data_o   (), 
    .RS2data_o   () 
);

MUX32 MUX_ALUSrc(
    .data1_i    (Forwarding_MUX_B.data_o),
    .data2_i    (ID_EX.sign_ext_o),
    .select_i   (ID_EX.ALUsrc_o),
    .data_o     ()
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEM_WB.ALUresult_o),
    .data2_i    (MEM_WB.MEMdata_o),
    .select_i   (MEM_WB.MemtoReg_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .instruction_i     (IF_ID.instruction_o),
    .data_o            ()
);

ALU ALU(
    .data1_i    (Forwarding_MUX_A.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({ID_EX.instruction_o[31:25], ID_EX.instruction_o[14:12]}),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  ()
);


IF_ID IF_ID(
	.MemStall_i		 (dcache.cpu_stall_o), 
    .clk_i           (clk_i),
    .pc_i            (PC.pc_o),
    .IF_ID_Write_i   (Hazard_Detection.IF_ID_Write_o),
    .pc_o            (),
    .instruction_i   (Instruction_Memory.instr_o),
    .instruction_o   (),
    .Flush_i         (Flush)
);

ID_EX ID_EX(
	.MemStall_i		 (dcache.cpu_stall_o), 
    .clk_i           (clk_i),
    .pc_i            (IF_ID.pc_o), 
    .RS1data_i       ( Registers.RS1data_o ), 
    .RS2data_i       (Registers.RS2data_o),
    .RDaddr_i        (IF_ID.instruction_o [11:7]), 
    .sign_ext_i      (Sign_Extend.data_o),
    .pc_o            (), 
    .RS1data_o       (), 
    .RS2data_o       (),
    .RDaddr_o        (),
    .sign_ext_o      (), 
    /**

    Pipline Control Signals###

    **/
    //EXE stage control signals
    .ALUsrc_i        (Control.ALUSrc_o),
    .ALUOp_i         (Control.ALUOp_o),
    .instruction_i   (IF_ID.instruction_o),
    .ALUsrc_o        (),
    .ALUOp_o         (),
    .instruction_o   (),
    //MEM stage control signals
    .MemWrite_i      (Control.MemWrite_o),
    .MemRead_i       (Control.MemRead_o),
    .MemWrite_o      (),
    .MemRead_o       (),
    //WB stage control signals
    .MemtoReg_i      (Control.MemtoReg_o),
    .RegWrite_i      (Control.RegWrite_o),
    .MemtoReg_o      (), 
    .RegWrite_o      ()
);

EX_MEM EX_MEM(
	.MemStall_i		 (dcache.cpu_stall_o), 
    .clk_i          (clk_i),
    .pc_i           (ID_EX.pc_o), // may change to another ALU output when implementing beq
    .Zero_i         (ALU.Zero_o),
    .ALUresult_i    (ALU.data_o),
    .RS2data_i      (Forwarding_MUX_B.data_o),
    .RDaddr_i       (ID_EX.RDaddr_o),
    .pc_o           (),
    .Zero_o         (),
    .ALUresult_o    (),
    .RS2data_o      (),
    .RDaddr_o       (),
    /**

    Pipline Control Signals###

    **/
    //MEM stage control signals
    .MemWrite_i     (ID_EX.MemWrite_o),
    .MemRead_i      (ID_EX.MemRead_o),
    .MemWrite_o     (),
    .MemRead_o      (),
    //WB stage control signals
    .MemtoReg_i     (ID_EX.MemtoReg_o),
    .RegWrite_i     (ID_EX.RegWrite_o),
    .MemtoReg_o     (),
    .RegWrite_o     ()
);

MEM_WB MEM_WB(
	.MemStall_i		 (dcache.cpu_stall_o), 
    .clk_i          (clk_i),
    .RDaddr_i       (EX_MEM.RDaddr_o),
    .ALUresult_i    (EX_MEM.ALUresult_o),
    .MEMdata_i      (dcache.cpu_data_o),
    .RDaddr_o       (),
    .ALUresult_o    (),
    .MEMdata_o      (),
    /**

    Pipline Control Signals###

    **/
    //WB stage control signals
    .MemtoReg_i     (EX_MEM.MemtoReg_o),
    .RegWrite_i     (EX_MEM.RegWrite_o),
    .MemtoReg_o     (),
    .RegWrite_o     ()

);

Forwarding_Unit Forwarding_Unit(
    .clk_i          (clk_i),
    .EX_RS1_i       (ID_EX.instruction_o [19:15]),
    .EX_RS2_i       (ID_EX.instruction_o [24:20]),
    .WB_RD_i        (MEM_WB.RDaddr_o),
    .WB_RegWrite_i  (MEM_WB.RegWrite_o),
    .MEM_RD_i       (EX_MEM.RDaddr_o),
    .MEM_RegWrite_i (EX_MEM.RegWrite_o),
    .ForwardA_o     (),
    .ForwardB_o     ()
);

Forwarding_MUX Forwarding_MUX_A(
    .port00_i (ID_EX.RS1data_o),
    .port01_i (MUX_MemtoReg.data_o),
    .port10_i (EX_MEM.ALUresult_o),
    .select_i (Forwarding_Unit.ForwardA_o),
    .data_o   ()
);

Forwarding_MUX Forwarding_MUX_B(
    .port00_i (ID_EX.RS2data_o),
    .port01_i (MUX_MemtoReg.data_o),
    .port10_i (EX_MEM.ALUresult_o),
    .select_i (Forwarding_Unit.ForwardB_o),
    .data_o   ()
);

Hazard_Detection Hazard_Detection(
    .ID_EX_MEMRead_i    (ID_EX.MemRead_o),
    .ID_EX_RDaddr_i     (ID_EX.RDaddr_o),
    .IF_ID_RS1addr_i    (IF_ID.instruction_o [19:15]),
    .IF_ID_RS2addr_i    (IF_ID.instruction_o [24:20]),
    .PCWrite_o          (),
    .IF_ID_Write_o      (),
    .Stall_o            ()
);

MUX32 PC_Src(
    .data1_i    (Add_PC.data_o),
    .data2_i    (Branch_pc_adder.data_o),
    .select_i   (Flush),
    .data_o     ()
);

// Determine wether the Branch is taken.
// Because the input is from register file, which is in the ID stage, so the branch taken or not is determine in the ID stage.
wire Flush = (Control.Branch_o == 1 && (Registers.RS1data_o == Registers.RS2data_o)) ? 1 : 0;

Adder Branch_pc_adder(
    .data1_in   (IF_ID.pc_o),
    .data2_in   (Sign_Extend.data_o),
    .data_o     ()
);

endmodule