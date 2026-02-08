# Конфигурации

Папка `vm/configs/` содержит **готовые к использованию** конфигурации, которые применяются через **симлинки**.

## Навигация по документации

- **[Главная документация](../../README.md)** — основная документация проекта
- **[VM Directory](../README.md)** — документация папки vm/
- **[DNS домены](lxc/dnsmasq.d/README.md)** — подробная документация по dnsmasq и кастомным доменам

---

### LXC конфигурации

#### Базовая сеть

**`vm/configs/lxc/lxc-net`** — настройка сети LXC (готов к использованию):

```bash
USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DOMAIN="lxc"
LXC_DHCP_CONFILE="/etc/lxc/dnsmasq.d"  # Уже настроено!
```

Контейнеры получают IP из диапазона `10.0.3.2-254` и доступны по именам `*.lxc`.

#### Дефолтная конфигурация контейнеров

**`vm/configs/lxc/default.conf`** — сетевые настройки новых контейнеров (готов к использованию):

```bash
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
```

Эти настройки применяются ко всем новым контейнерам автоматически.

#### Кастомные DNS домены

**`vm/configs/lxc/dnsmasq.d/custom-domains.conf`** — добавь свои домены:

Файл уже создан с примерами. Раскомментируй нужные строки или добавь свои:

```bash
# Пример: статические адреса для контейнеров
address=/web.myproject.local/10.0.3.100
address=/api.myproject.local/10.0.3.101
address=/db.myproject.local/10.0.3.102

# Алиасы
cname=www.myproject.local,web.myproject.local

# Wildcard домен (все *.app -> 10.0.3.200)
address=/.app/10.0.3.200
```

**Применить изменения:**

```bash
# Отредактируй файл в Windows
notepad vm\configs\lxc\dnsmasq.d\custom-domains.conf

# Перезапусти LXC сеть
vagrant ssh -c "sudo systemctl restart lxc-net"
```

** Подробнее:** [vm/configs/lxc/dnsmasq.d/README.md](./vm/configs/lxc/dnsmasq.d/README.md)

### SSH конфигурация

**`vm/configs/ssh/sshd_config`** — настройки SSH сервера (готов к использованию):

Все необходимые настройки уже включены:

```bash
# SOCKS5 прокси и туннелирование
AllowTcpForwarding yes
PermitTunnel yes

# Аутентификация
PubkeyAuthentication yes
PasswordAuthentication yes

# X11 forwarding
X11Forwarding yes

# Keep-alive для долгих сессий
ClientAliveInterval 60
ClientAliveCountMax 3
```

Конфиг применяется автоматически при установке. Если нужно изменить:

```bash
# Отредактируй в Windows
notepad vm\configs\ssh\sshd_config

# Перезапусти SSH
vagrant ssh -c "sudo systemctl restart sshd"
```

### Как узнать IP контейнера

```bash
sudo lxc-info -n container_name -iH
sudo lxc-ls -f
```
