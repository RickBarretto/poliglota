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
##   assert_are_equals <dir1> <dir2> <flags>
##   assert_dir_exists <directory> <flags>
##   assert_dir_is_empty <directory>
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
run_add() {
    ./poli proj add "$@"    \
        1> /dev/null        \
        2> "error.txt"
}


# Testing functions ---------


## Tests with default config
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
test_default_add_implementation() {
    CURRENT_TEST="test_default_add_implementation"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r implementation="MyCustomImplementation"
    local -r project="MyCustomProject"


    # >>> Prepare -----------
    generate_project "${project}"
    generate_template "${template}" "${implementation}"


    # >>> Action ------------
    run_add "${implementation}" "${project}" ||
        fail "${debug_message}"


    # >>> Assertion ---------
    assert_are_equals                                   \
        "${template}/${implementation}"                 \
        "${repository}/${project}/${implementation}"    \
        "default config"


    # >>> Cleanup -----------
    cleanup_project "${repository}" "${project}"
    cleanup_template "${template}" "${implementation}"

}


## Tests with an empty implementation
## Arguments:
##  $empty_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
test_empty_implementation() {
    CURRENT_TEST="test_empty_implementation"

    # -- Arguments ----------
    local -r empty_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"

    local -r implementation="MyCustomImplementation"
    local -r project="MyCustomProject"


    # >>> Prepare -----------
    generate_project "${project}"


    # >>> Action ------------
    run_add "${implementation}" "${project}" "${empty_flag}" ||
        fail                                \
            "Tried with ${empty_flag}.\n"   \
            "${debug_message}"


    # >>> Assertion ---------
    assert_dir_exists                                   \
        "${repository}/${project}/${implementation}"    \
        "${empty_flag}"

    assert_dir_is_empty                                 \
        "${repository}/${project}/${implementation}"


    # >>> Cleanup -----------
    cleanup_project "${repository}" "${project}"

}


## Tests with latest project
## Arguments:
##  $latest_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
test_add_implementation_to_lastest_project() {
    CURRENT_TEST="test_default_add_implementation"

    # -- Arguments ----------
    latest_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r implementation="MyCustomImplementation"
    local -r project="MyCustomProject"


    # >>> Prepare -----------
    generate_project "${project}"
    generate_template "${template}" "${implementation}"


    # >>> Action ------------
    run_add "${implementation}" "${latest_flag}" ||
        fail                                    \
            "Tried to run with ${latest_flag}"  \
            "${debug_message}"


    # >>> Assertion ---------
    assert_are_equals                                   \
        "${template}/${implementation}"                 \
        "${repository}/${project}/${implementation}"    \
        "${latest_flag}"


    # >>> Cleanup -----------
    cleanup_project "${repository}" "${project}"
    cleanup_template "${template}" "${implementation}"

}

## Tests with custom name
## Arguments:
##  $as_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
test_add_implementation_as() {
    CURRENT_TEST="test_add_implementation_as"

    # -- Arguments ----------
    as_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r implementation="MyCustomImplementation"
    local -r project="MyCustomProject"
    local -r as_value="MyCustomImplementation2"


    # >>> Prepare -----------
    generate_project "${project}"
    generate_template "${template}" "${implementation}"


    # >>> Action ------------
    run_add "${implementation}" "${project}" "${as_flag}" "${as_value}" ||
        fail                                            \
            "Tried to run with ${as_flag} ${as_value}"  \
            "${debug_message}"


    # >>> Assertion ---------
    assert_are_equals                                   \
        "${template:?}/${implementation:?}"             \
        "${repository:?}/${project:?}/${as_value:?}"    \
        "${as_flag:?} ${as_value:?}"


    # # >>> Cleanup -----------
    cleanup_project "${repository}" "${project}"
    cleanup_template "${template}" "${implementation}"

}

# Running tests -------------

## Runs every test for `proj add` command
init_tests() {

    echo_init_tests "test_add_proj"

    test_default_add_implementation

    test_empty_implementation "--empty"
    test_empty_implementation "-e"

    test_add_implementation_to_lastest_project "--latest"
    test_add_implementation_to_lastest_project "-l"

    test_add_implementation_as "--as"
    test_add_implementation_as "-a"

}

init_tests