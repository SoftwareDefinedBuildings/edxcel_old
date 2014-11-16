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
    op_a = 320'hff094481feac78b7ff2a6f1601e37d7bff2ec787fe653696ff7924bdfeaeb398fff6dbdd0101d414;
    op_b = 320'hff480db4fee2b700ffce7199ffa03cbcff79e8980001c029006a0a0fff156ebd00d37285ff5978b6;
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