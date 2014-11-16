module fe_add_tb();

`include "../fe/fe_add.v"
reg [319:0] f;
reg [319:0] g;
reg [319:0] h;

// Initialize all variables
initial begin        
  f = 320'heddf27ff7e2105ff7c4ce4ff210354fffbe52401f0dc9dffd84c5701ad1e0100f6545c00cfa66aff;
  g = 320'h61c7d9ffa909f6ff44be2e004d0375ff735be700e35e4f005340b700a11abcffff6790fff4a87c00;
  #10 h = fe_add(f, g);
  
  //4ea701ff272bfbfec00a13006e06c9fe6e410c02d33bedff2b8d0e024e39bdfff5bcecffc34fe7ff
  #10 $display("H is %h", h);
  #20 $finish;      // Terminate simulation
end


endmodule