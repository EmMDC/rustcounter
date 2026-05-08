savedcmd_rustcounter.mod := printf '%s\n'   rustcounter.o | awk '!x[$$0]++ { print("./"$$0) }' > rustcounter.mod
