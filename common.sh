application_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head()
{
   echo -e "\e[35m>>>>>>>>>>>>>>> $1 >>>>>>>>>>>>\e[0m"
}

schema_setup()
{
  echo -e "\e[36m>>>>>>>>>>>>>>> COPY REPO FILE TO YUM.REPO.D >>>>>>>>>>>>\e[0m"
  cp ${script_path}/mongod.repo /etc/yum.repos.d/mongod.repo

  echo -e "\e[36m>>>>>>>>>>>>>>> INSTALL MONGOD CLIENT >>>>>>>>>>>>\e[0m"
  yum install mongodb-org-shell -y

  echo -e "\e[36m>>>>>>>>>>>>>>> LOAD THE SCEHMA >>>>>>>>>>>>\e[0m"
  mongo --host mongodb-dev.rpadaladevops.online </app/schema/catalogue.js

  echo -e "\e[36m>>>>>>>>>>>>>>> RESTART THE SERVICE >>>>>>>>>>>>\e[0m"
  systemctl restart catalogue
}

func_nodejs(){
print_head "CONFIGURE NODE JS REPO"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "INSTALL NODE JS"
yum install nodejs -y

print_head "ADD APPLICATION USER"
useradd ${application_user}

print_head "CREATE APP DIRECTORY"
rm -rf /app
mkdir /app

print_head "DOWNLOAD THE APPLCATION CONTENT"
curl -L -o /tmp/${component_name}.zip https://roboshop-artifacts.s3.amazonaws.com/${component_name}.zip
cd /app

print_head "UNZIP APPLICATION CONTENT"
unzip /tmp/${component_name}.zip

print_head "INSTALL THE DEPENDENCIES"
npm install

print_head "COPY SERVICE FILE TO SYSTEMD"
cp ${script_path}/${component_name}.service /etc/systemd/system/${component_name}.service

print_head "RELOAD THE SERVICE"
systemctl daemon-reload

print_head "ENABLE THE SERVICE"
systemctl enable ${component_name}

print_head  "RESTART THE SERVICE"
systemctl restart ${component_name}
}