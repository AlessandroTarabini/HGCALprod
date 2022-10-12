HGCALprod
==========

This is the framework to produce samples for HGCALreco studies.

To install the repo
------------------------------
```
cmsrel CMSSW_12_6_0_pre2
cd CMSSW_12_6_0_pre2/src
cmsenv
git clone https://github.com/AlessandroTarabini/HGCALprod.git
scram b -j all
```

To submit a complete production
------------------------------
The working folder is ```condor```.

Before starting the submission, some manual operations are needed in the ```batchScript_template.sh``` file. The storage and local folder should be modified to fit your needs and setup.

```sh submit.sh``` is the command to run to setup the production and submit condor jobs.
```submit.sh``` needs some arguments:
* ```-p```: particles to generate (options: ```ele``` for electrons and ```pho``` for photons)
* ```-n```: number of events to generate. The number of the event corresponds to the seed of step1. If the seed is zero, the code returns an error, so always set number-of-desired-events+1
* ```-u```: flag to include PU
* ```-f```: name of the subfolder of the storage area to store the outputs

Example: if you want to generate 200 events with electrons, PU, and store the outputs in the subfolder ```electrons```, the command is:
```
sh submit.sh -p ele -n 201 -u -f electrons
```

After the submission a ```log``` folder is created with all information and log files

To process only step3
------------------------------
It is also possible to run only the last step (reco with TICL).

Before starting the submission, some manual operations are needed in the ```batchScript_onlystep3_template.sh``` file. The storage and local folder should be modified to fit your needs and setup.

```sh submit_onlystep3.sh``` is the command to run to setup the production and submit condor jobs.
```sh submit_onlystep3.sh``` needs some arguments:
* ```-f```: name of the folder in the storage area where step2 files (in a proper ```step2``` folder) are stored
* ```-s```: name of the folder where step3 files will be stored
