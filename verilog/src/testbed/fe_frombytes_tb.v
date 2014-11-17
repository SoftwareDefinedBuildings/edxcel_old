
module fe_frombytes_tb();

`include "../fe/fe_common.v"

reg [255:0] s;
reg [319:0] h;

// Initialize all variables
initial begin        
  s = 255'h5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a;
  #10 h = fe_frombytes(s);
  
  //fe5a5a6d 00969697 ff4b4b4b 00d2d2d3 01696969 005a5a5a 012d2d2d ff4b4b4b 01a5a5a6 ff696969
  #10 $display("H is %h", h);
  #20 $finish;      // Terminate simulation
end



endmodule
