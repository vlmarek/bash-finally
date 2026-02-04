#!/bin/bash

source ../finally

# Make sure that we can't accidentally overwrite existing trap

function main {
	finally :
	finally error
}

main "$@"
