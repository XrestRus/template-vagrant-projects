#!/bin/bash

# Установка и настройка SSHFS для монтирования удалённых файловых систем

set -e

echo "Установка SSHFS..."

# Установка пакета
sudo DEBIAN_FRONTEND=noninteractive apt install -y sshfs

# Проверяем наличие SSHFS_URL
if [[ -z "${SSHFS_URL}" ]]; then
    echo "⚠️  SSHFS_URL не указан в .env, пропускаем монтирование"
    exit 0
fi

echo "Настройка SSHFS подключения..."

# Создаём папку .ssh если её нет
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Извлекаем IP адрес из SSHFS_URL (формат: user@host:/path /mount)
IP=$(echo "$SSHFS_URL" | awk '{split($1, a, "@"); split(a[2], b, ":"); print b[1]}')

# Добавляем SSH ключ хоста в known_hosts (чтобы избежать интерактивного запроса)
echo "Добавляем SSH ключ хоста ${IP}..."
ssh-keyscan -t rsa,dsa,ecdsa,ed25519 "$IP" 2>/dev/null >> ~/.ssh/known_hosts || true

# Монтирование через SSHFS
echo "Монтируем удалённую файловую систему..."

if [ -n "${SSH_PASSWORD}" ]; then
    # Если указан пароль - используем его
    echo "${SSH_PASSWORD}" | sshfs $SSHFS_URL -o password_stdin,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
else
    # Иначе используем SSH ключи
    sshfs "$SSHFS_URL" -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
fi

# Проверяем монтирование
MOUNT_POINT=$(echo "$SSHFS_URL" | awk '{print $2}')
if mountpoint -q "$MOUNT_POINT"; then
    echo "✅ SSHFS успешно смонтирован в: $MOUNT_POINT"
    df -h "$MOUNT_POINT"
else
    echo "⚠️  Ошибка монтирования SSHFS"
    exit 1
fi

echo ""
echo "📌 Для отмонтирования используйте:"
echo "   fusermount -u $MOUNT_POINT"
