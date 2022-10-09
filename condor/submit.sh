cp batchScript_template.sh batchScript.sh
touch subInfo.txt

while getopts 'p:n:f:u' flag; do
  case "${flag}" in
    p) particle="${OPTARG}" ;;
    n) nevents="${OPTARG}" ;;
    f) folder="${OPTARG}" ;;
    u) pu='true' ;;
  esac
done

if [ $particle == 'ele' ]; then
  echo 'Particles: electrons'
  echo 'Particles: electrons' >> subInfo.txt
  sed -i "s/PARTICLE/SElectron_2to1000_cfi_GEN_SIM.py/" batchScript.sh
elif [ $particle == 'pho' ]; then
  echo 'Particles: photons'
  echo 'Particles: photons' >> subInfo.txt
  sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py/" batchScript.sh
else
  echo '!!!! unknwon particle !!!!'
  echo 'choices: ele - pho'
  exit
fi

if ! [ $folder ]; then
  echo '!!!! Name of the folder is missing !!!!'
else
  sed -i "s/FOLDER/$folder/" batchScript.sh
  echo 'Folder:' $folder >> subInfo.txt
fi


if [ $pu ]; then
  echo 'Pile-Up included'
  echo 'Pile-Up included' >> subInfo.txt
else
  echo 'Pile-Up not included'
  echo 'Pile-Up not included' >> subInfo.txt
  sed -i "s/_PU//" batchScript.sh
fi

if ! [ $nevents ]; then
  echo '!!!! Number of events is missing !!!!'
  echo '+1 should be added to the number of desired events'
  exit
else
  echo 'Number of events:' $nevents
  echo 'Number of events:' $nevents >> subInfo.txt
fi

if [ -d log ]; then
  echo 'Folder log exists'
  echo 'Previous generation might be ongoing, please check'
  echo 'To start a new generation, remove the log folder'
  rm subInfo.txt
  rm batchScript.sh
  exit
else
  mkdir log
  mv subInfo.txt log/.
  cp batchScript.sh log/.
fi

condor_submit condor.sub -queue $nevents
