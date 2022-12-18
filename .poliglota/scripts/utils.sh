## Sets the minimal arguments required by a command
## Arguments:
##  $wrong_input
## Output:
##  Prints an error message and the usage
## Returns:
##  exit "$E_BADARGS"
raise_wrong_arguments_input() {
    local -r wrong_input="$1"
    local -r E_BADARGS=85 ## Bad Arguments error value

    set +o noclobber
    echo "Wrong input: ${wrong_input}" >> /dev/stderr # > stderr

    echo
    usage
    exit "${E_BADARGS}"

}

## Sets the minimal arguments required by a command
## Arguments:
##  $minimal: minimal arguments to be able run
##  $arg_count: current arguments count
## Output:
##  Prints an error message and the usage
## Returns:
##  raise_wrong_arguments_input, if assert fails
assert_minimal_arguments() {

    local -r -i minimal=$1
    local -r -i arg_count=$2

    if [[ $minimal -gt $arg_count ]]; then
        raise_wrong_arguments_input \
            "The minimal arguments amount is ${minimal}."
    fi

}