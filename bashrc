# My Bash configuration
#
# Installation:
# Linux   put in ~/.bash_aliases
#         Ensure the following is in ~/.bashrc:
#         if [ -f ~/.bash_aliases ]; then
#           . ~/.bash_aliases
#         fi
# MacOS   put in ~/.bash_profile
# Windows put in ~/.bashrc


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


# Make subl an alias of sublime on MacOS  
if [[ $OSTYPE == *"darwin"* ]]; then  
    alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'  
fi

# Chromium settings -----------------------------------------------------------
CHROMIUM_ROOT=${HOME}/Desktop/chromium
if [[ ! -d ${CHROMIUM_ROOT} ]] ; then
    CHROMIUM_ROOT=/ssd/chromium
    if [[ ! -d ${CHROMIUM_ROOT} ]] ; then
        CHROMIUM_ROOT=/c/src/chromium
        if [[ ! -d ${CHROMIUM_ROOT} ]] ; then
            echo "CHROMIUM_ROOT not found, you need to update ~/bashrc"
        fi
    fi
fi
export PATH=$PATH:${CHROMIUM_ROOT}/depot_tools

# GOMA settings for cloud compiler
if [[ ! -x "$(command -v goma_ctl)" ]] ; then
    echo "goma_ctl not found, goma may not work."
fi
alias restartgoma="goma_ctl restart"

# Run Tests {Debug, Release}
alias rtd='${CHROMIUM_ROOT}/src/third_party/blink/tools/run_web_tests.py --debug -f'
alias rtr='${CHROMIUM_ROOT}/src/third_party/blink/tools/run_web_tests.py --release -f'

# Build aliases: Build {chromium, content_shell, blink_unit_tests, all tests} {Debug, Release}
# All tests (target blink_tests) includes content_shell and blink_unittests (see: src/BUILD.gn)
alias bcd='time autoninja -C ${CHROMIUM_ROOT}/src/out/Debug chrome'
alias bcr='time autoninja -C ${CHROMIUM_ROOT}/src/out/Release chrome'
alias bcsd='time autoninja -C ${CHROMIUM_ROOT}/src/out/Debug content_shell'
alias bcsr='time autoninja -C ${CHROMIUM_ROOT}/src/out/Release content_shell'
alias btd='time autoninja -C ${CHROMIUM_ROOT}/src/out/Debug blink_tests cc_unittests'
alias btr='time autoninja -C ${CHROMIUM_ROOT}/src/out/Release blink_tests cc_unittests'
alias bad='btd && bcd' # Build all debug
alias bar='btr && bcr' # Build all release
alias ba='bcd && bcr && btd && btr' # Build all

# Build aliases without goma
alias bcdng='GOMA_DISABLED=true bcd'
alias bcrng='GOMA_DISABLED=true bcr'
alias bcsdng='GOMA_DISABLED=true bcsd'
alias bcsrng='GOMA_DISABLED=true bcsr'
alias btdng='GOMA_DISABLED=true btd'
alias btrng='GOMA_DISABLED=true btr'
alias badng='btdng && bcdng' # Build all debug, no goma
alias barng='btrng && bcrng' # Build all release, no goma
alias bang='GOMA_DISABLED=true ba' # Build all, no goma
