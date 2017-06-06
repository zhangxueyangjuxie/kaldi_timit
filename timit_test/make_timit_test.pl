#!/sur/bin/perl
#descript : this script for create three files: spk2gender, utt2spk and wav.scp
#author : xueyang
#date : 2017-05-08

$in_file="data/timit_test/timit_test_utta_path";
$out_dir="data/timit_test";
$channel="1";

open(WAVLIST, "<", "$in_file") or die "cannot open wav list";
open(SPKGEN, ">", "$out_dir/spk2gender") or die "Could not open the spk2gender";
open(UTTSPK, ">", "$out_dir/utt2spk") or die "Could not open the utt2spk";
open(WAV, ">", "$out_dir/wav.scp") or die "Could not open the wav.scp";
open(OUT_TRIALS, ">", "$out_dir/trials") or die "cannot open trials list";

@utterance=();
@speaker=();
while (<WAVLIST>) {
	chomp;
	($subpath1, $subpath2, $subpath3, $spkr, $utt) = split("/", $_);
	$gender = substr($spkr,0,1) ;
	($utt, $wav) = split(/\./, $utt);
	$utt_id = $spkr . "_" . $channel;
	print WAV "$utt_id ", "sph2pipe -f wav -p -c $channel $_ |\n";
	#print WAV "$utt_id ", "$_\n";
	push(@utterance, "$utt_id");
	push(@speaker, "$spkr");
	print UTTSPK "$utt_id $spkr\n";
	print SPKGEN "$spkr $gender\n";
}

foreach $u_id1 (@speaker)
{
	foreach $u_id2(@utterance)
	{
		($temp_spkr, $temp_channel) = split("_", $u_id2);
		if ($u_id1 eq $temp_spkr){
			print OUT_TRIALS "$u_id1 $u_id2 target\n" ;
		}else{
			print OUT_TRIALS "$u_id1 $u_id2 nontarget\n" ;
		}
	}
}

close(WAVLIST) || die;
close(SPKGEN) || die;
close(UTTSPK) || die;
close(WAV) || die;
close(OUT_TRIALS) || die;

if (system(
  "utils/utt2spk_to_spk2utt.pl $out_dir/utt2spk >$out_dir/spk2utt") != 0) {
  die "Error creating spk2utt file in directory $out_dir";
}
system("utils/fix_data_dir.sh $out_dir");
if (system("utils/validate_data_dir.sh --no-text --no-feats $out_dir") != 0) {
  die "Error validating directory $out_dir";
}
