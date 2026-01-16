# Finally
`Finally` is a small Bash helper that runs a command automatically when a function (or the whole script) finishes – whether it exits normally or aborts unexpectedly. Think of it as a “poor‑man's” try/catch/finally construct.

# Example
```bash
#!/bin/bash

source finally

function worker {
    local TEMPDIR="$( mktemp -d -t workdir.XXXXXXX )"
    finally rm -rf "$TEMPDIR" # Set the trap to remove $TEMPDIR

    if no-work-to-do; then
        return 0              # ... and fire it when exiting the function
    fi
    if no-free-disk-space; then
        exit 1                # ... or when exiting whole script
    fi

    ...
}                             # ... or when the function is done

# ... or when user pressed Ctrl+C
# ... or when someone sent SIGKILL to our process
```

The same works at the top level of a script:


```bash
#!/bin/bash

source finally

finally echo done
```

# Usage
* Source the script `finally`
* Inside the block you want to protect (a function or the script’s top level), call the `finally` 
* Pass the command you want executed when the block terminates – this can be a function call, a builtin, or any external command.

```
finally <command‑or‑function> [args…]
```

# What does it do
* `finally` installs a `RETURN` trap for the current function. When that function exits, the specified command runs.
* If the function exits *unexpectedly* (`Ctrl‑c`, a `kill signal`, or an `error`), all active traps are invoked, not only the one belonging to the current function. And the program terminates.
* In case of an error, the script also prints a call‑stack trace showing where the problem occurred.

# Gotchas
## Strict mode
When you source finally, it enables the "unofficial Bash strict mode":
```bash
set -eEuo pipefail
```
I believe that is the way to write bash scripts :) See http://redsymbol.net/articles/unofficial-bash-strict-mode/.
* (`set -eE`) any command that exits with a non‑zero status aborts the script. For example if you use grep(1) and it does not find any text it returns with exit code 1 terminating your program. *If you deliberately want to ignore a failure, use: `command || :`*
* (`set -u`) any usage of *undefined* variable is an error. Variable is not empty by default, it is a trap by default.
* (`set -o pipefail`) any non-zero exit in pipeline `cmd1 | cmd2 | cmd3` causes an error.

## Global and Local variables in trap
Consider this example where two traps are executed:
```bash
#!/bin/bash

. finally

TMP=global

function finalize {
        echo "Finalizing $TMP"
}

function func2 {
        finally finalize
        local TMP=local-func2
        #false
}

function func1 {
        finally finalize
        local TMP=local-func1
        func2
}

func1
```
The output is:
```
Finalizing local-func2
Finalizing local-func1
```

However if I un-comment the `false` command in `func2` the output is:
```
Finalizing local-func2
Finalizing local-func2
```
This is because `finally` iterates over all traps in case of an 'unexpected' exit and running them in the context of the function where this happened. You can depend on a variable only if it is global one. Instead you can pass parameters to the trap. For example:

```bash
#!/bin/bash

. finally

TMP=global

function finalize {
        echo "Finalizing $1"
}

function func2 {
        finally finalize arg-func2
        false
}

function func1 {
        finally finalize arg-func1
        func2
}

func1
```

## Sourcing a file fires RETURN trap
```bash
#!/bin/bash

. finally

finally echo "I AM DONE"

. other

echo "I STILL SHOULD BE WORKING"
```

This prints
```
I AM DONE
I STILL SHOULD BE WORKING
```

I do not know how to avoid this. I am using `eval "$(<other)"` ...


## Trace attribute
Any function guarded by `finally` receives trace attribute (`declare -f -t function`). I'm not aware of any side effects, but I wanted to mention it anyway.
