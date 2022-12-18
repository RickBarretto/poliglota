#! /bin/bash

## These are unit tests for `poli proj fill` command
## It tests flags, arguments and behavior

## NOTE:
##     - Run this test updates your $LAST_PROJECT
##     - Depends of test_new_proj.sh and test_new_templ.sh

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
##   cleanup_directory <directory>
##   cleanup_project <repository> <project>
##   cleanup_template <template> <implementation>
##   fail <message>
##   generate_project $@
##   generate_template <template_folder> <implementation>
##   pass <message>
##   raise_cannot_execute
# shellcheck source=.poliglota/tests/utils.sh
source ".poliglota/tests/utils.sh"

## Runs the new command and sends all errors to /dev/null
## Arguments:
##   $@
## Output:
##   Writes on an error inside $STD_POLI_PATH/error.txt
run_fill() {
    ./poli proj fill "$@"    \
        1> /dev/null        \
        2> "error.txt"
}

test_fill() {
    CURRENT_TEST="test_fill"

    # -- Globals
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r project="TestProject"
    local -r implementation="MyCustomImplementation"

    # >>> Prepare -----------
    generate_project "${project}"
    generate_template "${template}" "${implementation}"

    ## >>> Action -----------
    run_fill "${project}" ||
        fail "${debug_message}"

    # >>> Assertion ---------
    local -r check_impl=$(
        cd "${template}" ||
            raise_cannot_execute
        ls --recursive | xargs )

    local -r check_proj=$(
        cd "${repository}/${project}" ||
            raise_cannot_execute
        ls --recursive | xargs )

    if [[ "${check_impl}" = "${check_proj}" ]]
    then pass "Default config is running"   \
        "\n  Template's: ${check_impl}"     \
        "\n  Project's : ${check_proj}"
    else fail "Trying to compare:"          \
        "\n  Template's: ${check_impl}"     \
        "\n  Project's : ${check_proj}"
    fi

    # >>> Cleanup -----------
    cleanup_project "${repository}" "${project}"
    cleanup_template "${template}" "${implementation}"


}


# Running tests -------------

## Runs every test for `proj new` command
init_tests() {

    echo_init_tests "test_fill_proj"
    test_fill

}

init_tests