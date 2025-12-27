#!/bin/bash

source ../finally

# Show that nothing happens when just including the source

function main {
	echo ok
}

main "$@"
