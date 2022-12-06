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
##  $message
## Globals:
##  $CURRENT_TEST
## Output:
##  Prints a success message
##  with the current test and a custom message
pass() {
    # -- Arguments
    local message="$1"

    # -- Globals
    local current_test="${CURRENT_TEST}"

    echo "[PASSED] ${current_test}: ${message}"
}


## Prints an error message for some test
## Arguments:
##  $message
## Globals:
##  $CURRENT_TEST
## Output:
##  Prints an error message
##  with the current test and a custom message
fail() {
    # -- Arguments
    local message="$1"

    # -- Globals
    local current_test="${CURRENT_TEST}"

    echo -e "[FAILED] ${current_test}: ${message}" \
        >> /dev/stderr
}