module fe_add_tb();

`include "../fe2/fe_common.v"

reg [319:0] f;
reg [319:0] g;
reg [319:0] h;

// Initialize all variables
initial begin        
  f = 320'h55555555555555555555555555555555555555555555555555555555555555555555555555555555;
  g = 320'h55555555555555555555555555555555555555555555555555555555555555555555555555555555;
  #10 h = fe_add(f,g);
  #20 $finish;      // Terminate simulation
end



endmodule