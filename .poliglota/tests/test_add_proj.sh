#! /bin/bash

## These are unit tests for `poli proj add` command
## It tests flags, arguments and behavior

## NOTE: Run these test'll update your $LAST_PROJECT

## Every function here will outputs:
## A success message if everything is alright
## An error message if wrong

## Imports:
##  -- Variables --
##   $STD_CONFIG_PATH
##   $STD_POLI_PATH
##   $STD_REPO_PATH
##   $STD_TEMPL_PATH
##   $STD_PLUGINS_PATH
##   $LAST_PROJECT
##   $CURRENT_TEST
##   $PLEASE_DEBUG
##  -- Functions --
##   pass <message>
##   fail <message>
##   raise_cannot_execute
# shellcheck source=.poliglota/tests/utils.sh
source ".poliglota/tests/utils.sh"

## Runs the new command and sends all errors to /dev/null
## Arguments:
##   $wrong_input
## Output:
##   Writes on an error inside $STD_POLI_PATH/error.txt
run_add() {
    ./poli proj add "$@" \
        1> /dev/null     \
        2> "error.txt"
}

# Testing functions ---------

# ...



# Running tests -------------

## Runs every test for `proj add` command
init_tests() {

    echo "Initializing tests..."

    # ...

}

init_tests