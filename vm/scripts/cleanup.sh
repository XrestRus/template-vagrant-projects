#!/bin/bash

# Умеренная очистка после установки окружения.
# Уменьшает размер системы/образа за счёт кэшей и временных данных.
# Запускается в конце bootstrap.sh, когда система уже настроена.

set -e

echo ""
echo "🧹 Очистка системы..."

# Очистка APT
sudo apt-get -y autoremove --purge
sudo apt-get -y clean
sudo apt-get -y autoclean
sudo rm -rf /var/lib/apt/lists/*

# Очистка логов
sudo find /var/log -type f -exec truncate -s 0 {} \;
sudo rm -rf /var/log/*.gz /var/log/*.1

# Очистка временных файлов
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Очистка кэша
sudo rm -rf /var/cache/*

# Временные файлы установки
sudo rm -rf /var/cache/apt/archives/*.deb 2>/dev/null || true
sudo rm -rf /tmp/* 2>/dev/null || true

echo "✅ Очистка завершена"
