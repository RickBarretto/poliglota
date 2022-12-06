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

    # -- Arguments
    local empty_flag="$1"

    # -- Globals
    local -r template="${STD_TEMPL_PATH}"
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"

    local -r proj_name="TestEmptyProject"

    # >>> Action
    run_new "${proj_name}" "${empty_flag}" ||
        failed "Tried with "${empty_flag}".\n${debug_message}"

    # >>> Assertions

    # Checks if project was created
    if [[ -d "${repository}/${proj_name}" ]]
        then pass "Project was created with ${empty_flag}"
        else fail "${repository}/${proj_name} does not exist"
    fi

    # Checks if repository is empty
    if [[ ! -e "${repository}/${proj_name}/*" ]]
        then pass "Project is empty"
        else fail "${repository}/${proj_name} is not empty"
    fi

    # >>> Cleanup
    rm --recursive "${repository}/${proj_name}" ||
        echo "Couldn't cleanup"

}


## Tests with a custom template folder
## Arguments:
##   $template_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_REPO_PATH
test_custom_template() {
    CURRENT_TEST="test_custom_template"

    # -- Arguments
    local -r template_flag="$1"

    # -- Globals
    local -r debug_message="${PLEASE_DEBUG}"
    local repository="${STD_REPO_PATH}"

    local -r template="CustomTemplate"
    local -r proj_name="FromCustom"

    # >>> Prepare
    # Creates a custom template folder
    mkdir "${template}"
    touch "${template}/${template}s_file.md"

    # >>> Action
    run_new "${proj_name}" "${template_flag}" "${template}"  ||
        failed "Tried with "${template_flag} ${template}".\n${debug_message}"

    # >>> Assertions

    # Checks if repository exists and has the template's file
    if [[ -f "${repository}/${proj_name}/${template}s_file.md" ]]
        then pass "Created with ${template} folder"
        else fail "${repository}/${proj_name} doesn't was created"
    fi

    # >>> Cleanup
    rm --recursive "${template}/" ||
        "Couldn't cleanup template folder"
    rm --recursive "${repository}/${proj_name}" ||
        echo "Couldn't cleanup project"

}


## Tests with a custom repository folder
## Arguments:
##   $repository_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_TEMPL_PATH
test_custom_repository() {
    CURRENT_TEST="test_custom_repository"

    # -- Arguments
    local -r repository_flag="$1"

    # -- Globals
    local -r debug_message="${PLEASE_DEBUG}"
    local -r template="${STD_TEMPL_PATH}"

    local -r repository="CustomRepository"
    local -r proj_name="FromCustom"

    # >>> Prepare
    # Creates a custom repository folder
    mkdir "${repository}"

    # >>> Action
    run_new "${proj_name}" "${repository_flag}" "${repository}"  ||
        failed \
        "Tried with "${repository_flag} ${repository}".\n${debug_message}"

    # >>> Assertions

    ## >>> Assertions
    local -r check_impl=$(cd "${template}"; echo */**)
    local -r check_repo=$(cd "${repository}/${proj_name}"; echo */**)

    # Checks if the same files exists in both
    # Note: files with a dot `.` at the start will be ignored
    if [[ "${check_impl}" = "${check_repo}" ]]
    then pass "Created with ${repository} folder"
    else
        fail "Trying to compare:
        Templates: ${check_impl} \\
        = Repository: ${check_repo}"
    fi

    # >>> Cleanup
    rm --recursive "${repository}" ||
        echo "Couldn't cleanup project"

}


# Running tests --------

## Runs every test for `proj new` command
init_tests() {
    echo "Initializing tests..."

    test_default_project

    test_empty_project "--empty"
    test_empty_project "-e"

    test_custom_template "--templ"
    test_custom_template "-t"

    test_custom_repository "--repo"
    test_custom_repository "-r"
}

init_tests