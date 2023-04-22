script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component_name=frontend

func_printhead "INSTALL NGINX WEBSERVER"
yum install nginx -y &>>${log_file}
func_status_check

func_printhead " ENABLE NGINX WEBSERVER "
systemctl enable nginx &>>${log_file}
func_status_check

func_printhead " RESTART NGINX WEBSERVER "
systemctl start nginx &>>${log_file}
func_status_check

func_printhead " REMOVE DEFAULT CONTENT ON WEBSERVER"
rm -rf /usr/share/nginx/html/* &>>${log_file}
func_status_check

func_printhead " DOWNLOAD THE APP CONTENT "
curl -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip &>>${log_file}
func_status_check

cd /usr/share/nginx/html

func_printhead " UNZIP THE APP CONTENT "
unzip /tmp/${component_name}.zip &>>${log_file}
func_status_check

func_printhead " COPY REVERSE PROXY FILE TO DEFAULT.D FOLDER m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
func_status_check

func_printhead "  RESTART NGINX WEBSERVER "
systemctl restart nginx &>>${log_file}
func_status_check