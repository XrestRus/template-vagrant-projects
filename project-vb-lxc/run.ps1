# Перед запуском
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Запуск
# ./run.ps1
# 
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && ./run.ps1

$Env:VAGRANT_PREFER_SYSTEM_BIN = 0

vagrant up

vagrant upload .env /home/vagrant/.env
vagrant upload .env /home/vagrant/run.sh

vagrant ssh -- -t "bash /tmp/run.sh"