# HGCALprod

This is the LLR framework to produce samples for HGCAL reco studies.

## Installation

```shell
cmsrel CMSSW_12_6_0_pre4
cd CMSSW_12_6_0_pre4/src
cmsenv
git clone https://github.com/AlessandroTarabini/HGCALprod.git
mv src/RecoNtuples .
scram b -j all
cp -r RecoNtuples HGCALprod/.
```

## To submit a complete production

The ntuples are produced by jobs launched via HTCondor. The storage and local folder are defined in ```condor/batchScript_template.sh```.

### Submit command

```bash submit.sh``` is the command to run to setup the production and submit condor jobs, with the following arguments:
* ```-p```: particles to generate (options: ```ele``` for electrons and ```pho``` for photons)
* ```-n```: number of events to generate. The number of the event corresponds to the seed of step1. If the seed is zero, the code returns an error, so always set number-of-desired-events+1
* ```-u```: flag to include PU
* ```-f```: name of the subfolder of the storage area to store the outputs

Example: generate 200 ntuples with electrons, PU, and store the outputs in the subfolder ```electrons```:

```shell
sh submit.sh -p ele -n 201 -f electrons -u
```

* _Note1:_ The first job always fails due to a zero-valued seed (not supported by Geant4). To submit N successful jobs one has to launch N+1 jobs.
* _Note2:_ Each job produces a number of events according to the ```maxEvents.input``` parameter defined under ```CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py```.

After the submission a ```log``` folder is created with all information and log files.

### CMSSW Configuration

For the case of photons and pions, ```condor/submit.sh``` launches ```CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py```. The latter provides the configuration for the particle gun (defined [here](https://github.com/cms-sw/cmssw/blob/master/IOMC/ParticleGuns/src/CloseByParticleGunProducer.cc)), generating particle from the font face of HGCAL (no interactions in the tracker) with the following arguments:

* ```ControlledByEta```: uniform particle along pseudo-rapidity &#03B7; if ```True```, across the angle &#03B8; if ```False```;
* ```MaxEnSpread```: 
* ```Delta```: arc-length distance in centimeters along &#03C6; between particles. For instance, if two particles are generated, the second one will be assigned a &#03C6; equal to ```phi_1 + Delta/R```, where the distance ```R``` to the primary vertex is obtained from &#03B7; and the Z coordinate. This is valid only when ```Overlapping=False```;
* ```NParticles```: number of particles generated per event;
* ```Overlapping```: whether there _can be_ an overlap between generated particles (no effect when generating a single particle)
* ```Pointing```: whether the generated particle points towards the primary vertex (despite being generated at the front face of HGCAL)

The other arguments should be self-explanatory.

## To process only step3

It is also possible to run only the last step (reco with TICL).

Before starting the submission, some manual operations are needed in the ```batchScript_onlystep3_template.sh``` file. The storage and local folder should be modified to fit your needs and setup.

```sh submit_onlystep3.sh``` is the command to run to setup the production and submit condor jobs.
```sh submit_onlystep3.sh``` needs some arguments:
* ```-f```: name of the folder in the storage area where step2 files (in a proper ```step2``` folder) are stored
* ```-s```: name of the folder where step3 files will be stored
