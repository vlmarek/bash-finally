#!/bin/bash

source ../finally

# Show that the trap will fire in pipeline even in if command in which the error trap is disabled

function process-end {
	echo 1>&2 "process-end $@"
}

function process {
	finally process-end $1
	sleep $1
	read L
	echo "$L$1"
	if [[ $1 -eq 3 ]]; then
		return 1
	fi
}

function main {
	if echo yes | process 1 | process 2 | process 3 | process 4; then
		:
	fi
}

main "$@"
