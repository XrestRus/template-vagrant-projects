#!/bin/bash

# Установка базовых пакетов
# Устанавливает: ssh, git, mc, curl, wget, gzip и другие необходимые утилиты

set -e

echo "Установка базовых пакетов..."

sudo apt install -y \
    openssh-server \
    git \
    mc \
    curl \
    wget \
    gzip \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    dos2unix \
    net-tools \
    htop \
    vim \
    nano

echo "✅ Базовые пакеты установлены"
