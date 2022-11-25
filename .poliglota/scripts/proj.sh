#! /bin/bash

## Configuration

## Imports:
##  $STD_CONFIG_PATH
##  $STD_POLI_PATH
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
##  $STD_PLUGINS_PATH
##  $LAST_PROJECT
source poli.config

set -C # Prevent overwriting of files by redirection

# --- Global internal functions ---

description() {
    echo "  proj                          project related tasks               "
    echo "      new <proj-name>           inits a new project with all        "
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
    echo "  new <proj-name>               inits a new project with all        "
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
    echo "OPTIONS                                                             "
    echo "  --help|-h                     shows this help page                "
}

## Sets the minimal arguments required by a command
## Arguments:
##  $minimal: minimal arguments to be able run
##  $arg_count: current arguments count
## Output:
##  Prints an error message and the usage
## Returns:
##  exit
test_minimal_args() {

    local -r -i minimal=$1
    local -r -i arg_count=$2
    local -r E_BADARGS=85 ## Bad Arguments error value

    if [[ $minimal -gt $arg_count ]]; then
        echo "Wrong: the minimal arguments amout is ${minimal}."
        description
        echo
        echo "Type './poli proj --help' for more information."
        exit $E_BADARGS
    fi

}

## Saves the project on history
## Arguments:
##  $current_project: current project
## Globals:
##  $STD_CONFIG_PATH
save_history() {

    local -r current_project="$1"
    local -r config_file="${STD_CONFIG_PATH}"

    sed --in-place --expression                                 \
        "s/last_project=.*/last_project=${current_project}/g"   \
        "${config_file}"

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
##   exit
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

    save_history "${project}"
    exit

}

## Creates an empty new project given a repository
## Arguments:
##  $repository: repository's folder path
##  $project: name of the new project
## Returns:
##  exit
create_empty_project() {

    local -r repository="$1"
    local -r project="$2"

    mkdir "${repository}/${project}"

    save_history "${project}"
    exit

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

    test_minimal_args "1" "$#"

    # local variables
    local project=""                ## Project's name
    local custom=""                 ## --custom script file path
    local repo="${STD_REPO_PATH}"   ## Repository's folder path
    local templ="${STD_TEMPL_PATH}" ## Template's folder path
    local -i empty=0                   ## --empty

    while  [[ -n "$1" ]]; do
        case "$1" in
            "--custom" | "-c")
                shift;
                ./$1 $@
                exit
                ;;
            "--empty" | "-e")
                local empty=1
                shift
                ;;
            "--repo" | "-r")
                local repo="$2"
                shift 2
                ;;
            "--templ" | "-t")
                local templ="$2";
                shift 2
                ;;
            *)
                local project="$1"
                shift
                ;;
        esac
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
##   exit
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

        save_history "${project}"
        exit

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

    save_history "${project}"
    exit

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

    test_minimal_args "2" "$#"

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
    for arg in $@; do
        if [[ "${arg}" == "--latest" || "${arg}" == "-l" ]]; then
            local -r latest=1
        fi
    done

    while  [[ -n "$1" ]]; do
        case "$1" in
            "--custom" | "-c")
                shift
                ./$1 $@
                exit
                ;;
            "--as" | "-a")
                shift
                local -r name="$1"
                shift
                ;;
            "--empty" | "-e")
                local -r empty=1
                shift 2
                ;;
            "--repo" | "-r")
                shift
                local -r repo="$2"
                shift 2
                ;;
            "--templ" | "-t")
                local -r templ="$2"
                shift 2
                ;;
            "--latest" | "-l")
                shift
                ;;
            *)
                if [[ $latest == 0 ]]; then
                    local -r implementation="$1"
                    local -r project="$2"
                    shift 2
                else
                    local -r implementation="$1"
                    local -r project="${last_project}"
                    shift
                fi
                ;;
        esac
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

# Code execution
test_minimal_args "1" "$#"

if [[ "$1" == "--description" ]]; then
    description
    exit
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit
fi

case "$1" in
    "new")
        shift;
        new_command $@
        exit;;
    "add")
        shift;
        add_command $@
        exit;;
    *)
        echo "Wrong command"
        usage
        exit $E_BADARGS
    ;;
esac