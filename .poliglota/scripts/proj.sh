#! /bin/bash

## Configuration
set -C          # Prevent overwriting of files by redirection

E_BADARGS=85    ## Bad Arguments error value

# Internal functions ---

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
    echo "    --repo|-r <folder>          modifies the output folder          "
    echo "    --templ|-t <folder>         modifies the template entry folder  "
    echo
    echo "OPTIONS                                                             "
    echo "  --help|-h                     shows this help page                "
}


## Saves the project on history
## $1: <project> -> the latest project used
save_history() {
    local config_file=.poliglota/config/history.config
    sed -i -e "s/last_project=.*/last_project=$1/g" $config_file
}


## Creates a new project base on .templates/
## $1: <project> -> the new project name
## --custom|-c <script-path>
## --empty|-e
## --repo|-o|-r <folder>
## --templ|-t <folder>
new_project() {

    if [[ -z "$1" ]]; then
        echo "Wrong Parameters"
        usage
        exit $E_BADARGS
    fi

    # local variables
    local project=""         ## Project name
    local custom=""          ## Custom script path
    local empty=0            ## Sets if the implementation'll be empty
    local repo="repository"  ## Repository's folder path
    local templ=".templates" ## Template's folder path

    while  [[ -n "$1" ]]; do
        case $1 in
            "--custom" | "-c")
                shift; ./$1 $@
                exit;;
            "--empty" | "-e")
                local empty=1
                shift;;
            "--repo" | "-r")
                local repo="$2"
                shift 2;;
            "--templ" | "-t")
                local templ="$2";
                shift 2;;
            *)
                local project="$1"
                shift;;
        esac
    done

    if [[ -n "$project" ]]; then

        # Just creates a project
        if [[ $empty == 1 ]]; then
            mkdir $repo/$project
            save_history $project
            exit

        # Creates the project based on a template
        else
            if mkdir $repo/$project; then
                cp ./$templ/* $repo/$project/ \
                    -r -b --no-preserve=timestamp

                if [[ "$templ" == ".templates" ]]; then
                    rm rm -R --force $repo/$project/.template/**
                fi
            else echo "This Project already exists"
            fi;

            save_history $project
            exit

        fi
    fi
    exit

}

## Adds an implementation to given project
## $1: <implementation> -> the name of a existing implementation
## $2: <project>  -> the name of existing project
## --as <new-name>
## --custom|-c <script-path>
## --empty|-e
## --repo|-o|-r <folder>
## --templ|-t <folder>
add_implementation() {

    # Param checker
    if [[ ! -n "$2" ]]; then
        echo "Wrong Parameters"
        usage
        exit $E_BADARGS
    fi

    # local variables
    source .poliglota/config/history.config # imports $last_project
    local implementation=""  ## The implementation to be used
    local name=""            ## Implementation's name used in the project
    local project=""         ## Project's name
    local repo="repository"  ## Repository's folder path
    local templ=".templates" ## Template's folder path
    local empty=0            ## Sets if the implementation'll be empty
    local latest=0           ## Sets if the latest project'll be the current

    while  [[ -n "$1" ]]; do
        case $1 in
            "--custom" | "-c")
                shift; ./$1 $@
                exit;;

            "--as" | "-a")
                shift; local name="$1";
                shift;;

            "--empty" | "-e")
                local empty=1
                shift;;

            "--repo" | "-r")
                shift; local repo="$1"
                shift;;

            "--templ" | "-t")
                shift; local templ="$1";
                shift;;

            *)
                local implementation="$1"
                local project="$2"
                shift 2;;
        esac
    done

    if [[ -n "$implementation" && -n "$project" ]]; then

        # Defines $name
        if [[ -z "$name" ]]; then
            local name="$implementation"
        fi

        # Just creates a project
        if [[ $empty == 1 ]]; then
            mkdir $repo/$project/$name
            save_history $project
            exit

        # Creates the project based on a implementation's template
        else
            if mkdir $repo/$project/$name ; then
                cp $templ/$implementation/** $repo/$project/$name \
                    -r -b --no-preserve=timestamp
                save_history $project
            fi
            exit
        fi
    fi; exit

}

# Code execution
if [[ "$1" == "--description" ]]; then
    description
    exit
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit
fi

if [[ ! -n "$1" ]]; then
    echo "Wrong Parameters"
    usage
    exit $E_BADARGS
fi

case $1 in
    new)
        shift;
        new_project $@
        exit;;
    add)
        shift;
        add_implementation $@
        exit;;
    *)
        echo "Wrong command"
        usage
        exit $E_BADARGS
    ;;
esac