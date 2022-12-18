# -- Cleanup functions

## Exports:
## cleanup_directory $directory

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
