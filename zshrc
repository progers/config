# My zsh configuration
#
# Installation: put in ~/.zshrc
#
# To make zsh the default shell, run: chsh -s /bin/zsh

# Terminal settings -----------------------------------------------------------
# Prompt, looks like: [time]:currentdirectory %
PROMPT='[%*]:%~ %# '

# Use a shared history file for all sessions, updated after every command
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt SHARE_HISTORY
# Extend history file and in-memory history size
SAVEHIST=10000
HISTSIZE=10000
# Use a more verbose history file
setopt EXTENDED_HISTORY
# Don't show duplicates when searching through history
setopt HIST_FIND_NO_DUPS


# Misc ------------------------------------------------------------------------
# Undo the last commit, "git undolastcommit"
git config --global --add alias.undolastcommit "reset --soft HEAD~1"

# List branches by date, "git bd"
git config --global --add alias.bd "! git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads | sed -e 's-refs/heads/--'"

# Prettier printing of git log, "git lol"
# Original author is Franz Bettag, http://uberblo.gs/2010/12/git-lol-the-other-git-log
git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# Chromium settings -----------------------------------------------------------
CHROMIUM_ROOT=${HOME}/Desktop/chromium
export PATH=$PATH:${CHROMIUM_ROOT}/depot_tools

# Runs a command with the macOS Crash Reporter temporarily disabled.
# Automatically and safely re-enables the reporter afterward, even if
# the command is interrupted (e.g., with Ctrl+C). This is an alternative
# to the `strip` command recommended in
# https://chromium.googlesource.com/chromium/src/+/HEAD/docs/testing/web_tests.md#initial-setup
# but, unlike `strip`, this retains debug symbols.
# Usage: no_crash_reporter <command_to_run>
no_crash_reporter() {
  # Requires the zsh/zutil module for the try...always block.
  zmodload zsh/zutil
  {
    if [[ $# -eq 0 ]]; then
      echo "Usage: no_crash_reporter <command_to_run ...>"
      return 1
    fi
    # Disable the crash reporter.
    defaults write com.apple.CrashReporter DialogType none || {
      echo "🚫 no_crash_reporter error: Could not disable crash reporter. Fix with:" >&2
      echo "  sudo chown \$(whoami) ~/Library/Preferences/com.apple.CrashReporter.plist" >&2
      echo "Continuing without disabling the crash reporter..."
    }
    # Execute the command passed to the function.
    "$@"
  } always {
    # This block is guaranteed to run, restoring the default setting.
    defaults delete com.apple.CrashReporter DialogType
  }
}

# Run Tests {Debug, Release}
alias rtd='no_crash_reporter ${CHROMIUM_ROOT}/src/third_party/blink/tools/run_web_tests.py --debug -f --no-retry-failures'
alias rtr='no_crash_reporter ${CHROMIUM_ROOT}/src/third_party/blink/tools/run_web_tests.py --release -f --no-retry-failures'

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

# Build aliases for offline
alias bcdo='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Debug chrome'
alias bcro='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Release chrome'
alias bcsdo='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Debug content_shell'
alias bcsro='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Release content_shell'
alias btdo='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Debug blink_tests cc_unittests'
alias btro='time autoninja --offline -C ${CHROMIUM_ROOT}/src/out/Release blink_tests cc_unittests'
alias bado='btdo && bcdo' # Build all debug
alias baro='btro && bcro' # Build all release
alias bao='bcdo && bcro && btdo && btro' # Build all
