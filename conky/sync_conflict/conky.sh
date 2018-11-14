#!/bin/bash
count=$(for dir in "$@"; do find "$dir" -name "*.sync-conflict-*"; done | wc -l)
if [[ $count -eq 1 ]]; then echo "There is a sync conflict!"
elif [[ $count -gt 1 ]]; then echo "There are $count sync conflicts!"
fi
