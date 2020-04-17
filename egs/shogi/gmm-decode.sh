#!/bin/bash

# Author Joshua Meyer (2016)

# USAGE:
#    $ kaldi/egs/your-model/your-model-1/gmm-decode.sh
# 
#    This script is meant to demonstrate how an existing GMM-HMM
#    model and its corresponding HCLG graph, build via Kaldi,
#    can be used to decode new audio files.
#    Although this script takes no command line arguments, it assumes
#    the existance of a directory (./transcriptions) and an scp file
#    within that directory (./transcriptions/wav.scp). For more on scp
#    files, consult the official Kaldi documentation.

# INPUT:
#    transcriptions/
#        wav.scp
#
#    config/
#        mfcc.conf
#
#    experiment/
#        triphones_deldel/
#            final.mdl
#
#            graph/
#                HCLG.fst
#                words.txt

# OUTPUT:
#    transcriptions/
#        feats.ark
#        feats.scp
#        delta-feats.ark
#        lattices.ark
#        one-best.tra
#        one-best-hypothesis.txt



. ./path.sh
# make sure you include the path to the gmm bin(s)
# the following two export commands are what my path.sh script contains:
# export PATH=$PWD/utils/:$PWD/../../../src/bin:$PWD/../../../tools/openfst/bin:$PWD/../../../src/fstbin/:$PWD/../../../src/gmmbin/:$PWD/../../../src/featbin/:$PWD/../../../src/lm/:$PWD/../../../src/sgmmbin/:$PWD/../../../src/fgmmbin/:$PWD/../../../src/latbin/:$PWD/../../../src/nnet2bin/:$PWD:$PATH
# export LC_ALL=C

# AUDIO --> FEATURE VECTORS
compute-mfcc-feats \
--config=conf/mfcc.conf \
scp:transcriptions/wav.scp \
ark,scp:transcriptions/feats.ark,transcriptions/feats.scp

compute-cmvn-stats \
--spk2utt=ark:transcriptions/spk2utt \
scp:transcriptions/feats.scp \
ark,scp:transcriptions/cmvn.ark,transcriptions/cmvn.scp

##Applyng CMVN
apply-cmvn \
--utt2spk=ark:transcriptions/utt2spk \
scp:transcriptions/cmvn.scp \
scp:transcriptions/feats.scp ark:transcriptions/cmvn-feats.ark

#Adding deltas
add-deltas \
ark:transcriptions/cmvn-feats.ark \
ark:transcriptions/delta-feats.ark

gmm-latgen-faster \
--word-symbol-table=data/lang/words.txt \
exp/tri1/final.mdl \
exp/tri1/graph/HCLG.fst \
ark:transcriptions/delta-feats.ark \
ark,t:transcriptions/lattices.ark


