#!/bin/bash

# Применение конфигураций через симлинки
# Все файлы уже есть в vm/configs/, проверки не нужны

set -e

echo "Применяем конфигурации из vm/configs/..."
echo ""

# ============================================
# LXC конфигурации
# ============================================
echo "📦 Применяем LXC конфигурации..."

# LXC default.conf
sudo rm -f /etc/lxc/default.conf
sudo ln -sf /vagrant/vm/configs/lxc/default.conf /etc/lxc/default.conf
echo "  ✅ Симлинк: lxc default.conf"

# LXC network config
sudo rm -f /etc/default/lxc-net
sudo ln -sf /vagrant/vm/configs/lxc/lxc-net /etc/default/lxc-net
echo "  ✅ Симлинк: lxc-net"

# dnsmasq main config
sudo rm -f /etc/lxc/dnsmasq.conf
sudo ln -sf /vagrant/vm/configs/lxc/dnsmasq.conf /etc/lxc/dnsmasq.conf
echo "  ✅ Симлинк: dnsmasq.conf"

# dnsmasq resolv file (upstream DNS)
sudo rm -f /etc/lxc/resolv.dnsmasq
sudo ln -sf /vagrant/vm/configs/lxc/resolv.dnsmasq /etc/lxc/resolv.dnsmasq
echo "  ✅ Симлинк: resolv.dnsmasq"

# dnsmasq.d конфиги
sudo mkdir -p /etc/lxc/dnsmasq.d
for conf_file in /vagrant/vm/configs/lxc/dnsmasq.d/*.conf; do
    conf_name=$(basename "$conf_file")
    sudo rm -f "/etc/lxc/dnsmasq.d/$conf_name"
    sudo ln -sf "$conf_file" "/etc/lxc/dnsmasq.d/$conf_name"
    echo "  ✅ Симлинк: dnsmasq.d/$conf_name"
done

# Запуск LXC сети
sudo systemctl enable lxc-net
sudo systemctl restart lxc-net
echo "  ✅ LXC сеть перезапущена"

# ============================================
# systemd-resolved конфигурация (для резолвинга LXC DNS)
# ============================================
echo ""
echo "🌐 Применяем systemd-resolved конфигурацию..."

sudo rm -f /etc/systemd/resolved.conf
sudo ln -sf /vagrant/vm/configs/systemd/resolved.conf /etc/systemd/resolved.conf
echo "  ✅ Симлинк: resolved.conf"

# Перезапуск systemd-resolved
sudo systemctl restart systemd-resolved
echo "  ✅ systemd-resolved перезапущен"

# ============================================
# SSH конфигурация
# ============================================
echo ""
echo "🔐 Применяем SSH конфигурацию..."

sudo rm -f /etc/ssh/sshd_config.d/99-custom.conf
sudo ln -sf /vagrant/vm/configs/ssh/sshd_config /etc/ssh/sshd_config.d/99-custom.conf
echo "  ✅ Симлинк: sshd_config"

# Перезапуск SSH
sudo systemctl restart ssh
echo "  ✅ SSH сервер перезапущен"

# ============================================
# Готово
# ============================================
echo ""
echo "✅ Все конфигурации применены через симлинки"
echo ""
echo "📝 Редактируй конфиги в vm/configs/ и перезапускай сервисы:"
echo "   LXC:      sudo systemctl restart lxc-net"
echo "   DNS:      sudo systemctl restart systemd-resolved"
echo "   SSH:      sudo systemctl restart ssh"
