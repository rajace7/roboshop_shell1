script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head " CONFIGURE REDIS  REPO "
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y -y &>>${log_file}
func_status_check

func_print_head " DISABLE REDIS 8 VERSION "
dnf module enable redis:remi-6.2 -y -y &>>${log_file}
func_status_check

func_print_head " INSTALL REDIS "
yum install redis -y -y &>>${log_file}
func_status_check

func_print_head " CHECK IP ADDRESS "
netstat -lntp -y &>>${log_file}
func_status_check

func_print_head " CHANGE LOCAL IP ADDRESS TO GLOBAL IP ADDRESS "
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf -y &>>${log_file}
func_status_check

func_print_head "ENABLE THE SERVICE "
systemctl enable redis -y &>>${log_file}
func_status_check

func_print_head " RESTART THE SERVICE "
systemctl restart redis -y &>>${log_file}
func_status_check

func_print_head " CHECK NEW IP ADDRESS "
netstat -lntp -y &>>${log_file}
func_status_check
