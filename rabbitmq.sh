script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo rabbitmq appuser password is missing
  exit
fi

func_print_head " CONFIGURE EARLANG REPO "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
func_status_check

func_print_head " INSTALL ERLANG "
yum install erlang -y &>>${log_file}
func_status_check

func_print_head "\ CONFIGURE RABBITMQ REPO "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
func_status_check

func_print_head " INSTALL RABBITMQ "
yum install rabbitmq-server -y &>>${log_file}
func_status_check

func_print_head "ENABLE THE SERVICE "
systemctl enable rabbitmq-server &>>${log_file}
func_status_check

func_print_head " RESTART THE SERVICE "
systemctl start rabbitmq-server &>>${log_file}
func_status_check

func_print_head " ADD USER IN RABBITMQ "
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
func_status_check