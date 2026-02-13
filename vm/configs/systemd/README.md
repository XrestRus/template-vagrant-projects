# systemd Конфигурации

Эта папка содержит конфигурационные файлы для различных systemd компонентов.

---

## 📄 `resolved.conf` — systemd-resolved

**Для чего**: Настраивает DNS резолвинг в хост VM, чтобы использовать **LXC dnsmasq** (`10.0.3.1`)

### 🔧 Применение конфигурации

Конфигурация применяется автоматически через **`apply-configs.sh`**:

```bash
vagrant ssh -c "bash /vagrant/vm/scripts/apply-configs.sh"
```

Или вручную:

```bash
vagrant ssh
sudo ln -sf /vagrant/vm/configs/systemd/resolved.conf /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved
```

### 🧪 Проверка

После применения проверь статус:

```bash
# Проверить статус systemd-resolved
resolvectl status

# Должен показать примерно:
# Global
#            Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
#     resolv.conf mode: stub
#   Current DNS Server: 10.0.3.1
#          DNS Servers: 10.0.3.1
# Fallback DNS Servers: 8.8.8.8 8.8.4.4
#           DNS Domain: local lxc test

# Проверить резолвинг
ping -c 2 mycontainer.lxc
ping -c 2 adminka.kladovochka.test
```

### 📝 Параметры

| Параметр | Значение | Описание |
|----------|----------|----------|
| `DNS` | `10.0.3.1` | LXC dnsmasq адрес |
| `FallbackDNS` | `8.8.8.8 8.8.4.4` | Google DNS как запасной |
| `Domains` | (закомментировано) | Домены для автопоиска |

### 🔄 После изменений

После редактирования `resolved.conf`:

```bash
vagrant ssh -c "sudo systemctl restart systemd-resolved"
```

---

## 📖 См. также

- **[LXC конфигурации](../lxc/)** — настройка LXC dnsmasq
- **[dnsmasq.d/](../lxc/dnsmasq.d/)** — кастомные DNS записи
- **[Главный README](../../../README.md)** — навигация по проекту
