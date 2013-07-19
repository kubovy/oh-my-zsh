# ------------------------------------------------------------------------
# Juan G. Hurtado oh-my-zsh theme
# (Needs Git plugin for current_branch method)
# ------------------------------------------------------------------------

# Color shortcuts
RED=$fg[red]
GREEN=$fg[green]
BLUE=$fg[blue]

CYAN=$fg[cyan]
MAGENTA=$fg[magenta]
YELLOW=$fg[yellow]
WHITE=$fg[white]

RED_BOLD=$fg_bold[red]
GREEN_BOLD=$fg_bold[green]
BLUE_BOLD=$fg_bold[blue]

CYAN_BOLD=$fg_bold[cyan]
YELLOW_BOLD=$fg_bold[yellow]
MAGENTA_BOLD=$fg_bold[magenta]
WHITE_BOLD=$fg_bold[white]

RESET_COLOR=$reset_color

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$MAGENTA%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY="%{$RED%}*"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$GREEN%}√"


# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$RED%}≈"
ZSH_THEME_GIT_PROMPT_DELETED="%{$RED%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$YELLOW%}ρ"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$YELLOW%}~"
ZSH_THEME_GIT_PROMPT_ADDED="%{$GREEN%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$WHITE%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD="%{$RED%}!"

# Format for git_remote_status()
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$RED%}!"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$MAGENTA%}!"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$YELLOW%}!"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$WHITE%}sha:%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER=" "

# Memory limits
MEMORY_WARNING=75
MEMORY_CRITICAL=95


prompt_git() {
	git status &> /dev/null
	local IS_GIT=$?
	if [[ $IS_GIT -eq 0 ]]; then
		echo -n "%{$WHITE%}[$(git_prompt_info)$(git_remote_status)%{$WHITE%}] "
	fi
}

prompt_user() {
	UID=`id -u`
	if [[ $UID -eq 0 ]]; then
		echo -n "%{$RED%}%m"
	else
		echo -n "%{$GREEN_BOLD%}%n@%m"
	fi
}

prompt_result() {
	if [[ $RETVAL -eq 0 ]]; then
		echo -n "%{$GREEN%}:) "
	else
		echo -n "%{$RED%}:( "
	fi
}

prompt_jobs() {
	local JOBS=`jobs -l | wc -l`
	if [[ $JOBS -gt 0 ]]; then
		echo -n "%{$YELLOW%}(%{$JOBS%}) "
	fi
}

rprompt_logged_users() {
	#local USERS=$(users | wc -w)
	#echo -n "%{$WHITE%}u:%{$CYAN%}%{$USERS%}"
}

rprompt_load() {
	up=`uptime | awk -F"load average:" '{print $2}' | tr -d "[:blank:]"`
	local L1=$(echo $up | cut -d"," -f1)
	local L5=$(echo $up | cut -d"," -f2)
	local L15=$(echo $up | cut -d"," -f3)
	local CORES=$(grep 'model name' /proc/cpuinfo | wc -l)
	local LC1=$(echo "scale=2;$L1/$CORES" | bc)
	local LC5=$(echo "scale=2;$L5/$CORES" | bc)
	local LC15=$(echo "scale=2;$L15/$CORES" | bc)

	echo -n "%{$WHITE%}l:"
	if [[ $LC1 -eq 0 ]]; then
		echo -n "%{$GREEN%}0.0$LC1 "
	elif [[ $LC1 -lt 1 ]]; then
		echo -n "%{$GREEN%}0$LC1 "
	elif [[ $LC1 -eq 1 ]]; then
		echo -n "%{$YELLOW%}$LC1 "
	elif [[ $LC1 -gt 1 ]]; then
		echo -n "%{$RED%}$LC1 "
	fi

	if [[ $LC5 -eq 0 ]]; then
		echo -n "%{$GREEN%}0.0$LC5 "
	elif [[ $LC5 -lt 1 ]]; then
		echo -n "%{$GREEN%}0$LC5 "
	elif [[ $LC5 -eq 1 ]]; then
		echo -n "%{$YELLOW%}$LC5 "
	elif [[ $LC5 -gt 1 ]]; then
		echo -n "%{$RED%}$LC5 "
	fi

	if [[ $LC15 -eq 0 ]]; then
		echo -n "%{$GREEN%}0.0$LC15"
	elif [[ $LC15 -lt 1 ]]; then
		echo -n "%{$GREEN%}0$LC15"
	elif [[ $LC15 -eq 1 ]]; then
		echo -n "%{$YELLOW%}$LC15"
	elif [[ $LC15 -gt 1 ]]; then
		echo -n "%{$RED%}$LC15"
	fi
	echo -n " "
}

rprompt_mem() {
	local USED=$(echo "scale=1;$(free | grep "Mem:" | awk '{print $3}')/$(free | grep "Mem:" | awk '{print $2}')*100" | bc | cut -d"." -f1)

	echo -n "%{$WHITE%}m:"
	if [[ $USED -gt $MEMORY_WARNING ]]; then
		echo -n "%{$YELLOW%}"
	elif [[ $USED -gt $MEMORY_CRITICAL ]]; then
		echo -n "%{$RED%}"
	else
		echo -n "%{$GREEN%}"
	fi
	echo -n "$USED%%"
}

build_prompt() {
	RETVAL=$?
	prompt_user
	echo -n "%{$WHITE%}:%{$BLUE_BOLD%}%~%u "
	prompt_git
	prompt_jobs
	prompt_result
	echo -n "%{$BLUE_BOLD%}»%{$RESET_COLOR%}"
}

# Prompt format » ►
PROMPT='%{%f%b%k%}$(build_prompt) '
#RPROMPT='%{$GREEN_BOLD%}%{$WHITE%}[$(git_prompt_short_sha)$(rprompt_logged_users) $(rprompt_load) $(rprompt_mem)%{$WHITE%}]%{$RESET_COLOR%}'
