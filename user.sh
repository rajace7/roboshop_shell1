script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component_name=user
schema_setup=mongo
func_nodejs


