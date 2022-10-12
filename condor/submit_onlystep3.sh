cp batchScript_onlystep3_template.sh batchScript_onlystep3.sh

while getopts 's:f:u' flag; do
  case "${flag}" in
    f) folder="${OPTARG}" ;;
    s) step3="${OPTARG}" ;;
  esac
done

if ! [ $step3 ]; then
  echo '!!!! Name of step3 folder is missing !!!!'
  exit
else
  sed -i "s/STEP3/$step3/" batchScript_onlystep3.sh
fi


if ! [ $folder ]; then
  echo '!!!! Name of the folder is missing !!!!'
  exit
else
  sed -i "s/FOLDER/$folder/" batchScript_onlystep3.sh
fi

python3 step2_fileList_generator.py --path $folder

if [ -d log ]; then
  echo 'Folder log exists'
  echo 'Previous generation might be ongoing, please check'
  echo 'To start a new generation, remove the log folder'
  rm batchScript_onlystep3.sh
  exit
else
  mkdir log
  cp batchScript_onlystep3.sh log/.
fi

condor_submit condor_onlystep3.sub -queue from step2files.txt

rm step2files.txt
