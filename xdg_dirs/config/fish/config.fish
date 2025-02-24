if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Customisable prompt
starship init fish | source


# Abbreviations (aliases
abbr --add -- g git
abbr --add -- ga git add

abbr --add -- gst git status
