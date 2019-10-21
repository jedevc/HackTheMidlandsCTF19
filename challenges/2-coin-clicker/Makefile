.PHONY: all linux windows linux-package windows-package

all: linux-package windows-package

linux:
	@echo "> Building for Linux"
	@mkdir -p build/linux/
	@dub build --force
	@mv clicker build/linux/
	@cp -R assets/ build/linux/
	@cp README build/linux/

windows:
	@echo "> Building for Windows"
	@mkdir -p build/windows/
	@wine dub build --force
	@mv -u clicker.exe build/windows/
	@cp -R assets/ build/windows/
	@cp lib/windows/* build/windows/
	@cp README build/windows/

linux-package: linux
	@echo "> Creating zip package for Linux"
	@zip build/linux.zip -r build/linux

windows-package: windows
	@echo "> Creating zip package for Windows"
	@zip build/windows.zip -r build/windows

clean:
	@echo "> Cleaning all"
	@dub clean
	@rm -rf build
