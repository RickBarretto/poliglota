#! /bin/bash

usage() {
    echo "templ command                                                       "
    echo "  poli templ [OPTIONS]... [SUBCOMMANDS]                             "
    echo
    echo "  SUBCOMMANDS                                                       "
    echo
    echo "    add                                                             "
    echo "      --templ <folder-path>       uses a custom template base       "
    echo "      --custom <file-path>        uses a custom script to run       "
    echo "                                  instead of this                   "
    echo
    echo "    rm                            removes a language's template     "
    echo "      --templ <folder-path>       uses a custom template folder     "
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
