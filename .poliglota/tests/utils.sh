## Utils functions and variables to be used
## by every test function inside this folder

# Use source ".poliglota/tests/utils.sh"

# --- Global variables to be exported ---

## Imports:
## >> Constants
##  $STD_CONFIG_PATH
##  $STD_POLI_PATH
##  $STD_REPO_PATH
##  $STD_TEMPL_PATH
##  $STD_PLUGINS_PATH
## >> Variables
##  $LAST_PROJECT
# shellcheck source=poli.config
source "poli.config"

## >> Variable
## This is the current test that is running
CURRENT_TEST=""


## >> Constant
## String used to be printed in fail(),
## case the command returned an error
declare -r PLEASE_DEBUG="Command returned an error.
Please run with set -x. And read ${STD_POLI_PATH}/error.txt"

