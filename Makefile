CC=cc
PREFIX:=$(shell sdl2-config --prefix)
CFLAGS:=$(shell sdl2-config --cflags)
STATIC_INSTALL_DIR:=${PREFIX}/lib
HEADER_INSTALL_DIR:=${PREFIX}/include/SDL2

AR:=ar -crsv ./libSDL_gifwrap.a

all: libSDL_gifwrap.a


libSDL_gifwrap.a: SDL_gifwrap.o
	${AR} ./SDL_gifwrap.o

SDL_gifwrap.o:
	${CC} -c SDL_gifwrap.c -Wall -Wextra -Wpedantic ${CFLAGS}

install: libSDL_gifwrap.a
	cp libSDL_gifwrap.a ${STATIC_INSTALL_DIR}/
	cp SDL_gifwrap.h ${HEADER_INSTALL_DIR}/SDL_gifwrap.h

@PHONY: all install
