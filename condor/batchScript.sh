#!/usr/bin/env bash

# Defaults
NEVENTS="10"
PU="0"

while [[ $# -gt 0 ]]; do
    key=${1}
    case $key in
        --folder)
            FOLDER=${2}
            shift; shift;
            ;;
        --particle)
            PARTICLE=${2}
            shift; shift;
            ;;
        --command)
            COMMAND=${2}
            shift; shift;
            ;;
        --PID)
            PID=${2}
            shift; shift;
            ;;
	--nevents)
            NEVENTS=${2}
            shift; shift;
            ;;
	--pu)
            PU="1"
            shift;
            ;;
        --seed)
            SEED=${2}
            shift; shift;
            ;;
	*)  # unknown option
            echo "Wrong parameter ${1}."
            exit 1
            ;;
    esac
done

STORAGE=/data_CMS/cms/"${USER}"/${FOLDER}
LOCAL=/home/llr/cms/"${USER}"/CMSSW_12_6_0_pre4/src/HGCALprod
CURRENT=${PWD}
echo "--- " `pwd`
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SITECONFIG_PATH=/cvmfs/cms.cern.ch/SITECONF/T2_FR_GRIF_LLR/GRIF-LLR
echo "--- " `pwd`
cd ${LOCAL}
echo "--- " `pwd`
eval $(scram ru -sh)
cd ${CURRENT}
echo "--- " `pwd`

mkdir -p ${STORAGE} ${STORAGE}/step1 ${STORAGE}/step2 ${STORAGE}/step3

cp ${STORAGE}/${COMMAND} .
cmsRun ${COMMAND} nEvents=${NEVENTS} seed=${SEED} PID=${PID}

if [[ ${PU} -eq 1 ]]; then
    cp ${LOCAL}/step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT_PU.py .
    cmsRun step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT_PU.py
else
    cp ${LOCAL}/step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT.py .
    cmsRun step2_DIGI_L1TrackTrigger_L1_DIGI2RAW_HLT.py
fi

cp ${LOCAL}/run_Step3andAnalyzer.py .
cmsRun run_Step3andAnalyzer.py

mv step1.root ${STORAGE}/step1/step1_${SEED}.root
mv step2.root ${STORAGE}/step2/step2_${SEED}.root
mv step3.root ${STORAGE}/step3/step3_${SEED}.root

cd ${CURRENT}
echo "--- " `pwd`
#rm -f *.py *.cc *.txt *.root
