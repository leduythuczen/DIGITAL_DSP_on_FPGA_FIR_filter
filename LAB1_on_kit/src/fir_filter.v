`timescale 1ns / 1ps

module fir_filter(
    input clk,
    input reset,
    input signed [23:0] fir_input, // 24-bits input
    input fir_ready,
    output reg signed [23:0] fir_output // 24-bits output
);

// 32-tap FIR Filter
parameter TAP_COUNT = 32;
reg enable_fir, enable_buff;
reg [4:0] buff_cnt; 
reg signed [23:0] in_sample;

// buffer array to hold delayed self
reg signed [23:0] buffer [0:TAP_COUNT-1];

// tap coefficients obtain via matlab 
wire signed [23:0] taps [0:TAP_COUNT-1];

// accumulator reg
reg signed [47:0] acc [0:TAP_COUNT-1];  // 48-bit accumulation for precision
reg signed [47:0] sum;

// caculated by a cat
assign taps[0]  = 24'h0051EB;  // 0.0025 * 2^23
assign taps[1]  = 24'h006594;  // 0.0031 * 2^23
assign taps[2]  = 24'h009374;  // 0.0045 * 2^23
assign taps[3]  = 24'h00DED2;  // 0.0068 * 2^23
assign taps[4]  = 24'h014AF4;  // 0.0101 * 2^23
assign taps[5]  = 24'h01D495;  // 0.0143 * 2^23
assign taps[6]  = 24'h027EF9;  // 0.0195 * 2^23
assign taps[7]  = 24'h03404E;  // 0.0254 * 2^23
assign taps[8]  = 24'h041205;  // 0.0318 * 2^23
assign taps[9]  = 24'h04ED91;  // 0.0385 * 2^23
assign taps[10]  = 24'h05C5D6;  // 0.0451 * 2^23
assign taps[11]  = 24'h068DB8;  // 0.0512 * 2^23
assign taps[12]  = 24'h073EAB;  // 0.0566 * 2^23
assign taps[13]  = 24'h07CED9;  // 0.061 * 2^23
assign taps[14]  = 24'h083126;  // 0.064 * 2^23
assign taps[15]  = 24'h086594;  // 0.0656 * 2^23
assign taps[16]  = 24'h086594;  // 0.0656 * 2^23
assign taps[17]  = 24'h083126;  // 0.064 * 2^23
assign taps[18]  = 24'h07CED9;  // 0.061 * 2^23
assign taps[19]  = 24'h073EAB;  // 0.0566 * 2^23
assign taps[20]  = 24'h068DB8;  // 0.0512 * 2^23
assign taps[21]  = 24'h05C5D6;  // 0.0451 * 2^23
assign taps[22]  = 24'h04ED91;  // 0.0385 * 2^23
assign taps[23]  = 24'h041205;  // 0.0318 * 2^23
assign taps[24]  = 24'h03404E;  // 0.0254 * 2^23
assign taps[25]  = 24'h027EF9;  // 0.0195 * 2^23
assign taps[26]  = 24'h01D495;  // 0.0143 * 2^23
assign taps[27]  = 24'h014AF4;  // 0.0101 * 2^23
assign taps[28]  = 24'h00DED2;  // 0.0068 * 2^23
assign taps[29]  = 24'h009374;  // 0.0045 * 2^23
assign taps[30]  = 24'h006594;  // 0.0031 * 2^23
assign taps[31]  = 24'h0051EB;  // 0.0025 * 2^23


// circular buffer control and input sample management
always @(posedge clk or negedge reset)
begin
    if (reset == 1'b0) begin
        buff_cnt <= 5'd0;
        enable_fir <= 1'b0;
        in_sample <= 24'd0;
    end else if (buff_cnt == TAP_COUNT-1) begin
        buff_cnt <= 5'd0;
        enable_fir <= 1'b1;
        in_sample <= fir_input;
    end else begin
        buff_cnt <= buff_cnt + 1;
        in_sample <= fir_input;
    end
end   

// buffer update
always @(posedge clk or negedge reset)
begin
    if (reset == 1'b0)
        enable_buff <= 1'b0;
    else if (fir_ready == 1'b0)
        enable_buff <= 1'b0;
    else
        enable_buff <= 1'b1;
end

// circular buffer stage buffn = buffern+1
always @(posedge clk)
begin
    if (enable_buff == 1'b1) begin
        buffer[0] <= in_sample;
        for (integer i = 1; i < TAP_COUNT; i = i + 1) begin
            buffer[i] <= buffer[i-1];  // Shift buffer values
        end
    end
end

// mult stage acc = tap * buffer
always @(posedge clk)
begin
    if (enable_fir == 1'b1) begin
        for (integer i = 0; i < TAP_COUNT; i = i + 1) begin
            acc[i] <= taps[i] * buffer[i];  // Perform multiplication
        end
    end
end

// accumilate stage sum = acc + acc +...
always @(posedge clk)
begin
    if (enable_fir == 1'b1) begin
        sum <= 48'd0;  // Reset sum
        for (integer i = 0; i < TAP_COUNT; i = i + 1) begin
            sum <= sum + acc[i];  // Accumulate all products
        end
    end
end


always @(posedge clk)
begin
    fir_output <= sum[31:8];  // truncate and round the result to fit into 24 bits
end

endmodule
