#!/bin/bash

# Install script for:
#    custom .bashrc/.bash_profile
#    custom .screenrc
#    custom .vimrc

if [ ! -f custom.bashrc ] ; then
    echo "custom.bashrc not found. Run install.sh from the same directory as custom.bashrc"
    exit
fi

INSTALL_CUSTOM_BASHRC=1
if [ -f ${HOME}/custom.bashrc ] ; then
    DIFF=`diff -u ${HOME}/custom.bashrc custom.bashrc`
    if [[ !  -z  $DIFF  ]] ; then
        echo "{$DIFF}"
        read -p "Overwrite custom.bashrc? y/n: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
            INSTALL_CUSTOM_BASHRC=0
        fi
    fi
fi

if [ $INSTALL_CUSTOM_BASHRC -eq 1 ] ; then
    echo "Updating ${HOME}/custom.bashrc..."
    cp custom.bashrc ${HOME}/custom.bashrc

    DEFAULT_BASH_INIT="${HOME}/.bashrc"
    if [[ $OSTYPE == *"darwin"* ]] ; then
        DEFAULT_BASH_INIT="${HOME}/.bash_profile"
    fi
    SOURCE_LINE="if [ -f ${HOME}/custom.bashrc ] ; then source ${HOME}/custom.bashrc ; fi # Pull in custom bash settings."
    if grep -Fq "${SOURCE_LINE}" ${DEFAULT_BASH_INIT} ; then
        echo "custom.bashrc already hooked in ${DEFAULT_BASH_INIT}"
    else
        echo "Adding hook to pull in custom.bashrc from ${DEFAULT_BASH_INIT}..."
        echo "${SOURCE_LINE}" >> ${DEFAULT_BASH_INIT}
    fi
fi

echo "Done"
