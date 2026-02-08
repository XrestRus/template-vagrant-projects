# VM Directory

Эта папка содержит всё необходимое для работы виртуальной машины и монтируется в VM как `/vagrant/vm`.

## Навигация по документации

- **[Главная документация](../README.md)** — основная документация проекта
- **[Конфигурации](configs/README.md)** — подробнее про конфигурации LXC и SSH
- **[DNS домены](configs/lxc/dnsmasq.d/README.md)** — документация по dnsmasq и кастомным доменам

## Содержимое

### `env` — Системные настройки

Конфигурационный файл для bash скриптов внутри VM:

- `GIT_FULL_URL` — URL Git репозитория для клонирования
- `INSTALL_SCRIPT` — Скрипт установки проекта
- `SSHFS_URL` — Настройки SSHFS монтирования
- `SSH_PASSWORD` — Пароль для SSHFS

**Копируйте `env.example` как `env` и настройте под себя.**

### `scripts/` — Скрипты установки

Модульные bash скрипты для установки и настройки системы:

- `bootstrap.sh` — главный оркестратор, запускает все остальные
- `install-base.sh` — базовые пакеты (git, mc, curl, wget)
- `install-docker.sh` — Docker Engine + Docker Compose
- `install-lxc.sh` — LXC + встроенный dnsmasq
- `setup-ssh.sh` — настройка SSH для туннелирования
- `install-sshfs.sh` — SSHFS монтирование
- `setup-project.sh` — клонирование Git проекта
- `apply-configs.sh` — применение конфигураций через симлинки

### `configs/` — Конфигурации

Все конфигурации применяются через **симлинки**.

#### `configs/lxc/`

**`lxc-net`** — базовая настройка сети LXC  
**`default.conf`** — дефолтная конфигурация контейнеров  
**`dnsmasq.d/`** — кастомные DNS домены:
- `custom-domains.conf` — ваши домены
- `README.md` — подробная документация по dnsmasq

#### `configs/ssh/`

**`sshd_config`** — настройки SSH сервера (туннелирование, SOCKS5)

## Симлинки

Конфигурации применяются через симлинки автоматически при установке:

**LXC:**
- `vm/configs/lxc/lxc-net` → `/etc/default/lxc-net`
- `vm/configs/lxc/default.conf` → `/etc/lxc/default.conf`
- `vm/configs/lxc/dnsmasq.d/*.conf` → `/etc/lxc/dnsmasq.d/*.conf`

**SSH:**
- `vm/configs/ssh/sshd_config` → `/etc/ssh/sshd_config.d/99-custom.conf`

**Применение изменений:**

```bash
# LXC
vagrant ssh -c "sudo systemctl restart lxc-net"

# SSH
vagrant ssh -c "sudo systemctl restart sshd"
```

## Редактирование

Вы можете редактировать файлы в этой папке на Windows, и они **сразу доступны в VM** через монтирование VirtualBox.

**Важно:** Все файлы автоматически получают line endings `LF` благодаря `.gitattributes`.

## Использование

Файлы автоматически монтируются при старте VM через `Vagrantfile`:

```ruby
config.vm.synced_folder "vm/", "/vagrant/vm", type: "virtualbox"
```

Скрипты запускаются из монтированной папки:

```bash
bash /vagrant/vm/scripts/bootstrap.sh
```
