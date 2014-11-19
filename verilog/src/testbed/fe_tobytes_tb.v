
module fe_tobytes_tb();

`include "../fe/fe_common.v"

reg [319:0] h;
reg [255:0] res;

reg [319:0] tst; 
reg [31:0] foo = 32'h00000002;
// Initialize all variables
initial begin      
             //ff348211fef50137006a7aa9014d6f3f00fe8356fe5600a000dfcc46019732a5ff5135d600c4b8ae  
    tst = 320'hff348211fef50137006a7aa9014d6f3f00fe8356fe5600a000dfcc46019732a5ff5135d600c4b8ae;
    #10
    res = fe_tobytes(tst);
    #10
    $display("tst %h", tst);
    $display("res %h", res);
   //4d20942f50137353d54a9ade7efe83559580281bf988ccb9952544d758c4b89b <WRONG
   //4d20842f50137353d54a9ade7efe83559580281bf988ccb9952544d758c4b89b
   //4d20842f50137353d54a9ade7efe83559580281bf988ccb9952544d758c4b89b
  #20 $finish;      // Terminate simulation
end



endmodule