module sprite;
import derelict.sdl2.sdl;

struct Sprite {
	private SDL_Renderer* renderer;
	private SDL_Texture* sheet;

	public uint x;
	public uint y;
	public uint width;
	public uint height;

	public ubyte alpha;

	private uint frame;
	private uint switchEvery;
	private uint maxFrames;

	this(SDL_Renderer* renderer, SDL_Texture* sheet, uint width, uint height, uint maxFrames=1, uint switchEvery=1) {
		this.renderer = renderer;
		this.sheet = sheet;

		this.x = 0;
		this.y = 0;
		this.width = width;
		this.height = height;

		this.alpha = 0xff;

		this.frame = 0;
		this.maxFrames = maxFrames;
		this.switchEvery = switchEvery;
	}

	void render() {
		SDL_Rect box = SDL_Rect(x, y, width, height);
		SDL_Rect quad = SDL_Rect(width * (frame / switchEvery), 0, width, height);

		SDL_SetTextureAlphaMod(sheet, alpha);
		SDL_RenderCopy(renderer, sheet, &quad, &box);
	}

	void next() {
		frame++;
		if (frame >= maxFrames * switchEvery) {
			frame = 0;
		}
	}
}
