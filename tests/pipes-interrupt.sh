#!/bin/bash

source ../finally

# This does not work in bash

function process-end {
	echo 1>&2 "process-end"
}

function process {
	finally process-end $1
	read L
	echo "$L$1"
}

function trap-main {
	echo 1>&2 trap-main
}

function main {
	finally trap-main
	echo yes | process 1 | process 2 | process 3 | process 4
}

main "$@"
