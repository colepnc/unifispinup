ip="192.168.1.22"
netmask="255.255.255.0"
gateway="192.168.1.1"
dns="192.168.1.2"
apt-get update
apt-get dist-upgrade -y
apt-get install cron-apt -y
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysct.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysct.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysct.conf
sysctl -p
sed -i -e 's/iface eth0 inet dhcp/#iface eth0 inet dhcp/g' /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "address $ip" >> /etc/network/interfaces
echo "netmask $netmask" >> /etc/network/interfaces
echo "gateway $gateway" >> /etc/network/interfaces
echo "dns-nameservers $dns" >> /etc/network/interfaces
echo "## Debian/Ubuntu" >> /etc/apt/sources.list
echo "# stable => unifi4" >> /etc/apt/sources.list
echo "# deb http://www.ubnt.com/downloads/unifi/debian unifi4 ubiquiti" >> /etc/apt/sources.list
echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti" >> /etc/apt/sources.list
echo "# deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" >> /etc/apt/sources.list
echo "# oldstable => unifi3" >> /etc/apt/sources.list
echo "# deb http://www.ubnt.com/downloads/unifi/debian unifi3 ubiquiti" >> /etc/apt/sources.list
echo "# deb http://www.ubnt.com/downloads/unifi/debian oldstable ubiquiti" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50
apt-get update
apt-get install unifi -y
sed -i -e 's/# unifi.https.port=8443/unifi.https.port=443/g' /usr/lib/unifi/data/system.properties
apt-get install htop -y
iptables -F
iptables -P INPUT DROP
iptables -A INPUT -i lo -p all -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8843 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8880 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP
su
iptables-save > /etc/iptables.conf
su unifi
sed -i "13i iptables-restore < /etc/iptables.conf" /etc/rc.local
reboot
