#!/bin/bash

# 0. Environment Variables
CONF_DIR=/etc/gravity-sync
CONF_FILE=${CONF_DIR}/gravity-sync.conf
PUB_KEY=${CONF_DIR}/gravity-sync.rsa.pub

# 1. Setup root login settings
if [ ! -f ${PUB_KEY} ]; then
    echo "[*] ${PUB_KEY} not found."
    echo "[+] Setting root password"
    echo "root:${ROOT_PASS}" | chpasswd
else
    # Remove the root password if SSH keys have been configured
    echo "[+] Removing root password..."
    passwd -dl root
    echo "[+] Disabling root password authentication..." 
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
fi

# 2. Print gravity-sync version
gravity-sync version

# 3. Install cronjob
echo "@hourly root /bin/bash /usr/local/bin/gravity-sync" > /etc/cron.d/10-gravity-sync

# 4. Start crond
cron -l

# 5. Run SSHD in the foreground
if [ ! -d /run/sshd ]; then
    mkdir -p /run/sshd
fi

/usr/sbin/sshd -D
