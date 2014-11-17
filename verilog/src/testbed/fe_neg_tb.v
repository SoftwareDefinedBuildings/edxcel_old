module fe_neg_tb();

`include "../fe/fe_common.v"
reg [319:0] f;
reg [319:0] h;

// Initialize all variables
initial begin        
  f = 320'hffc0d56400241116ffb6e681fe44cff1ff40e06201c5253e004575330188e7a9ff7d0d09ffa9b956;
  #10 h = fe_neg(f);
  
  //003f2a9cffdbeeea0049197f01bb300f00bf1f9efe3adac2ffba8acdfe7718570082f2f7005646aa
  #10 $display("H is %h", h);
  $display("Orig 003f2a9cffdbeeea0049197f01bb300f00bf1f9efe3adac2ffba8acdfe7718570082f2f7005646aa");
  #20 $finish;      // Terminate simulation
end


endmodule