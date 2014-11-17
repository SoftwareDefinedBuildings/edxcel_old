


function automatic signed [0:256*8-1] slide;

input [0:32*8-1] a;

begin: slide_blk
    integer i;
    integer b;
    integer k;
    reg break1;
    reg break2;
    
    for (i = 0; i < 256; i = i + 1) begin
      slide[i*8 +: 8] = 8'h01 & (a[(i>>>3)*8 +: 8] >>> (i & 32'sd7));
    end
       
    for (i = 0; i < 256; i = i + 1) begin
      if (slide[i*8 +: 8] !== 8'sh00) begin
          break1 = 0;
          for (b = 1; b <= 6 && (i + b) < 256 && break1 === 1'b0; ) begin
              if (i == 7) begin
              end
              if (slide[(i + b)*8 +: 8] !== 8'sd0) begin
                  if (($signed(slide[i*8 +: 8]) + $signed(slide[(i + b)*8 +: 8] << b)) <= 8'sd15) begin
                      slide[i*8 +: 8] = $signed(slide[i*8 +: 8]) + $signed(slide[(i + b)*8 +: 8] << b);
                      slide[(i + b)*8 +: 8] = 8'sd0;
                  end else if ((($signed(slide[i*8 +: 8]) - $signed(slide[(i + b)*8 +: 8] << b))) >= -8'sd15) begin
                      slide[i*8 +: 8] = $signed(slide[i*8 +: 8]) - $signed(slide[(i + b)*8 +: 8] << b);
                      break2 = 0;
                      for (k = i + b; k < 256 && break2 === 1'b0;) begin
                          if (slide[k*8 +: 8] === 8'sd0) begin
                              slide[k*8 +: 8] = 8'sd1;
                              break2 = 1;
                          end
                          if (break2 === 1'b0) begin
                              slide[k*8 +: 8] = 8'sd0;
                              k = k + 1;
                          end
                      end
                  end else begin
                      break1 = 1;
                  end
              end
              if (break1 === 1'b0) begin
                  b = b + 1;
              end
          end
      end
    end
end
endfunction