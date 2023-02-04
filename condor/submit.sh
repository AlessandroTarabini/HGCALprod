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
printf "NEVENTS\t= ${NEVENTS}\n"
printf "NSAMPLES\t= ${NSAMPLES}\n"
printf "PU\t\t= ${PU}\n"
echo "-------------------------------"

WORKDIR="condor"
BATCH="${WORKDIR}/batchScript.sh"
STOREDIR="${WORKDIR}/log_${FOLDER}"
LOGS="${STOREDIR}/logs"
TXT="${LOGS}/subInfo.txt"
SUB="${STOREDIR}/condor.sub"

if [ -d ${STOREDIR} ]; then
    echo "Folder ${STOREDIR} exists"
    echo "Previous generation might be ongoing, please check"
    echo "To start a new generation, remove the ${STOREDIR} folder: 'rm -r ${STOREDIR}/'"
    echo "You might also want to remove/update the folder storing the ntuples: '/data_CMS/cms/${USER}/${FOLDER}/'."
    exit 1
else
    cp ${WORKDIR}/batchScript_template.sh ${BATCH}
    mkdir -p "${STOREDIR}"
    mkdir ${LOGS}
    touch ${TXT}
    cp ${BATCH} ${LOGS}/.
fi

if [ ${PARTICLE} == ${PARTICLES[0]} ]; then
	outstr="Particles: electrons"
	sed -i "s/PARTICLE/SElectron_2to1000_cfi_GEN_SIM.py/" ${BATCH}
elif [ ${PARTICLE} == ${PARTICLES[1]} ]; then
  	outstr="Particles: photons"
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py nEvents=${NEVENTS}/" ${BATCH}
elif [ ${PARTICLE} == ${PARTICLES[2]} ]; then
	outstr="Particles: pions"
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py nEvents=${NEVENTS}/" ${BATCH}
else
  echo "ERROR: Unknwon Particle! Pick one of the following: ${PARTICLES[@]}"
  exit
fi
echo ${outstr}
echo ${outstr} >> ${TXT}

voms-proxy-init --rfc --voms cms -valid 192:00
source /opt/exp_soft/cms/t3/t3setup

if ! [ ${FOLDER} ]; then
  echo 'ERROR: The name of the folder is missing!'
  exit
else
  sed -i "s/FOLDER/${FOLDER}/" ${BATCH}
  echo 'Folder:' ${FOLDER} >> ${TXT}
fi

if [[ ${PU} -eq 1 ]]; then
  echo 'Pile-Up included' >> ${TXT}
else
  echo 'Pile-Up not included' >> ${TXT}
  sed -i "s/_PU//" ${BATCH}
fi

echo 'Number of events per sample:' ${NEVENTS} >> ${TXT}

if ! [ ${NSAMPLES} ]; then
  echo 'ERROR: Specify the number of samples (add one to compensate for a seed=0 failure).'
  exit
else
  echo 'Number of samples:' ${NSAMPLES} >> ${TXT}
fi

# Write condor submission file
cat >${SUB} <<EOL
executable  = condor/batchScript.sh
arguments   = \$(ProcId)
universe    = vanilla
output      = ${LOGS}/\$(ProcId).out
error       = ${LOGS}/\$(ProcId).err
log         = ${LOGS}/\$(ProcId).log

+JobFlavour = "tomorrow"
+JobBatchName="\${FOLDER}"

getenv = true

T3Queue = long
WNTag=el7
+SingularityCmd = ""
include : /opt/exp_soft/cms/t3/t3queue |
EOL

comm="condor_submit ${SUB} -queue ${NSAMPLES}";
[[ ${DRYRUN} -eq 1 ]] && printf "\nDry-run: ${comm}\n" || ${comm};

