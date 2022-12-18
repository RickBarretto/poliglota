## Assertions functions

## Exports:
##  raise_cannot_execute
##  pass <message>
##  fail <message>
##  assert_are_equals <dir1> <dir2> <flags>

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


assert_are_equals() {

    local -r  path1="$1"
    local -r  path2="$2"
    local -r params="$3"

    local -r dir_1=$(
        cd "${path1}" ||
            raise_cannot_execute
        ls --recursive | xargs )

    local -r dir_2=$(
        cd "${path2}" ||
            raise_cannot_execute
        ls --recursive | xargs )

    if [[ "${dir_1}" = "${dir_2}" ]]
    then pass "Running with ${params}"                      \
        "\n  ${path1}'s: ${dir_1}"                          \
        "\n  ${path2}'s : ${dir_2}"
    else fail "Trying to compare, while using ${params}:"   \
        "\n  ${path1}'s: ${dir_1}"                          \
        "\n  ${path2}'s : ${dir_2}"
    fi

}

