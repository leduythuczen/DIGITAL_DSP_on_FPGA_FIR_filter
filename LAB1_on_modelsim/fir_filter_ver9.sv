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
reg [23:0] in_sample;
reg [4:0] buff_cnt; 



// buffer array to hold delayed self
reg signed [23:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7, buff8, buff9, buff10, buff11, buff12, buff13, buff14, buff15, buff16, buff17, buff18, buff19, buff20, buff21, buff22, buff23, buff24, buff25, buff26, buff27, buff28, buff29, buff30, buff31;


// tap coefficients obtain via matlab 
wire signed [23:0] tap0, tap1, tap2, tap3, tap4, tap5, tap6, tap7, tap8, tap9, tap10, tap11, tap12, tap13, tap14, tap15, tap16, tap17, tap18, tap19, tap20, tap21, tap22, tap23, tap24, tap25, tap26, tap27, tap28, tap29, tap30, tap31;


// accumulator reg
reg signed [47:0] acc0, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10, acc11, acc12, acc13, acc14, acc15, acc16, acc17, acc18, acc19, acc20, acc21, acc22, acc23, acc24, acc25, acc26, acc27, acc28, acc29, acc30, acc31;

reg signed [48:0] sum;
integer i;

// caculated by a cat
assign tap0  = 24'h005254;  // 0.0025 * 2^23
assign tap1 = 24'h006678;  // 0.0031 * 2^23
assign tap2 = 24'h0093DC;  // 0.0045 * 2^23
assign tap3 = 24'h00DEF4;  // 0.0068 * 2^23
assign tap4 = 24'h014A28;  // 0.0101 * 2^23
assign tap5 = 24'h01D580;  // 0.0143 * 2^23
assign tap6  = 24'h027E6F;  // 0.0195 * 2^23
assign tap7  = 24'h033FDF;  // 0.0254 * 2^23
assign tap8 = 24'h041269;  // 0.0318 * 2^23
assign tap9 = 24'h04ECC8;  // 0.0385 * 2^23
assign tap10  = 24'h05C46E;  // 0.0451 * 2^23
assign tap11  = 24'h068E43;  // 0.0512 * 2^23
assign tap12  = 24'h073F64;  // 0.0566 * 2^23
assign tap13  = 24'h07CDF8;  // 0.061 * 2^23
assign tap14  = 24'h0831DF;  // 0.064 * 2^23
assign tap15  = 24'h086552;  // 0.0656 * 2^23
assign tap16  = 24'h086552;  // 0.0656 * 2^23
assign tap17  = 24'h0831DF;  // 0.064 * 2^23
assign tap18  = 24'h07CDF8;  // 0.061 * 2^23
assign tap19  = 24'h073F64;  // 0.0566 * 2^23
assign tap20  = 24'h068E43;  // 0.0512 * 2^23
assign tap21  = 24'h05C46E;  // 0.0451 * 2^23
assign tap22  = 24'h04ECC8;  // 0.0385 * 2^23
assign tap23  = 24'h041269;  // 0.0318 * 2^23
assign tap24  = 24'h033FDF;  // 0.0254 * 2^23
assign tap25  = 24'h027E6F;  // 0.0195 * 2^23
assign tap26  = 24'h01D580;  // 0.0143 * 2^23
assign tap27  = 24'h014A28;  // 0.0101 * 2^23
assign tap28  = 24'h00DEF4;  // 0.0068 * 2^23
assign tap29  = 24'h0093DC;  // 0.0045 * 2^23
assign tap30  = 24'h006678;  // 0.0031 * 2^23
assign tap31  = 24'h005254;  // 0.0025 * 2^23

// circular buffer control and input sample management
always @ (posedge clk or negedge reset)
        begin
            if (reset == 1'b0) 
                begin
                    buff_cnt <= 5'd0;
                    enable_fir <= 1'b0;
                    in_sample <= 24'd0;
                end
            else if (buff_cnt == 4'd31)
                begin
                    buff_cnt <= 5'd0;
                    enable_fir <= 1'b1;
                    in_sample <= fir_input;
                end
            else
                begin
                    buff_cnt <= buff_cnt + 1;
                    in_sample <= fir_input;
                end
        end   
    always @ (posedge clk or negedge reset)
        begin
            if(reset == 1'b0)
                begin
                    enable_buff <= 1'b0;
                end
				else if  (fir_ready == 1'b0)
				begin
                    enable_buff <= 1'b0;
                end
            else
                begin
                    enable_buff <= 1'b1;
                end
        end

// buffer update

 always @ (posedge clk)
        begin
            if(enable_buff == 1'b1)
                begin
buff0 <= in_sample;

buff1 <= buff0;        

buff2 <= buff1;         

buff3 <= buff2;      

buff4 <= buff3;      

buff5 <= buff4;       

buff6 <= buff5;    

buff7 <= buff6;

buff8 <= buff7;

buff9 <= buff8;

buff10 <= buff9;

buff11 <= buff10;

buff12 <= buff11;

buff13 <= buff12;

buff14 <= buff13;

buff15 <= buff14;

buff16 <= buff15;

buff17 <= buff16;

buff18 <= buff17;

buff19 <= buff18;

buff20 <= buff19;

buff21 <= buff20;

buff22 <= buff21;

buff23 <= buff22;

buff24 <= buff23;

buff25 <= buff24;

buff26 <= buff25;

buff27 <= buff26;

buff28 <= buff27;

buff29 <= buff28;

buff30 <= buff29;

buff31 <= buff30;    
       
                end
            else
                begin
buff0 <= buff0;

buff1 <= buff1;        

buff2 <= buff2;         

buff3 <= buff3;      

buff4 <= buff4;      

buff5 <= buff5;       

buff6 <= buff6;    

buff7 <= buff7;

buff8 <= buff8;

buff9 <= buff9;

buff10 <= buff10;

buff11 <= buff11;

buff12 <= buff12;

buff13 <= buff13;

buff14 <= buff14;

buff15 <= buff15;       

buff16 <= buff16;

buff17 <= buff17;

buff18 <= buff18;

buff19 <= buff19;

buff20 <= buff20;

buff21 <= buff21;

buff22 <= buff22;

buff23 <= buff23;

buff24 <= buff24;

buff25 <= buff25;

buff26 <= buff26;

buff27 <= buff27;

buff28 <= buff28;

buff29 <= buff29;

buff30 <= buff30;

buff31 <= buff31;
      
            end
end

// mult stage acc = tap * buffer

always @(posedge clk)
begin

    if (enable_fir == 1'b1) begin
acc0 <= tap0 * buff0;

acc1 <= tap1 * buff1;

acc2 <= tap2 * buff2;

acc3 <= tap3 * buff3;

acc4 <= tap4 * buff4;

acc5 <= tap5 * buff5;

acc6 <= tap6 * buff6;

acc7 <= tap7 * buff7;

acc8 <= tap8 * buff8;

acc9 <= tap9 * buff9;

acc10 <= tap10 * buff10;

acc11 <= tap11 * buff11;

acc12 <= tap12 * buff12;

acc13 <= tap13 * buff13;

acc14 <= tap14 * buff14;

acc15 <= tap15 * buff15;

acc16 <= tap16 * buff16;

acc17 <= tap17 * buff17;

acc18 <= tap18 * buff18;

acc19 <= tap19 * buff19;

acc20 <= tap20 * buff20;

acc21 <= tap21 * buff21;

acc22 <= tap22 * buff22;

acc23 <= tap23 * buff23;

acc24 <= tap24 * buff24;

acc25 <= tap25 * buff25;

acc26 <= tap26 * buff26;

acc27 <= tap27 * buff27;

acc28 <= tap28 * buff28;

acc29 <= tap29 * buff29;

acc30 <= tap30 * buff30;

acc31 <= tap31 * buff31;


    end
end

// accumilate stage sum = acc + acc +...
always @(posedge clk)
begin

    if (enable_fir == 1'b1) begin
sum <= acc0 + acc1 + acc2 + acc3 + acc4 + acc5 + acc6 + acc7 + acc8 + acc9 + acc10 + acc11 + acc12 + acc13 + acc14 + acc15 +
       acc16 + acc17 + acc18 + acc19 + acc20 + acc21 + acc22 + acc23 + acc24 + acc25 + acc26 + acc27 + acc28 + acc29 + acc30 + acc31;
    end
end


always @(posedge clk)
begin
    fir_output <= sum[48:25];  // truncate and round the result to fit into 24 bits
end

endmodule
