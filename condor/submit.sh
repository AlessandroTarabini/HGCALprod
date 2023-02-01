#!/usr/bin/env bash

### Defaults
PARTICLE=""
NSAMPLES=""
PU="0"

declare -a PARTICLES=("ele" "pho" "pion")

### Argument parsing
HELP_STR="Prints this help message."
PARTICLE_STR="(String) Which particles to shoot. Defaults to '${PARTICLES}'."
NSAMPLES_STR="(String) How many samples to produce. Each samples has a number of events specified in the particle gun python configuration file (maxEvents.input)"
FOLDER_STR="(String) Folder to store all files."
PU_STR="(Boolean flag) If present, pile-up is included."

function print_usage_submit {
    USAGE="
        Run example: bash $(basename "$0") -t out_test --in_tag Jan2023 --user bfontana --dry-run
    -h / --help[ ${HELP_STR} ]
    -p / --particle[ ${PARTICLE_STR} ]
    -n / --nsamples[ ${NSAMPLES_STR} ]
    -f / --folder[ ${FOLDER_STR} ]
    -u / --pu[ ${PU_STR} ]
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
	-p|--particle)
	    PARTICLE=${2}
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

WORKDIR="condor"
BATCH="${WORKDIR}/batchScript.sh"
STOREDIR="${WORKDIR}/${FOLDER}"
LOGS="${STOREDIR}/log"
TXT="${STOREDIR}/log/subInfo.txt"
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
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py/" ${BATCH}
elif [ ${PARTICLE} == ${PARTICLES[2]} ]; then
	outstr="Particles: pions"
	sed -i "s/PARTICLE/CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py/" ${BATCH}
else
  echo "ERROR: Unknwon Particle! Pick one of the following: ${PARTICLES[@]}"
  exit
fi
echo ${outstr}
echo ${outstr} >> ${TXT}

voms-proxy-init --rfc --voms cms -valid 192:00
source /opt/exp_soft/cms/t3/t3setup

if ! [ ${FOLDER} ]; then
  echo '!!!! Name of the folder is missing !!!!'
  exit
else
  sed -i "s/FOLDER/${FOLDER}/" ${BATCH}
  echo 'Folder:' ${FOLDER} >> ${TXT}
fi


if [[ ${PU} -eq 1 ]]; then
  echo 'Pile-Up included'
  echo 'Pile-Up included' >> ${TXT}
else
  echo 'Pile-Up not included'
  echo 'Pile-Up not included' >> ${TXT}
  sed -i "s/_PU//" ${BATCH}
fi

if ! [ ${NSAMPLES} ]; then
  echo '!!!! Number of events is missing !!!!'
  echo '+1 should be added to the number of desired events'
  exit
else
  echo 'Number of samples:' ${NSAMPLES}
  echo 'Number of samples:' ${NSAMPLES} >> ${TXT}
fi

# Write condor submission file
cat >${SUB} <<EOL
executable  = condor/batchScript.sh
arguments   = \$(ProcId)
universe    = vanilla
output      = ${LOGS}/output.\$(ProcId).out
error       = ${LOGS}/error.\$(ProcId).err
log         = ${LOGS}/log.\$(ProcId).log

+JobFlavour = "tomorrow"

getenv = true

T3Queue = long
WNTag=el7
+SingularityCmd = ""
include : /opt/exp_soft/cms/t3/t3queue |
EOL

condor_submit ${SUB} -queue ${NSAMPLES}
