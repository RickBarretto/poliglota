#! /bin/bash

## These are unit tests for `poli proj new` command
## It tests flags, arguments and behavior

## NOTE: Run this test updates your $LAST_PROJECT

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
##   assert_are_equals <dir1> <dir2> <flags>
##   assert_dir_exists <directory> <flags>
##   assert_dir_is_empty <directory>
##   cleanup_directory <directory>
##   fail <message>
##   generate_project $@
##   generate_template <template_folder> <implementation>
##   pass <message>
##   raise_cannot_execute
# shellcheck source=.poliglota/tests/utils.sh
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


# Testing functions ---------

## Tests with default new project settings
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
test_default_project() {
    CURRENT_TEST="test_default_project"

    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"
    local -r project="__test_project"

    ## >>> Action -----------
    run_new "${project:?}" ||
        fail "${debug_message:?}"

    ## >>> Assertions -------
    assert_are_equals                       \
        "${template:?}"                     \
        "${repository:?}/${project:?}"    \
        "default config"

    ## >>> Cleanup ----------
    cleanup_directory "${repository:?}/${project:?}"
}


## Tests with an empty project
## Arguments:
##   $empty_flag: must be the empty flag
## Globals:
##  $STD_TEMPL_PATH
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $CURRENT_TEST
test_empty_project() {
    CURRENT_TEST="test_empty_projects"

    local empty_flag="$1"
    local -r template="${STD_TEMPL_PATH}"
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r project="__test_empty_project"

    # >>> Action ------------
    run_new "${project:?}" "${empty_flag:?}" ||
        fail                                \
            "Tried with ${empty_flag:?}.\n" \
            "${debug_message:?}"

    # >>> Assertions --------
    assert_dir_exists "${repository:?}/${project:?}"      \
        "${empty_flag}"

    assert_dir_is_empty "${repository:?}/${project:?}"

    # >>> Cleanup
    cleanup_directory "${repository:?}/${project:?}"
}


# Running tests -------------

## Runs every test for `proj new` command
init_tests() {
    echo_init_tests "test_new_proj"

    test_default_project
    test_empty_project "--empty"
    test_empty_project "-e"
}

init_tests