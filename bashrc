# Terminal settings -----------------------------------------------------------
export PS1="[\t]:\w $ "

# Chromium settings -----------------------------------------------------------
CHROMIUM_ROOT=${HOME}/Desktop/chromium
WEBKIT_HOME=${CHROMIUM_ROOT}/src/third_party/WebKit
export PATH=$PATH:${CHROMIUM_ROOT}/depot_tools

GOMA_DIR=${HOME}/goma
GOMAJS=100 # How many j's to use for goma
USE_APIARY=1 # Set to 0 to disable goma's apiary access

if [ $USE_APIARY -eq 1 ]; then
	export GOMAMODE=apiary
    if [ ! -f ${HOME}/.goma_apiary_key ]; then
        echo "${HOME}/.goma_apiary_key not found, apiary access may not work."
    fi
fi

export GYP_GENERATORS=ninja
export GYP_DEFINES="clang=1 disable_nacl=1 use_goma=1 gomadir=${GOMA_DIR} component=shared_library"

# Run Tests {Debug, Release}
alias rtd='${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --debug -f --no-retry-failures'
alias rtr='${WEBKIT_HOME}/Tools/Scripts/run-webkit-tests --release -f --no-retry-failures'

# Build aliases: Build {Chrome, Tests} {Debug, Release}
alias bcd='time ninja -j ${GOMAJS} -C ${CHROME_ROOT}/src/out/Debug chrome'
alias bcr='time ninja -j ${GOMAJS} -C ${CHROME_ROOT}/src/out/Release chrome'
alias btd='time ninja -j ${GOMAJS} -C ${CHROME_ROOT}/src/out/Debug blink_tests'
alias btr='time ninja -j ${GOMAJS} -C ${CHROME_ROOT}/src/out/Release blink_tests'
alias ba='bcd && bcr && btd && btr' # Build all

# No-goma aliases
alias bcdng='GOMA_DISABLED=true bcd'
alias bcrng='GOMA_DISABLED=true bcr'
alias btdng='GOMA_DISABLED=true btd'
alias btrng='GOMA_DISABLED=true btr'
alias bang='GOMA_DISABLED=true ba' # Build all, no goma.

# Misc ------------------------------------------------------------------------
if [ $OSTYPE == "darwin14" ]; then
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
fi
alias gitundolastcommit='git reset --soft HEAD~1'
export SVN_EDITOR=vi