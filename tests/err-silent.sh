#!/bin/bash

source ../finally

# Show that the traps will fire if there is non-zero retrun code

__FINALLY_QUIET_EXIT=1

function three { false; }
function two { three; }
function one { two; }
function main { one; }

main "$@"
