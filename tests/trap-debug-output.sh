#!/bin/bash

source ../finally

# If finally is about to display callstack and exit the program then disable
# the tracing as it would print just too much of not very usefull mess.

function start {
	set -x
	false
}

start "$@"
