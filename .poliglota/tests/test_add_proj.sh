#! /bin/bash

## These are unit tests for `poli proj add` command
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
##   cleanup_directory
##   cleanup_project
##   fail <message>
##   pass <message>
##   raise_cannot_execute
# shellcheck source=.poliglota/tests/utils.sh
source ".poliglota/tests/utils.sh"

## Runs the new command and sends all errors to /dev/null
## Arguments:
##   $wrong_input
## Output:
##   Writes on an error inside $STD_POLI_PATH/error.txt
run_add() {
    ./poli proj add "$@"    \
        1> /dev/null        \
        2> "error.txt"
}


generate_project() {
    ./poli proj new "$@" "--empty"  \
        1> /dev/null                \
        2> /dev/stderr              \
    || raise_cannot_execute
}


# TODO: replace by the real template command
#   It should run with `templ new ...`
generate_template() {
    # .poli templ new "$@"    \
    # 1> /dev/null            \
    # 2> /dev/stderr          \
    # || raise_cannot_execute

    local -r template_folder="$1"
    local -r implementation="$2"

    mkdir "${template_folder}/${implementation}" ||
        ( echo "Couldn't create directory"              \
            >> /dev/stderr                              \
            && raise_cannot_execute )

    cp -r -b --no-preserve=timestamp                    \
            "${template_folder}/.template/"**           \
            "${template_folder}/${implementation}/" ||
        ( echo "Couldn't copy base template"            \
            >> /dev/stderr                              \
            && raise_cannot_execute )

}

cleanup_template() {
    local -r template="$1"
    local -r implementation="$2"
    cleanup_project "${template}" "${implementation}"
}


# Testing functions ---------


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_default_add_implementation() {
    CURRENT_TEST="test_default_add_implementation"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------

}


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_empty_implementation() {
    CURRENT_TEST="test_empty_implementation"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------
}


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_add_implementation_as() {
    CURRENT_TEST="test_custom_implementation"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------
}


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_custom_template() {
    CURRENT_TEST="test_custom_template"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------
}


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_custom_repository() {
    CURRENT_TEST="test_custom_repository"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------
}


## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
test_custom_script() {
    CURRENT_TEST="test_custom_script"

    # -- Arguments ----------

    # -- Globals ------------


    # >>> Prepare -----------


    # >>> Action ------------
    run_add


    # >>> Assertion ---------


    # >>> Cleanup -----------
}


# Running tests -------------

## Runs every test for `proj add` command
init_tests() {

    echo "Initializing tests..."

    test_default_add_implementation

    test_empty_implementation "--empty"
    test_empty_implementation "-e"

    test_add_implementation_as "--as"
    test_add_implementation_as "-a"

    test_custom_template "--templ"
    test_custom_template "-t"

    test_custom_repository "--repo"
    test_custom_repository "-r"

    test_custom_script "--custom"
    test_custom_script "-c"

}

init_tests