# -- Cleanup functions

## Exports:
## cleanup_directory $directory
## cleanup_project   $repository $project
## cleanup_template  $template   $implementation

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
    rm --recursive "${repository:?}/${project:?}" ||
        ( echo "Couldn't cleanup project"           \
            >> /dev/stderr                          \
            && raise_cannot_execute )
}


## Cleanup created project
## Arguments:
##   $template
##   $implementation
## Output:
##  outputs to stderr if cleanup fails
## Return:
##  raise_cannot_execute if cleanup fails
cleanup_template() {
    local -r template="$1"
    local -r implementation="$2"
    cleanup_project "${template}" "${implementation}"
}