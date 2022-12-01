#! /usr/bin/env bash

wget --load-cookies=adventofcode.com_cookies.txt \
	https://adventofcode.com/2022/day/$1/input\
	-O input/$1.txt
