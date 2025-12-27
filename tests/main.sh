#!/bin/bash

source ../finally

# Show that the traps can be set to top level code (not inside function)

function trap-top-level {
	echo end
	typeset -p __FINALLY_ERROR
}

finally trap-top-level
echo running code
