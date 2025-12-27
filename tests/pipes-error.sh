#!/bin/bash

source ../finally

# Show that exit trap will fire in pipe process too

exec 1>&2 # Make sure that 'finally' does not write to closed pipe

function process-end {
	sleep 1
	echo 1>&2 "... process-end"
}

function process {
	finally process-end $1
	echo 1>&2 "process running ..."
	if [ $1 -eq 1 ]; then
		exit 1
	fi
	read L
	echo "$L$1"
}

function trap-main {
	sleep 1
	echo 1>&2 trap-main
}

function main {
	finally trap-main
	echo yes | process 1 | process 2 | process 3 | process 4
}

main "$@"
