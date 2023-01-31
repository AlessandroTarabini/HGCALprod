#!/usr/bin/env bash

storage=/data_CMS/cms/"${USER}"/FOLDER
local=/home/llr/cms/"${USER}"/CMSSW_12_6_0_pre4/src/HGCALprod
folder=$PWD

source /cvmfs/cms.cern.ch/cmsset_default.sh
export SITECONFIG_PATH=/cvmfs/cms.cern.ch/SITECONF/T2_FR_GRIF_LLR/GRIF_LLR

cd $local
eval $(scram ru -sh)
cd $folder

mkdir $storage $storage/step1 $storage/step2 $storage/step3

cp $local/PARTICLE .
sed -i "s/DUMMY/$1/" PARTICLE
cmsRun PARTICLE

cp $local/step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT_PU.py .
cmsRun step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT_PU.py

cp $local/run_Step3andAnalyzer.py .
cmsRun run_Step3andAnalyzer.py

mv step1.root step1_$1.root
mv step1_$1.root $storage/step1
mv step2.root step2_$1.root
mv step2_$1.root $storage/step2
mv step3.root step3_$1.root
mv step3_$1.root $storage/step3

cd $folder
rm -f *.py *.cc *.txt *.root
