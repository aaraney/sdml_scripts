#!/bin/bash

# unset previous vars
unset MODEL_FNAMES
unset USGS_FNAMES
unset com_num
unset i

# check if model and usgs dir exist
if [ ! -d ./model/ ] && [ ! -d ./usgs/ ]; then
	echo "You are missing directories! model and usgs"
	echo "Place WBMsed files in model dir and gaging site files in usgs"
	echo "I just made them for you."
	mkdir usgs && mkdir model
	exit 1
  # Control will enter here if $DIRECTORY doesn't exist.
fi;


# set vars
MODEL_FNAMES=($(ls ./model/*.csv))
USGS_FNAMES=($(ls ./usgs/*.csv))

# get rid of 3 column line in model files
# check first
for i in ${MODEL_FNAMES[@]};
	do
		com_num=$(head -n1 ${i} | grep -o "model" | wc -l)
		if [ "$com_num" -eq 0 ];then
			tail -n +2 ${i} > ${i}.tmp && mv ${i}.tmp ${i}
		fi;
done;

unset com_num

#change the dates to USGS format
for i in ${MODEL_FNAMES[@]};
	do
		python formatter.py 1 ${i} > ${i}.tmp && mv ${i}.tmp ${i}
done;

# start merging the files together
mkdir -p merged
rm ./merged/*.csv
cp ./usgs/*.csv ./merged/

echo "Merging the following: "
i=0
for name in ./merged/*.csv;
do 
	echo "model: " ${MODEL_FNAMES[$i]} "usgs: " "$name"
	cat ${MODEL_FNAMES[$i]} >> "$name"
	let "i=i+1"
done;
unset i

for name in ./merged/*.csv;
do 
	python formatter.py 2 "${name}" > "${name}".tmp && mv "${name}".tmp "${name}"
done;

for name in ./merged/*.csv;
do 
	sort -u -k1 "$name" > "${name}".tmp && mv "${name}".tmp "${name}"
done;

for name in ./merged/*.csv;
do 
	cat <(echo "Date,GS,WBMsed") <(awk -F, 'NF>2' "${name}") > "${name}".tmp && mv "${name}".tmp "${name}"
done;
