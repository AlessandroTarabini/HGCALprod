#!/bin/bash

storage=/eos/cms/store/group/dpg_hgcal/comm_hgcal/atarabin/FOLDER
local=/afs/cern.ch/user/a/atarabin/CMSSW_12_6_0_pre2/src
folder=$PWD

cd $local
eval $(scram ru -sh)
cd $folder

mkdir $storage/STEP3

cp $storage/step2/step2_$1.root .
mv step2_$1.root step2.root

cp $local/run_Step3andAnalyzer.py .
cmsRun run_Step3andAnalyzer.py

mv step3.root step3_$1.root
mv step3_$1.root $storage/STEP3

cd $folder
rm -f *.py *.cc *.txt *.root
