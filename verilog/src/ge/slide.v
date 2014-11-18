


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
end
endfunction