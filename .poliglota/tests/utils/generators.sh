# -- Generation functions

## Exports:
## generate_project $@
## generate_template $template_folder $implementation

## Creates a new empty project based on proj new command
## Arguments:
##  $@
## Output:
##  prints only errors
## Returns:
##  raise_cannot_execute
generate_project() {
    ./poli proj new "$@" "--empty"  \
        1> /dev/null                \
        2> /dev/stderr              \
    || raise_cannot_execute
}


# TODO: replace by the real template command
#   It should run with `templ new ...`
## Creates a new empty project based on `proj new` command
## Arguments:
##  ~~$@~~ (on a future implementation)
##  $template_folder
##  $implementation
## Output:
##  prints just errors
## Returns:
##  raise_cannot_execute
generate_template() {
    # .poli templ new "$@"    \
    # 1> /dev/null            \
    # 2> /dev/stderr          \
    # || raise_cannot_execute

    local -r template_folder="$1"
    local -r implementation="$2"

    mkdir "${template_folder}/${implementation}" ||
        ( echo "Couldn't create directory"              \
            >> /dev/stderr                              \
            && raise_cannot_execute )

    cp -r -b --no-preserve=timestamp                    \
            "${template_folder}/.template/"**           \
            "${template_folder}/${implementation}/" ||
        ( echo "Couldn't copy base template"            \
            >> /dev/stderr                              \
            && raise_cannot_execute )

}