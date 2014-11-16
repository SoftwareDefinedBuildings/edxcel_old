
module fe_tobytes_tb();

`include "../fe2/fe_common.v"

reg [319:0] h;
reg [255:0] res;

// Initialize all variables
initial begin        
  h = 320'h5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a;
  #10 res = fe_tobytes(h);
  
  $display("x %d", 32'sd1515870810 * 32'sd19);
  //b1 5d 5a c2 69 69 39 d4 d2 12 4e 4b cb a1 96 96 70 5a 5a 0e b5 b4 84 d3 d2 72 a8 a5 25 9c 96 16
  #10 $display("H is %h", res);
  #20 $finish;      // Terminate simulation
end



endmodule