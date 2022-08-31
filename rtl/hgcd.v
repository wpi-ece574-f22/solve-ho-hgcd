module hgcd(
    input wire[7:0] a,
    input wire[7:0] b,
    input wire ld,
    input wire clk,
    input wire reset,
    output wire[7:0] q,
    output wire rdy);

   localparam S00 = 0, S01 = 1, S10 = 2, S11 = 3, SW = 4;
   
   reg [2:0] 	state, state_next;

   reg 		ld1,  ld2;
   wire 	rdy1, rd2;
   wire [7:0] 	q1,    q2;
 
   reg [7:0] 	qbackup;
   reg [7:0] 	qvar;
   reg          rdyvar;
   
   gcd gcd1(.a(a), .b(b), .ld(ld1), .clk(clk), .reset(reset), .q(q1), .rdy(rdy1));
   gcd gcd2(.a(a), .b(b), .ld(ld2), .clk(clk), .reset(reset), .q(q2), .rdy(rdy2));
   
   assign q   = qvar;
   assign rdy = rdyvar;

   always @(posedge clk, posedge reset)
     if (reset)
       begin
	  state   <= S00;
	  qbackup <= 8'b0;
       end
     else
       begin
	  state   <= state_next;
	  qbackup <= q2;
       end
   
   always @(*)
     begin
	ld1 = 1'b0;
	ld2 = 1'b0;
	state_next = state;
	qvar = 8'b0;
	rdyvar = 1'b0;
	
	case (state)
	  S00:
	    if (ld)
	      begin
		 ld1 = 1'b1;
		 state_next = S01;
	      end
	  
	  S01:
	    if (!ld & rdy1)
	      begin
		 qvar = q1;
		 rdyvar = 1'b1;		 
		 state_next = S00;
	      end
	    else if (ld & rdy1)
	      begin
		 qvar = q1;
		 rdyvar = 1'b1;		 
		 ld2 = 1'b1;
		 state_next = S10;
	      end
	    else if (ld & !rdy1)
	      begin
		 ld2 = 1'b1;
		 state_next = S11;
	      end

	  S10:
	    if (!ld & rdy2)
	      begin
		 qvar = q2;
		 rdyvar = 1'b1;		 
		 state_next = S00;
	      end
	    else if (ld)
	      begin
		 ld1 = 1'b1;
		 state_next = S11;
	      end

	  S11:
	    if (rdy1 & !rdy2)
	      begin
		 qvar = q1;
		 rdyvar = 1'b1;		 
		 state_next = S10;
	      end
	    else if (!rdy1 & rdy2)
	      begin
		 qvar = q2;
		 rdyvar = 1'b1;		 
		 state_next = S01;
	      end
	    else if (rdy1 & rdy2)
	      begin
		 qvar = q1;
		 rdyvar = 1'b1;		 
		 state_next = SW;
	      end

	  SW:
	    begin
	       qvar = qbackup;
	       rdyvar = 1'b1;		 
	       state_next = S00;	       
	    end
	    
	  default:
	    state_next = S00;
	  
	endcase
     end

endmodule
