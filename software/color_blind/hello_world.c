#include <stdio.h>
#include "io.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#define PIXEL_BUFFER_BASE (volatile unsigned int ) 0x00000000
// pixel at (319, 119)
#define PIXEL_BUFFER_BASE_OFFSET (volatile unsigned int ) 0x0003BA7E

void write_pixel(int x, int y, short color) {
	volatile short *vga_addr=(volatile short*)(0x00000000 + (y<<10) + (x<<1));
	*vga_addr=color;
}

int main()
{
	printf("Hello from Nios II!\n");
	int counter = 0;

	while(1) {
		// draw the reticle
		// left bar
		write_pixel(314, 240, 0xFFFF);
		write_pixel(315, 240, 0xFFFF);
		write_pixel(316, 240, 0xFFFF);
		write_pixel(317, 240, 0xFFFF);
		// right bar
		write_pixel(323, 240, 0xFFFF);
		write_pixel(324, 240, 0xFFFF);
		write_pixel(325, 240, 0xFFFF);
		write_pixel(326, 240, 0xFFFF);
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
			// 0x1F is 11111
			int green = (val & (0x3F << 5)) >> 5;
			// 0x3F = 111111
			int blue = (val & 0x1F);
			// 0x1F is 11111
			counter = 0;
			printf("Pixel: (%d, %d) ", x, y);
			printf("Red: %d Green: %d Blue: %d\n", red * (255/31), green * (255/63), blue * (255/31));
	//		usleep(1000000);
		}
  }
  return 0;
}

