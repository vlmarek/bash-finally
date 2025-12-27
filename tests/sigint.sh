#!/bin/bash

source ../finally

# Show that trap will fire on SIGINT

function send-self-sigint {
  sleep 1
  PID=$(<$TMPFILE)
  echo killing myself
  kill -s SIGINT $PID
}

function cleanup {
  if [ -n "$TMPFILE" ]; then
    echo removing tmpfile
    typeset -p __FINALLY_ERROR
    rm "$TMPFILE"
  fi
}

function main {
  TMPFILE=$(mktemp -t finally-test.XXXXXXX)
  finally cleanup

  sleep 100 &
  echo $BASHPID > $TMPFILE

  send-self-sigint &

  wait
}

main "$@"
