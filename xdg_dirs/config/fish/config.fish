if status is-interactive
    # Commands to run in interactive sessions can go here
end

################################################################################
# Abbreviations (aliases)
################################################################################
abbr --add -- ls ls --color=auto
abbr --add -- ll ls -l
abbr --add -- lla ls -lA
abbr --add -- l ls
abbr --add -- la ls -A

abbr --add -- el eza -l
abbr --add -- ela eza -la
abbr --add -- e eza
abbr --add -- ea eza -a 

# iproute2
abbr --add -- ip ip -c
abbr --add -- bridge bridge -c

# Git
abbr --add -- g git
abbr --add -- ga git add
abbr --add -- gco git checkout
abbr --add -- gcm git commit -m
abbr --add -- gd git diff
abbr --add -- gfo git fetch origin
abbr --add -- glo git log --pretty=format:"%h%x09%an%x09%ad%x09%s"
abbr --add -- gpom git pull origin master
abbr --add -- gpull git pull
abbr --add -- gpush git push
abbr --add -- gst git status

# Kubernetes
abbr --add -- kc kubectl

# Customisable prompt
starship init fish | source

