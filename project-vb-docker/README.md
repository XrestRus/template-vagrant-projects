# Шаблон для проекта в VirtualBox -> Docker

Это шаблон для `Windows 11`.
После установки можно зайти и запустить установку проекта из репозитория

## Настройка

Создать `.env` по примеру `.env.example`
В `.env` - Указать ссылку на проект (опционально)

### Что устанавливается

- Ubuntu Noble 24.04 LTS (ubuntu/noble64)
- Git
- Midnight Commander (mc)
- OpenSSH Server
- Docker Engine
- Docker Compose plugin

### Синхронизация

Пока отключена, у Windows и Linux много проблем с совместимостью

### Соединение по sshfs

Можно использовать

- https://github.com/winfsp/sshfs-win
- https://github.com/evsar3/sshfs-win-manager - В качестве GUI

Также можно использовать sshfs в контейнере

### Использование внутреннего DNS при Docker

Для трансляции запросов через DNS контейнера можно использовать ssh

- `vagrant ssh -- -D7777`

В браузере можно использовать расширение [SwitchyOmega](https://chromewebstore.google.com/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)
и настроить подключение к прокси по `127.0.0.1:7777` - `SOCKS5`

## Запуск

Запуск команды

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; ./run.ps1
```

Команда делает:

- Ставит в VB - `ubuntu/noble64`
- Ставит в среду `Docker`, `Docker Compose`, `git`, `mc`, `openssh-server`
- Подключает sshfs (если указан)
- Скачивает репозиторий (если указан `GIT_FULL_URL`)
- Запускает скрипт установки проекта `install.sh` (если существует)
- Предоставляет оболочку для управления

## Управление

Команды vagrant

- `vagrant ssh` - Подключиться к контейнеру, если есть проблемы с доступом, то сперва вызвать `$Env:VAGRANT_PREFER_SYSTEM_BIN = 0`
- `vagrant halt` - Остановить контейнер
- `vagrant destroy` - Удалить контейнер

## Работа с Docker

После подключения через `vagrant ssh` можно использовать Docker команды без sudo:

```bash
docker ps
docker compose up -d
docker images
```

## Дополнительные возможности

### Автоматическая установка проекта

Если в вашем Git репозитории есть скрипт установки, он будет автоматически запущен после клонирования проекта.

По умолчанию ищется файл `install.sh` в корне проекта. Вы можете указать кастомный путь к скрипту через переменную `INSTALL_SCRIPT` в файле `.env`:

```bash
# Пример для скрипта в другой директории
INSTALL_SCRIPT="scripts/setup.sh"

# Пример для скрипта с другим именем
INSTALL_SCRIPT="deploy.sh"
```

### Порты

Для проброса портов из контейнеров наружу, добавьте в `Vagrantfile`:

```ruby
config.vm.network "forwarded_port", guest: 80, host: 8080
config.vm.network "forwarded_port", guest: 443, host: 8443
```
