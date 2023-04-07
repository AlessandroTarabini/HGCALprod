voms-proxy-init --rfc --voms cms -valid 192:00
source /opt/exp_soft/cms/t3/t3setup

cd condor
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

if [ -d log_step3_${folder} ]; then
  echo 'Folder log exists'
  echo 'Previous generation might be ongoing, please check'
  echo 'To start a new generation, remove the log folder'
  rm batchScript_onlystep3.sh
  exit
else
  mkdir log_step3_${folder}
  cp batchScript_onlystep3.sh log_step3_${folder}/.
  cp step2files.txt log_step3_${folder}/.
fi

cd log_step3_${folder}

# Write condor submission file
cat >condor.sub <<EOL
executable  = batchScript_onlystep3.sh
arguments   = \$(Item)
universe    = vanilla
output      = \$(Item).out
error       = \$(item).err
log         = \$(Item).log

+JobFlavour = "tomorrow"
+JobBatchName = "step3_${folder}"

getenv = true

T3Queue = long
WNTag=el7
+SingularityCmd = ""
include : /opt/exp_soft/cms/t3/t3queue |

EOL

condor_submit condor.sub -queue from step2files.txt

rm step2files.txt
