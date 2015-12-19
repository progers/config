#!/bin/bash
#
# Install script for:
#    ~/bashrc which is run from .bashrc/.bash_profile
#        This preserves existing (e.g., set by corp policy) .bashrc/.bash_profile settings.
#    ~/.screenrc
#    ~/.vimrc

if [[ ! -f bashrc ]] ; then
    echo "bashrc not found. Run install.sh from the same directory as bashrc"
    exit
fi
if [[ ! -f screenrc ]] ; then
    echo "screenrc not found. Run install.sh from the same directory as screenrc"
    exit
fi
if [[ ! -f vimrc ]] ; then
    echo "vimrc not found. Run install.sh from the same directory as vimrc"
    exit
fi

INSTALL_CUSTOM_BASHRC=1
if [[ -f ${HOME}/bashrc ]] ; then
    DIFF=`diff -u ${HOME}/bashrc bashrc`
    if [[ !  -z  $DIFF  ]] ; then
        echo "{$DIFF}"
        read -p "Overwrite bashrc? y/n: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
            INSTALL_CUSTOM_BASHRC=0
        fi
    fi
fi
if [[ $INSTALL_CUSTOM_BASHRC -eq 1 ]] ; then
    echo "Updating ${HOME}/bashrc..."
    cp bashrc ${HOME}/bashrc

    DEFAULT_BASH_INIT="${HOME}/.bashrc"
    if [[ $OSTYPE == *"darwin"* ]] ; then
        DEFAULT_BASH_INIT="${HOME}/.bash_profile"
    fi
    SOURCE_LINE="if [[ -f ${HOME}/bashrc ]] ; then source ${HOME}/bashrc ; fi # Custom settings."
    if grep -Fq "${SOURCE_LINE}" ${DEFAULT_BASH_INIT} ; then
        echo "${HOME}/bashrc already run from ${DEFAULT_BASH_INIT}"
    else
        echo "Adding line to run ${HOME}/bashrc from ${DEFAULT_BASH_INIT}..."
        echo "${SOURCE_LINE}" >> ${DEFAULT_BASH_INIT}
    fi
fi

INSTALL_CUSTOM_SCREENRC=1
if [[ -f ${HOME}/.screenrc ]] ; then
    DIFF=`diff -u ${HOME}/.screenrc screenrc`
    if [[ !  -z  $DIFF  ]] ; then
        echo "{$DIFF}"
        read -p "Overwrite ~/.screenrc? y/n: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
            INSTALL_CUSTOM_SCREENRC=0
        fi
    fi
fi
if [[ $INSTALL_CUSTOM_SCREENRC -eq 1 ]] ; then
    echo "Updating ${HOME}/.screenrc..."
    cp screenrc ${HOME}/.screenrc
fi

INSTALL_CUSTOM_VIMRC=1
if [[ -f ${HOME}/.vimrc ]] ; then
    DIFF=`diff -u ${HOME}/.vimrc vimrc`
    if [[ !  -z  $DIFF  ]] ; then
        echo "{$DIFF}"
        read -p "Overwrite ~/.vimrc? y/n: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
            INSTALL_CUSTOM_VIMRC=0
        fi
    fi
fi
if [[ $INSTALL_CUSTOM_VIMRC -eq 1 ]] ; then
    echo "Updating ${HOME}/.vimrc..."
    cp vimrc ${HOME}/.vimrc
fi

echo "Done"
