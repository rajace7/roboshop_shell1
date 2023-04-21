application_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head()
{
   echo -e "\e[35m>>>>>>>>>>>>>>> $1 >>>>>>>>>>>>\e[0m"
}

func_schema_setup()
{
  if [ "$schema_setup" == mongo ]; then
   func_print_head "COPY REPO FILE TO YUM.REPO.D"
  cp ${script_path}/mongod.repo /etc/yum.repos.d/mongod.repo

  func_print_head " INSTALL MONGOD CLIENT "
  yum install mongodb-org-shell -y

 func_print_head " LOAD THE SCEHMA "
  mongo --host mongodb-dev.rpadaladevops.online </app/schema/${component_name}.js

  func_print_head" RESTART THE SERVICE "
  systemctl restart ${component_name}
  fi

  if [ "$schema_setup" == mysql ]; then
    func_print_head " INSTALL MYSQL CLIENT "
    yum install mysql -y

    func_print_head " LOAD THE SCEHMA "
    mysql -h mysql.rpadaladevops.online -uroot -p${mysql_root_password} < /app/schema/${component_name}.sql

     func_print_head" RESTART THE SERVICE "
      systemctl restart ${component_name}
  fi

}

func_app_prereq()
{
  func_print_head " ADD APPLICATION USER "
    useradd ${application_user}

    func_print_head " CREATE APP DIRECTORY "
    rm -rf /app
    mkdir /app

    func_print_head " DOWNLOAD THE APPLCATION CONTENT "
    curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip
    cd /app

    func_print_head " UNZIP APPLICATION CONTENT "
    unzip /tmp/${component_name}.zip
}

func_systemd_setup(){

  func_print_head "COPY SERVICE FILE TO SYSTEMD"
  cp ${script_path}/${component_name}.service /etc/systemd/system/${component_name}.service

  func_print_head "RELOAD THE SERVICE"
  systemctl daemon-reload

  func_print_head "ENABLE THE SERVICE"
  systemctl enable ${component_name}

  func_print_head  "RESTART THE SERVICE"
  systemctl restart ${component_name}

}

func_nodejs(){
func_print_head "CONFIGURE NODE JS REPO"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "INSTALL NODE JS"
yum install nodejs -y

func_app_prereq

func_print_head "INSTALL THE DEPENDENCIES"
npm install

func_schema_setup
func_systemd_setup

}

func_java()
{
  func_print_head " INSTALL MAVEN "
  yum install maven -y

  func_app_prereq

  func_print_head " INSTALL THE DEPENDENCIES "
  mvn clean package
  mv target/shipping-1.0.jar shipping.jar

  func_schema_setup
  func_systemd_setup

}