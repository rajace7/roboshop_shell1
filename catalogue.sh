script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


component_name=catalogue
func_nodejs
schema_setup=mongo



