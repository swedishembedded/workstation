export LD_LIBRARY_PATH=/usr/local/lib
export EDITOR=nvim
export PS1="\u \w > "
. /etc/bash_completion

# added by travis gem
[ -f /home/martin/.travis/travis.sh ] && source /home/martin/.travis/travis.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias ls="ls -F --color=auto --group-directories-first -v"
alias git-emails="git shortlog --summary --numbered --email"
alias ll="ls -lh"
alias llt="ls --human-readable --size -l -S --classify"
alias lt="du -sh * | sort -h"
alias cpv='rsync -ah --info=progress2'
alias tcn='mv --force -t ~/.local/share/Trash '
alias cg='cd `git rev-parse --show-toplevel`'
alias gitk-local="gitk --argscmd='git rev-list --no-walk --branches --tags'"
alias pygdb="gdb-multiarch -x ~/.pygdbinit"

PATH=$PATH:/opt/microchip/xc16/v1.36/bin:/opt/microchip/xc32/v2.15/bin/
export PATH=~/.local/bin:"$PATH"

function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

function drun() {
	if [[ ! -d $PWD/../.west/ ]]; then
		echo "Run this command from a directory inside a west workspace!"
		exit 1
	fi
	docker run -ti -v /dev/bus/usb:/dev/bus/usb \
		-v $(realpath $PWD/..):$(realpath $PWD/..) \
		swedishembedded/develop:latest bash -c "cd $PWD && $*"
}

export PATH=~/.local/bin:"$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export WASMTIME_HOME="$HOME/.wasmtime"
export PATH="$WASMTIME_HOME/bin:$PATH"
