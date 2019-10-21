import std.stdio;
import std.conv;
import std.string;
import std.exception;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.ttf;

import score;
import background;
import sprite;
import flag;
import text;

const string TITLE = "Coin Clicker";
const int WIDTH = 600;
const int HEIGHT = 600;

SDL_Texture* loadTexture(SDL_Renderer* renderer, string path) {
	SDL_Surface* image = IMG_Load(path.toStringz);
	enforce(!(image is null), "Could not load image");
	SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer, image);
	enforce(!(texture is null), "Could not create texture from image");
	SDL_FreeSurface(image);

	return texture;
}

void main()
{
	// load SDL libraries
	DerelictSDL2.load();
	DerelictSDL2Image.load();
	DerelictSDL2ttf.load();

	const int imgFlags = IMG_INIT_PNG;

	// initialize SDL
	enforce(SDL_Init(SDL_INIT_VIDEO) == 0, "SDL could not intitialize");
	enforce((IMG_Init(imgFlags) & imgFlags) == imgFlags,
			"Image library could not initialize");
	enforce(TTF_Init() == 0, "TTF library could not initialize");

	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");

	SDL_Window* window = SDL_CreateWindow(TITLE.toStringz,
			SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
			WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
	enforce(!(window is null), "Could not create window");

	SDL_Renderer* renderer = SDL_CreateRenderer(window, -1,
			SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	enforce(!(renderer is null), "Could not create renderer");
	SDL_SetRenderDrawColor(renderer, 0xff, 0xff, 0xff, 0xff);

	SDL_Texture* background = loadTexture(renderer, "assets/fancy-cushion.png");
	Background spritebg = Background(renderer, background, 400, 400, WIDTH, HEIGHT);

	TTF_Font* font = TTF_OpenFont("assets/FiraMono-Regular.ttf", 50);
	Score score = Score(renderer, font, 20, 24);
	score.x = 10;
	score.y = 560;
	score.points = 0;

	SDL_Texture* coinTexture = loadTexture(renderer, "assets/coin.png");
	SDL_SetTextureBlendMode(coinTexture, SDL_BLENDMODE_BLEND);
	Sprite coin = Sprite(renderer, coinTexture, 100, 100, 6, 2);
	coin.alpha = 0;

	Text *flag = null;

	bool mouseDown = false;

	SDL_Event event;
	eventloop: while (true) {
		SDL_PollEvent(&event);

		switch (event.type) {
		case SDL_QUIT:
			break eventloop;
		case SDL_MOUSEBUTTONDOWN:
			if (!mouseDown) {
				mouseDown = true;

				score.points++;
				string flagStr = get_flag(score.points);
				if (flagStr.length > 0) {
					writeln(flagStr);
					flag = new Text(renderer, font, to!uint(20 * flagStr.length), 24, flagStr);
					flag.x = 10;
					flag.y = 10;
				}

				int mouseX, mouseY;
				SDL_GetMouseState(&mouseX, &mouseY);
				coin.alpha = 0xff;
				coin.x = mouseX - 50;
				coin.y = mouseY - 50;
			}
			break;
		case SDL_MOUSEBUTTONUP:
			mouseDown = false;
			break;
		default:
			break;
		}

		SDL_RenderClear(renderer);
		spritebg.render();
		score.render();
		coin.render();
		if (!(flag is null)) {
			flag.render();
		}
		SDL_RenderPresent(renderer);

		SDL_Delay(1000 / 60);
		coin.next();
		coin.y -= 13;
		if (coin.alpha <= 20) {
			coin.alpha = 0;
		} else {
			coin.alpha -= 20;
		}
	}

	SDL_DestroyTexture(background);
	SDL_DestroyTexture(coinTexture);
	SDL_DestroyWindow(window);
	SDL_DestroyRenderer(renderer);
	SDL_Quit();
	IMG_Quit();
}
