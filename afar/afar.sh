#!/bin/bash
config_json='http://dreamafar.qiniudn.com/destination.json'
pic_base_url='http://dreamafar.qiniudn.com/'
output_path="$HOME/Pictures/afar"

if [[ ! -d $"output_path" ]]; then
    mkdir -p "$output_path"
    if [[ ! "$?" = "0" ]]; then
        echo 'mkdir error!'
        return 1
    fi
fi
list=$(curl --silent "$config_json" | pcregrep --multiline --only-matching=1 --only-matching=2 --om-separator=':' '"alias": "(\w+)",[^,]+,[^:]+: (\d+)')
for alias_count in $list;do
    array=(${alias_count//:/ })
    for id in $(seq 1 ${array[1]});do
        filename="${array[0]}_${id}.jpg"
        if [[ -f "$output_path/$filename" ]]; then
            echo "jump --------- $filename"
            continue
        fi
        url="$pic_base_url$filename"
        echo "downloading $url"
        wget --quiet --directory-prefix="$output_path" "$url"
        if [[ ! "$?" = "0" ]]; then
            echo "download ========= $url error!"
            continue
        fi
        sleep 0.5s
    done
done
