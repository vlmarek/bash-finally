#!/bin/bash

source ../finally

# Show that trap will fire when we sigterm a command

function killwait {
  sleep 1
  PID=$(<$TMPFILE)
  echo killing sleep
  kill -s SIGTERM $PID
}

function cleanup {
  if [ -n "$TMPFILE" ]; then
    typeset -p __FINALLY_ERROR
    echo removing tmpfile
    rm "$TMPFILE"
  fi
}

function main {
  TMPFILE=$(mktemp -t finally-test.XXXXXXX)
  finally cleanup

  sleep 100 &
  local PID=$!
  echo $PID > $TMPFILE

  killwait &

  wait $PID
  echo wait done
}

main "$@"
