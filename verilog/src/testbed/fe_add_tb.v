module fe_add_tb();

`include "../fe/fe_common.v"

reg [319:0] f;
reg [319:0] g;
reg [319:0] h;

// Initialize all variables
initial begin        
  f = 320'hff5e9ea4ffd2d0b7ff7f99e901aac0ee00106891fe73a68800f77b4affd2714effbcbe34fe38b5ce;
  g = 320'hff18c31700e3efe000b264fbff1171c7ffcc7a920100b51c009fd3000137a8e7000ec6fe016b0a14;
  #10 h = fe_add(f, g);
  
  //fe7761bb00b6c0970031fee400bc32b5ffdce323ff745ba401974e4a010a1a35ffcb8532ffa3bfe2
  #10 $display("H is %h", h);
  $display("Orig fe7761bb00b6c0970031fee400bc32b5ffdce323ff745ba401974e4a010a1a35ffcb8532ffa3bfe2");
  #20 $finish;      // Terminate simulation
end

endmodule