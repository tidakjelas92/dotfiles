#
# ~/.bashrc
#

# Colors const
COLOR_NONE="\e[0m"
RED="\e[0;31m"
GREEN="\e[0;32m"
BLUE="\e[0;34m"
PURPLE="\e[0;35m"
CYAN="\e[0;36m"
WHITE="\e[0;37m"
GRAY="\e[2;37m"

# Symbols const
# SYMBOL_USER=$'\uf007'
SYMBOL_USER=$''
SYMBOL_FOLDER=$'\uf07c'
# SYMBOL_GIT_MODIFIED=${SYMBOL_GIT_MODIFIED:-*}
# SYMBOL_GIT_PUSH=${SYMBOL_GIT_PUSH:-↑}
# SYMBOL_GIT_PULL=${SYMBOL_GIT_PULL:-↓}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function command_exists() {
	type "$1" &>/dev/null
}

function directory_exists() {
	if [[ ! -d $1 ]]; then
		return 1
	fi

	return 0
}

# Aliases
if command_exists exa; then
	alias ls='exa -a -l --group-directories-first --icons'
else
	alias ls='ls --color=auto'
fi

alias luamake=/home/hansen/programs/lua-language-server/3rd/luamake/luamake
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'

if command_exists nvim; then
	alias vi='nvim'
	alias vim='nvim'
fi

# Prompt customization
function is_git_repository() {
	git branch >/dev/null 2>&1
}

function set_git_branch() {
	# Note that for new repo without commit, git rev-parse --abbrev-ref HEAD
	# will error out.
	if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
		local branch_name=$(git rev-parse --abbrev-ref HEAD)

		# Remind if on the main branch
		if [[ $branch_name = "main" || $branch_name = "master" ]]; then
			BRANCH="${branch_name} ${RED}${COLOR_NONE}"
		else
			BRANCH="${branch_name}"
		fi
	else
		BRANCH="bare repo!"
	fi
}

function set_bash_prompt() {
	if is_git_repository; then
		set_git_branch
		SYMBOL_GIT_BRANCH=$'\ue725'
	else
		BRANCH=""
		SYMBOL_GIT_BRANCH=""
	fi

	# Prompt Setting
	PS1=""
	# User and host
	PS1+="╭─${SYMBOL_USER}${GREEN} \u${RED}@${GRAY}\h  "
	# Working Directory
	PS1+="${BLUE}${SYMBOL_FOLDER} \w  "
	# Git Branch
	PS1+="${CYAN}${SYMBOL_GIT_BRANCH} ${BRANCH}"
	# Prompt
	PS1+="${COLOR_NONE}\n╰── $ "
}

export PROMPT_COMMAND=set_bash_prompt

# Additional paths

function set_environment_variables() {
	result=$PATH

	# Please note that these path will be added only if they exist
	declare -a env=(
		"/home/hansen/.local/bin"
		"/home/hansen/.cargo/bin"
	)

	for path in "${env[@]}"; do
		if [ -d "$path" ]; then
			result="$path:$result"
		fi
	done

	export PATH=$result
}

set_environment_variables

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

# nvm integration
NVM_PATH="/usr/share/nvm"
if directory_exists $NVM_PATH; then
	source "$NVM_PATH/init-nvm.sh"
fi
