# Если проблемы с подключением
# $Env:VAGRANT_PREFER_SYSTEM_BIN = 0 
# vagrant ssh

ENV['VAGRANT_SERVER_URL'] = 'http://vagrant.elab.pro'

Vagrant.configure("2") do |config| 
  # Базовые настройки VM
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.hostname = "vagrant-devbox"
  
  # Настройки ресурсов VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "16384"
    vb.cpus = "4"
  end

  # Отключаем дефолтную shared folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # Монтируем всю папку vm/ (скрипты, конфиги, env)
  config.vm.synced_folder "vm/", "/vagrant/vm", type: "virtualbox"
  
  # Минимальная подготовка VM (без автоматической установки пакетов)
  config.vm.provision "shell", inline: <<-SHELL
  SHELL
end
