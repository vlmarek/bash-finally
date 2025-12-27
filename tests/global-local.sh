#!/bin/bash

source ../finally

# Show that the RETURN traps will have locally defined variables available
# Compare to 'global-only.sh'

VAR=1

function trap-recursion {
	echo "Trap VAR=$VAR $__FINALLY_ERROR"
}

function recursion {
	local VAR="$(( $VAR + 1 ))"
	finally trap-recursion

	echo "recursion $VAR"

	local NUM=$(( $1 - 1 ))
	if [[ $NUM -eq 0 ]]; then
		return
	else
		recursion $NUM
	fi
}

function trap-main {
	echo trap-main
	typeset -p __FINALLY_ERROR
}

function main {
	finally trap-main
	recursion 10
}

main "$@"
