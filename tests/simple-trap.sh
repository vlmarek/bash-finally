#!/bin/bash

source ../finally

# Show simple trap usage

function trap-main {
	echo trap
}

function main {
	echo 1
	finally trap-main
	echo 2
}

main "$@"
