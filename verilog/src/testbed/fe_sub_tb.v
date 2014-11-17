module fe_sub_tb();

`include "../fe/fe_common.v"
reg [319:0] f;
reg [319:0] g;
reg [319:0] h;

// Initialize all variables
initial begin        
  f = 320'hff38eb6b0068b65d0049847afedac18b00711d39ff6caef40006409affffaa8f00f040f8ff132a63;
  g = 320'hffa382fefe9dbd1dffd9da98fe764b25fff0595b00c23d37008e24f201cbef390085cbb401f1e328;
  #10 h = fe_sub(f, g);
  
  //ff95686d01caf940006fa9e2006476660080c3defeaa71bdff781ba8fe33bb56006a7544fd21473b
  #10 $display("H is %h", h);
  $display("Orig ff95686d01caf940006fa9e2006476660080c3defeaa71bdff781ba8fe33bb56006a7544fd21473b");
  #20 $finish;      // Terminate simulation
end


endmodule