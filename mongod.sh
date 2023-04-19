script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> COPY REPO FILE TO YUM.REPO.D >>>>>>>>>>>>\e[0m"
cp mongod.repo /etc/yum.repos.d/mongod.repo

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL MONGODB >>>>>>>>>>>>\e[0m"
yum install mongodb-org -y

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable mongod

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl start mongod

echo -e "\e[36m>>>>>>>>>>>>>>> CHECK LOCAL IP ADDRESS >>>>>>>>>>>>\e[0m"
netstat -lntp

echo -e "\e[36m>>>>>>>>>>>>>>> CHANGE IT TO GLOBAL IP ADDRESS >>>>>>>>>>>>\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart mongod

echo -e "\e[36m>>>>>>>>>>>>>>> CHECK GLOBAL IP ADDRESS >>>>>>>>>>>>\e[0m"
netstat -lntp