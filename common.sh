application_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
rm -rf $log_file

func_print_head()
{
   echo -e "\e[35m>>>>>>>>>>>>>>> $1 >>>>>>>>>>>>\e[0m"
   echo -e "\e[35m>>>>>>>>>>>>>>> $1 >>>>>>>>>>>>\e[0m" &>>${log_file}
}

func_schema_setup()
{
  if [ "$schema_setup" == mongo ]; then
   func_print_head "COPY REPO FILE TO YUM.REPO.D"
  cp ${script_path}/mongod.repo /etc/yum.repos.d/mongod.repo

  func_print_head " INSTALL MONGOD CLIENT "
  yum install mongodb-org-shell -y &>>${log_file}

 func_print_head " LOAD THE SCEHMA "
  mongo --host mongodb-dev.rpadaladevops.online </app/schema/${component_name}.js &>>${log_file}

  func_print_head" RESTART THE SERVICE "
  systemctl restart ${component_name}
  fi

  if [ "$schema_setup" == mysql ]; then
    func_print_head " INSTALL MYSQL CLIENT "
    yum install mysql -y &>>${log_file}

    func_print_head " LOAD THE SCEHMA "
    mysql -h mysql.rpadaladevops.online -uroot -p${mysql_root_password} < /app/schema/${component_name}.sql &>>${log_file}

     func_print_head " RESTART THE SERVICE "
      systemctl restart ${component_name}
  fi

}
func_status_check()
{
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    echo "for  more details plz go to /tmp/roboshop.log"
    exit 1
  fi
}

func_app_prereq()
{

  func_print_head " ADD APPLICATION USER "
  id ${application_user} &>>${log_file}
  if [ $? -ne 0 ]; then
    useradd ${application_user} &>>${log_file}
  fi
    func_status_check

    func_print_head " CREATE APP DIRECTORY "
    rm -rf /app
    mkdir /app

    func_print_head " DOWNLOAD THE APPLCATION CONTENT "
    curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip &>>${log_file}
    func_status_check
    cd /app

    func_print_head " UNZIP APPLICATION CONTENT "
    unzip /tmp/${component_name}.zip &>>${log_file}
    func_status_check
}

func_systemd_setup(){

  func_print_head "COPY SERVICE FILE TO SYSTEMD"
  cp ${script_path}/${component_name}.service /etc/systemd/system/${component_name}.service &>>${log_file}
  func_status_check

  func_print_head "RELOAD THE SERVICE"
  systemctl daemon-reload &>>${log_file}
  func_status_check

  func_print_head "ENABLE THE SERVICE"
  systemctl enable ${component_name} &>>${log_file}
  func_status_check

  func_print_head  "RESTART THE SERVICE"
  systemctl restart ${component_name} &>>${log_file}
  func_status_check

}

func_nodejs(){
func_print_head "CONFIGURE NODE JS REPO"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
func_status_check

func_print_head "INSTALL NODE JS"
yum install nodejs -y &>>${log_file}
func_status_check

func_app_prereq

func_print_head "INSTALL THE DEPENDENCIES"
npm install &>>${log_file}
func_status_check

func_systemd_setup
func_schema_setup


}

func_java()
{
  func_print_head " INSTALL MAVEN "
  yum install maven -y &>>${log_file}
  func_status_check

  func_app_prereq

  func_print_head " INSTALL THE DEPENDENCIES "
  mvn clean package &>>${log_file}
  func_status_check
  mv target/${component_name}-1.0.jar ${component_name}.jar &>>${log_file}
  func_status_check

 func_systemd_setup
  func_schema_setup


}

func_python()
{
  func_print_head "install python3.6"
  yum install python36 gcc python3-devel -y &>>${log_file}
  func_status_check

  func_app_prereq

  func_print_head " INSTALL THE DEPENDENCIES"
  pip3.6 install -r requirements.txt &>>${log_file}
  func_status_check

  func_print_head " update rabbitmq password in systemd service file"
  sed -i -e 's|rabbitmq_appuser_password|${rabbitmq_appuser_password}|' ${script_path}/${component_name}.service  &>>${log_file}
  func_status_check

  func_systemd_setup
}