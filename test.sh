#!/usr/bin/env bash

if [ $? -ne 0 ]; then
    echo "Failed to parse options…" >&2
    exit 1
fi

# re-set the positional parameters to the parsed result
# Now iterate and only keep what you want (or skip)
while true; do
    case "$1" in
    -a)
        echo "Saw -a"
        shift
        ;;
    -b)
        echo "Saw -b with $2"
        shift 2
        ;;
    --foo)
        echo "Saw --foo (dropping it!)"
        shift
        ;;
    --bar)
        echo "Saw --bar with $2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    esac
done

# $@ now contains only the “leftover” arguments (non-options)
echo "remainders: $@"
