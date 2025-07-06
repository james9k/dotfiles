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
abbr --add -- gb git branch
abbr --add -- gba git branch -a
abbr --add -- gbm git branch --merged
abbr --add -- gco git checkout
abbr --add -- gcm git commit -m
abbr --add -- gd git diff
abbr --add -- gfo git fetch origin
abbr --add -- glo git log --pretty=format:"%h%x09%an%x09%ad%x09%s"
abbr --add -- gpom git pull origin master
abbr --add -- gpull git pull
abbr --add -- gpush git push
abbr --add -- grpo git remote prune origin
abbr --add -- gst git status

# Kubernetes
abbr --add -- kc kubectl
abbr --add -- ktx kubectx
abbr --add -- kns kubens
kubectl completion fish | source
# Requires: pacman -S kubectx
abbr --add -- ktx kubectx
abbr --add -- kns kubens

# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# Customisable prompt
starship init fish | source

