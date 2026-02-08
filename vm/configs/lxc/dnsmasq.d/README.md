# Кастомные DNS конфигурации для LXC

Эта папка содержит конфигурационные файлы dnsmasq для настройки кастомных доменов LXC контейнеров.

## Навигация по документации

- **[Главная документация](../../../../README.md)** — основная документация проекта
- **[VM Directory](../../../README.md)** — документация папки vm/
- **[Конфигурации](../../README.md)** — документация конфигураций

---

## Быстрый старт

### 1. Отредактируйте конфигурационный файл

Файл `custom-domains.conf` уже создан с примерами. Раскомментируйте нужные строки или добавьте свои:

```bash
# Редактируйте в Windows
notepad vm\configs\lxc\dnsmasq.d\custom-domains.conf

# Или создайте новый файл для вашего проекта
notepad vm\configs\lxc\dnsmasq.d\myproject.conf
```

### 2. Добавьте DNS записи

```bash
# myproject.conf

# Статический IP для контейнера
address=/web.myproject.local/10.0.3.100
address=/db.myproject.local/10.0.3.101

# Алиас
cname=www.myproject.local,web.myproject.local
```

### 3. Перезапустите VM или LXC сеть

```bash
# Внутри VM
sudo systemctl restart lxc-net

# Или из хоста
vagrant reload
```

### 4. Проверьте DNS

```bash
# Внутри VM
ping web.myproject.local
dig @10.0.3.1 web.myproject.local

# Через SOCKS5 прокси в браузере
http://web.myproject.local
```

## Синтаксис dnsmasq

### Статические адреса

```bash
# Формат: address=/hostname.domain/IP
address=/mycontainer.local/10.0.3.50
```

### Wildcard домены

```bash
# Все *.app резолвятся на 10.0.3.100
address=/.app/10.0.3.100
```

### CNAME (алиасы)

```bash
# www.example.local -> example.local
cname=www.example.local,example.local
```

### Домены для поиска

```bash
# Позволяет использовать короткие имена: ping web вместо ping web.local
domain=local
domain=dev
```

### Комментарии

```bash
# Это комментарий
address=/test.local/10.0.3.1  # Комментарий в конце строки
```

## Примеры использования

### Пример 1: Веб-проект

```bash
# configs/lxc/dnsmasq.d/webapp.conf

address=/web.myapp.local/10.0.3.10
address=/api.myapp.local/10.0.3.11
address=/db.myapp.local/10.0.3.12

cname=www.myapp.local,web.myapp.local
cname=admin.myapp.local,web.myapp.local
```

### Пример 2: Микросервисы

```bash
# configs/lxc/dnsmasq.d/microservices.conf

# Gateway
address=/gateway.services/10.0.3.20

# Сервисы
address=/auth.services/10.0.3.21
address=/users.services/10.0.3.22
address=/orders.services/10.0.3.23
address=/payments.services/10.0.3.24

# Wildcard для новых сервисов
address=/.services/10.0.3.30
```

### Пример 3: Окружения (dev/staging/prod)

```bash
# configs/lxc/dnsmasq.d/environments.conf

# Development
address=/app.dev/10.0.3.100
address=/api.dev/10.0.3.101

# Staging
address=/app.staging/10.0.3.110
address=/api.staging/10.0.3.111

# Production (локальная копия)
address=/app.prod/10.0.3.120
address=/api.prod/10.0.3.121
```

## Как узнать IP контейнера

### Вариант 1: lxc-info

```bash
sudo lxc-info -n container_name -iH
```

### Вариант 2: lxc-ls

```bash
sudo lxc-ls -f
```

### Вариант 3: Внутри контейнера

```bash
sudo lxc-attach -n container_name
hostname -I
```

## Как назначить статический IP контейнеру

### В конфигурации контейнера

```bash
# /var/lib/lxc/mycontainer/config

# Сеть
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:aa:bb:cc
lxc.net.0.ipv4.address = 10.0.3.100/24
lxc.net.0.ipv4.gateway = 10.0.3.1
```

### Или через dnsmasq DHCP

```bash
# В lxc-net или в dnsmasq.d/*.conf
dhcp-host=00:16:3e:aa:bb:cc,10.0.3.100,mycontainer
```

## Отладка

### Проверить конфигурацию dnsmasq

```bash
# Проверить синтаксис
dnsmasq --test -C /etc/default/lxc-net

# Просмотреть логи
sudo journalctl -u lxc-net -f
```

### Проверить DNS резолвинг

```bash
# Из VM
dig @10.0.3.1 mycontainer.local
nslookup mycontainer.local 10.0.3.1

# С хоста через SOCKS5
# Настройте браузер на SOCKS5: 127.0.0.1:7777
# vagrant ssh -- -D7777
```

### Перезапуск LXC сети

```bash
sudo systemctl restart lxc-net
```

## Важные замечания

1. **IP адреса должны быть из сети LXC** (по умолчанию `10.0.3.0/24`)
2. **Файлы должны иметь расширение `.conf`** (не `.conf.example`)
3. **После изменений нужен перезапуск** `lxc-net`
4. **Симлинки работают автоматически** — изменения применяются сразу после перезапуска `lxc-net`
5. **Для доступа с хоста используйте SOCKS5 прокси**: `vagrant ssh -- -D7777`

## Дополнительно

- [Документация dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
- [Документация LXC](https://linuxcontainers.org/lxc/documentation/)
- [Примеры dnsmasq конфигов](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq.conf.example)
