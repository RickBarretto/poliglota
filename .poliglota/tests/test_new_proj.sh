#! /bin/bash

## These are unit tests for `poli proj new` command
## It tests flags, arguments and behavior

## NOTE: Run these test'll update your $LAST_PROJECT

## Every file here will outputs:
## A success message if everything is alright
## An error message if wrong

## Imports:
##  -- Variables --
##   $STD_CONFIG_PATH
##   $STD_POLI_PATH
##   $STD_REPO_PATH
##   $STD_TEMPL_PATH
##   $STD_PLUGINS_PATH
##   $LAST_PROJECT
##   $CURRENT_TEST
##   $PLEASE_DEBUG
##  -- Functions --
##   pass <message>
##   fail <message>
source ".poliglota/tests/utils.sh"

