#!/bin/bash

source ../finally

# Show that the traps will fire even if we 'exit' in the middle of trap

DO_EXIT=

function trap-aaa {
	echo trap-aa $__FINALLY_FUNCTION $__FINALLY_ERROR
	if [ $DO_EXIT ] ; then
		exit 5
	fi
}

function aaa {
	finally trap-aaa
}

function trap-top-level {
	echo trap-top-level $__FINALLY_FUNCTION $__FINALLY_ERROR
}

finally trap-top-level

function trap-main {
	echo trap-main $__FINALLY_FUNCTION $__FINALLY_ERROR
}

function main {
	finally trap-main
	aaa
}

main "$@"
DO_EXIT=1
main "$@"

