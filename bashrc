# Terminal settings -----------------------------------------------------------
# Prompt, looks like: [time]:currentdirectory $ 
export PS1="[\t]:\w $ "

# No duplicate entries in history
export HISTCONTROL=ignoredups:erasedups

export SVN_EDITOR=vi
export EDITOR=vi


# Misc ------------------------------------------------------------------------

# Undo the last commit, "git undolastcommit"
git config --global --add alias.undolastcommit "reset --soft HEAD~1"

# List branches by date, "git bd"
git config --global --add alias.bd "! git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads | sed -e 's-refs/heads/--'"

# Prettier printing of git log, "git lol"
# Original author is Franz Bettag, http://uberblo.gs/2010/12/git-lol-the-other-git-log
git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# Make subl an alias of sublime on OSX
if [[ $OSTYPE == *"darwin"* ]]; then
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
fi


# Chromium settings -----------------------------------------------------------
CHROMIUM_ROOT=${HOME}/Desktop/chromium
if [[ ! -d ${CHROMIUM_ROOT} ]] ; then
    CHROMIUM_ROOT=/ssd/chromium
    if [[ ! -d ${CHROMIUM_ROOT} ]] ; then
        echo "CHROMIUM_ROOT not found, you need to update ~/bashrc"
    fi
fi
WEBKIT_HOME=${CHROMIUM_ROOT}/src/third_party/WebKit
export PATH=$PATH:${CHROMIUM_ROOT}/depot_tools

# GOMA settings for cloud compiler
GOMA_DIR=${HOME}/goma
if [[ ! -d ${GOMA_DIR} ]] ; then
    echo "GOMA_DIR not found, goma may not work."
fi
alias restartgoma="${GOMA_DIR}/goma_ctl.py restart"

GOMAJS=220 # How many j's to use for goma

# Use OAUTH for GOMA
export GOMA_OAUTH2_CONFIG_FILE=$HOME/.goma_oauth2_config

# Display settings for running tests in a terminal
USE_FAKE_DISPLAY=0 # Set to 1 to use a fake x environment to run tests without a display.
CUSTOM_DISPLAY=""
alias fakex="nohup Xvfb :4 -screen 0 1024x768x24 > /dev/null 2>&1 &"
if [[ $USE_FAKE_DISPLAY -eq 1 ]] ; then
    fakex
    CUSTOM_DISPLAY="DISPLAY=:4"
fi

# Run Tests {Debug, Release}
alias rtd='${CUSTOM_DISPLAY} ${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --debug -f'
alias rtr='${CUSTOM_DISPLAY} ${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --release -f'

# Build aliases: Build {chromium, tests} {Debug, Release}
alias bcd='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Debug chrome'
alias bcr='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Release chrome'
alias btd='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Debug blink_tests cc_unittests'
alias btr='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Release blink_tests cc_unittests'
alias bad='btd && bcd' # Build all debug
alias bar='btr && bcr' # Build all release
alias ba='bcd && bcr && btd && btr' # Build all

# Build alias for an official build.
alias bco='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Official chrome'

# Build aliases without goma
alias bcdng='GOMA_DISABLED=true bcd'
alias bcrng='GOMA_DISABLED=true bcr'
alias btdng='GOMA_DISABLED=true btd'
alias btrng='GOMA_DISABLED=true btr'
alias badng='btdng && bcdng' # Build all debug, no goma
alias barng='btrng && bcrng' # Build all release, no goma
alias bang='GOMA_DISABLED=true ba' # Build all, no goma
