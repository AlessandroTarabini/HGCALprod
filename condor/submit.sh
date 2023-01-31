#!/usr/bin/env bash

voms-proxy-init --rfc --voms cms -valid 192:00
source /opt/exp_soft/cms/t3/t3setup

WORKDIR="condor"
BATCH="${WORKDIR}/batchScript.sh"
TXT="${WORKDIR}/subInfo.txt"

cp ${WORKDIR}/batchScript_template.sh ${BATCH}
touch ${TXT}

while getopts 'p:n:f:u' flag; do
  case "${flag}" in
    p) particle="${OPTARG}" ;;
    n) nevents="${OPTARG}" ;;
    f) folder="${OPTARG}" ;;
    u) pu='true' ;;
  esac
done

LOGS="${WORKDIR}/log_${folder}"

if [ $particle == 'ele' ]; then
	outstr="Particles: electrons"
	sed -i "s/PARTICLE/SElectron_2to1000_cfi_GEN_SIM.py/" ${BATCH}
elif [ $particle == 'pho' ]; then
  	outstr="Particles: photons"
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py/" ${BATCH}
elif [ $particle == 'pion' ]; then
	outstr="Particles: pions"
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py/" ${BATCH}
else
  echo '!!!! unknwon particle !!!!'
  echo 'choices: ele - pho - pion'
  exit
fi
echo ${outstr}
echo ${outstr} >> ${TXT}


if ! [ $folder ]; then
  echo '!!!! Name of the folder is missing !!!!'
  exit
else
  sed -i "s/FOLDER/$folder/" ${BATCH}
  echo 'Folder:' $folder >> ${TXT}
fi


if [ $pu ]; then
  echo 'Pile-Up included'
  echo 'Pile-Up included' >> ${TXT}
else
  echo 'Pile-Up not included'
  echo 'Pile-Up not included' >> ${TXT}
  sed -i "s/_PU//" ${BATCH}
fi

if ! [ $nevents ]; then
  echo '!!!! Number of events is missing !!!!'
  echo '+1 should be added to the number of desired events'
  exit
else
  echo 'Number of events:' $nevents
  echo 'Number of events:' $nevents >> ${TXT}
fi

if [ -d ${LOGS} ]; then
  echo 'Folder $LOGS exists'
  echo 'Previous generation might be ongoing, please check'
  echo 'To start a new generation, remove the $LOGS folder'
  rm ${TXT}
  rm ${BATCH}
  exit
else
  mkdir ${LOGS}
  mv ${TXT} ${LOGS}/.
  cp ${BATCH} ${LOGS}/.
fi

condor_submit ${WORKDIR}/condor.sub -queue $nevents
