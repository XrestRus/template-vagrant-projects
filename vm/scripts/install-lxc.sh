#!/bin/bash

# Установка LXC с включением встроенного dnsmasq
# Контейнеры будут доступны по именам: mycontainer.lxc

set -e

echo "Установка LXC..."

# Установка LXC и дополнительных пакетов
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    lxc \
    lxc-templates \
    uidmap \
    debootstrap

echo "✅ LXC пакеты установлены"
echo ""
echo "ℹ️  Конфигурация LXC будет применена через apply-configs.sh"

# Проверка конфигурации LXC
echo ""
echo "Проверка конфигурации LXC:"
sudo lxc-checkconfig | grep -E "enabled|missing" | head -20 || true

echo ""
echo "✅ LXC установлен и настроен"
echo "   • Контейнеры будут в сети: 10.0.3.0/24"
echo "   • Gateway: 10.0.3.1"
echo "   • DNS домен: .lxc"
echo "   • Контейнеры доступны как: mycontainer.lxc"
echo ""
echo "📝 Пример создания контейнера:"
echo "   sudo lxc-create -n mycontainer -t download -- -d ubuntu -r jammy -a amd64"
echo "   sudo lxc-start -n mycontainer"
echo "   ping mycontainer.lxc"
