# vim:ft=zsh ts=2 sw=2 sts=2
# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 1000 ]]; then
    local user_host='%{$terminfo[bold]$fg[green]%}%n%{$reset_color%}'
else
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
fi

local current_dir='%{$terminfo[bold]$fg[blue]%} %3~%{$reset_color%}'
local git_branch='$(git_branch_info)%{$reset_color%}'
local shell_icon='$(echo -e $myicons_arch_linux_arrow)'
local git_icon='$(echo -e $oct_git_branch)'

PROMPT="╭─${user_host} ${current_dir} ${git_branch}
╰─$shell_icon  "
RPS1="${return_code}"


git_branch_info() {
	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		echo -en "%{$fg[yellow]%} $oct_git_branch"
		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' enable git
		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		zstyle ':vcs_info:*' stagedstr ' '
		zstyle ':vcs_info:*' unstagedstr ' '
		zstyle ':vcs_info:*' formats '%b %u%c'
		zstyle ':vcs_info:*' actionformats '%b %u%c (%a)'
		vcs_info
		echo -n "${vcs_info_msg_0_%%}"

		local_commit=$(git rev-parse @ 2>&1)
		remote_commit=$(git rev-parse @{u} 2>&1)
		common_base=$(git merge-base @ @{u} 2>&1) # last common commit

		if [[ $local_commit == $remote_commit ]]; then
			echo -n ""
		else
			if [[ $common_base == $remote_commit ]]; then
				echo -en "$oct_cloud_upload"
			elif [[ $common_base == $local_commit ]]; then
				echo -en "$oct_cloud_download"
			else
				echo -en "$oct_git_commit"
			fi
		fi
		echo -n "%{$reset_color%}"
	fi
}
