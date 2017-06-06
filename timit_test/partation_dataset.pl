#!/usr/bin/perl
#descrip : partation all_utta_file into train timit_train and timit_test, 
#                train for train ubm and PLDA with 530 people, everyone 
# 	     has 10 voice, remainder 100 people's 9 voice for adapt 
#	     ubm, 1 voice for test, 100 voice with 100 speaker model
# 	     random match, has 10000 trials of all.
#author : xueyang
#date : 2017-05-08

$in_file="data/all_utta_path";
$train_out_dir="data/train";
$timit_train_out_dir="data/timit_train";
$timit_test_out_dir="data/timit_test";

open(ALLUTTA, "<", "$in_file") or die "cannot open all_utta_path";
open(TRAINLIST, ">", "$train_out_dir/train_utta_path") or die "Could not open train_utta_path";
open(TIMITTRAINLIST, ">", "$timit_train_out_dir/timit_train_utta_path") or die "Could not open timit_train_utta_path";
open(TIMITTESTLIST, ">", "$timit_test_out_dir/timit_test_utta_path") or die "Could not open timit_test_utta_path";

$num = 0;
$count=0;
while (<ALLUTTA>) {
	#if ($num < 4300){
	#	$num++;
	#}
	#elsif ($num < 5300){
	if ($num < 5300){
		print TRAINLIST "$_";
		$num++;
	}elsif ($count == 0){
		print TIMITTESTLIST "$_";
		$count++;
	}else{
		print TIMITTRAINLIST "$_";
		$count++;
		$count %= 10;
	}
}

close(ALLUTTA) || die;
close(TRAINLIST) || die;
close(TIMITTRAINLIST) || die;
close(TIMITTESTLIST) || die;
