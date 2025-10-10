#!/usr/bin/env bash

##### VARIABLES
    export CLEAR='\033[0m'       # Text Reset
    # Regular Colors
    export Black='\033[0;30m'        # Black
    export Red='\033[0;31m'          # Red
    export Green='\033[0;32m'        # Green
    export Yellow='\033[0;33m'       # Yellow
    export Blue='\033[0;34m'         # Blue
    export Purple='\033[0;35m'       # Purple
    export Cyan='\033[0;36m'         # Cyan
    export White='\033[0;37m'        # White
    # Bold
    export BBlack='\033[1;30m'       # Black
    export BRed='\033[1;31m'         # Red
    export BGreen='\033[1;32m'       # Green
    export BYellow='\033[1;33m'      # Yellow
    export BBlue='\033[1;34m'        # Blue
    export BPurple='\033[1;35m'      # Purple
    export BCyan='\033[1;36m'        # Cyan
    export BWhite='\033[1;37m'       # White
#
step1(){
    sudo cp /etc/dnf/dnf.conf "/etc/dnf/dnf.conf.`date +%Y_%m_%d_%H_%M_%S`"
    sudo dnf update --best --allowerasing -y --refresh >/dev/null
    sudo echo '[main]
    gpgcheck=1
    installonly_limit=3
    clean_requirements_on_remove=True
    best=True
    skip_if_unavailable=True
    ip_resolve=4
    fastestmirror=true
    max_parallel_downloads=20
    deltarpm=1
    keepcache=True
    timeout=20
    retries=20
    ' | tr -d " " | sudo tee /etc/dnf/dnf.conf >/dev/null


    enabled_repos=`dnf repolist --enabled`
    # setting up rpmfusion-free repo
    if [ "`echo "$enabled_repos" | grep -ic rpmfusion-free`" -lt "2" ] ; then
        dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    fi
    # setting up rpmfusion-nonfree repo
    if [ "`echo "$enabled_repos" | grep -ic rpmfusion-nonfree`" -lt "1" ] ; then
        dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    fi

}
step2(){
    dnf install -y --best --skip-unavailable --skip-broken --allowerasing curl aria2 bc bash-color-prompt bash-completion bind-utils chrony cronie cryptsetup curl \
    fdupes firewalld ftp git htop iftop iotop iputils jq lshw lsof mtr net-tools \
    NetworkManager NetworkManager-tui ngrep nload nmap nmap-ncat openssl \
    p7zip p7zip-plugins pip policycoreutils-python-utils util-linux vim  \
    procps procps-ng psmisc python3-devel python3-pip qemu-img qrencode \
    setroubleshoot-server screen sshfs sshuttle sysstat wget whois \
    wireguard-tools wireshark-cli tcpdump telnet tmux traceroute unzip  \
     hping3 GeoIP bwm-ng jcal jdupes mmv mysql mycli \
    netstat-nat pwgen unar unrar vnstat plocate
}
step3(){
    mkdir -p /etc/docker /usr/local/lib/docker/cli-plugins 
    dnf install -y --best --skip-unavailable --skip-broken --allowerasing \
    moby-engine sen podman podman-compose podman-tui \
    buildah skopeo toolbox cri-tools lxc lxc-templates colin openscap-containers \
    kubernetes-client helm
    dnf group install --with-optional -y --skip-unavailable --skip-broken --best --allowerasing \
    container-management mysql container-management mysql
        mkdir -p /etc/docker /usr/local/lib/docker/cli-plugins 
    echo -e "{\n\"bip\" : \"192.168.255.1/24\",\n\"data-root\": \"/data/docker-data/\"\n}\n" > /etc/docker/daemon.json
    # installing docker-compose
    if [ ! -f /usr/local/lib/docker/cli-plugins/docker-compose ] ; then
      # https://github.com/docker/compose/releases/latest
      GH_DP_COMPOSE=$(curl -s "https://api.github.com/repos/docker/compose/releases/latest" | jq -r '.assets[] | "\(.name) \(.browser_download_url)"')
      DLND_URL=$(echo "$GH_DP_COMPOSE" | grep "linux-x86_64 " | awk '{print $2}')
      curl -sSL "$DLND_URL" -o /usr/local/lib/docker/cli-plugins/docker-compose
      chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    fi
    # installing docker-buildx
    if [ ! -f /usr/local/lib/docker/cli-plugins/docker-buildx ] ; then
      # https://github.com/docker/buildx/releases/latest
      GH_DP_COMPOSE=$(curl -s "https://api.github.com/repos/docker/buildx/releases/latest" | jq -r '.assets[] | "\(.name) \(.browser_download_url)"')
      DLND_URL=$(echo "$GH_DP_COMPOSE" | grep "linux-amd64 " | awk '{print $2}')
      curl -sSL $DLND_URL -o /usr/local/lib/docker/cli-plugins/docker-buildx
      chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx
    fi

}
step4(){
    sudo sed 's/^# %wheel/%wheel/' -i /etc/sudoers
    sudo timedatectl set-timezone UTC
    timedatectl set-ntp true
    sudo touch /etc/vimrc ; sed -i /etc/vimrc -e "s/set hlsearch/set nohlsearch/g"
    sudo systemctl daemon-reload
    SERVICES="firewalld sshd sysstat vnstat vmtoolsd chronyd crond docker"
    for SRV in $SERVICES  ; do sudo systemctl restart  &> /dev/null  $SRV ; done
    rpm --rebuilddb
}
step5(){

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
    export VAGRANT_DEFAULT_PROVIDER=libvirt
    shopt -s histappend

    PS1="\[\e[0;1m\]\u\[\e[0m\]@\[\e[0;1;38;5;160m\]\H\[\e[0m\][\[\e[0;1m\]\W\[\e[0m\]]\[\e[0m\]:\[\e[0m\](\[\e[0;1m\]$?\[\e[0m\])\[\e[0m\]\$ \[\e[0m\]"
    PS1="\[\e[38;5;160;1m\]\w\[\e[0m\] ➜ $ "
    export PS1="\[$(tput setaf 33)\]\u\[$(tput setaf 69)\]@\[$(tput setaf 105)\]\h \[$(tput setaf 141)\]\w \[$(tput sgr0)\] ➜ $ "

    # -------------------------- ALIASES
    alias mydnf="dnf update --best --allowerasing -y --refresh "
    alias mylogs1="journalctl --since \"10 min ago\""
    alias mylogs2="journalctl --since \"1 hour ago\""
    alias dig="dig +short "
    alias ll="ls -l --color=auto"
    alias lll="ls -ltrh --color=auto"
    alias llll="ls -ltrha --color=auto"
    alias lsblk="lsblk -f "
    alias date_dir="date +%Y_%m_%d_%H_%M_%S "
    alias jdate_dir="jdate +%Y_%m_%d_%H_%M_%S "
    alias grep="grep --color=never "
    alias tcpdump_file="tcpdump -nnnnvvvvvvv -s 65535 -w dump`date +%Y_%m_%d_%H_%M_%S`.pacp"
    alias s="sudo su "
    alias ping="ping -i 0.2 -W 0.2 -O -U "
    alias aria2c="aria2c --file-allocation=none "
    alias ipadd="ip -brief address"
    alias ww="~/.scripts/set.bg.pic.sh &> /dev/null"
    alias ssh_raw="ssh -o PubkeyAuthentication=no " 
    alias ssh-copy-id_raw="ssh-copy-id -o PubkeyAuthentication=no "
    alias k="kubectl "
    ' | sudo tee /root/.bashrc.d/mybash >/dev/null

    echo '
    # -----TEMPLATE----
    Host host1 !host2
    HostName 1.1.2.1
    User root
    Port 22
    ProxyJump host1
    LocalCommand echo -e "\n\n\x1b[30;31m------WARNING: You are on a PRODUCTIVE system! \x1b0------\n\n"
    PermitLocalCommand yes
    LocalForward 3306 127.0.0.1:33061
    StrictHostKeyChecking no
    IdentityFile ~/.ssh/mykey
    HostKeyAlgorithms +ssh-rsa,ssh-dss
    PubkeyAcceptedKeyTypes +ssh-rsa,ssh-dss
    KexAlgorithms +curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1
    Ciphers +aes256-cbc,aes128-cbc,3des-cbc
    HostbasedKeyTypes +ssh-rsa,ssh-dss
    IdentitiesOnly yes
    PubkeyAuthentication no
    PasswordAuthentication yes
    ControlMaster auto
    ControlPersist 10s
    ControlMaster auto
    ControlPath ~/.ssh/controlmasters/%C
    ControlPersist 30s

    ' | sudo tee /root/.ssh/ssh.sample.config >/dev/null

    echo '. /root/.bashrc.d/mybash' | sudo tee /root/.bashrc >/dev/null

}
echo -ne "$BBlue"
step1
step2
step3
step4
step5
echo -ne "$CLEAR"





