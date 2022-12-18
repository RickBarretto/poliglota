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

set -o noclobber # Prevent overwriting of files by redirection

# --- Global internal functions ---

description() {
    echo "  proj                          project related tasks               "
    echo "      new <project>             inits a new project with all        "
    echo "                                avaliable implementations           "
    echo "      add <impl> <project>      adds a particular implementation to "
    echo "                                an existing project                 "
    echo "      fill <project>            fills the project with missing      "
    echo "                                implementations from a template     "
    echo "                                folder                              "
}

usage() {
    echo "command proj                                                        "
    echo "poli proj [OPTIONS]... [SUBCOMMANDS]                                "
    echo
    echo "SUBCOMMANDS                                                         "
    echo
    echo "  new <project>                 inits a new project with all        "
    echo "                                avaliable implementations           "
    echo "    --empty|-e                  creates a empty project             "
    echo
    echo "  add <impl> <project>          adds a particular implementation to "
    echo "                                an existing project                 "
    echo "    --as|-a <new-impl-name>     adds the implementation with a      "
    echo "                                specific name.                      "
    echo "    --empty|-e                  creates an empty implementation     "
    echo "    --latest|-l                 uses the latest command's project as"
    echo "                                the current                         "
    echo
    echo "  fill <project>                fills the project with missing      "
    echo "                                implementations from a template     "
    echo "                                folder                              "
    echo
    echo "OPTIONS                                                             "
    echo "  --help|-h                     shows this help page                "
    echo "  --description                 shows a short description           "
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

    echo "Saving... ${current_project} on ${STD_CONFIG_PATH}"

    sed --in-place --expression                                 \
        "s/LAST_PROJECT=.*/LAST_PROJECT=${current_project}/g"   \
        "${config_file}"
    exit

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
        set +o noclobber
        echo "${project} already exists" >>/dev/stderr # > stderr
        exit
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
##  --empty|-e
## Arguments:
##   $@: arguments to parse
## Globals:
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
## Returns:
##  test_minimal_args
##  try_run_custom_script
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

    while  [[ -n "$1" ]]; do
        case "$1" in
        "--empty" | "-e")
            local -r empty=1
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
        set +o noclobber
        echo "${name} already implemented" >>/dev/stderr # > stderr
        exit
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
##  --empty|-e
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

    # --latest has first-class importance, changing the behavior
    # so, it must to be declared here
    for arg in "$@"; do
        if [[ "${arg}" == "--latest" || "${arg}" == "-l" ]]; then
            local -r latest=1
        fi
    done

    while  [[ -n "$1" ]]; do
        case "$1" in
        "--as" | "-a")
            local -r name="$2"
            shift
            ;;
        "--empty" | "-e")
            local -r empty=1
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

# --- Fill internal functions ---

## Creates an empty new project given a repository
## Arguments:
##  $template: templates' path
##  $repository_path: repository's folder path
##  $project_name: name of the new project
##  $name: implementation's name inside the project
## Returns:
##  save_and_exit
fill_project() {
    local -r template="$1"
    local -r repository_path="$2"
    local -r project_name="$3"
    local -r project="${repository_path}/${project_name}"

    cp  "${template}/"** "${project}"       \
        --recursive --no-preserve=timestamp \
        --no-clobber # prevents overwrite

    save_and_exit "${project_name}"

}

## [Command]: Fills an existing project with missing implementations
## Command Arguments:
##   $project: name of the new project
## Arguments:
##   $@: arguments to parse
## Globals:
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
## Returns:
##  test_minimal_args
##  fill_project
##  exit
fill_command() {

    assert_minimal_arguments "1" "$#"

    local project=""                ## Project's name
    local repo="${STD_REPO_PATH}"   ## Repository's folder path
    local templ="${STD_TEMPL_PATH}" ## Template's folder path


    while [[ -n "$1" ]]; do
        case "$1" in
        "-"*)
            raise_wrong_arguments_input "$1"
            ;;
        *)
            local -r project="$1"
        esac
        shift
    done

    if [[ -n "${project}" ]]; then
        fill_project "$templ" "$repo" "$project"
    fi

    exit

}

# --- Script functions ---

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
    "fill")
        shift
        fill_command "$@"
        ;;
    *)
        raise_wrong_arguments_input "$1"
        ;;
    esac

    exit

}

main "$@"
