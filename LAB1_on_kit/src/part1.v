
module part1 (CLOCK_50, CLOCK2_50, KEY, I2C_SCLK, I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

  
	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output I2C_SCLK;
	inout I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	// Local wires.
		wire	CLOCK_50MHZ;
      wire	END_TR;
      wire	KEYON;
      wire	[1:0] sel;
      wire	sound;
      wire	XCK;
      wire	GO;
		wire	SELECT_MICROPHONE;
      wire	reset_n;
      wire	reset = ~KEY[0]; 
		wire	[23:0] CONFIGURATION_DATA;
		wire read_ready, write_ready, read, write;
		wire [23:0] readdata_left, readdata_right;
		wire [23:0] writedata_left, writedata_right;
		wire I2C_SCLK_from_cfg;

		assign I2C_SCLK = I2C_SCLK_from_cfg;
 ////your circuit code go here
	main main_ut(
	.sample_clock(CLOCK_50),  
	.read_ready(read_ready), 
	.write_ready(write_ready),
	.reset(reset),
	.readdata(readdata_left),
	.read(read),
	.write(write), 
	.writedata(writedata_left)
	);
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		.CLOCK_27(CLOCK2_50),
		.reset(reset),

		// outputs
		.AUD_XCK(AUD_XCK)
	);

	audio_and_video_config cfg(
		// Inputs
		.clk(CLOCK_50),
		.reset(reset),

		// Bidirectionals
		.I2C_SDAT(I2C_SDAT),
		.I2C_SCLK(I2C_SCLK_from_cfg)
	);

	audio_codec codec(
		// Inputs
		.clk(CLOCK_50),
		.reset(reset),

		.read(read),	.write(write),
		.writedata_left(writedata_left), .writedata_right(writedata_right),

		.AUD_ADCDAT(AUD_ADCDAT),

		// Bidirectionals
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCLRCK(AUD_ADCLRCK),
		.AUD_DACLRCK(AUD_DACLRCK),

		// Outputs
		.read_ready(read_ready), .write_ready(write_ready),
		.readdata_left(readdata_left), .readdata_right(readdata_right),
		.AUD_DACDAT(AUD_DACDAT)
	);
////////////////////////////////////////
/*CLOCK_500	b2v_inst4(
					// inputs
					.CLOCK(CLOCK_50),
					.END_TR(END_TR),
					.RESET(reset),
					.KEYON(KEYON),
					.SEL_MIC (SELECT_MICROPHONE),
					// outputs
					.CLOCK_500(CLOCK_50MHZ),
					.GO(GO),
					.CLOCK_2(XCK),
					.DATA(CONFIGURATION_DATA));*/
// Module i2c provides serial control interface to transfer parameters to the codec
// The parameters determine the sampling rate and other settings for codec's operation
// as outlined in WM8731 datasheet.
// This module just sends the parameteres. The parameters themselves are set in the module
// CLOCK_500
/*i2c	b2v_inst(
			// inputs
			.CLOCK(CLOCK_50MHZ),
			.GO(GO),
			.W_R(1'b1),
			.I2C_DATA(CONFIGURATION_DATA),
			.RESET(KEYON),
			// output
			.I2C_SDAT(I2C_SDAT),
			.I2C_SCLK(I2C_SCLK_from_i2c),
			.END_TR(END_TR));*/

// Module keytr monitors KEY[0] being pressed, and limits how much the volume is increased
// when the key is held down. This is done by sending the KEYON signal to the CLOCK_500
// module, which then changes the volume appropriately
/*keytr	b2v_inst1(
				// inputs
				.key(KEY0),
				.clock(CLOCK_50MHZ),
				// outputs
				.KEYON(KEYON));*/


endmodule
