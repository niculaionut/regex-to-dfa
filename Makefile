CXX=c++
CXXFLAGS=-std=c++20 -Os -flto -fno-exceptions -fno-rtti -march=native -Wall -Wextra -Wpedantic -Wconversion
LDFLAGS=`pkg-config fmt libgvc --libs` -flto

SRC = main.cpp
OBJ = ${SRC:.cpp=.o}

all: options rtd

options:
	@echo rtd build options:
	@echo "CXXFLAGS = ${CXXFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CXX      = ${CXX}"

.cpp.o:
	${CXX} -c ${CXXFLAGS} $<

${OBJ}: numtypes.hpp

rtd: ${OBJ}
	${CXX} -o $@ ${OBJ} ${LDFLAGS}

tests: rtd
	rm -f output/*
	for filename in tests/*; do \
			./rtd "$$(cat "$$filename")" && dot -Tsvg graph.dot >output/"$$(basename "$$filename")".svg ; \
	done

clean:
	rm -f rtd ${OBJ} graph.dot output.svg

.PHONY: all options tests clean
