
module fe_tobytes_tb();

`include "../fe2/fe_common.v"

reg [319:0] h;
reg [255:0] res;

reg signed [63:0] x;
reg [255:0] tst = {255{1'b1}};

reg [31:0] foo = 32'h00000002;
// Initialize all variables
initial begin        

  x = $signed(tst[0+:32]);
  $display("x %d", foo[7:0]);
   $display("x2 %d", foo*2);

  #20 $finish;      // Terminate simulation
end



endmodule