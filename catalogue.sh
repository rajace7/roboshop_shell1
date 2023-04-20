script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


component_name=catalogue
func_nodejs


echo -e "\e[36m>>>>>>>>>>>>>>> COPY REPO FILE TO YUM.REPO.D >>>>>>>>>>>>\e[0m"
cp ${script_path}/mongod.repo /etc/yum.repos.d/mongod.repo

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL MONGOD CLIENT >>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>>>>>> LOAD THE SCEHMA >>>>>>>>>>>>\e[0m"
mongo --host mongodb-dev.rpadaladevops.online </app/schema/catalogue.js

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl restart catalogue