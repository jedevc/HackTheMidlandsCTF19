module text;

import std.string;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;

struct Text {
	private SDL_Renderer* renderer;
	private SDL_Texture* texture;

	public uint x;
	public uint y;
	private uint width;
	private uint height;

	this(SDL_Renderer* renderer, TTF_Font* font, uint width, uint height, string content) {
		this.renderer = renderer;
		this.x = 0;
		this.y = 0;
		this.width = width;
		this.height = height;

		SDL_Color base = {0xff, 0xff, 0xff};

        SDL_Surface* surface_message = TTF_RenderText_Solid(font, content.toStringz, base);
        texture = SDL_CreateTextureFromSurface(renderer, surface_message);
        SDL_FreeSurface(surface_message);
	}

	~this() {
        SDL_DestroyTexture(texture);
	}

	void render() {
		SDL_Rect box = SDL_Rect(x, y, width, height);
        SDL_RenderCopy(renderer, texture, null, &box);
	}
}
