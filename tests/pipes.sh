#!/bin/bash

source ../finally

# Show that the trap will fire in pipe process

function process-end {
	echo 1>&2 "process-end $@"
}

function process {
	finally process-end $1
	sleep $1
	read L
	echo "$L$1"
}

function main {
	echo yes | process 1 | process 2 | process 3 | process 4
}

main "$@"
