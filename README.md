# HGCALprod

This is the LLR framework to produce samples for HGCAL reco studies.

## Installation

```shell
cmsrel CMSSW_12_6_0_pre4
cd CMSSW_12_6_0_pre4/src
cmsenv
git clone https://github.com/AlessandroTarabini/HGCALprod.git
mv HGCALprod/RecoNtuples .
scram b -j all
cp -r RecoNtuples HGCALprod/.
cd HGCALprod/
```

## Local test

A local test can be launched with the following:

```shell
cd condor/
bash batchScript.sh --seed 1 --folder Test --command CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py --nevents 5 --particle pho --PID 22
```

The three steps should run, producing outputs under ```/data_CMS/cms/${USER}/Test/```.

## Submit a complete production

The ntuples are produced by jobs launched via HTCondor.

### Submit command

The command to run to setup the production and submit condor jobs is ```condor/submit.sh```. Run ```bash condor/submit.sh --help``` to print more information.

Example: generate 500 ntuples with 100 pion events each, no pile-up, and store the outputs in the subfolder ```SinglePion_0PU```:

```shell
bash condor/submit.sh -p pion -n 500 -v 100 -f SinglePion_0PU
```

A ```condor/log_SinglePion_0PU``` folder will be locally created with all information and log files.

### CMSSW Configuration

For the case of photons and pions, ```condor/submit.sh``` launches ```CloseByParticle_Photon_ERZRanges_cfi_GEN_SIM.py```. The latter provides the configuration for the particle gun (defined [here](https://github.com/cms-sw/cmssw/blob/master/IOMC/ParticleGuns/src/CloseByParticleGunProducer.cc)), generating particle from the font face of HGCAL (no interactions in the tracker) with the following arguments:

* ```ControlledByEta```: uniform particle along pseudo-rapidity &eta; if ```True```, across the angle &varphi; if ```False```;
* ```MaxEnSpread```: if ```True``` the energies of the generated particles are set in constant steps of the specified range. If ```False``` particles will be generated with an energy randomly sampled in ```[EnMin, EnMax]```;
* ```Delta```: arc-length distance in centimeters along &varphi; between particles. For instance, if two particles are generated, the second one will be assigned a &varphi; equal to ```phi_1 + Delta/R```, where the distance ```R``` to the primary vertex is obtained from &eta; and the Z coordinate. This is valid only when ```Overlapping=False```;
* ```NParticles```: number of particles generated per event;
* ```Overlapping```: whether there _can be_ an overlap between generated particles (no effect when generating a single particle)
* ```Pointing```: whether the generated particle points towards the primary vertex (despite being generated at the front face of HGCAL)

The other arguments should be self-explanatory. They are also documented [here](https://hgcal.web.cern.ch/Generation/CloseByParticleGun/).

## To process only step3

It is possible to run only the last step (reco with TICL).

```bash condor/submit_onlystep3.sh``` is the command to run to setup the production and submit condor jobs. It requires the following arguments:
* ```-f```: folder name in the storage area where step2 files (in a proper ```step2/``` folder) are stored
* ```-s```: name of the folder where step3 files will be stored
It is assumed the storage folder is ```/data_CMS/cms/${USER}/```.