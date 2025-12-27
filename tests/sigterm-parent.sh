#!/bin/bash

source ../finally

# Show that thrap will fire if we sigterm parent process

function killwait {
  sleep 1
  local PID=$(<$TMPFILE)
  echo killing parent
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
  PID=$!
  echo $BASHPID > $TMPFILE

  killwait &

  wait $PID || { echo "Wait returns error $?"; }
  echo wait done
}

main "$@"
