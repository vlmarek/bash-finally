#!/bin/bash

source ../finally

# Show that the traps fire also in background jobs

function sleeper-done {
	echo $1
}

function sleeper {
	finally sleeper-done $1
	sleep $1
}

function main {
	sleeper 1 &
	sleeper 2 &
	sleeper 3 &
	wait
}

main "$@"
