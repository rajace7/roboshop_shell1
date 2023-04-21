script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

mysql_root_password=$1
component_name=shipping
schema_setup=mysql



if [ -z "$mysql_root_password" ]; then
  echo mysql root password is missing
  exit
fi

component_name=shipping
schema_setup=mysql
func_java




