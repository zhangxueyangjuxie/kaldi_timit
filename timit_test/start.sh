#!/bin/bash
#describe : speaker recognitino for TIMIT
#author : xueyang
#date : 2017-05-08


. cmd.sh
. path.sh
set -e
mfccdir=`pwd`/mfcc
vaddir=`pwd`/mfcc
trials_female=data/timit_test_female/trials
trials_male=data/timit_test_male/trials
trials=data/timit_test/trials
num_components=1024 # Larger than this doesn't make much of a difference.

#bash clear_data.sh
#bash get_all_utta_path.sh TIMIT
#perl partation_dataset.pl
#perl make_train.pl
#perl make_timit_train.pl
#perl make_timit_test.pl


#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 2 --cmd "$train_cmd" \
#data/train exp/make_mfcc $mfccdir
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 2 --cmd "$train_cmd" \
#data/timit_train exp/make_mfcc $mfccdir
#steps/make_mfcc.sh --mfcc-config conf/mfcc.conf --nj 2 --cmd "$train_cmd" \
#data/timit_test exp/make_mfcc $mfccdir

#for name in timit_train timit_test train; do
#utils/fix_data_dir.sh data/${name}
#done

#sid/compute_vad_decision.sh --nj 2 --cmd "$train_cmd" \
#data/train exp/make_vad $vaddir
#sid/compute_vad_decision.sh --nj 2 --cmd "$train_cmd" \
#data/timit_train exp/make_vad $vaddir
#sid/compute_vad_decision.sh --nj 2 --cmd "$train_cmd" \
#data/timit_test exp/make_vad $vaddir

#for name in timit_train timit_test train; do
#  utils/fix_data_dir.sh data/${name}
#done

#Reduce the amount of training data for the UBM.
#utils/subset_data_dir.sh data/train 400 data/train_400
#utils/subset_data_dir.sh data/train 800 data/train_800

#Train UBM and i-vector extractor.
#sid/train_diag_ubm.sh --cmd "$train_cmd" \
#  --nj 2 --num-threads 1 \
#  data/train_400 $num_components \
#  exp/diag_ubm_$num_components

#sid/train_full_ubm.sh --nj 2 --remove-low-count-gaussians false \
#  --cmd "$train_cmd" data/train_800 \
#  exp/diag_ubm_$num_components exp/full_ubm_$num_components

#sid/train_ivector_extractor.sh --cmd "$train_cmd" \
#  --ivector-dim 400 \
#  --num-iters 5 exp/full_ubm_$num_components/final.ubm data/train \
#  exp/extractor

# Extract i-vectors.
#sid/extract_ivectors.sh --cmd "$train_cmd" --nj 2 \
#  exp/extractor data/timit_train \
#  exp/ivectors_timit_train

#sid/extract_ivectors.sh --cmd "$train_cmd" --nj 2 \
#  exp/extractor data/timit_test \
#  exp/ivectors_timit_test

#sid/extract_ivectors.sh --cmd "$train_cmd" --nj 2 \
#  exp/extractor data/train \
#  exp/ivectors_train

# Separate the i-vectors into male and female partitions and calculate
# i-vector means used by the scoring scripts.
#local/scoring_common.sh data/train data/timit_train data/timit_test \
#  exp/ivectors_train exp/ivectors_timit_train exp/ivectors_timit_test


# Create a gender independent PLDA model and do scoring.
#local/plda_scoring.sh data/train data/timit_train data/timit_test \
#  exp/ivectors_train exp/ivectors_timit_train exp/ivectors_timit_test $trials exp/scores_gmm_1024_ind_pooled
#local/plda_scoring.sh --use-existing-models true data/train data/timit_train_female data/timit_test_female \
#  exp/ivectors_train exp/ivectors_timit_train_female exp/ivectors_timit_test_female $trials_female exp/scores_gmm_1024_ind_female
#local/plda_scoring.sh --use-existing-models true data/train data/timit_train_male data/timit_test_male \
#  exp/ivectors_train exp/ivectors_timit_train_male exp/ivectors_timit_test_male $trials_male exp/scores_gmm_1024_ind_male

# Create gender dependent PLDA models and do scoring.
#local/plda_scoring.sh data/train_female data/timit_train_female data/timit_test_female \
#  exp/ivectors_train exp/ivectors_timit_train_female exp/ivectors_timit_test_female $trials_female exp/scores_gmm_1024_dep_female
#local/plda_scoring.sh data/train_male data/timit_train_male data/timit_test_male \
#  exp/ivectors_train exp/ivectors_timit_train_male exp/ivectors_timit_test_male $trials_male exp/scores_gmm_1024_dep_male

# Pool the gender dependent results.
#mkdir -p exp/scores_gmm_1024_dep_pooled
#cat exp/scores_gmm_1024_dep_male/plda_scores exp/scores_gmm_1024_dep_female/plda_scores \
#  > exp/scores_gmm_1024_dep_pooled/plda_scores

#echo "GMM-$num_components EER"
for x in ind dep; do
  for y in female male pooled; do
    eer=`compute-eer <(python local/prepare_for_eer.py $trials exp/scores_gmm_${num_components}_${x}_${y}/plda_scores) 2> /dev/null`
    echo "${x} ${y}: $eer"
  done
done


