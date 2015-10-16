#include <stdio.h>
#include <unistd.h>
#include "io.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "altera_up_avalon_character_lcd.h"
#define PIXEL_BUFFER_BASE (volatile unsigned int ) 0x00000000

void write_pixel(int x, int y, short color) {
	volatile short *write_addr=(volatile short*)(0x00000000 + (y<<10) + (x<<1));
	*write_addr=color;
}

int main()
{
	printf("System Initialized\n");

	alt_up_character_lcd_dev * char_lcd_dev;
	char *first_row;

	// open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/character_lcd_0");
	if ( char_lcd_dev == NULL)
		alt_printf ("Error: could not open character LCD device\n");
	else
		alt_printf ("Opened character LCD device\n");

	/* Initialize the character display */
	alt_up_character_lcd_init (char_lcd_dev);
	int counter = 0;

	while(1) {
		// draw the reticle
		// left bar
		write_pixel(313, 240, 0xFFFF);
		write_pixel(314, 240, 0xFFFF);
		write_pixel(315, 240, 0xFFFF);
		write_pixel(316, 240, 0xFFFF);
		write_pixel(317, 240, 0xFFFF);
		// right bar
		write_pixel(323, 240, 0xFFFF);
		write_pixel(324, 240, 0xFFFF);
		write_pixel(325, 240, 0xFFFF);
		write_pixel(326, 240, 0xFFFF);
		write_pixel(327, 240, 0xFFFF);
//		// top bar
//		write_pixel(320, 234, 0xFFFF);
//		write_pixel(320, 235, 0xFFFF);
//		write_pixel(320, 236, 0xFFFF);
//		write_pixel(320, 237, 0xFFFF);
//		// bottom bar
//		write_pixel(320, 243, 0xFFFF);
//		write_pixel(320, 244, 0xFFFF);
//		write_pixel(320, 245, 0xFFFF);
//		write_pixel(320, 246, 0xFFFF);

		counter++;
		// Log color info every 10000 iterations
		if (counter > 10000) {
			int x = 319;
			int y = 119;
			volatile unsigned int base = PIXEL_BUFFER_BASE;
			volatile unsigned int offset = (x | (y << 10)) << 1;
			volatile unsigned int position = base + offset;
			unsigned int val = IORD_16DIRECT(position, 0);
			int red = (val & (0x1F << 11)) >> 11;
			red *= (255/31); // convert to 255 RGB scheme
			// 0x1F is 11111
			int green = (val & (0x3F << 5)) >> 5;
			green *= (255/63); // convert to 255 RGB scheme
			// 0x3F = 111111
			int blue = (val & 0x1F);
			blue *= (255/31); // convert to 255 RGB scheme
			// 0x1F is 11111
			counter = 0;
			printf("Pixel: (%d, %d) ", x, y);
			printf("Red: %d Green: %d Blue: %d\n", red, green, blue);
			//Log the color detected (Red, Orange, Yellow, Green, Blue, Indigo, Violet, Pink)
			char *color;
			int detected = 0;

			if (red > 155) {
				// Either red or orange or pink or yellow
				if (green < 120 && blue < 120) {
					color = "Red   \0";
					detected = 1;
				}
				else if (green > 100 && blue < 100) {
					color = "Orange\0";
					detected = 1;
				}
				else if (green < 175 && blue > 240) {
					color = "Pink  \0";
					detected = 1;
				}
				else if (green > 240 && blue < 200) {
					color = "Yellow\0";
					detected = 1;
				}
			} else if (green > 240) {
				// If green
				if (red < 180 && blue < 180) {
					color = "Green \0";
					detected = 1;
				}
			} else if (blue > 240) {
				// Either indigo, violet, or blue
				if (red < 50 && green < 130) {
					color = "Indigo\0";
					detected = 1;
				}
				else if (red < 130 && green < 130) {
					color = "Violet\0";
					detected = 1;
				}
				else if (red < 110 && green < 200) {
					color = "Blue  \0";
					detected = 1;
				}
			}

			if (detected == 1) {
				printf("Color Detected: %s\n", color);
				first_row = "Color Detected:\0";
				alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 0);
				alt_up_character_lcd_string(char_lcd_dev, first_row);
				alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
				alt_up_character_lcd_string(char_lcd_dev, color);
			} else {
				// Blank the LCD
				first_row = "               \0";
				alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 0);
				alt_up_character_lcd_string(char_lcd_dev, first_row);
				alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 1);
				alt_up_character_lcd_string(char_lcd_dev, first_row);
			}
		}
  }
  return 0;
}

