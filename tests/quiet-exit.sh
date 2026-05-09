#!/bin/bash

source ../finally

# If you intentinally want to exit with non-zero code but do not want to see stack trace

function main {
	__FINALLY_QUIET_EXIT=1
	exit 1
}

main "$@"
