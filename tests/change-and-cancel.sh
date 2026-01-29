#!/bin/bash

source ../finally

# Show that it is possible to change and/or cancle the trap completely

function trap-recursion {
	echo done $1
}

function recursion {
	finally trap-recursion $1
	echo "recursion $1"
	local NUM=$(( $1 - 1 ))
	if [[ $1 == 4 ]]; then
		finally # We must clear existing code before overwriting
		finally trap-recursion changed
	elif [[ $1 == 2 ]]; then
		finally # cancel
	fi
	if [[ $NUM -eq 0 ]]; then
		return
	else
		recursion $NUM
	fi
}

function main {
	recursion 5
}

main "$@"
