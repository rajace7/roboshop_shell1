
echo -e "\e[36m>>>>>>>>>>>>>>> CONFIGURE REDIS  REPO >>>>>>>>>>>>\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[36m>>>>>>>>>>>>>>> DISABLE REDIS 8 VERSION >>>>>>>>>>>>\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL REDIS >>>>>>>>>>>>\e[0m"
yum install redis -y

echo -e "\e[36m>>>>>>>>>>>>>>> CHECK IP ADDRESS >>>>>>>>>>>>\e[0m"
netstat -lntp

echo -e "\e[36m>>>>>>>>>>>>>>> CHANGE IP ADDRESS >>>>>>>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable redis

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart redis

echo -e "\e[36m>>>>>>>>>>>>>>> CHECK NEW IP ADDRESS >>>>>>>>>>>>\e[0m"
netstat -lntp
