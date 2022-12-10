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
##   raise_cannot_execute
# shellcheck source=".poliglota/tests/utils.sh"
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

    # -- Globals
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"
    local -r template="${STD_TEMPL_PATH}"

    local -r proj_name="TestProject"


    ## >>> Action -----------
    run_new "${proj_name}" ||
        failed "${debug_message}"


    ## >>> Assertions -------
    local -r check_impl=$(
        ( cd "${template}" || raise_cannot_execute )
        echo */**)

    local -r check_repo=$(
        ( cd "${repository}/${proj_name}" || raise_cannot_execute )
        echo */**)

    # Checks if files exists in both
    # Note: files with a dot `.` at the start will be ignored
    if [[ "${check_impl}" = "${check_repo}" ]]
    then pass                               \
            "default config is running"
    else
        fail                                \
            "Trying to compare:\n"          \
            "\tTemplates : ${check_impl}\n" \
            "\tRepository: ${check_repo}"
    fi


    ## >>> Cleanup ----------
    rm --recursive "${repository:?}/${proj_name:?}" ||
        ( echo "Couldn't cleanup" >> /dev/stderr &&
            raise_cannot_execute )

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

    # -- Arguments ----------
    local empty_flag="$1"


    # -- Globals ------------
    local -r template="${STD_TEMPL_PATH}"
    local -r debug_message="${PLEASE_DEBUG}"
    local -r repository="${STD_REPO_PATH}"

    local -r proj_name="TestEmptyProject"


    # >>> Action ------------
    run_new "${proj_name}" "${empty_flag}" ||
        failed "Tried with ${empty_flag}.\n" \
            "${debug_message}"


    # >>> Assertions --------

    # Checks if project was created
    if [[ -d "${repository}/${proj_name}" ]]
        then pass
                "Project was created with ${empty_flag}"
        else fail
                "${repository}/${proj_name} does not exist"
    fi

    # Checks if repository is empty
    if [[ ! -e "${repository:?}/${proj_name:?}/"* ]]
        then pass
                "Project is empty"
        else fail
                "${repository}/${proj_name} is not empty"
    fi


    # >>> Cleanup
    rm --recursive "${repository:?}/${proj_name:?}" ||
        ( echo "Couldn't cleanup" >> /dev/stderr &&
            raise_cannot_execute )

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

    # -- Arguments ----------
    local -r template_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local repository="${STD_REPO_PATH}"

    local -r template="CustomTemplate"
    local -r proj_name="FromCustom"


    # >>> Prepare -----------
    # Creates a custom template folder
    mkdir "${template}"
    touch "${template}/${template}s_file.md"


    # >>> Action ------------
    run_new "${proj_name}" "${template_flag}" "${template}"  ||
        failed "Tried with ${template_flag} ${template}.\n" \
        "\t${debug_message}"


    # >>> Assertions --------

    # Checks if repository exists and has the template's file
    if [[ -f "${repository}/${proj_name}/${template}s_file.md" ]]
        then pass "Created with ${template} folder"
        else fail "${repository}/${proj_name} doesn't was created"
    fi


    # >>> Cleanup -----------
    rm --recursive "${template:?}/" ||
        ( echo "Couldn't cleanup template folder" >> /dev/stderr &&
            raise_cannot_execute )
    rm --recursive "${repository:?}/${proj_name:?}" ||
        ( echo "Couldn't cleanup project" >> /dev/stderr &&
            raise_cannot_execute )

}


## Tests with a custom repository folder
## Arguments:
##   $repository_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_TEMPL_PATH
## Returnns:
##  exits if cd command fails
test_custom_repository() {
    CURRENT_TEST="test_custom_repository"

    # -- Arguments ----------
    local -r repository_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"
    local -r template="${STD_TEMPL_PATH}"

    local -r repository="CustomRepository"
    local -r proj_name="FromCustom"


    # >>> Prepare -----------
    # Creates a custom repository folder
    mkdir "${repository}"


    # >>> Action ------------
    run_new "${proj_name}" "${repository_flag}" "${repository}"  ||
        failed "Tried with ${repository_flag} ${repository}.\n" \
        "\t${debug_message}"


    # >>> Assertions --------
    local -r check_impl=$(
        ( cd "${template}" || raise_cannot_execute )
        echo */**)
    local -r check_repo=$(
        ( cd "${repository}/${proj_name}" || raise_cannot_execute )
        echo */**)

    # Checks if the same files exists in both
    # Note: files with a dot `.` at the start will be ignored
    if [[ "${check_impl}" = "${check_repo}" ]]
    then pass                                   \
            "Created with ${repository} folder"
    else
        fail                                    \
            "Trying to compare:"                \
            "\n\tTemplates: ${check_impl}"      \
            "\n\t= Repository: ${check_repo}"
    fi


    # >>> Cleanup -----------
    rm --recursive "${repository:?}" ||
        ( echo "Couldn't cleanup project" >> /dev/stderr &&
            raise_cannot_execute )

}


## Tests with a custom script
## Arguments:
##   $custom_flag
## Globals:
##  $CURRENT_TEST
##  $PLEASE_DEBUG
##  $STD_TEMPL_PATH
test_custom_script() {
    CURRENT_TEST="test_custom_script"

    # -- Arguments ----------
    local -r custom_flag="$1"

    # -- Globals ------------
    local -r debug_message="${PLEASE_DEBUG}"

    local -r script="custom_script.sh"
    local -r args="--flag1 value -f2 value2"
    local -r proj_name="CreatedWithCustomScript"
    local -r output_file="test.txt"


    # >>> Prepare -----------
    printf '#! /bin/bash
        echo "$@" > "%s"' \
        "${output_file}"  \
        > "${script}"


    # >>> Action ------------
    run_new "${proj_name}" "${custom_flag}" "${script}" "${args}" ||
        failed \
            "Tried with ${custom_flag} ${script}.\n" \
            "${debug_message}"


    # >>> Assertion ---------
    output=$(head -n 1 "${output_file}")
    if [[ "${output}" = "${proj_name} ${custom_flag} ${script} ${args}" ]]
    then pass "Custom Script is working." \
        "\n\tOutput: ${output}"
    else fail "Output is different:"                        \
        "\n\t${output}"                                     \
        "\n\t${proj_name} ${custom_flag} ${script} ${args}"
    fi


    # >>> Cleanup -----------
    rm "${output_file:?}" "${script:?}" ||
        ( echo "Couldn't cleanup" >> /dev/stderr &&
            raise_cannot_execute )

}


# Running tests -------------

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

    test_custom_script "--custom"
    test_custom_script "-c"

}

init_tests