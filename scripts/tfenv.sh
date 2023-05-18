#!/bin/bash

# USAGE

#   before_hook "tfenv" {
#     commands     = ["apply", "plan", "init"]
#     execute      = ["bash", "./hooks/tfenv.sh"]
#     run_on_error = false
#   }


if command -v tfenv &> /dev/null
then
    echo -e "\033[33mfound tfenv in PATH\033[0m"

    if ! test -f .terraform-version ; then
        echo -e "\033[31mError - could not find '.terraform-version' file\033[0m" >&2
        exit 1
    fi

    tfenv use "$(cat .terraform-version)"
fi
