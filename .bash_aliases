# if [[ -x "$(command -v exa)" ]]
# then
#     alias ls="exa --long --icons --git-ignore"
#     alias tree="exa --tree --icons --no-user --no-permissions --no-time --no-filesize --git-ignore -I '.git'"
# fi



# if [[ -x "$(command -v batcat)" ]]
# then
#     alias cat="batcat"
# elif [[ -x "$(command -v bat)" ]]
# then
#     alias cat="bat"
# fi

# if [[ -x "$(command -v rg)" ]]
# then
#     alias grep="rg"
# fi


if [[ -x "$(command -v wsl.exe)" ]]
then
    if [[ -x "$(command -v subl.exe)" ]]; then
        alias subl="subl.exe"
    fi
    alias e="explorer.exe"
    alias notepad="notepad.exe"
fi
