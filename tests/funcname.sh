#!/bin/bash

source ../finally

# The trap will have __FINALLY_FUNCTION variable set to the name of function
# from which the trap is called

function ccc {
	finally mytrap ccc
}

function bbb {
	finally mytrap bbb
	ccc
}

function aaa {
	finally mytrap aaa
	bbb
}

function mytrap {
	echo trap "$@"
	typeset -p __FINALLY_FUNCTION
}

finally mytrap top-level

function start {
	finally mytrap start
	aaa
}

start "$@"
