#!/bin/bash

# Загружаем переменные из .env
set -a
source <(cat /home/vagrant/.env | tr -d '\r')
set +a

GIT_PROJECT_NAME="$(basename "$GIT_FULL_URL" .git)"

# Переходим в проекты
mkdir -p /home/vagrant/projects
cd /home/vagrant/projects || exit 1

# Обновляем систему и ставим базовые пакеты
sudo apt update && 
sudo apt install -y git mc openssh-server ca-certificates curl

# Установка Docker Engine
# Добавляем официальный GPG ключ Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Добавляем репозиторий Docker в sources.list.d
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Обновляем индекс пакетов и устанавливаем Docker Engine, CLI, containerd и Docker Compose plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Добавляем пользователя vagrant в группу docker (чтобы не использовать sudo)
sudo usermod -aG docker vagrant

# Включаем и запускаем Docker
sudo systemctl enable docker
sudo systemctl start docker

# Проверяем установку Docker
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker compose version

# Подключаем диск, если указан SSHFS_URL
if [[ -n "${SSHFS_URL}" ]]; then
    sudo apt install -y sshfs
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

# Клонируем проект, если указан GIT_FULL_URL
if [[ -n "${GIT_FULL_URL}" ]]; then
    # Проверяем, есть ли уже проект
    if [ -d "${GIT_PROJECT_NAME}" ]; then
        cd "${GIT_PROJECT_NAME}" || exit 1
        git pull
    else
        git clone "${GIT_FULL_URL}"
        cd "${GIT_PROJECT_NAME}" || exit 1
    fi

    # Запускаем скрипт установки проекта, если он указан и существует
    if [[ -n "${INSTALL_SCRIPT}" ]] && [ -f "${INSTALL_SCRIPT}" ]; then
        echo "Запускаем скрипт установки проекта: ${INSTALL_SCRIPT}"
        bash "${INSTALL_SCRIPT}"
    elif [ -f "install.sh" ]; then
        echo "Запускаем скрипт установки проекта по умолчанию: install.sh"
        bash install.sh
    else
        echo "Скрипт установки не найден."
    fi

    echo "Welcome to ${GIT_PROJECT_NAME}"
else
    echo "GIT_FULL_URL не указан. Пропускаем клонирование проекта."
fi

# ВАЖНО: Выходим из скрипта для перезагрузки групп пользователя
echo ""
echo "Установка завершена!"
echo "Для применения прав группы docker выполните: vagrant ssh"
exec /bin/bash
