# Universal Vagrant Box

Универсальная Vagrant-конфигурация для быстрого развёртывания полноценного окружения разработки на базе VirtualBox + Ubuntu 24.04 LTS.

## Навигация по документации

- **[VM Directory](vm/README.md)** — документация папки vm/ (скрипты, конфиги, env)
- **[Конфигурации](vm/configs/README.md)** — подробнее про конфигурации LXC и SSH
- **[DNS домены](vm/configs/lxc/dnsmasq.d/README.md)** — документация по dnsmasq и кастомным доменам

---

## Что включено

### Всегда устанавливается:
- **Ubuntu 24.04 LTS** (Noble Numbat)
- **Docker Engine + Docker Compose v2** — для контейнеризации
- **LXC + встроенный dnsmasq** — системные контейнеры с DNS (доступ по `*.lxc`)
- **SSH сервер** — с поддержкой туннелирования (SOCKS5, port forwarding)
- **Базовые утилиты**: `git`, `mc`, `curl`, `wget`, `gzip`, `vim`, `htop` и др.

## Предварительные требования

1. **[VirtualBox](https://www.virtualbox.org/wiki/Downloads)** — версия >= 7.2.6
2. **[Vagrant](https://www.vagrantup.com/downloads)** — версия >= 2.4.9
3. **Windows 11** с PowerShell

## Быстрый старт

### 1. Создание `.env` файла

```powershell
Copy-Item .env.example .env
```

### 2. Настройка конфигов

**Настройки системы (Git, SSHFS) — `vm/env`:**

```bash
# Git проект (опционально)
GIT_FULL_URL="https://github.com/username/project.git"
INSTALL_SCRIPT="install.sh"

# SSHFS (опционально)
SSHFS_URL="user@192.168.1.100:/remote/path /home/vagrant/remote"
SSH_PASSWORD="password"
```

### 3. Запуск окружения

#### Вариант 1: Удаление и заного полная установка
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; ./rebuild.ps1
```

#### Вариант 2: Полная установка
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; ./run.ps1
```

## 🔧 Управление VM

```powershell
# Подключиться к VM
vagrant ssh

# SOCKS5 прокси (для доступа к контейнерам из браузера)
vagrant ssh -- -D7777

# Проброс портов
vagrant ssh -- -L8080:localhost:80

# Остановить VM
vagrant halt

# Перезапустить VM
vagrant reload

# Удалить VM
vagrant destroy -f

# Статус VM
vagrant status
```

## Docker

Docker устанавливается автоматически и настраивается для работы без `sudo`:

```bash
# Проверка версии
docker --version
docker compose version
```

## LXC с DNS

LXC устанавливается со встроенным dnsmasq. Контейнеры доступны по именам `*.lxc`:

```bash
# Создание контейнера Ubuntu 22.04
sudo lxc-create -n mycontainer -t download -- -d ubuntu -r jammy -a amd64

# Запуск контейнера
sudo lxc-start -n mycontainer

# Подключение к контейнеру
sudo lxc-attach -n mycontainer

# Список контейнеров
sudo lxc-ls -f

# Остановка контейнера
sudo lxc-stop -n mycontainer

# Удаление контейнера
sudo lxc-destroy -n mycontainer
```

Или установите [SwitchyOmega](https://chromewebstore.google.com/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif) для удобного переключения прокси.

## SSH и туннелирование

SSH сервер настроен с поддержкой всех видов туннелирования:

### SOCKS5 динамический прокси

```powershell
vagrant ssh -- -D7777
# Настройте браузер на SOCKS5: 127.0.0.1:7777
```

### Проброс локального порта

```powershell
# Порт 80 из VM будет доступен на localhost:8080
vagrant ssh -- -L8080:localhost:80
```

### Обратный туннель

```powershell
# Порт 3000 с хоста будет доступен внутри VM на порту 9000
vagrant ssh -- -R9000:localhost:3000
```

## Автоматическая установка проекта

Если указан `GIT_FULL_URL`, проект будет автоматически склонирован в `/home/vagrant/projects/`.

Если в проекте есть скрипт установки, он будет запущен:

1. Если указан `INSTALL_SCRIPT` в `vm/env` — запустится этот скрипт
2. Иначе, если есть `install.sh` в корне проекта — запустится он

Пример `vm/env`:

```bash
GIT_FULL_URL="https://github.com/username/myproject.git"
INSTALL_SCRIPT="scripts/setup.sh"
```

## SSHFS монтирование

Подключение удалённых файловых систем через SSHFS:

```bash
# В vm/env укажите:
SSHFS_URL="user@192.168.1.100:/var/www /home/vagrant/remote"
SSH_PASSWORD="password"  # Опционально, если не используются SSH ключи
```

После установки удалённая папка будет доступна в `/home/vagrant/remote/`.

## Примеры использования

### Разработка с Docker Compose

```bash
# Подключиться к VM
vagrant ssh

# Перейти в проект
cd ~/projects/myproject

# Запустить сервисы
docker compose up -d

# Просмотр логов
docker compose logs -f
```

### Тестирование в LXC контейнере

```bash
# Создать Ubuntu контейнер
sudo lxc-create -n test -t download -- -d ubuntu -r jammy -a amd64

# Запустить
sudo lxc-start -n test

# Войти в контейнер
sudo lxc-attach -n test

# Установить приложение
apt update && apt install nginx

# Доступ из хоста через SOCKS5:
# http://test.lxc (в браузере с прокси)
```

### Доступ к сервисам через SOCKS5

```powershell
# В Windows PowerShell
vagrant ssh -- -D7777

# В браузере настроить SOCKS5: 127.0.0.1:7777

# Теперь доступны:
# - http://container.lxc         (LXC контейнеры)
# - http://localhost:3000        (сервисы в VM)
# - http://172.17.0.2            (Docker контейнеры)
```

## Дополнительная документация

Проект имеет модульную документацию для удобной навигации:

| Документ | Описание |
|----------|----------|
| **[README.md](README.md)** | Главная документация (вы здесь) |
| **[vm/README.md](vm/README.md)** | Структура папки vm/, скрипты и конфиги |
| **[vm/configs/README.md](vm/configs/README.md)** | Конфигурации LXC и SSH |
| **[vm/configs/lxc/dnsmasq.d/README.md](vm/configs/lxc/dnsmasq.d/README.md)** | Подробная документация по dnsmasq |

## Полезные ссылки

- [Документация Vagrant](https://www.vagrantup.com/docs)
- [VirtualBox Documentation](https://www.virtualbox.org/manual/)
- [Docker Documentation](https://docs.docker.com/)
- [LXC Documentation](https://linuxcontainers.org/lxc/documentation/)
- [SSHFS GitHub](https://github.com/libfuse/sshfs)
- [dnsmasq Documentation](http://www.thekelleys.org.uk/dnsmasq/doc.html)
