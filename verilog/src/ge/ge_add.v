 
module ge_add(
    input [319:0] p_x, 
    input [319:0] p_y, 
    input [319:0] p_z, 
    input [319:0] p_t, 
    input [319:0] q_yplusx,
    input [319:0] q_yminusx,
    input [319:0] q_t2d,
    input [319:0] q_z,
    output [319:0] r_x,
    output [319:0] r_y,
    output [319:0] r_z,
    output [319:0] r_t,
    input clk,
    input rst,
    input valid,
    output done
);

reg [319:0] mul_in1;
reg [319:0] mul_in2;
reg mul_valid;
wire [319:0] mul_res;
wire mul_done;


fe_mulx ML(
    .op_a(mul_in1),
    .op_b(mul_in2),
    .valid(mul_valid),
    .res(mul_res),
    .clk(clk),
    .rst(rst),
    .done(mul_done)
    );
  
reg cycle;


reg [319:0] rr_x;
reg [319:0] rr_y;
reg [319:0] rr_z;
reg [319:0] rr_t;

reg [319:0] add_in1;
reg [319:0] add_in2;
wire [319:0] add_res;
always @ (*)
begin
    add_res = fe_add(add_in1, add_in2);
end 

reg [319:0] sub_in1;
reg [319:0] sub_in2;
wire [319:0] sub_res;
always @ (*)
begin
    sub_res = fe_sub(sub_in1, sub_in2);
end 

assign r_x = rr_x;
assign r_y = rr_y;
assign r_z = rr_z;
assign r_t = rr_t;

always @ (posedge clk)
begin
    if (rst)
    begin
    
    end
    else 
    begin
        cycle <= cycle + 1;
        mul_valid <= 0;
        case (cycle)
            4'd0 :  begin //==== cycle 0 ===
                        if (valid == 1'b1)
                        begin
                            add_in1 <= p_y;
                            add_in2 <= p_x;
                            sub_in1 <= p_y;
                            sub_in2 <= p_x;
                        end
                        else
                            cycle <= 0;
                    end
                    
            4'd1 :  begin //==== cycle 1 ===
                        rr_x <= add_res;
                        rr_y <= sub_res;
                        mul_in1 <= add_res;
                        mul_in2 <= q_yplusx;
                        mul_valid <= 1;
                    end
            4'd2 :  begin //==== cycle 2 ===
                        if (mul_done)
                        begin
                            rr_z <= mul_res;
                            mul_in1 <= rr_y;
                            mul_in2 <= q_yminusx;
                            mul_valid <= 1;
                        end
                        else
                            cycle <= 2;
                    end
            4'd3 :  begin //==== cycle 3 ===
                        if (mul_done)
                        begin
                            rr_y <= mul_res;
                            mul_in1 <= q_t2d;
                            mul_in2 <= p_t;
                            mul_valid <= 1;
                        end
                        else
                            cycle <= 3;
                    end
            4'd4 :  begin //==== cycle 4 ===
                        if (mul_done)
                        begin
                            rr_t <= mul_res;
                            mul_in1 <= p_z;
                            mul_in2 <= q_z;
                            mul_valid <= 1;
                            add_in1 <= rr_z;
                            add_in2 <= rr_y;
                            sub_in1 <= rr_z;
                            sub_in2 <= rr_y;
                        end
                        else
                            cycle <= 4;
                    end
            4'd5 :  begin //==== cycle 5 ===
                        rr_y <= add_res;
                        rr_x <= sub_res;
                    end
            4'd6 :  begin //==== cycle 6 ===           
                        if (mul_done)
                        begin
                            rr_x <= mul_res;
                            add_in1 <= mul_res;
                            add_in2 <= mul_res;
                        end
                        else
                            cycle <= 6;
                    end
            4'd7 :  begin //==== cycle 7 ===
                        if (mul_done)
                        begin
                            rr_x <= mul_res;
                            add_in1 <= mul_res;
                            add_in2 <= mul_res;
                        end
                        else
                            cycle <= 7;
                    end
            4'd8 :  begin //==== cycle 8 ===
                        add_in1 <= add_res;
                        sub_in1 <= add_res;
                        add_in2 <= rr_t;
                        sub_in2 <= rr_t;
                    end
            4'd8 :  begin //==== cycle 9 ===
                        rr_z <= add_res;
                        rr_t <= sub_res;
                        done <= 1;
                        cycle <= 0;
                    end
        endcase
    end

end

endmodule