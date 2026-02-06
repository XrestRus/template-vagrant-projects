#!/bin/bash

# Загружаем переменные из .env
set -a
source <(cat /home/vagrant/.env | tr -d '\r')
set +a

GIT_PROJECT_NAME="$(basename "$GIT_FULL_URL" .git)"

# Переходим в проекты
mkdir -p /home/vagrant/projects
cd /home/vagrant/projects || exit 1

# Ставим дополнительное ПО
sudo apt update && 
sudo apt install -y git lxc lxc-templates sshfs mc

# Подключаем диск, если указан SSHFS_URL
if [[ -n "${SSHFS_URL}" ]]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    IP=$(echo "$SSHFS_URL" | awk '{split($1, a, "@"); split(a[2], b, ":"); print b[1]}')
    ssh-keyscan -t rsa,dsa,ecdsa,ed25519 "$IP" 2>/dev/null >> ~/.ssh/known_hosts

    if [ -n "${SSH_PASSWORD}" ]; then
        echo "$SSH_PASSWORD" | sshfs $SSHFS_URL -o password_stdin
    else
        sshfs "$SSHFS_URL"
    fi
fi

# Проверяем, есть ли уже проект
if [ -d "${GIT_PROJECT_NAME}" ]; then
    cd "${GIT_PROJECT_NAME}" || exit 1
    git pull
else
    git clone "${GIT_FULL_URL}"
    cd "${GIT_PROJECT_NAME}" || exit 1
fi

echo "Welcome to ${GIT_PROJECT_NAME}"
exec /bin/bash
