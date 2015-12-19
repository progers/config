# Terminal settings -----------------------------------------------------------
# Prompt, looks like: [time]:currentdirectory $ 
export PS1="[\t]:\w $ "

# No duplicate entries in history
export HISTCONTROL=ignoredups:erasedups

export SVN_EDITOR=vi
export EDITOR=vi

# Chromium settings -----------------------------------------------------------
CHROMIUM_ROOT=${HOME}/Desktop/chromium
if [ ! -d ${CHROMIUM_ROOT} ]; then
    CHROMIUM_ROOT=/ssd/chromium
    if [ ! -d ${CHROMIUM_ROOT} ]; then
        echo "CHROMIUM_ROOT not found, you need to update ~/custom.bashrc"
    fi
fi
WEBKIT_HOME=${CHROMIUM_ROOT}/src/third_party/WebKit
export PATH=$PATH:${CHROMIUM_ROOT}/depot_tools

# GOMA settings for cloud compiler
GOMA_DIR=${HOME}/goma
if [ ! -d ${GOMA_DIR} ]; then
    echo "GOMA_DIR not found, goma may not work."
fi
alias restartgoma="${GOMA_DIR}/goma_ctl.py restart"
GOMAJS=220 # How many j's to use for goma
USE_APIARY=1 # Set to 0 to disable goma's apiary access
if [ $USE_APIARY -eq 1 ]; then
    export GOMAMODE=apiary
    if [ ! -f ${HOME}/.goma_apiary_key ]; then
        echo "${HOME}/.goma_apiary_key not found, apiary access may not work."
    fi
fi

# Display settings for running tests in a terminal
USE_FAKE_DISPLAY=0 # Set to 1 to use a fake x environment to run tests without a display.
CUSTOM_DISPLAY=""
alias fakex="nohup Xvfb :4 -screen 0 1024x768x24 > /dev/null 2>&1 &"
if [ $USE_FAKE_DISPLAY -eq 1 ]; then
    fakex
    CUSTOM_DISPLAY="DISPLAY=:4"
fi

export GYP_GENERATORS=ninja
export GYP_DEFINES="clang=1 disable_nacl=1 use_goma=1 gomadir=${GOMA_DIR} component=shared_library proprietary_codecs=1 ffmpeg_branding=Chrome"

# Run Tests {Debug, Release}
alias rtd='${CUSTOM_DISPLAY} ${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --debug -f --no-retry-failures'
alias rtr='${CUSTOM_DISPLAY} ${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --release -f --no-retry-failures'

# Build aliases: Build {chromium, tests} {Debug, Release}
alias bcd='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Debug chrome'
alias bcr='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Release chrome'
alias btd='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Debug blink_tests cc_unittests'
alias btr='time ninja -j ${GOMAJS} -C ${CHROMIUM_ROOT}/src/out/Release blink_tests cc_unittests'
alias ba='bcd && bcr && btd && btr' # Build all

# No-goma aliases
alias bcdng='GOMA_DISABLED=true bcd'
alias bcrng='GOMA_DISABLED=true bcr'
alias btdng='GOMA_DISABLED=true btd'
alias btrng='GOMA_DISABLED=true btr'
alias bang='GOMA_DISABLED=true ba' # Build all, no goma.

# Misc ------------------------------------------------------------------------
# Make subl an alias of sublime on OSX
if [[ $OSTYPE == *"darwin"* ]]; then
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
fi
alias gitundolastcommit='git reset --soft HEAD~1'