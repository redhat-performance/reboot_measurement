#!/bin/bash
#
# Define options
#
working_dir=`pwd`
iterations=1
boot_version="v1.0"
test_name="reboot_measurement"

usage()
{
	echo "Usage: $0"
	echo "  --host_config: host configuration information"
	echo "  --home_parent: parent directory of the home directory"
	echo "  --iterations: number of iterations to run reboot test"
	echo "  --run_user: user running the test"
	echo "  --sysname: name of the system using"
	echo "  --sys_type: aws/azure/local...."
	echo "  --tuned_setting:  system tuned using."
	echo "  --usage: this is usage message"
	echo "  --working_dir: Directory to run ansible from, default is current working directory"
	echo " Three files are required by ansible, user has to create/provide."
	echo " These files must be in the designated working directory"
	echo "   ansible_vars.yml"
	echo "   ansible_test_group"
	echo "   ignore.yml"
	echo ""
	echo " Files content/format"
	echo " ansible_vars.yml"
	echo ""
	echo " ---"
	echo " config_info:"
	echo "   test_user: <user logging in as>"
	echo "   ssh_key: <full path to the ssh key to use>"
	echo "   user_parent: <parent directory of the users home directory>"
	echo ""
	echo "  ansible_test_group"
	echo ""
	echo " ---"
	echo " test_group_list:"
	echo "   - <host name>"
	echo " "
	echo " ignore.yml (dummy file to keep ansible happy)"
	echo ""
	echo " ---"
	echo " ignore:"
	echo "   ignore: 0"

	exit
}

ARGUMENT_LIST=(
	"host_config"
	"home_parent"
	"iterations"
	"run_user"
	"sysname"
	"sys_type"
	"tuned_setting"
	"working_dir"
)

NO_ARGUMENTS=(
	"usage"
)

# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --longoptions "$(printf "%s," "${NO_ARGUMENTS[@]}")" \
    --name "$(basename "$0")" \
    --options "h" \
    -- "$@"
)

if [ $? -ne 0 ]; then
	exit
fi

eval set --$opts

while [[ $# -gt 0 ]]; do
        case "$1" in
		--host_config)
			config=`echo ${2} | cut -d'"' -f 2`
			shift 2
		;;
                --home_parent)
                        home_root=${2}
			shift 2
                ;;
                --iterations)
                        iterations=${2}
			shift 2
                ;;
                --run_user)
                        user=${2}
			shift 2
                ;;
		--sys_type)
			sys_type=${2}
			shift 2
		;;
		--sysname)
			sysname=${2}
			shift 2
		;;
                --tuned_setting)
                        tuned_setting=${2}
			shift 2
		;;
		--usage)
			usage
		;;
		--working_dir)
			working_dir=${2}
			shift 2
		;;
		-h)
			usage
		;;
		--)
			break; 
		;;
		*)
			echo option not found $1
			usage
		;;
        esac
done

#
# Execute the playbook for the reboot test.
#
cd $working_dir
for iteration in  `seq 1 1 $iterations`
do
	ansible-playbook -i ./inventory --extra-vars "working_dir=${working_dir} iteration=${iteration} ansible_python_interpreter=auto sys_type=${sys_type} to_tuned_setting=${tuned_setting} sysname=${sysname} boot_version=${boot_version} test_name=${test_name}" ${working_dir}/workloads/reboot_me*/reboot_measurement/reboot_measure.yml
done
exit 0
