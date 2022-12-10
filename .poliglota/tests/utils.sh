## Utils functions and variables to be used
## by every test function inside this folder

# Use source ".poliglota/tests/utils.sh"

# --- Global variables to be exported ---

## Imports:
## >> Constants
##  $STD_CONFIG_PATH
##  $STD_POLI_PATH
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
##  $STD_PLUGINS_PATH
## >> Variables
##  $LAST_PROJECT
# shellcheck source=poli.config
source "poli.config"

## >> Variable
## This is the current test that is running
CURRENT_TEST=""

## >> Constant
## String used to be printed in fail(),
## case the command returned an error
declare -r PLEASE_DEBUG="Command returned an error.
Please run with set -x. And read ${STD_POLI_PATH}/error.txt"

# --- Global functions to be exported ---

## Prints a success message for some test
## Arguments:
##  $message *
## Globals:
##  $CURRENT_TEST
## Output:
##  Prints a success message
##  with the current test and a custom message
pass() {
    # -- Arguments
    local -r message="$*"

    # -- Globals
    local current_test="${CURRENT_TEST}"

    # -- Colors
    local -r RESET='\033[0m'
    local -r GREEN='\033[0;32m'
    local -r GREEN_BG='\033[42m'
    local -r GREEN_UNDERLINE='\033[4;32m'

    # -- To print
    local -r status="${GREEN_BG}[PASSED]${RESET}"
    local -r title="${GREEN_UNDERLINE}${current_test}"
    local -r divisor="${GREEN}:${RESET}"
    local -r description="${RESET}${message}"

    echo -e "${status} ${title}${divisor}" "${description}"
}


## Prints an error message for some test
## Arguments:
##  $message *
## Globals:
##  $CURRENT_TEST
## Output:
##  Prints an error message
##  with the current test and a custom message
fail() {
    # -- Arguments
    local -r message="$*"

    # -- Globals
    local current_test="${CURRENT_TEST}"

    # -- Colors
    local -r RESET='\033[0m'
    local -r RED='\033[0;31m'
    local -r RED_BG='\033[41m'
    local -r RED_UNDERLINE='\033[4;31m'

    # -- To print
    local -r status="${RED_BG}[FAILED]${RESET}"
    local -r title="${RED_UNDERLINE}${current_test}"
    local -r divisor="${RED}:${RESET}"
    local -r description="${RESET}${message}"

    echo -e "${status} ${title}${divisor}" "${description}" \
        >> /dev/stderr
}


## Exits with 126 code
## Returns
##  exits with 126 code
raise_cannot_execute() {
    local -r -i cannot_execute=126
    exit $cannot_execute
}

# -- Cleanup functions

## Cleanup created directory
## Arguments:
##   $directory
## Output:
##  outputs to stderr if cleanup fails
## Return:
##  raise_cannot_execute if cleanup fails
cleanup_directory() {
    local -r directory="$1"
    rm --recursive "${directory:?}/" ||
        ( echo "Couldn't cleanup directory"         \
            >> /dev/stderr                          \
            && raise_cannot_execute )
}


## Cleanup created project
## Arguments:
##   $repository
##   $project
## Output:
##  outputs to stderr if cleanup fails
## Return:
##  raise_cannot_execute if cleanup fails
cleanup_project() {
    local -r repository="$1"
    local -r project="$2"
    rm --recursive "${repository:?}/${proj_name:?}" ||
        ( echo "Couldn't cleanup project"           \
            >> /dev/stderr                          \
            && raise_cannot_execute )
}
