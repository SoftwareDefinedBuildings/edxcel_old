
`timescale 1 ns / 1 ps


	module EdXel_v1_1_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 16,
		
		parameter integer NUM_EPU = 2
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY,
		
		//DEBUG
		output wire epu0_valid,
		output wire epu0_sok,
		output wire epu0_rdy,
		output wire [31:0] epu0_sigl,
		output wire [31:0] epu0_keyl,
		output wire [31:0] epu0_rhashl,
		input wire epu_clock
	);


    
    localparam integer PL_VERSION = 32'h0410_0147;
    
	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 15;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	integer raddr;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

    //XTAG EPU assets

    
    reg [511:0] epu_sig [0:NUM_EPU-1];
    reg [255:0] epu_key [0:NUM_EPU-1];
    reg [255:0] epu_rhash [0:NUM_EPU-1];
    reg epu_vld [0:NUM_EPU-1];
    wire epu_rdy [0:NUM_EPU-1];
    wire epu_sok [0:NUM_EPU-1];
    wire epu_rst [0:NUM_EPU-1];
    generate
    genvar ep_idx;
    for (ep_idx = 0; ep_idx < NUM_EPU; ep_idx = ep_idx + 1)
    begin
        EPU U (
             .axiclk(S_AXI_ACLK),
             .modclk(epu_clock),
             .resetn(S_AXI_ARESETN),
             .sig(epu_sig[ep_idx]),
             .key(epu_key[ep_idx]),
             .rhash(epu_rhash[ep_idx]),
             .ready(epu_rdy[ep_idx]),
             .result(epu_sok[ep_idx]),
             .valid(epu_vld[ep_idx])
        );
    end
    endgenerate
    
    assign epu0_valid = epu_vld[0];
    assign epu0_sok = epu_sok[0];
    assign epu0_rdy = epu_rdy[0];
    assign epu0_sigl = epu_sig[0][31:0];
    assign epu0_keyl = epu_key[0][31:0];
    assign epu0_rhashl = epu_rhash[0][31:0];
    
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	        end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin : rstblock
	       //XTAG: reset logic
            integer ni;
            //for (ni = 0; ni < NUM_EPU; ni=ni+1)
            //    epu_vld[ni] <= 0;
                    
	    end 
	 end
	



generate
genvar n;  
for (n=0;n<NUM_EPU;n=n+1) 
begin : epu_loops
	always @( posedge S_AXI_ACLK )
	begin
	  
	  epu_rhash[n] <= epu_rhash[n];
      epu_sig[n] <= epu_sig[n];
      epu_key[n] <= epu_key[n];
      epu_vld[n] <= epu_vld[n];
      if ( epu_rdy[n] == 1'b0 )
      begin
        epu_vld[n] <= 1'b0;
      end
	  if ( S_AXI_ARESETN == 1'b1 && slv_reg_wren)
	   begin
           if ( axi_awaddr[15:8] == 8'h20 + n ) 
           begin //Choose an EPU
                //Signature
                for (raddr = 0; raddr < 64; raddr = raddr + 4) 
                begin
                   if (axi_awaddr[7:0] == raddr ) 
                   begin
                       for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                       begin
                             if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                               epu_sig[n][(raddr + byte_index)*8 +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                             end
                       end
                   end
                end
                
                //Public key
                for (raddr = 0; raddr < 32; raddr = raddr + 4) 
                begin
                    if (axi_awaddr[7:0] == raddr + 8'h80 ) 
                    begin
                        for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                        begin
                              if ( S_AXI_WSTRB[byte_index] == 1 ) 
                              begin
                                epu_key[n][(raddr + byte_index)*8 +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                              end
                        end
                    end
                end
                //Message
                for (raddr = 0; raddr < 32; raddr = raddr + 4) 
                begin
                  if (axi_awaddr[7:0] == raddr + 8'hA0 )
                  begin
                      for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                      begin
                            if ( S_AXI_WSTRB[byte_index] == 1 ) 
                            begin
                              epu_rhash[n][(raddr + byte_index)*8 +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                            end
                      end
                  end
                end //message*/
              //Go
              if (axi_awaddr[7:0] == 8'hC0)
              begin
                if ( S_AXI_WDATA[31:0] == 32'h00000410)
                    epu_vld[n] <= 1'b1;
              end
              //Go
              if (axi_awaddr[7:0] == 8'hC4)
              begin
                   epu_vld[n] <= 1'b1;
              end
              //Go
               if (axi_awaddr[7:0] == 8'hC8)
               begin
                    epu_vld[n] <= 1'b0;
               end
               //RST
              if (axi_awaddr[7:0] == 8'hCC)
              begin
                   epu_vld[n] <= 1'b0;
                   epu_rhash[n] <= 0;
                   epu_sig[n] <= 0;
                   epu_key[n] <= 0;
              end
           end //choose epu
       end //if wren
   end //always
end //for loop
endgenerate

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

    integer epu_num;
    reg found;
	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	
	always @(*)
	begin
	      reg_data_out <= 0;
	      // Address decoding for reading registers
	      if (axi_araddr[15:8] == 8'h00) 
	      begin
              case ( axi_araddr[7:0] )
                8'h00 : reg_data_out <= PL_VERSION;
                8'h04 : reg_data_out <= NUM_EPU;
                8'h08 : begin
                               reg_data_out <= 16'hFFFF;
                               for (epu_num=0;epu_num<NUM_EPU; epu_num = epu_num + 1) 
                               begin
                                   reg_data_out[epu_num] <= !epu_rdy[epu_num];
                               end
                           end
                8'h14 : begin
                              reg_data_out <= 16'h00FF;
                              found = 0;
                              for (epu_num=0;epu_num<NUM_EPU; epu_num = epu_num + 1) 
                              begin
                                  if (epu_rdy[epu_num] && found == 0)
                                  begin
                                    reg_data_out <= epu_num;
                                    found <= 1;
                                  end
                              end
                            end
                8'h18 : begin
                              reg_data_out <= 16'hFFFF;
                              for (epu_num=0;epu_num<NUM_EPU; epu_num = epu_num + 1) 
                              begin
                                  reg_data_out[epu_num] <= !epu_sok[epu_num];
                              end
                        end
                default : reg_data_out <= 0;
	          endcase
	      end else begin : epu_goregblock
	          integer epmi;
	          for (epmi = 0; epmi < NUM_EPU; epmi=epmi+1)
	          begin
                  if (axi_araddr[15:8] == 8'h20 + epmi)
                  begin
                      case ( axi_araddr[7:0] )
                          8'hC0 : begin
                                      if ( epu_rdy[epmi] )
                                      begin
                                          if ( epu_sok[epmi] )
                                              reg_data_out <= 1;
                                          else
                                              reg_data_out <= 2;
                                      end else
                                          reg_data_out <= 0;
                                  end
                          default : reg_data_out <= 0;
                      endcase
                  end
              end
	      end
	end

/*
generate
genvar epmi, epmipad;
for (epmi = 0; epmi < NUM_EPU; epmi = epmi + 1) 
begin
    always @(*)
    begin
        if (axi_araddr[15:8] == 8'h20 + epmi)
        begin
            case ( axi_araddr[7:0] )
                8'hC0 : begin
                            if ( epu_rdy[epmi] )
                            begin
                                if ( epu_sok[epmi] )
                                    reg_data_out <= 1;
                                else
                                    reg_data_out <= 2;
                            end else
                                reg_data_out <= 0;
                        end
                default : reg_data_out <= 0;
            endcase
        end
    end
end
*/
/*
for (epmipad = NUM_EPU + 8'h20; epmipad < 8'hFF; epmipad = epmipad + 1) 
begin
    always @(*)
    begin
        if (axi_araddr[15:8] == epmipad)
            reg_data_out <= 0;
        end
    end
end
*/
//endgenerate

   

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here
    //Implement one EPU at 
	// User logic ends

	endmodule
