#!/bin/bash

status=0

for orig in *_orig.*; do
    normal="${orig/_orig/}"

    if [[ ! -f "$normal" ]]; then
        echo "MISSING: $normal"
        status=1
        continue
    fi

    if diff -q "$orig" "$normal" >/dev/null; then
        echo "OK: $orig == $normal"
    else
        echo "DIFF: $orig != $normal"
        status=1
    fi
done

exit $status
