#!/bin/bash

source ../finally

# Show that traps will fire in recursion in subshell

function trap-recursion {
	if [[ $BASHPID == $1 ]]; then
		echo good $2
	else
		echo error $2
	fi
}

function recursion {
	finally trap-recursion $BASHPID $1
	(
	echo "recursion $1"
	local NUM=$(( $1 - 1 ))
	if [[ $NUM -eq 0 ]]; then
		return
	else
		recursion $NUM
	fi
	)
}

function trap-main {
	echo trap-main
}

function main {
	finally trap-main
	echo main1
	recursion 10
	echo main2
}

main "$@"
