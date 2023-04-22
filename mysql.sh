script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

mysql_root_password=$1

if [ -z  "$mysql_root_password" ]; then
  echo "sql root password is missing"
  exit
fi

func_print_head " DISABLE MYSQL 8 "
dnf module disable mysql -y &>>${log_file}
func_status_check

func_print_head "COPY REPO FILE TO YUM.REPO.D"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
func_status_check

func_print_head " INSTALL MYSQL "
yum install mysql-community-server -y &>>${log_file}
func_status_check

func_print_head "ENABLE THE SERVICE "
systemctl enable mysqld &>>${log_file}
func_status_check

func_print_head " RESTART THE SERVICE "
systemctl restart mysqld &>>${log_file}
func_status_check

func_print_head" SET MYSQL PASSWORD "
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
func_status_check

#mysql -uroot -p${mysql_root_password}
