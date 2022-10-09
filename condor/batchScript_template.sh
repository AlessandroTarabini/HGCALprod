#!/bin/bash

storage=/eos/cms/store/group/dpg_hgcal/comm_hgcal/atarabin
local=/afs/cern.ch/user/a/atarabin/CMSSW_12_6_0_pre2/src
folder=$PWD

# cp $local/condor/CMSSW_12_6_0_pre2.tgz .
# tar -zxvf CMSSW_12_6_0_pre2.tgz
# rm CMSSW_12_6_0_pre2.tgz
# cd CMSSW_12_6_0_pre2/src

cd $local
eval $(scram ru -sh)
cd $folder

# source /cvmfs/cms.cern.ch/cmsset_default.sh
# scramv1 b ProjectRename
# eval `scramv1 runtime -sh`

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
