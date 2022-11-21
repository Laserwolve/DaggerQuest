#!/bin/sh
echo -ne '\033c\033]0;Dagger Quest\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Dagger Quest.x86_64" "$@"
