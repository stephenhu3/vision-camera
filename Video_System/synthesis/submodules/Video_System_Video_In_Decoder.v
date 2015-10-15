/******************************************************************************
 * License Agreement                                                          *
 *                                                                            *
 * Copyright (c) 1991-2013 Altera Corporation, San Jose, California, USA.     *
 * All rights reserved.                                                       *
 *                                                                            *
 * Any megafunction design, and related net list (encrypted or decrypted),    *
 *  support information, device programming or simulation file, and any other *
 *  associated documentation or information provided by Altera or a partner   *
 *  under Altera's Megafunction Partnership Program may be used only to       *
 *  program PLD devices (but not masked PLD devices) from Altera.  Any other  *
 *  use of such megafunction design, net list, support information, device    *
 *  programming or simulation file, or any other related documentation or     *
 *  information is prohibited for any other purpose, including, but not       *
 *  limited to modification, reverse engineering, de-compiling, or use with   *
 *  any other silicon devices, unless such use is explicitly licensed under   *
 *  a separate agreement with Altera or a megafunction partner.  Title to     *
 *  the intellectual property, including patents, copyrights, trademarks,     *
 *  trade secrets, or maskworks, embodied in any such megafunction design,    *
 *  net list, support information, device programming or simulation file, or  *
 *  any other related documentation or information provided by Altera or a    *
 *  megafunction partner, remains with Altera, the megafunction partner, or   *
 *  their respective licensors.  No other licenses, including any licenses    *
 *  needed under any third party's intellectual property, are provided herein.*
 *  Copying or modifying any file, or portion thereof, to which this notice   *
 *  is attached violates this copyright.                                      *
 *                                                                            *
 * THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
 * FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  *
 * IN THIS FILE.                                                              *
 *                                                                            *
 * This agreement shall be governed in all respects by the laws of the State  *
 *  of California and by the laws of the United States of America.            *
 *                                                                            *
 ******************************************************************************/

/******************************************************************************
 *                                                                            *
 * This module decodes video input streams on the DE boards.                  *
 *                                                                            *
 ******************************************************************************/

module Video_System_Video_In_Decoder (
	// Inputs
	clk,
	reset,

	PIXEL_CLK,
	LINE_VALID,
	FRAME_VALID,
	PIXEL_DATA,
	pixel_clk_reset,

	stream_out_ready,

	// Bidirectional

	// Outputs
	overflow_flag,

	stream_out_data,
	stream_out_startofpacket,
	stream_out_endofpacket,
	stream_out_empty,
	stream_out_valid
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/

parameter IW		= 11;

parameter OW		= 7;
parameter FW		= 9;

parameter PIXELS	= 1280;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input						clk;
input						reset;

input						PIXEL_CLK;
input						LINE_VALID;
input						FRAME_VALID;
input			[IW: 0]	PIXEL_DATA;
input						pixel_clk_reset;

input						stream_out_ready;

// Bidirectional

// Outputs
output reg				overflow_flag;

output		[OW: 0]	stream_out_data;
output					stream_out_startofpacket;
output					stream_out_endofpacket;
output					stream_out_empty;
output					stream_out_valid;

/*****************************************************************************
 *                           Constant Declarations                           *
 *****************************************************************************/

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire						video_clk;
wire						video_clk_reset;

wire			[OW: 0]	decoded_pixel;
wire						decoded_startofpacket;
wire						decoded_endofpacket;
wire						decoded_valid;

wire			[FW: 0]	data_from_fifo;
wire			[ 6: 0]	fifo_used_words;
wire			[ 6: 0]	wrusedw;
wire						wrfull;

wire						rdempty;
						

// Internal Registers
reg						reached_start_of_frame;

// State Machine Registers

// Integers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

// Output Registers
always @(posedge video_clk)
begin
	if (video_clk_reset)
		overflow_flag <= 1'b0;
	else if (decoded_valid & reached_start_of_frame & wrfull)
		overflow_flag <= 1'b1;
end

// Internal Registers
always @(posedge video_clk)
begin
	if (video_clk_reset)
		reached_start_of_frame <= 1'b0;
	else if (decoded_valid & decoded_startofpacket)
		reached_start_of_frame <= 1'b1;
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments

assign stream_out_data				= data_from_fifo[OW: 0];
assign stream_out_startofpacket	= data_from_fifo[(FW - 1)];
assign stream_out_endofpacket		= data_from_fifo[FW];
assign stream_out_empty				= 1'b0;
assign stream_out_valid				= ~rdempty;

// Internal Assignments
assign video_clk						= PIXEL_CLK;
assign video_clk_reset					= pixel_clk_reset;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

// Camera Daughter Card Decoding
//`ifdef USE_BAYER_PATTERN
//altera_up_video_camera_decoder_bayer Camera_Decoder (
//`else
//altera_up_video_camera_decoder_RGB Camera_Decoder (
//`endif
altera_up_video_camera_decoder Camera_Decoder (
	// Inputs
	.clk				(video_clk),
	.reset			(video_clk_reset),

	.PIXEL_DATA		(PIXEL_DATA[11: 4]),
	.LINE_VALID		(LINE_VALID),
	.FRAME_VALID	(FRAME_VALID),

	.ready			(decoded_valid & ~wrfull),

	// Bidirectionals

	// Outputs
//	.data_out		(decoded_pixel),
//	.startofpacket	(decoded_startofpacket),
//	.valid			(decoded_valid)

	.data				(decoded_pixel),
	.startofpacket	(decoded_startofpacket),
	.endofpacket	(decoded_endofpacket),
//	.empty			(),
	.valid			(decoded_valid)
);
defparam
//`ifdef USE_BAYER_PATTERN
	Camera_Decoder.DW		= 7;
//`else
//	Camera_Decoder.IDW		= 7,
//	Camera_Decoder.ODW		= OW,
//	Camera_Decoder.WIDTH	= PIXELS;
//`endif

altera_up_video_dual_clock_fifo Video_In_Dual_Clock_FIFO (
	// Inputs
	.wrclk			(video_clk),
	.wrreq			(decoded_valid & ~wrfull),
//	.data			({decoded_endofpacket, decoded_startofpacket, decoded_pixel}),
	.data				({decoded_endofpacket, decoded_startofpacket, decoded_pixel}),
	
	.rdclk			(clk),
	.rdreq			(stream_out_valid & stream_out_ready),

	// Bidirectionals

	// Outputs
	.wrusedw			(wrusedw),
	.wrfull			(wrfull),
		
	.q					(data_from_fifo),
	.rdusedw			(fifo_used_words),
	.rdempty			(rdempty)
);
defparam 
	Video_In_Dual_Clock_FIFO.DW = (FW + 1);

endmodule

