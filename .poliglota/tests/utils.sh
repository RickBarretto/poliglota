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

## Imports:
## >> Functions
##  cleanup_directory $directory
##  cleanup_project   $repository $project
##  cleanup_template  $template   $implementation
source "${STD_POLI_PATH}/tests/cleanuppers.sh"

## Imports:
## generate_project $@
## generate_template $template_folder $implementation
source "${STD_POLI_PATH}/tests/generators.sh"

## Imports:
##  assert_are_equals <dir1> <dir2> <flags>
##  assert_dir_exists <directory> <flags>
##  fail <message>
##  pass <message>
##  raise_cannot_execute
source "${STD_POLI_PATH}/tests/assertions.sh"

## >> Variable
## This is the current test that is running
CURRENT_TEST=""

## >> Constant
## String used to be printed in fail(),
## case the command returned an error
declare -r PLEASE_DEBUG="Command returned an error.
Please run with set -x. And read ${STD_POLI_PATH}/error.txt"

# --- Global functions to be exported ---

## Prints an init messaga
## Arguments:
##  $file
echo_init_tests() {
    # -- Arguments
    local -r file="$1"

    # -- Colors
    local -r RESET='\033[0m'
    local -r CYAN='\033[0;36m'
    local -r CYAN_BG='\033[46m'
    local -r CYAN_UNDERLINE='\033[4;36m'

    # -- To print
    local -r status="${CYAN_BG}[RUNNING]${RESET}"
    local -r title="${CYAN_UNDERLINE}${file}${RESET}"
    local -r divisor="${CYAN}:${RESET}"

    echo -e "\n${status} ${title}${divisor}"

}
