#!/sur/bin/perl
#descript : this script for create three files: spk2gender, utt2spk and wav.scp
#author : xueyang
#date : 2017-05-08

$in_file="data/train/train_utta_path";
$out_dir="data/train";
$channe="1";

open(WAVLIST, "<", "$in_file") or die "cannot open wav list";
open(SPKGEN, ">", "$out_dir/spk2gender") or die "Could not open the spk2gender";
open(UTTSPK, ">", "$out_dir/utt2spk") or die "Could not open the utt2spk";
open(WAV, ">", "$out_dir/wav.scp") or die "Could not open the wav.scp";

%spkrflag=();
while (<WAVLIST>) {
	chomp;
	($subpath1, $subpath2, $subpath3, $spkr, $utt) = split("/", $_);
	$gender = substr($spkr,0,1);
	($utt, $wav) = split(/\./, $utt);
	$utt_id = $spkr . "-" . $utt;
	print WAV "$utt_id ", "sph2pipe -f wav -p -c $channe $_ |\n";
	#print WAV "$utt_id ", "$_\n";
	print UTTSPK "$utt_id $spkr", "\n";
	if (!exists $spkrflag{$spkr}){
		$spkrflag{$spkr} = 1;
		print SPKGEN "$spkr $gender\n";
	}
}

close(WAVLIST) || die;
close(SPKGEN) || die;
close(UTTSPK) || die;
close(WAV) || die;

if (system(
  "utils/utt2spk_to_spk2utt.pl $out_dir/utt2spk >$out_dir/spk2utt") != 0) {
  die "Error creating spk2utt file in directory $out_dir";
}
system("utils/fix_data_dir.sh $out_dir");
if (system("utils/validate_data_dir.sh --no-text --no-feats $out_dir") != 0) {
  die "Error validating directory $out_dir";
}