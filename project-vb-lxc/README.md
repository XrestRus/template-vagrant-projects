# Шаблон для проекта в VirtualBox -> LXC

Это шаблон для `Windows 11`.
После установки можно зайти и запустить установку проекта из репозитория

## Настройка

Создать `.env` по примеру `.env.example`
В `.env` - Указать ссылку на проект

### Синхронизация

Пока отключена, у Windows и Linux много проблем с совместимостью

### Соединение по sshfs

Можно использовать

- https://github.com/winfsp/sshfs-win
- https://github.com/evsar3/sshfs-win-manager - В качестве GUI

Также можно использовать sshfs в контейнере

### Использование внутреннего DNS при LXC

Для трансляции запросов через DNS контейнера можно использовать ssh

- `vagrant ssh -- -D7777`

В браузере можно использовать расширение [SwitchyOmega](https://chromewebstore.google.com/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif)
и настроить подлючение к прокси по `127.0.0.1:7777` - `SOCKS5`

## Запуск

Запуск команды

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; ./run.ps1
```

Команда делает:

- Ставит в VB - `ubuntu/jammy64`
- Ставит в среду `lxc`, `git`, ...
- Подключает sshfs (если есть)
- Скачиват репозиторий
- Предоставит оболочку для управления

## Управление

Команды vagrant

- `vagrant ssh` - Подключиться к контейнеру, если есть проблемы с доступом, то сперва вызвать `$Env:VAGRANT_PREFER_SYSTEM_BIN = 0`
- `vagrant destroy` - Удалить контейнер
