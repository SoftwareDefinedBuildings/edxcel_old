 
module ge_add(
    input [319:0] p_x, 
    input [319:0] p_y, 
    input [319:0] p_z, 
    input [319:0] p_t, 
    input [319:0] q_yplusx,
    input [319:0] q_yminusx,
    input [319:0] q_z,
    input [319:0] q_t2d,
    output [319:0] r_x,
    output [319:0] r_y,
    output [319:0] r_z,
    output [319:0] r_t,
    input clk,
    input rst,
    input valid,
    output done
);

`include "../fe/fe_common.v"

reg [319:0] mul_in1;
reg [319:0] mul_in2;
reg mul_valid;
reg rdone;
assign done = rdone;

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
  
reg [3:0] cycle = 0;


reg [319:0] rr_x;
reg [319:0] rr_y;
reg [319:0] rr_z;
reg [319:0] rr_t;

reg [319:0] add_in1;
reg [319:0] add_in2;
reg [319:0] add_res;
always @ (*)
begin
    add_res = fe_add(add_in1, add_in2);
end 

reg [319:0] sub_in1;
reg [319:0] sub_in2;
reg [319:0] sub_res;
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
    if (rst == 1'b0)
    begin
        cycle <= 0;
    end
    else 
    begin
        rdone <= 0;
        cycle <= cycle + 1;
        mul_valid <= 0;
        case (cycle)
            4'd0 :  begin //==== cycle 0 ===
                        if (valid == 1'b1)
                        begin
                            // fe_add(r->X, p->Y, p->X);
                            add_in1 <= p_y;
                            add_in2 <= p_x;
                            // fe_sub(r->Y, p->Y, p->X);
                            sub_in1 <= p_y;
                            sub_in2 <= p_x;
                        end
                        else
                        begin
                            cycle <= 0;
                        end
                    end
                    
            4'd1 :  begin //==== cycle 1 ===
                        rr_x <= add_res;
                        rr_y <= sub_res;
                        // fe_mul(r->Z, r->X, q->YplusX);
                        mul_in1 <= add_res;
                        mul_in2 <= q_yplusx;
                        mul_valid <= 1;
                    end
            4'd2 :  begin //==== cycle 2 ===
                        if (mul_done)
                        begin
                            rr_z <= mul_res;
                            // fe_mul(r->Y, r->Y, q->YminusX);
                            mul_in1 <= rr_y;
                            mul_in2 <= q_yminusx;
                            mul_valid <= 1;
                        end
                        else
                        begin
                            cycle <= 2;
                        end
                    end
            4'd3 :  begin //==== cycle 3 ===
                        if (mul_done)
                        begin
                            rr_y <= mul_res;
                            // fe_mul(r->T, q->T2d, p->T);
                            mul_in1 <= q_t2d;
                            mul_in2 <= p_t;
                            mul_valid <= 1;
                        end
                        else
                        begin
                            cycle <= 3;
                        end
                    end
            4'd4 :  begin //==== cycle 4 ===
                        if (mul_done)
                        begin
                            rr_t <= mul_res;
                            // fe_mul(r->X, p->Z, q->Z);
                            mul_in1 <= p_z;
                            mul_in2 <= q_z;
                            mul_valid <= 1;
                            // fe_add(r->Y, r->Z, r->Y);
                            add_in1 <= rr_z;
                            add_in2 <= rr_y;
                            // fe_sub(r->X, r->Z, r->Y);
                            sub_in1 <= rr_z;
                            sub_in2 <= rr_y;
                        end
                        else
                        begin
                            cycle <= 4;
                        end
                    end
            4'd5 :  begin //==== cycle 5 ===
                        rr_y <= add_res;
                        rr_x <= sub_res;
                    end
            4'd6 :  begin //==== cycle 6 ===           
                        if (mul_done)
                        begin
                            //rr_x <= mul_res;
                            //fe_add(t0, r->X, r->X);
                            add_in1 <= mul_res;
                            add_in2 <= mul_res;
                        end
                        else
                        begin
                            cycle <= 6;
                        end
                    end
            4'd7 :  begin //==== cycle 7 ===
                        // fe_add(r->Z, t0, r->T);
                        add_in1 <= add_res;
                        add_in2 <= rr_t;
                        // fe_sub(r->T, t0, r->T);
                        sub_in1 <= add_res;
                        sub_in2 <= rr_t;
                    end
            4'd8 :  begin //==== cycle 8 ===
                        rr_z <= add_res;
                        rr_t <= sub_res;
                        rdone <= 1;
                        cycle <= 0;
                    end
        endcase
    end

end

endmodule