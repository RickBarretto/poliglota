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

set -C # Prevent overwriting of files by redirection

# --- Global internal functions ---

description() {
    echo "  proj                          project related tasks               "
    echo "      new <project>           inits a new project with all        "
    echo "                                avaliable implementations           "
    echo "      add <impl> <project>      adds a particular implementation to "
    echo "                                an existing project                 "
}

usage() {
    echo "command proj                                                        "
    echo "poli proj [OPTIONS]... [SUBCOMMANDS]                                "
    echo
    echo "SUBCOMMANDS                                                         "
    echo
    echo "  new <project>                 inits a new project with all        "
    echo "                                avaliable implementations           "
    echo "    --custom|-c <script-path>   run with a custom script instead    "
    echo "    --empty|-e                  creates a empty project             "
    echo "    --repo|-r <folder>          modifies the output folder          "
    echo "    --templ|-t <folder>         modifies the template entry folder  "
    echo
    echo "  add <impl> <project>          adds a particular implementation to "
    echo "                                an existing project                 "
    echo "    --as|-a <new-impl-name>     adds the implementation with a      "
    echo "                                specific name.                      "
    echo "    --custom|-c <script-path>   run with a custom script instead    "
    echo "    --empty|-e                  creates an empty implementation     "
    echo "    --latest|-l                 uses the latest command's project as"
    echo "                                the current                         "
    echo "    --repo|-r <folder>          modifies the output folder          "
    echo "    --templ|-t <folder>         modifies the template entry folder  "
    echo
    echo "  fill <project>                fills the project with missing      "
    echo "                                implementations from a template     "
    echo "                                folder                              "
    echo "    --custom|-c <script-path>   run with a custom script instead    "
    echo "    --latest|-l                 uses the latest command's project as"
    echo "                                the current                         "
    echo "    --repo|-r <folder>          modifies the output folder          "
    echo "    --templ|-t <folder>         modifies the template entry folder  "
    echo
    echo "OPTIONS                                                             "
    echo "  --help|-h                     shows this help page                "
    echo "  --description                 shows a short description           "
}

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

    echo "Wrong input: ${wrong_input}"
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
            "The minimal arguments amout is ${minimal}."
    fi

}

## Saves the project on history
## Arguments:
##  $current_project: current project
## Globals:
##  $STD_CONFIG_PATH
## Returns
##  exit
save_and_exit() {

    local -r current_project="$1"
    local -r config_file="${STD_CONFIG_PATH}"

    sed --in-place --expression                                 \
        "s/last_project=.*/last_project=${current_project}/g"   \
        "${config_file}"
    exit

}

## Runs a custom script
## Command Arguments:
##   $script: path to the script file
## Arguments:
##   $@: arguments to parse
## Returns:
##  exit, if --script flag is defined
try_run_custom_script() {
    local -i found=0
    for arg in "$@"; do
        if [[ $found = 1 ]]; then
            "${arg}" "$@"
            exit
        elif [[ "${arg}" == "--custom" || "${arg}" == "-c" ]]; then
            local -r found=1
        fi
    done
}

## --- New internal functions ---

## Creates a new project based on a template
## Arguments:
##  $repository: repository's folder path
##  $project: name of the new project
##  $template: template's folder path
## Outputs:
##  prints an error message, if mkdir returns an error
## Returns:
##   save_and_exit
create_project_with_template() {

    local -r repository="$1"
    local -r project="$2"
    local -r template="$3"

    if mkdir "${repository}/${project}"; then
        cp "${template}"/* "${repository}/${project}/" \
            --recursive -b --no-preserve=timestamp
    else
        echo "${project} already exists"
    fi

    if [ -f "${repository}/${project}/.template" ]; then
        rm "${repository}/${project}/.template" \
            --force -recursive --dir
    fi

    save_and_exit "${project}"

}

## Creates an empty new project given a repository
## Arguments:
##  $repository: repository's folder path
##  $project: name of the new project
## Returns:
##  save_and_exit
create_empty_project() {

    local -r repository="$1"
    local -r project="$2"

    mkdir "${repository}/${project}"
    save_and_exit "${project}"

}

## [Command]: Creates a new project based on .templates/
## Command Arguments:
##   $project: name of the new project
## Command Options:
##  --custom|-c script-path
##  --empty|-e
##  --repo|-r folder
##  --templ|-t folder
## Arguments:
##   $@: arguments to parse
## Globals:
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
## Returns:
##  test_minimal_args
##  create_project_with_template
##  create_empty_project
##  exit
new_command() {

    assert_minimal_arguments "1" "$#"

    # local variables
    local project=""                ## Project's name
    local repo="${STD_REPO_PATH}"   ## Repository's folder path
    local templ="${STD_TEMPL_PATH}" ## Template's folder path
    local -i empty=0                   ## --empty

    try_run_custom_script "$@"

    while  [[ -n "$1" ]]; do
        case "$1" in
        "--custom" | "-c")
            shift
            ;;
        "--empty" | "-e")
            local -r empty=1
            ;;
        "--repo" | "-r")
            local -r repo="$2"
            shift
            ;;
        "--templ" | "-t")
            local -r templ="$2";
            shift
            ;;
        "-"*)
            raise_wrong_arguments_input "$1"
            ;;
        *)
            local -r project="$1"
            ;;
        esac
        shift
    done

    if [[ -n "${project}" ]]; then

        # Just creates a project
        if [[ $empty == 1 ]]; then
            create_empty_project                  \
                "${repo}" "${project}"
        else
            create_project_with_template          \
                "${repo}" "${project}" "${templ}"
        fi
    fi

    exit

}

## --- Add internal functions ---

## Creates a new project based on a template
## Arguments:
##  $repository: repository's folder path
##  $project: name of the new project
##  $template: template's folder path
##  $implementation: the folder path of implementation's template
##  $name: name to be saved
## Outputs:
##  prints an error message, if mkdir returns an error
## Returns:
##   save_and_exit
create_implementation_with_template() {

    local -r repository="$1"
    local -r project="$2"
    local -r template="$3"
    local -r implementation="$4"
    local -r name="$5"

    if mkdir "${repository}/${project}/${name}" ; then

        cp "${template}/${implementation}/"**  \
            "${repository}/${project}/${name}" \
            -r -b --no-preserve=timestamp

        save_and_exit "${project}"

    else
        echo "${name} already implemented"
    fi

}

## Creates an empty new project given a repository
## Arguments:
##  $repository: repository's folder path
##  $project: name of the new project
##  $name: implementation's name inside the project
## Returns:
##  exit
create_empty_implementation() {

    local -r repository="$1"
    local -r project="$2"
    local -r name="$3"

    mkdir "${repository}/${project}/${name}"
    save_and_exit "${project}"

}


## [Command]: Adds an implementation to given project
## Command Arguments:
##   $implementation: an existing implementation's name
##   $project: an existing project's name
## Command Options:
##  --custom|-c script_path
##  --empty|-e
##  --repo|-r folder
##  --templ|-t folder
## Arguments:
##   $@: arguments to parse
## Globals:
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
## Returns:
##  test_minimal_args
##  create_implementation_with_template
##  create_empty_implementation
##  exit
add_command() {

    assert_minimal_arguments "2" "$#"

    # local variables
    local implementation=""         ## The implementation to be used
    local name=""                   ## Implementation's name used in the project
    local project=""                ## Project's name
    local repo="${STD_REPO_PATH}"   ## Repository's folder path
    local templ="${STD_TEMPL_PATH}" ## Template's folder path
    local -i empty=0                ## --empty
    local -i latest=0               ## --latest

    try_run_custom_script "$@"

    # --latest has first-class importance, changing the behavior
    # so, it must to be declared here
    for arg in "$@"; do
        if [[ "${arg}" == "--latest" || "${arg}" == "-l" ]]; then
            local -r latest=1
        fi
    done

    while  [[ -n "$1" ]]; do
        case "$1" in
        "--custom" | "-c")
            shift
            ;;
        "--as" | "-a")
            local -r name="$2"
            shift
            ;;
        "--empty" | "-e")
            local -r empty=1
            ;;
        "--repo" | "-r")
            local -r repo="$2"
            shift
            ;;
        "--templ" | "-t")
            local -r templ="$2"
            shift
            ;;
        "--latest" | "-l")
            ;;
        "-"*)
            raise_wrong_arguments_input "$1" # badargs, exits
            ;;
        *)
            if [[ $latest == 0 ]]; then
                local -r implementation="$1"
                local -r project="$2"
                shift
            else
                local -r implementation="$1"
                local -r project="${LAST_PROJECT}"
            fi
            ;;
        esac
        shift
    done

    if [[ -n "${implementation}" && -n "${project}" ]]; then

        # Defines $name
        if [[ -z "${name}" ]]; then
            local name="${implementation}"
        fi

        if [[ $empty == 1 ]]; then
            create_empty_implementation \
                "${repo}" "${project}" "${name}"
        else
            create_implementation_with_template \
                "${repo}" "${project}" "${templ}" "${implementation}" "${name}"
        fi
    fi

}

## [Script] Parses the arguments and calls the right commands
## Script Commands:
##   new
##   add
## Script Options:
##  --help
##  --description
## Arguments:
##   $@: arguments to parse
## Returns:
##  test_minimal_args
##  create_implementation_with_template
##  create_empty_implementation
##  raise_wrong_arguments_input, for wrong arguments
main() {

    assert_minimal_arguments "1" "$#"

    case "$1" in
    "--description")
        description
        ;;
    "--help" | "-h")
        usage
        ;;
    "new")
        shift
        new_command "$@"
        ;;
    "add")
        shift
        add_command "$@"
        ;;
    *)
        raise_wrong_arguments_input "$1"
        ;;
    esac

    exit

}

main "$@"
