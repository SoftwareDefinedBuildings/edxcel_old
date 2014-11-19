`timescale 10ns / 1ps

module femulx_tb();

reg [319:0] op_a;
reg [319:0] op_b;
reg valid;
reg rst;
wire [319:0] res;
reg clk;
wire done;


fe_mulx ML(
    .op_a(op_a),
    .op_b(op_b),
    .valid(valid),
    .res(res),
    .clk(clk),
    .rst(rst),
    .done(done)
    );

initial
begin
    valid = 0;
    clk = 1;
    rst = 0;
    #10
    rst = 1;
    #30
    op_a = 320'hff14b7700089ecef0018075300f26d5effe67e010038eab6ff520d3aff4bd386ff6a910300d5e7c2;
    op_b = 320'h00901b6701c56e00ff9ce332ff40797700f3d1300003805200d4141efe2add7bffa6e50afeb2f159;
    //op_a = 320'hfd83ef9a015fdac6fe99c76c00e7e9ab00d564f2ff4b49b3ff5d6d7f002ad3d10102ebd200f9adb1;
    //op_b = 320'hffbcaf5f00f20b2efd5a3edaff514f9bfed39b5afee31a21fefb05d7fff31033019e1efbffc3571b;
    //017285b5008e59bb0156b6ec00ea50990020f1550069d78500e6c004ff1db4cafe8e51ddff6e8e17
    valid = 1;
    #10
    valid = 0;
    while (done == 0)
    begin
        #10;
    end
    $display("result after 30 ticks: %h", res);
    #10
    $finish;
    
    
end


always
    #5 clk = !clk;
    
endmodule    