/******************************************************************************
 * License Agreement                                                          *
 *                                                                            *
 * Copyright (c) 1991-2010 Altera Corporation, San Jose, California, USA.     *
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

module D5M_Video_In (
	// Inputs
	CLOCK_50,
	KEY,
	LEDG,
	SW,

	// Bidirectionals
	//  Memory (SRAM)
	SRAM_DQ,
	
	//  GPIO_1
	GPIO_1,
	
	// Outputs
	// 	Memory (SRAM)
	SRAM_ADDR,

	SRAM_CE_N,
	SRAM_WE_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_LB_N,

	// (SDRAM)
	DRAM_ADDR,
   DRAM_BA_1,
	DRAM_BA_0,
	DRAM_CLK,
    DRAM_CAS_N,
    DRAM_CKE,
    DRAM_CS_N,
    DRAM_DQ,
    DRAM_UDQM,
	 DRAM_LDQM,
    DRAM_RAS_N,
    DRAM_WE_N,
	
	//  VGA
	VGA_CLK,
	VGA_HS,
	VGA_VS,
	VGA_BLANK,
	VGA_SYNC,
	VGA_R,
	VGA_G,
	VGA_B,
	
	// LCD
	LCD_DATA,
	LCD_ON,
	LCD_BLON,
	LCD_EN,
	LCD_RS,
	LCD_RW
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input		[ 3: 0]	KEY;

// Bidirectionals
// 	Memory (SRAM)
inout		[15: 0]	SRAM_DQ;

// Memory (SDRAM)
inout		[15:0]DRAM_DQ;

//  GPIO_1
inout		[35: 0]	GPIO_1;

// Outputs
// 	Memory (SRAM)
output		[17: 0]	SRAM_ADDR;
output				SRAM_CE_N;
output				SRAM_WE_N;
output				SRAM_OE_N;
output				SRAM_UB_N;
output				SRAM_LB_N;

// Memory (SDRAM)
output		[11: 0]	DRAM_ADDR;
output 			 	DRAM_BA_1, DRAM_BA_0;
output 				DRAM_CAS_N;
output 				DRAM_CKE;
output 				DRAM_CS_N;
output 				DRAM_UDQM, DRAM_LDQM;
output 				DRAM_RAS_N;
output				DRAM_CLK;
output 				DRAM_WE_N;

//  VGA
output				VGA_CLK;
output				VGA_HS;
output				VGA_VS;
output				VGA_BLANK;
output				VGA_SYNC;
output		[ 9: 0]	VGA_R;
output		[ 9: 0]	VGA_G;
output		[ 9: 0]	VGA_B;
input [7:0] SW;
output [7:0] LEDG;

// LCD
inout [ 7: 0]		LCD_DATA;
output 				LCD_ON;
output 				LCD_BLON;
output 				LCD_EN;
output 				LCD_RS;
output 				LCD_RW;


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire		[11: 0]	CCD_DATA;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/


// Output Registers

// Internal Registers

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign	GPIO_1[19]	=	1'b1;
assign	GPIO_1[17]	=	KEY[0];

// Internal Assignments
assign	CCD_DATA[0]	=	GPIO_1[13];
assign	CCD_DATA[1]	=	GPIO_1[12];
assign	CCD_DATA[2]	=	GPIO_1[11];
assign	CCD_DATA[3]	=	GPIO_1[10];
assign	CCD_DATA[4]	=	GPIO_1[9];
assign	CCD_DATA[5]	=	GPIO_1[8];
assign	CCD_DATA[6]	=	GPIO_1[7];
assign	CCD_DATA[7]	=	GPIO_1[6];
assign	CCD_DATA[8]	=	GPIO_1[5];
assign	CCD_DATA[9]	=	GPIO_1[4];
assign	CCD_DATA[10]=	GPIO_1[3];
assign	CCD_DATA[11]=	GPIO_1[1];

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Video_System Char_Buffer_System (
	// 1) global signals:
	.clk_clk									(CLOCK_50),
	.reset_reset_n								(KEY[0]),
	.vga_clk								(GPIO_1[16]),
	// added
	.sdram_clk_clk (DRAM_CLK),
	// added
	.switches_export (SW),
	.leds_export (LEDG),

	// the_Pixel_Buffer
	.SRAM_DQ_to_and_from_the_Pixel_Buffer	(SRAM_DQ),
	.SRAM_ADDR_from_the_Pixel_Buffer		(SRAM_ADDR),
	.SRAM_LB_N_from_the_Pixel_Buffer		(SRAM_LB_N),
	.SRAM_UB_N_from_the_Pixel_Buffer		(SRAM_UB_N),
	.SRAM_CE_N_from_the_Pixel_Buffer		(SRAM_CE_N),
	.SRAM_OE_N_from_the_Pixel_Buffer		(SRAM_OE_N),
	.SRAM_WE_N_from_the_Pixel_Buffer		(SRAM_WE_N),

	// the_Video_In_Decoder
	.PIXEL_CLK_to_the_Video_In_Decoder		(GPIO_1[0]),
	.PIXEL_DATA_to_the_Video_In_Decoder		(CCD_DATA),
	.LINE_VALID_to_the_Video_In_Decoder		(GPIO_1[21]),
	.FRAME_VALID_to_the_Video_In_Decoder	(GPIO_1[22]),

	// the_AV_Config
	.I2C_SCLK_from_the_AV_Config			(GPIO_1[24]),
	.I2C_SDAT_to_and_from_the_AV_Config		(GPIO_1[23]),

	// the_vga_controller
	.VGA_CLK_from_the_VGA_Controller		(VGA_CLK),
	.VGA_HS_from_the_VGA_Controller			(VGA_HS),
	.VGA_VS_from_the_VGA_Controller			(VGA_VS),
	.VGA_BLANK_from_the_VGA_Controller		(VGA_BLANK),
	.VGA_SYNC_from_the_VGA_Controller		(VGA_SYNC),
	.VGA_R_from_the_VGA_Controller			(VGA_R),
	.VGA_G_from_the_VGA_Controller			(VGA_G),
	.VGA_B_from_the_VGA_Controller			(VGA_B),

	.sdram_wire_addr                                     (DRAM_ADDR),                                     //                          sdram_wire.addr
   .sdram_wire_ba                                       ({DRAM_BA_1, DRAM_BA_0}),                                       //                                    .ba
   .sdram_wire_cas_n                                    (DRAM_CAS_N),                                    //                                    .cas_n
   .sdram_wire_cke                                      (DRAM_CKE),                                      //                                    .cke
   .sdram_wire_cs_n                                     (DRAM_CS_N),                                     //                                    .cs_n
   .sdram_wire_dq                                       (DRAM_DQ),                                       //                                    .dq
   .sdram_wire_dqm                                      ({DRAM_UDQM, DRAM_LDQM}),                                      //                                    .dqm
   .sdram_wire_ras_n                                    (DRAM_RAS_N),                                    //                                    .ras_n
   .sdram_wire_we_n                                     (DRAM_WE_N),                                     //                                    .we_n
	
	.lcd_data_DATA                                       (LCD_DATA),                                       //                            lcd_data.DATA
	.lcd_data_ON                                         (LCD_ON),                                         //                                    .ON
	.lcd_data_BLON                                       (LCD_BLON),                                       //                                    .BLON
	.lcd_data_EN                                         (LCD_EN),                                         //                                    .EN
	.lcd_data_RS                                         (LCD_RS),                                         //                                    .RS
	.lcd_data_RW                                         (LCD_RW),                                          //                                    .RW
);

endmodule

