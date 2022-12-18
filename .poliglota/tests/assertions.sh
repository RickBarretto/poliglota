## Assertions functions

## Exports:
##  raise_cannot_execute
##  pass <message>
##  fail <message>

## Exits with 126 code
## Returns
##  exits with 126 code
raise_cannot_execute() {
    local -r -i cannot_execute=126
    exit $cannot_execute
}

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
    local -r status="${GREEN_BG}[PASSED✔]${RESET}"
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
    local -r status="${RED_BG}[FAILED✘]${RESET}"
    local -r title="${RED_UNDERLINE}${current_test}"
    local -r divisor="${RED}:${RESET}"
    local -r description="${RESET}${message}"

    echo -e "${status} ${title}${divisor}" "${description}" \
        >> /dev/stderr
}