#! /bin/bash

## Configuration

## Imports:
##  $STD_CONFIG_PATH
##  $STD_POLI_PATH
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
##  $STD_PLUGINS_PATH
##  $LAST_PROJECT
# shellcheck source=poli.config
source "poli.config"

## Imports:
##   raise_wrong_arguments_input <wrong_input>
##   assert_minimal_arguments <minimal> <arg_count>
# shellcheck source=.poliglota/scripts/utils.sh
source "${STD_POLI_PATH}/scripts/utils.sh"

## Imports:
##   raise_wrong_arguments_input <wrong_input>
##   assert_minimal_arguments <minimal> <arg_count>
# shellcheck source=.poliglota/scripts/utils.sh
source "${STD_POLI_PATH}/scripts/utils.sh"

set -o noclobber # Prevent overwriting of files by redirection

# --- Global internal functions ---

description() {
    echo "  archive <project> <group>     archives a project                  "
}

usage() {
    echo "command archive                                                     "
    echo "poli archive [OPTIONS]... <project> <group>                         "
    echo "                                archives a project                  "
    echo
    echo "OPTIONS                                                             "
    echo "  --help|-h                     shows this help page                "
    echo "  --description                 shows a short description           "
}


# --- Script functions ---

## [Script] Archives a project into a group
## Script Arguments:
##   <project>
##   <group>
## Script Options:
##  --help
##  --description
## Arguments:
##   $@: arguments to parse
## Returns:
##  assert_minimal_arguments
##  exit
##  raise_wrong_arguments_input, for wrong arguments
main() {

    assert_minimal_arguments "1" "$#"

    local project=""
    local group=""

    while  [[ -n "$1" ]]; do
        case "$1" in
        "--description")
            description
            exit
            ;;
        "--help" | "-h")
            usage
            exit
            ;;
        "-"*)
            raise_wrong_arguments_input "$1"
            ;;
        *)
            local project="$1"
            local group="$2"
            shift 2
            ;;
        esac
    done

    if [[ ! -d "${archive_PATH:?}" ]]; then
        mkdir "${archive_PATH:?}/"
    fi

    if [[ ! -d "${archive_PATH:?}/${group}" ]]; then
        mkdir "${archive_PATH:?}/${group:?}"
        mkdir "${archive_PATH:?}/${group:?}/${project:?}"
    fi

    mv -b                                           \
        "${STD_REPO_PATH:?}/${project:?}"           \
        "${archive_PATH:?}/${group:?}/${project:?}"


}

main "$@"
