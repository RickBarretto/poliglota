#! /bin/bash

description() {
    echo "templ                                                               "
    echo "    add                           creates a new template            "
    echo "    rm                            removes an exiting template       "
}


usage() {
    echo "templ command                                                       "
    echo "  poli templ [OPTIONS]... [SUBCOMMANDS]                             "
    echo
    echo "  SUBCOMMANDS                                                       "
    echo
    echo "    add <new-template>            creates a new template            "
    echo "      --from|-f <template2>       uses an existing template as base "
    echo
    echo "    rm <template>                 removes an exiting template       "
    echo
    echo "  OPTIONS                                                           "
    echo "    --help|-h                     shows this help page              "
}

## $1: the new template name
##
add_template() {
    mkdir .templates/$1
    cp -r -b --no-preserve=timestamp            \
        .templates/.template/** .templates/$1/
}
