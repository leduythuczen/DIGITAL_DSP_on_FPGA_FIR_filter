`timescale 1ns / 1ps
module yourstatemachine(
//Input
input read_ready,
input write_ready,
input sample_clock,

//Output
output reg read,
output reg write,
output reg readen,
output reg writeen	
);
	
always @(posedge sample_clock) 
begin
	case({write_ready,read_ready})
	2'b00: 
	begin
		read <= 1'b0;
		readen <= 1'b0;	
		write <= 1'b0;
		writeen <= 1'b0;
	end
	2'b01:
	begin
		read <= 1'b1;
		readen <= 1'b1;
		write <= 1'b0;
		writeen <= 1'b0;
	end	
	2'b10:
	begin
		write <= 1'b1;
		writeen <= 1'b1;
		read <= 1'b0;
		readen <= 1'b0;
	end
	2'b11: 
	begin
		write <= 1'b1;
		writeen <= 1'b1;
		read <= 1'b1;
		readen <= 1'b1;		
	end
	
	endcase
end

endmodule
