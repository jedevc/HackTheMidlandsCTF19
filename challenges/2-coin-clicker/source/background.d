module background;
import derelict.sdl2.sdl;
import std.math;

struct Background {
	private SDL_Renderer* renderer;
	private SDL_Texture* texture;

	public uint width;
	public uint height;
    public uint maxWidth;
    public uint maxHeight;

	this(SDL_Renderer* renderer, SDL_Texture* texture, uint width, uint height, uint maxWidth=0, uint maxHeight=0) {
		this.renderer = renderer;
		this.texture = texture;

		this.width = width;
		this.height = height;
        this.maxWidth = maxWidth == 0 ? width : maxWidth;
        this.maxHeight = maxHeight == 0 ? height : maxHeight;
	}

	void render() {
        const int xs = cast (int) ceil(cast (float) maxWidth / width);
        const int ys = cast (int) ceil(cast (float) maxHeight / height);

        foreach (i; 0..xs) {
            foreach (j; 0..ys) {
                SDL_Rect box = SDL_Rect(i * width, j * height, width, height);
                SDL_RenderCopy(renderer, texture, null, &box);
            }
        }
	}
}
