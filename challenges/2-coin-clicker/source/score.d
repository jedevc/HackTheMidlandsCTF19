module score;

import std.math;
import std.conv;
import std.string;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

struct Score {
	private SDL_Renderer* renderer;
	private SDL_Texture*[] numbers;

	public uint x;
	public uint y;
	private uint width;
	private uint height;

	public uint points;

	this(SDL_Renderer* renderer, TTF_Font* font, uint width, uint height) {
		this.renderer = renderer;
		this.x = 0;
		this.y = 0;
		this.width = width;
		this.height = height;
		this.points = 0;

		SDL_Color base = {0xff, 0xff, 0xff};

		numbers = new SDL_Texture*[10];
		foreach (i; 0..10) {
			SDL_Surface* surface_message = TTF_RenderText_Solid(font, to!string(i).toStringz, base);
			numbers[i] = SDL_CreateTextureFromSurface(renderer, surface_message);
			SDL_FreeSurface(surface_message);
		}
	}

	~this() {
		foreach (number; numbers) {
			SDL_DestroyTexture(number);
		}
	}

	void render() {
		// calculate digits so as to calculate x-positions
		uint digit_count;
		if (points == 0) {
			digit_count = 1;
		} else {
			digit_count = to!uint(log10(points)) + 1;
		}

		SDL_Rect box = SDL_Rect(x + digit_count * width, y, width, height);
		
		uint rest = points;
		ushort digit;
		do {
			digit = rest % 10;
			rest = rest / 10;

			box.x -= width;
			SDL_RenderCopy(renderer, numbers[digit], null, &box);
		} while (rest != 0);
	}
}
