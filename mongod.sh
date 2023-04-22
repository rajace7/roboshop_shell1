script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "configure mongod repo"
cp mongod.repo /etc/yum.repos.d/mongod.repo &>>${log_file}
func_status_check

func_print_head "install mongodb server"
yum install mongodb-org -y &>>${log_file}
func_status_check

func_print_head "enable the mongod"
systemctl enable mongod &>>${log_file}

func_print_head "start the mongod"
systemctl start mongod

func_print_head "check the local ip address"
netstat -lntp &>>${log_file}

func_print_head "change  the local ip address to global ip address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
func_status_check

func_print_head "restart the mongod"
systemctl restart mongod

func_print_head "check the global  ip address"
netstat -lntp &>>${log_file}