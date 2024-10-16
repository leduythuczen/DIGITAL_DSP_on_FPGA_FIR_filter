`timescale 1ns / 1ps
module main (
input sample_clock,  
input read_ready, 
input write_ready,
input reset,
input signed [23:0] readdata,
output read,
output write, 
output reg signed [23:0] writedata);
	

	wire signed [23:0] fir_output;
	wire readen,writeen;



	fir_filter FIR (
	.clk(sample_clock), 
	.reset(reset), 
	.fir_input(readdata), 
	.fir_ready(readen),
	.fir_output(fir_output)
	);

	FSM FSM (
	.sample_clock(sample_clock),
	.read_ready(read_ready),
	.write_ready(write_ready),
	.read(read),
	.write(write),
	.readen(readen),
	.writeen(writeen)
	);
	
always @(posedge sample_clock)
begin
	if (!reset) writedata <= 24'b0;
	else  writedata <= fir_output;


end
endmodule
