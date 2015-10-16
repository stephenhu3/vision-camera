#include <stdio.h>
#include <unistd.h>
#include "io.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "altera_up_avalon_character_lcd.h"
#define PIXEL_BUFFER_BASE (volatile unsigned int ) 0x00000000
#define RETICLE_COLOR (volatile unsigned int) 0xFFFF

void write_pixel(int x, int y, short color) {
	volatile short *write_addr=(volatile short*)(0x00000000 + (y<<10) + (x<<1));
	*write_addr=color;
}

int main() {
	printf("System Initialized\n");
	volatile unsigned int base = PIXEL_BUFFER_BASE;
	alt_up_character_lcd_dev * char_lcd_dev;
	char *first_row;
	// Open the Character LCD port
	char_lcd_dev = alt_up_character_lcd_open_dev ("/dev/character_lcd_0");
	if ( char_lcd_dev == NULL)
		alt_printf ("Error: could not open character LCD device\n");
	else
		alt_printf ("Opened character LCD device\n");

	// Initialize the character display
	alt_up_character_lcd_init (char_lcd_dev);
	int counter = 0;

	while(1) {
		// Draw the reticle
		int m;
		int n;
		// Left bar
		for (m = 312; m <= 324; m++)
			write_pixel(m, 240, RETICLE_COLOR);
		// Right bar
		for (n = 312; n <= 328; n++)
			write_pixel(n, 240, RETICLE_COLOR);

		counter++;
		// Log color info every 10000 iterations
		if (counter > 10000) {
			volatile unsigned int redSampled = 0;
			volatile unsigned int greenSampled = 0;
			volatile unsigned int blueSampled = 0;
			volatile unsigned int red;
			volatile unsigned int green;
			volatile unsigned int blue;
			volatile unsigned int position;
			volatile unsigned int offset;
			volatile unsigned int val;
			int detected = 0;
			int i;
			int j;
			int x;
			int y;
			char *color;
			/*
			Sample center 5 pixels in "+" reticle shape
		   (318, 119) to (320, 119)
		   (319, 118) to (319, 120) 
		   	*/
			// Across horizonally
			for (i = 318; i <= 320; i++) {
				x = i;
				y = 119;
				offset = (x | (y << 10)) << 1;
				position = base + offset;
				val = IORD_16DIRECT(position, 0);
				red = (val & (0x1F << 11)) >> 11;
				red *= (255/31); // convert to 255 RGB scheme
				redSampled += red;
				// 0x1F is 11111
				green = (val & (0x3F << 5)) >> 5;
				green *= (255/63); // convert to 255 RGB scheme
				greenSampled += green;
				// 0x3F = 111111
				blue = (val & 0x1F);
				blue *= (255/31); // convert to 255 RGB scheme
				blueSampled += blue;
				// 0x1F is 11111
				printf("Pixel: (%d, %d) RGB: (%d, %d, %d)\n", x, y, red, green, blue);
			}

			// Down vertically
			for (j = 118; j <= 120; j++) {
				// (319, 119) was covered already by previous loop
				if (j == 119)
					continue;
				x = 319;
				y = j;
				offset = (x | (y << 10)) << 1;
				position = base + offset;
				val = IORD_16DIRECT(position, 0);
				red = (val & (0x1F << 11)) >> 11;
				red *= (255/31); // convert to 255 RGB scheme
				redSampled += red;
				// 0x1F is 11111
				green = (val & (0x3F << 5)) >> 5;
				green *= (255/63); // convert to 255 RGB scheme
				greenSampled += green;
				// 0x3F = 111111
				blue = (val & 0x1F);
				blue *= (255/31); // convert to 255 RGB scheme
				blueSampled += blue;
				// 0x1F is 11111
				printf("Pixel: (%d, %d) RGB: (%d, %d, %d)\n", x, y, red, green, blue);
			}

			// Take the average of the 5 RGB values sampled
			redSampled /= 5;
			greenSampled /= 5;
			blueSampled /= 5;
			
			printf("Sampled Values: Red: %d Green: %d Blue: %d\n", redSampled, greenSampled, blueSampled);
			
			//Log the color detected (Red, Orange, Yellow, Green, Blue, Indigo, Violet, Pink)
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
			counter = 0;
		}
  	}
	return 0;
}

