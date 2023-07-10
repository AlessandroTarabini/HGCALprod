#!/usr/bin/env bash

### Defaults
PARTICLE=""
NEVENTS="100"
NSAMPLES=""
PU="0"
DRYRUN="0"

declare -a PARTICLES=("ele" "pho" "pion")

### Argument parsing
HELP_STR="Prints this help message."
DRYRUN_STR="(Boolean) Prints all the commands to be launched but does not launch them. Defaults to ${DRYRUN}."
PARTICLE_STR="(String) Which particles to shoot. Available options: ${PARTICLES[@]}."
NEVENTS_STR="(String) Number of events per sample. To be multiplied by the number of samples to obtain the total number of events produced. Defaults to ${NEVENTS}"
NSAMPLES_STR="(String) How many samples to produce."
FOLDER_STR="(String) Folder to store all files."
PU_STR="(Boolean flag) If present, pile-up is included."

function print_usage_submit {
    USAGE="
    Run example: bash $(basename "$0") -p pion -n 101 -v 100 -f SinglePion_0PU --dry-run

    -h / --help     [ ${HELP_STR} ]
    -d / --dry-run  [ ${DRYRUN_STR} ]
    -p / --particle [ ${PARTICLE_STR} ]
    -n / --nsamples [ ${NSAMPLES_STR} ]
    -v / --nevents  [ ${NEVENTS_STR} ]
    -f / --folder   [ ${FOLDER_STR} ]
    -u / --pu       [ ${PU_STR} ]
"
    printf "${USAGE}"
}

while [[ $# -gt 0 ]]; do
    key=${1}
    case $key in
	-h|--help)
	    print_usage_submit
	    exit 1
	    ;;
	-d|--dry-run)
	    DRYRUN="1"
	    shift;
	    ;;
	-p|--particle)
	    PARTICLE=${2}
	    shift; shift;
	    ;;
	-v|--nevents)
	    NEVENTS=${2}
	    shift; shift;
	    ;;
	-n|--nsamples)
	    NSAMPLES=${2}
	    shift; shift;
	    ;;
	-f|--folder)
	    FOLDER=${2}
	    shift; shift;
	    ;;
	-u|--pu)
	    PU="1"
	    shift;
	    ;;
	*)  # unknown option
	    echo "Wrong parameter ${1}."
	    exit 1
	    ;;
    esac
done

## Argument parsing: information for the user
echo "------ Arguments --------------"
printf "DRYRUN\t\t= ${DRYRUN}\n"
printf "PARTICLE\t= ${PARTICLE}\n"
printf "NEVENTS\t\t= ${NEVENTS}\n"
printf "NSAMPLES\t= ${NSAMPLES}\n"
printf "PU\t\t= ${PU}\n"
echo "-------------------------------"

WORKDIR="condor"
STOREDIR="${WORKDIR}/log_${FOLDER}"
BATCH="${WORKDIR}/batchScript.sh"
TXT="${STOREDIR}/subInfo.txt"
SUB="${STOREDIR}/condor.sub"
LOGS="${STOREDIR}/logs"

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Exit."; exit 1 ;;
        esac
    done
}

if [ -d ${STOREDIR} ]; then
    echo "Folders ${STOREDIR}/ (and very likely /data_CMS/cms/${USER}/${FOLDER}/) exist."
    echo "Note that the previous sample generation with the same tag might be ongoing, please check."
    DELCMD1="rm -r ${STOREDIR}/"
    DELCMD2="rm -r /data_CMS/cms/${USER}/${FOLDER}/"
    yes_or_no "Do you want to remove the former with: '${DELCMD1}'?" && ${DELCMD1}
    yes_or_no "Do you want to remove the latter with: '${DELCMD2}'?" && ${DELCMD2}
fi

mkdir -p "${STOREDIR}"
mkdir ${LOGS}
touch ${TXT}

if [ ${PARTICLE} == ${PARTICLES[0]} ]; then
	outstr="Particles: electrons"
	CMSSW_COMMAND="SElectron_2to1000_cfi_GEN_SIM.py"
elif [ ${PARTICLE} == ${PARTICLES[1]} ]; then
  	outstr="Particles: photons"
	CMSSW_COMMAND="CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py"
  PID=22
elif [ ${PARTICLE} == ${PARTICLES[2]} ]; then
	outstr="Particles: pions"
	CMSSW_COMMAND="CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py"
	PID=211
else
  echo "ERROR: Unknwon Particle! Pick one of the following: ${PARTICLES[@]}"
  exit
fi
echo ${outstr} >> ${TXT}

voms-proxy-init --rfc --voms cms -valid 192:00
source /opt/exp_soft/cms/t3/t3setup

if ! [ ${FOLDER} ]; then
  echo "ERROR: The name of the folder is missing!"
  exit
else
  echo "Folder:" ${FOLDER} >> ${TXT}
  STORAGE=/data_CMS/cms/${USER}/${FOLDER}
  mkdir -p ${STORAGE}
  LOCAL=/home/llr/cms/"${USER}"/CMSSW_12_6_0_pre4/src/HGCALprod
fi

if ! [ ${NSAMPLES} ]; then
  echo "ERROR: Specify the number of samples."
  exit
else
  echo "Number of samples:" ${NSAMPLES} >> ${TXT}
fi

echo "Number of events per sample:" ${NEVENTS} >> ${TXT}

cp ${LOCAL}/${CMSSW_COMMAND} ${STORAGE} # create copy of input file to allow multiple consecutive job submissions

if [[ ${PU} -eq 1 ]]; then
  echo "Pile-Up included" >> ${TXT}
  ARGUMENTS="--seed \$(SampleId) --particle ${PARTICLE} --command ${CMSSW_COMMAND} --nevents ${NEVENTS} --folder ${FOLDER} --PID ${PID} --pu"
else
  echo "Pile-Up not included" >> ${TXT}
  ARGUMENTS="--seed \$(SampleId) --particle ${PARTICLE} --command ${CMSSW_COMMAND} --nevents ${NEVENTS} --folder ${FOLDER} --PID ${PID}"
fi
echo "Arguments:" ${NSAMPLES} >> ${TXT}

# Write condor submission file
cat >${SUB} <<EOL
executable  = ${BATCH}
arguments   = ${ARGUMENTS}
universe    = vanilla
output      = ${LOGS}/\$(SampleId).out
error       = ${LOGS}/\$(SampleId).err
log         = ${LOGS}/\$(SampleId).log

+JobFlavour = "tomorrow"
+JobBatchName = "${FOLDER}"

getenv = true

T3Queue = long
WNTag=el7
+SingularityCmd = ""
include : /opt/exp_soft/cms/t3/t3queue |

queue SampleId from seq 1 ${NSAMPLES} |
EOL

comm="condor_submit ${SUB}";
[[ ${DRYRUN} -eq 1 ]] && printf "\nDry-run: ${comm}\n" || ${comm};
