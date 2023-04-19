script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> CONFIGURE EARLANG REPO >>>>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL ERLANG >>>>>>>>>>>>\e[0m"
yum install erlang -y

echo -e "\e[36m>>>>>>>>>>>>>>> CONFIGURE RABBITMQ REPO >>>>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL RABBITMQ >>>>>>>>>>>>\e[0m"
yum install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>>>>>> ENABLE THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl enable rabbitmq-server

echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
systemctl start rabbitmq-server

echo -e "\e[36m>>>>>>>>>>>>>>> ADD USER IN RABBITMQ >>>>>>>>>>>>\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"