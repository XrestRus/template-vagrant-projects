# Перед запуском установите политику выполнения:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# 
# Запуск:
# ./run.ps1
# 
# Или одной командой:
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; ./run.ps1

# Отключаем использование системного SSH для Vagrant
$Env:VAGRANT_PREFER_SYSTEM_BIN = 0

# Запуск VM с VirtualBox провайдером
vagrant up --provider=virtualbox
