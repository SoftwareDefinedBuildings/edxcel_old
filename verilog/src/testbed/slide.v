module slide();

//`include "../fe/fe_sub.v"
reg [32*8-1:0] a;
reg signed [256*8-1:0] r;


// Initialize all variables
initial begin: slide
  integer i;
  integer b;
  integer k;
  reg break1;
  reg break2;
  
  
  a = 256'h42e6b3da746f7982c72e3945ca2e987362ae2af25aa079470fd723b60d430c0a;
  for (i = 0; i < 256; i = i + 1) begin
      r[i*8 +: 8] = 8'h01 & (a[(i>>>3)*8 +: 8] >>> (i & 32'sd7));
  end
       
  for (i = 0; i < 256; i = i + 1) begin
      $display("r[i*8 +: 8] is %h", r[i*8 +: 8]);
      if (r[i*8 +: 8] !== 8'sh00) begin
          $display("a is %d", a);
          break1 = 0;
          for (b = 1; b <= 6 && (i + b) < 256; b = b + 1) begin
              if (break1 === 1'b0) begin
                  if (r[(i + b)*8 +: 8] !== 8'sd0) begin
                      if ((r[i*8 +: 8] + (r[(i + b)*8 +: 8] << b)) <= 8'sd15) begin
                          r[i*8 +: 8] = r[i*8 +: 8] + (r[(i + b)*8 +: 8] << b);
                          r[(i + b)*8 +: 8] = 0;
                      end else if ((r[i*8 +: 8] - (r[(i + b)*8 +: 8] << b)) <= -8'sd15) begin
                          r[i*8 +: 8] = r[i*8 +: 8] - (r[(i + b)*8 +: 8] << b);
                          break2 = 0;
                          for (k = i + b; k < 256; k = k + 1) begin
                              if (break2 === 1'b0) begin
                                  if (r[k*8 +: 8] === 8'sd0) begin
                                      r[k*8 +: 8] = 8'sd1;
                                      break2 = 1;
                                  end
                                  
                                  r[k*8 +: 8] = 8'sd0;
                              end 
                          end
                      end else begin
                          break1 = 1;
                      end
                  end
              end
          end
      end
  end
  #10 $display("r is %h", r);
  #20 $finish;      // Terminate simulation
end


endmodule