#!/bin/bash


DISK_LABEL="/dev/disk/by-partlabel/ydb_disk_ssd_01"
YDBD_URL="https://binaries.ydb.tech/release/23.2.12/ydbd-23.2.12-linux-amd64.tar.gz"

usage() {
    echo "setup_mirror_3_dc.sh --hosts <hosts_file> --disks <disk1> <disk2> <disk3>"
}

tmp_dir=

cleanup() {
    if [ -n "$tmp_dir" ]; then
        rm -rf $tmp_dir
    fi
}

trap cleanup EXIT

if ! which parallel-ssh >/dev/null; then
    echo "parallel-ssh not found, you should install pssh"
    exit 1
fi

if ! which parallel-scp >/dev/null; then
    echo "parallel-ssh not found, you should install pssh"
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --hosts)
            shift
            hosts=$1
            shift
            ;;
        --disks)
            shift
            disks=()
            for arg in "$@"
            do
                if [[ $arg == -* ]]
                then
                    break
                fi
                disks+=("$arg")
                shift
            done
            ;;
        *)
            usage
            exit 1
            ;;
    esac   
done

if [ -z "$hosts" ]; then
    echo "Hosts file not specified"
    usage
    exit 1
fi

if [ ! -f "$hosts" ]; then
    echo "Hosts file $hosts not found"
    exit 1
fi

if [ -z "$disks" ]; then
    echo "Disk not specified"
    usage
    exit 1
fi

if [[ ${#disks[@]} != 3 ]]; then
    echo "You should enter three disks"
    usage
    exit 1
fi

script_path=`readlink -f "$0"`
script_dir=`dirname "$script_path"`
common_dir="$script_dir/common"

"$common_dir"/copy_ssh_keys.sh --hosts "$hosts"

echo "Killing YDB if it is running"
parallel-ssh -h "$hosts" "sudo pkill -9 ydbd"
echo "Partition disk!"
declare -i number=1
for disk in "${disks[@]}"
do
    "$common_dir"/partition_disk.sh --hosts "$hosts" --disk "$disk" --number "$number"
    ((number++))
done
echo "Transparent hugepages!"
"$common_dir"/enable_transparent_hugepages.sh --hosts "$hosts"

parallel-ssh -h "$hosts" "sudo apt-get update; sudo apt-get install -yyq libaio1 libidn11"

tmp_dir=`mktemp -d`
echo "Generate configs!"
"$script_dir"/generate_configs.py --disks "${disks[@]}" --output-dir $tmp_dir --hosts "$hosts"
if [[ $? -ne 0 ]]; then
    echo "Failed to generate configs"
    exit 1
fi

wget -q $YDBD_URL $tmp_dir

echo "Setup!"
"$script_dir"/setup.sh --ydbd "$script_dir"/ydbd-23.2.12-linux-amd64.tar.gz --config $tmp_dir/setup_config
if [[ $? -ne 0 ]]; then
    echo "Failed to setup YDB"
    exit 1
fi

echo "Congrats, your YDB cluster is ready!"
