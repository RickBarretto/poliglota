#! /bin/bash

## These are unit tests for `poli proj new` command
## It tests flags, arguments and behavior

## NOTE: Run these test'll update your $LAST_PROJECT

## Every file here will outputs:
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
source ".poliglota/tests/utils.sh"

## Runs the new command and sends all errors to /dev/null
## Arguments:
##   $wrong_input
## Output:
##   Writes on an error inside $STD_POLI_PATH/error.txt
run_new() {
    ./poli proj new "$@" \
        1> /dev/null     \
        2> "error.txt"
}

# Testing functions -------


## Tests with default new project settings
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
test_default_project() {
    CURRENT_TEST="test_default_project"

    # -- Globals
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r proj_name="TestProject"

    ## >>> Action
    run_new "${proj_name}" ||
        failed "${debug_message}"

    ## >>> Assertions
    local -r check_impl=$(cd "${template}"; echo */**)
    local -r check_repo=$(cd "${repository}/${proj_name}"; echo */**)

    # Checks if the same files exists in both
    # Note: files with a dot `.` at the start will be ignored
    if [[ "${check_impl}" = "${check_repo}" ]]
    then pass "default config is running"
    else
        fail "Trying to compare:
        Templates: ${check_impl} \\
        = Repository: ${check_repo}"
    fi

    ## >>> Cleanup
    rm --recursive "${repository}/${proj_name}" ||
        echo "Couldn't cleanup"

}

# Running tests --------

## Runs every test for `proj new` command
init_tests() {
    echo "Initializing tests..."

    test_default_project


}

init_tests