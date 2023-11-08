# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "bento/ubuntu-22.04"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "sA" do |sA|
    sA.vm.network "private_network", ip: '192.168.100.2', adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "100-net"
    sA.vm.network "forwarded_port", guest: 80, host: 9080
    sA.vm.network "public_network", bridge: "en0: Wi-Fi"
    sA.vm.hostname = "sA"
    sA.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y nginx traceroute tcpdump
        echo "192.168.100.2 mysyte.local" >> /etc/hosts
      SHELL
  end

  config.vm.define "sB" do |sB|
    sB.vm.network "private_network", ip: '192.168.100.3', adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "100-net"
    sB.vm.network "private_network", ip: '192.168.101.2', adapter: 3, netmask: "255.255.255.0", virtualbox__intnet: "101-net"
    sB.vm.hostname = "sB"
    sB.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y mysql-server traceroute tcpdump
        sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
        service mysql restart
      SHELL
  end

  config.vm.define "sC" do |sC|
    sC.vm.network "private_network", ip: '192.168.100.4', adapter: 2, netmask: "255.255.255.0", virtualbox__intnet: "100-net"
    sC.vm.network "private_network", ip: '192.168.102.2', adapter: 3, netmask: "255.255.255.0", virtualbox__intnet: "102-net"
    sC.vm.hostname = "sC"
    sC.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y nginx traceroute tcpdump
        echo "192.168.102.2 mysyte.local" >> /etc/hosts
        apt-get install -y php libapache2-mod-php php-mysql
        apt-get install -y curl
        curl -O https://wordpress.org/latest.tar.gz
        tar -zxvf latest.tar.gz -C /var/www/html/
        cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
        sed -i 's/database_name_here/wordpress/' /var/www/html/wordpress/wp-config.php
        sed -i 's/username_here/root/' /var/www/html/wordpress/wp-config.php
        sed -i 's/password_here/root/' /var/www/html/wordpress/wp-config.php
        sed -i 's/localhost/192.168.101.2/' /var/www/html/wordpress/wp-config.php
        service apache2 restart
      SHELL
  end
end
