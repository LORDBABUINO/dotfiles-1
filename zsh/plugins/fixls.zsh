# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/theme-and-appearance.zsh

# ls colors
autoload -U colors && colors

# Enable ls colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# TODO organise this chaotic logic

if [[ "$DISABLE_LS_COLORS" != "true" ]]; then
  # Find the option for using colors in ls, depending on the version
  if [[ "$OSTYPE" == netbsd* ]]; then
	# On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
	# otherwise, leave ls as is, because NetBSD's ls doesn't support -G
	gls --color -d . &>/dev/null && alias ls='gls --color=tty --group-directories-first'
  elif [[ "$OSTYPE" == openbsd* ]]; then
	# On OpenBSD, "gls" (ls from GNU coreutils) and "colorls" (ls from base,
	# with color and multibyte support) are available from ports.  "colorls"
	# will be installed on purpose and can't be pulled in by installing
	# coreutils, so prefer it to "gls".
	gls --color -d . &>/dev/null && alias ls='gls --color=tty --group-directories-first'
	colorls -G -d . &>/dev/null && alias ls='colorls -G --group-directories-first'
  elif [[ "$OSTYPE" == darwin* ]]; then
	# this is a good alias, it works by default just using $LSCOLORS
	ls -G . &>/dev/null && alias ls='ls -G --group-directories-first'

	# only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
	# otherwise, gls will use the default color scheme which is ugly af
	[[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ls='gls --color=tty --group-directories-first'
  else
	# For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
	if [[ -z "$LS_COLORS" ]]; then
	  (( $+commands[dircolors] )) && eval "$(dircolors -b)"
	fi

	ls --color -d . &>/dev/null && alias ls='ls --color=tty --group-directories-first' || { ls -G . &>/dev/null && alias ls='ls -G --group-directories-first' }

	# Take advantage of $LS_COLORS for completion as well.
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  fi
fi

setopt auto_cd
setopt multios
