#!/usr/bin/env bash

##### COLORS #####
export CLEAR='\033[0m'
export BBlue='\033[1;34m'

############################################
step1() {
  sudo cp /etc/apt/apt.conf.d/20apt-fast.conf "/etc/apt/apt.conf.d/20apt-fast.conf.$(date +%Y_%m_%d_%H_%M_%S)" 2>/dev/null
  sudo apt update -y >/dev/null
  sudo apt upgrade -y >/dev/null
}
step2() {
  sudo apt install -y \
    curl aria2 bc bash-completion bind9-dnsutils chrony cron cryptsetup \
    fdupes firewalld ftp git htop iftop iotop iputils-ping jq lshw lsof mtr-tiny \
    net-tools network-manager nload nmap openssl \
    p7zip-full p7zip-rar python3-dev python3-pip qemu-utils qrencode \
    screen sshfs sysstat wget whois wireguard tcpdump telnet tmux traceroute unzip \
    podman podman-docker podman-compose >/dev/null
  sudo apt install -y ngrep wireshark-common >/dev/null
}
step3() {
    sudo sed -i 's/^# %sudo/%sudo/' /etc/sudoers
    sudo timedatectl set-timezone UTC
    sudo timedatectl set-ntp true
    sudo touch /etc/vim/vimrc
    sudo sed -i "s/set hlsearch/set nohlsearch/g" /etc/vim/vimrc
    sudo systemctl daemon-reload
    SERVICES="firewalld ssh sysstat chrony cron podman"
    for SRV in $SERVICES; do
        sudo systemctl restart $SRV 2>/dev/null
    done
}
step4() {
    sudo mkdir -p /root/.bashrc.d/ /root/.ssh/
    echo '
COLF0=$(tput setaf 0)
COLF1=$(tput setaf 1)
COLF2=$(tput setaf 2)
COLF3=$(tput setaf 3)
COLF4=$(tput setaf 4)
COLF5=$(tput setaf 5)
COLF6=$(tput setaf 6)
COLF7=$(tput setaf 7)
COLB0=$(tput setab 0)
COLB1=$(tput setab 1)
COLB2=$(tput setab 2)
COLB3=$(tput setab 3)
COLB4=$(tput setab 4)
COLB5=$(tput setab 5)
COLB6=$(tput setab 6)
COLB7=$(tput setab 7)
COLRST=$(tput sgr0)

export SYSTEMD_PAGER=
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "
export VISUAL=/usr/bin/vi
export EDITOR="$VISUAL"
shopt -s histappend

export PS1="\[$(tput setaf 33)\]\u\[$(tput setaf 69)\]@\[$(tput setaf 105)\]\h \[$(tput setaf 141)\]\w \[$(tput sgr0)\] ➜ $ "

alias update="sudo apt update && sudo apt -y upgrade"
alias dig="dig +short "
alias ll="ls -l --color=auto"
alias lll="ls -ltrh --color=auto"
alias llll="ls -ltrha --color=auto"
alias lsblk="lsblk -f"
alias date_dir="date +%Y_%m_%d_%H_%M_%S"
alias grep="grep --color=never"
alias tcpdump_file="tcpdump -nnnnvvvvvvv -s 65535 -w dump$(date +%Y_%m_%d_%H_%M_%S).pcap"
alias s="sudo su"
alias ping="ping -i 0.2 -W 0.2 -O -U"
alias aria2c="aria2c --file-allocation=none"
alias ipadd="ip -brief address"
alias ssh_raw="ssh -o PubkeyAuthentication=no"
alias ssh-copy-id_raw="ssh-copy-id -o PubkeyAuthentication=no"
alias k="kubectl"
    ' | sudo tee /root/.bashrc.d/mybash >/dev/null
####### SSH CONFIG TEMPLATE #######
    echo '
    Host host1 !host2
    ProxyJump host1
    LocalCommand echo -e "\n\n\x1b[30;31m------WARNING: PRODUCTIVE system! ------\n\n"
    PermitLocalCommand yes
    User root
    LocalForward 3306 127.0.0.1:33061
    StrictHostKeyChecking no
    IdentitiesOnly yes
    PasswordAuthentication yes
    ControlMaster auto
    ControlPersist 10s
    ' | sudo tee /root/.ssh/ssh.sample.config >/dev/null
    echo '. /root/.bashrc.d/mybash' | sudo tee /root/.bashrc >/dev/null
}


############################################
echo -ne "$BBlue"
step1
step2
step3
step4
echo -ne "$CLEAR"
