#include <cstdio>

int main()
{
	FILE*f = fopen("font.bmp", "rb");
	FILE*fo = fopen("font.asm", "wb");
	
	fseek( f,  0x36, SEEK_SET);
	for (int i = 0; i< 45; i++)
	{
		fprintf( fo, ".DB");
		for (int y = 0; y<4; y++)
		{
			int c1 = fgetc( f );
			fgetc( f );	fgetc( f );
			
			char x1 = (c1==0xff)?0xf:0;
			
			int c2 = fgetc( f );
			fgetc( f );	fgetc( f );
			
			char x2 = (c2==0xff)?0xf:0;
			
			int c3 = fgetc( f );
			fgetc( f );	fgetc( f );
			
			char x3 = (c3==0xff)?0xf:0;
			
			int c4 = fgetc( f );
			fgetc( f );	fgetc( f );
			
			char x4 = (c4==0xff)?0xf:0;
			
			fprintf( fo, "\t0x%x, 0x%x", x2<<4|x1, x4<<4|x3);
			if (y!=3) fprintf( fo, ",\\\n");
			else fprintf(fo, "\n");
		}
		fprintf( fo, "\n");
	}
}