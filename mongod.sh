script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_printhead "configure mongod repo"
cp mongod.repo /etc/yum.repos.d/mongod.repo &>>${log_file}
func_stat_check

func_printhead "install mongodb server"
yum install mongodb-org -y &>>${log_file}
func_stat_check

func_printhead "enable the mongod"
systemctl enable mongod &>>${log_file}

func_printhead "start the mongod"
systemctl start mongod

func_printhead "check the local ip address"
netstat -lntp &>>${log_file}

func_printhead "change  the local ip address to global ip address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>${log_file}
func_stat_check

func_printhead "restart the mongod"
systemctl restart mongod

func_printhead "check the global  ip address"
netstat -lntp &>>${log_file}