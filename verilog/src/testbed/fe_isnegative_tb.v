module fe_isnegative_tb();

`include "../fe/fe_common.v"
reg [319:0] f;
reg [7:0] result;

// Initialize all variables
initial begin        
  f = 320'h0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000;
  #10 result = fe_isnegative(f);
  
  //00000000
  #10 $display("result is %h", result);
  #20 $finish;      // Terminate simulation
end


endmodule