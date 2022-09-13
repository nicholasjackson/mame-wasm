# Download the mame source code
download_mame_source:
	rm -rf ./mame
	wget https://github.com/mamedev/mame/archive/refs/tags/mame0247.tar.gz
	tar -xzf mame0247.tar.gz
	mv mame-mame0247 mame
	rm mame0247.zip

# Download the emularity source code
download_emularity_source:
	rm -rf emularity-master
	wget https://github.com/db48x/emularity/archive/refs/heads/master.zip
	unzip master.zip
	mv emularity-master emularity
	rm master.zip

download_street_fighter_rom:
	https://wowroms.com/en/roms/mame-0.139u1/street-fighter-ii-champion-edition-world-920513/7000.html

# Build the Capcom CP1 emulator using Docker
build_docker:
	docker run -it --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) emscripten/emsdk:2.0.34 bash -c 'emmake make SUBTARGET=cps1 SOURCES=src/mame/capcom/cps1.cpp -j 16'

# Run a Docker container for emscripten that can be used to build emulators
emscripten_container:
	docker run -it --rm -v $(shell pwd):/src -u $(shell id -u):$(shell id -g) emscripten/emsdk:2.0.34 bash

# Copy the source files required for nginx
copy_src:
	cp -f ./mame/cps1.js ./src
	cp -f ./mame/cps1.wasm ./src
	cp -rf ./emularity/logo ./src
	cp -rf ./emularity/images ./src
	cp -f ./emularity/browserfs.min.js ./src
	cp -f ./emularity/loader.js ./src
	cp -f ./emularity/es6-promise.js ./src

# Run nginx in Docker using the src folder
run_nginx_local_src:
	docker run -it --name mame -v $(shell pwd)/src:/usr/share/nginx/html:ro -d -p 8080:80 nginx

run_nginx_docker:
	docker run -it --name mame -d -p 8080:80 nicholasjackson/mame:latest

build_docker_app:
	docker build -t nicholasjackson/mame:latest .

stop_docker:
	docker stop mame
	docker rm mame
