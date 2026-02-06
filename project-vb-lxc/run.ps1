# Перед запуском
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Запуск
# ./run.ps1
# 
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && ./run.ps1

$Env:VAGRANT_PREFER_SYSTEM_BIN = 0

vagrant up --provider=virtualbox

vagrant upload .env /home/vagrant/.env
vagrant upload run.sh /home/vagrant/run.sh

# Конвертируем окончания строк Windows -> Unix
vagrant ssh -c "dos2unix /home/vagrant/.env /home/vagrant/run.sh 2>/dev/null || sed -i 's/\r$//' /home/vagrant/.env /home/vagrant/run.sh"

vagrant ssh -- -t "bash /home/vagrant/run.sh"