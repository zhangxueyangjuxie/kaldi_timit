#!/bin/bash
#descript : get dataset base information
#author : xueyang
#data : 2017-05-08

#create folder
if [ ! -d "data" ]; then
	mkdir data
fi
if [ ! -d "data/train" ]; then
	mkdir data/train
fi
if [ ! -d "data/timit_train" ]; then
	mkdir data/timit_train
fi
if [ ! -d "data/timit_test" ]; then
	mkdir data/timit_test
fi

#create path file
if [ -f "data/all_utta_path" ]; then
	rm data/all_utta_path
fi
touch data/all_utta_path

#iterator find .wav files
function get_wav()
{
	for element in `ls $1`
	do
		dir_or_file=$1"/"$element
		if [ -d $dir_or_file ]; then
			get_wav $dir_or_file
		else
			if [ "${dir_or_file##*.}"x = "wav"x ]; then
				echo $dir_or_file >> data/all_utta_path
			fi
		fi
	done	
}
get_wav $1
