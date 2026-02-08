#!/bin/bash

# Установка Docker Engine и Docker Compose plugin
# Официальная документация: https://docs.docker.com/engine/install/ubuntu/

set -e

echo "Установка Docker Engine..."

# Добавляем официальный GPG ключ Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Добавляем репозиторий Docker в sources.list.d (используем новый формат DEB822)
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Обновляем индекс пакетов
sudo apt update

# Устанавливаем Docker Engine, CLI, containerd и плагины
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Добавляем пользователя vagrant в группу docker (для работы без sudo)
sudo usermod -aG docker vagrant

# Включаем и запускаем Docker
sudo systemctl enable docker
sudo systemctl start docker

# Проверяем установку
echo ""
echo "✅ Docker установлен:"
docker --version
docker compose version

echo ""
echo "ℹ️  Пользователь vagrant добавлен в группу docker"
echo "   Для применения изменений переподключитесь: vagrant ssh"
