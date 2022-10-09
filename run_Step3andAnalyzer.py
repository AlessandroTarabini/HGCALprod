# Auto generated configuration file
# using:
# Revision: 1.19
# Source: /local/reps/CMSSW/CMSSW/Configuration/Applications/python/ConfigBuilder.py,v
# with command line options: step3 --conditions auto:phase2_realistic_T15 -s RAW2DIGI,L1Reco,RECO,RECOSIM --datatier GEN-SIM-RECO -n 10 --geometry Extended2026D49 --era Phase2C9 --eventcontent FEVTDEBUGHLT --filein file:step2.root --fileout file:step3.root --no_exec
import FWCore.ParameterSet.Config as cms

#from Configuration.Eras.Era_Phase2C9_cff import Phase2C9
#from Configuration.ProcessModifiers.clue3D_cff import clue3D
from Configuration.StandardSequences.Eras import eras
from Configuration.Eras.Era_Phase2C17I13M9_cff import Phase2C17I13M9


process = cms.Process('TEST',Phase2C17I13M9)
#process = cms.Process('RECO',Phase2C17I13M9)
#process = cms.Process('TEST',Phase2C9,clue3D)

# import of standard configurations
process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.load('Configuration.EventContent.EventContent_cff')
#process.load('SimGeneral.MixingModule.mixNoPU_cfi')
process.load('SimGeneral.MixingModule.mix_POISSON_average_cfi')
#process.load('Configuration.Geometry.GeometryExtended2026D49Reco_cff')
process.load('Configuration.StandardSequences.MagneticField_cff')
process.load('Configuration.StandardSequences.RawToDigi_cff')
process.load('Configuration.StandardSequences.L1Reco_cff')
process.load('Configuration.StandardSequences.Reconstruction_cff')
process.load('Configuration.StandardSequences.RecoSim_cff')
process.load('Configuration.StandardSequences.EndOfProcess_cff')
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')


process.load('Configuration.Geometry.GeometryExtended2026D88_cff')
process.load('Configuration.Geometry.GeometryExtended2026D88Reco_cff')




from FastSimulation.Event.ParticleFilter_cfi import *




process.maxEvents = cms.untracked.PSet(
    input = cms.untracked.int32(-1),
#    input = cms.untracked.int32(-1),

   output = cms.optional.untracked.allowed(cms.int32,cms.PSet)
)

# Input source
process.source = cms.Source("PoolSource",
#    fileNames = cms.untracked.vstring('file:step3_t.root'),
#    fileNames = cms.untracked.vstring('file:/afs/cern.ch/work/s/shghosh/public/HGCAL_TICL_STUFF/TICL_DEBUG/CMSSW_11_2_0_pre10/src/prod/step2.root'),
#    fileNames = cms.untracked.vstring('file:/afs/cern.ch/work/s/shghosh/public/HGCAL_TICL_STUFF/TICL_DEBUG/CMSSW_11_2_0_pre10/src/prod/morestat/step2.root'),
    fileNames = cms.untracked.vstring(
    #    'file:/afs/cern.ch/work/s/shghosh/public/HGCAL_TICL_STUFF/TICL_DEBUG/CMSSW_11_2_0_pre10/src/prod/morestatpion/step2.root'
#   'file:/grid_mnt/data__data.polcms/cms/sghosh/GENPHOTEST/step2_0.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/GENPHOTEST/step2_1.root'
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/GENPITEST/step2_1.root'
#         'file:/grid_mnt/data__data.polcms/cms/sghosh/GENPHOTESTPU2/step2_257.root',
#        'file:/grid_mnt/data__data.polcms/cms/tarabini/electrons/step2/step2_98.root'
        'file:step2.root'
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_0.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_1.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_2.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_3.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_4.root',
#        'file:/grid_mnt/data__data.polcms/cms/sghosh/VALDATA/PhaseIISpring22DRMiniAOD_photon/file_5.root'


#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/31f4bed2-aca8-4bdb-9a59-e809e99cf8f7.root',
#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/dcd939b4-45fc-40d5-ab50-c8e8b326e07c.root',
#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/11297820-b650-43b5-98d5-df0bfeb3e8f4.root',
#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/f7398850-abd2-4c47-aaf6-2a3abe7a296a.root',
#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/66036b41-2100-4a67-989d-9c6828174c5c.root',
#        'root://xrootd-cms.infn.it//store/mc/PhaseIISpring22DRMiniAOD/SinglePhoton_Pt-2To200-gun/GEN-SIM-DIGI-RAW-MINIAOD/PU200_123X_mcRun4_realistic_v11-v1/2560000/2b53c5d4-5968-42b3-a456-b7c2db56f203.root',


    ),
    secondaryFileNames = cms.untracked.vstring(),
#    secondaryFileNames = cms.untracked.vstring(),
#    skipEvents=cms.untracked.uint32(1)
    duplicateCheckMode = cms.untracked.string('noDuplicateCheck'),
    dropDescendantsOfDroppedBranches=cms.untracked.bool(False),
    inputCommands=cms.untracked.vstring(
                  'keep *',
                  'drop *l1tTkPrimaryVertexs_L1TkPrimaryVertex__HLT',
#                  'drop *_*_*_HLT',
#                  'keep FEDRawDataCollection_*_*_*'
          )













)

process.options = cms.untracked.PSet(
    FailPath = cms.untracked.vstring(),
    IgnoreCompletely = cms.untracked.vstring(),
    Rethrow = cms.untracked.vstring(),
    SkipEvent = cms.untracked.vstring(),
    allowUnscheduled = cms.obsolete.untracked.bool,
    canDeleteEarly = cms.untracked.vstring(),
    emptyRunLumiMode = cms.obsolete.untracked.string,
    eventSetup = cms.untracked.PSet(
        forceNumberOfConcurrentIOVs = cms.untracked.PSet(
            allowAnyLabel_=cms.required.untracked.uint32
        ),
        numberOfConcurrentIOVs = cms.untracked.uint32(1)
    ),
    fileMode = cms.untracked.string('FULLMERGE'),
    forceEventSetupCacheClearOnNewRun = cms.untracked.bool(False),
    makeTriggerResults = cms.obsolete.untracked.bool,
    numberOfConcurrentLuminosityBlocks = cms.untracked.uint32(1),
    numberOfConcurrentRuns = cms.untracked.uint32(1),
    numberOfStreams = cms.untracked.uint32(0),
    numberOfThreads = cms.untracked.uint32(1),
    printDependencies = cms.untracked.bool(False),
    sizeOfStackForThreadsInKB = cms.optional.untracked.uint32,
    throwIfIllegalParameter = cms.untracked.bool(True),
    wantSummary = cms.untracked.bool(False)
)

# Production Info
process.configurationMetadata = cms.untracked.PSet(
    annotation = cms.untracked.string('step3 nevts:10'),
    name = cms.untracked.string('Applications'),
    version = cms.untracked.string('$Revision: 1.19 $')
)

# Output definition

process.FEVTDEBUGHLToutput = cms.OutputModule("PoolOutputModule",
    dataset = cms.untracked.PSet(
        dataTier = cms.untracked.string('GEN-SIM-RECO'),
        filterName = cms.untracked.string('')
    ),
    fileName = cms.untracked.string('file:step3.root'),
    outputCommands = process.FEVTDEBUGHLTEventContent.outputCommands,
    splitLevel = cms.untracked.int32(0)
)


#process._hgcalTracksterMapper_HGCal.pid_threshold = cms.double(0.5)
#process.particleFlowClusterHGCal.initialClusteringStep.pid_threshold =  cms.double(0.8)
#process.particleFlowClusterHGCal.initialClusteringStep.filterByTracksterIteration = cms.bool(False)
#process.particleFlowClusterHGCal.initialClusteringStep.filterByTracksterPID = cms.bool(True)


process.ticlMultiClustersFromTrackstersTEST = cms.EDProducer("MultiClustersFromTrackstersProducer",
    LayerClusters = cms.InputTag("hgcalLayerClusters"),
    Tracksters = cms.InputTag("ticlTrackstersMerge"), ## merged tracksters
#    Tracksters = cms.InputTag("ticlTrackstersCLUE3DHigh"), ## raw tracksters clue3d
    mightGet = cms.optional.untracked.vstring,
    verbosity = cms.untracked.uint32(3)
)

process.ana = cms.EDAnalyzer('HGCalAnalysis',
                             detector = cms.string("all"),

                             inputTag_HGCalMultiCluster = cms.string("ticlMultiClustersFromTrackstersTEST"),
                             inputTag_Reco = cms.string("TEST"),  ## switch reco collection to use
                             inputTag_ReReco = cms.string("TEST"),  ## switch reco collection to use
#                             inputTag_HGCalMultiCluster = cms.string("hgcalMultiClusters"),
                             CaloHitSourceEE = cms.string("HGCHitsEE"),
                             CaloHitSourceHEfront = cms.string("HGCHitsHEfront"),
                             CaloHitSourceHEback = cms.string("HGCHitsHEback"),
                             rawRecHits = cms.bool(True),
                             verbose = cms.bool(True),
                             readCaloParticles = cms.bool(True),
                             storeGenParticleOrigin = cms.bool(True),
                             storeGenParticleExtrapolation = cms.bool(True),
                             storeElectrons = cms.bool(True),
                             storePFCandidates = cms.bool(True),
                             storeGunParticles = cms.bool(True),
                             readGenParticles = cms.bool(True),
                             layerClusterPtThreshold = cms.double(-1),  # All LayerCluster belonging to a multicluster are saved; this Pt threshold applied to the others
                             TestParticleFilter = ParticleFilterBlock.ParticleFilter
)




process.TFileService = cms.Service("TFileService",
                                   fileName = cms.string("file:step3.root")

                                   )

# Other statements
from Configuration.AlCa.GlobalTag import GlobalTag
#process.GlobalTag = GlobalTag(process.GlobalTag, 'auto:phase2_realistic_T15', '')
process.GlobalTag = GlobalTag(process.GlobalTag, 'auto:phase2_realistic_T21', '')

# Path and EndPath definitions
process.raw2digi_step = cms.Path(process.RawToDigi)
process.L1Reco_step = cms.Path(process.L1Reco)
process.reconstruction_step = cms.Path(process.reconstruction)
process.recosim_step = cms.Path(process.recosim)
process.endjob_step = cms.EndPath(process.endOfProcess)
process.FEVTDEBUGHLToutput_step = cms.EndPath(process.FEVTDEBUGHLToutput)
process.analyze_step = cms.Path(process.ana)
#process.analyze_step2 = cms.Path(process.HGCANALYZE)
#process.extendclue3d = cms.Path(process.ticlTrackstersCLUE3DHighTEST*process.ticlMultiClustersFromTrackstersTEST)
process.extendclue3d = cms.Path(process.ticlMultiClustersFromTrackstersTEST)
rereco = True

if rereco:
    # Schedule definition
#    process.schedule = cms.Schedule(process.raw2digi_step,process.L1Reco_step,process.reconstruction_step,process.recosim_step,process.analyze_step2,process.endjob_step)#,process.FEVTDEBUGHLToutput_step)
#    process.schedule = cms.Schedule(process.raw2digi_step,process.L1Reco_step,process.reconstruction_step,process.recosim_step,process.analyze_step,process.endjob_step)#,process.FEVTDEBUGHLToutput_step) ##### used for actual reco+ntupler last 05/07/2021
    #process.schedule = cms.Schedule(process.raw2digi_step,process.L1Reco_step,process.reconstruction_step,process.extendclue3d,process.recosim_step,process.analyze_step,process.endjob_step)
    #    process.schedule = cms.Schedule(process.reconstruction_step,process.analyze_step,process.endjob_step)
#    process.schedule = cms.Schedule(process.analyze_step,process.endjob_step)
    process.schedule = cms.Schedule(process.raw2digi_step,process.reconstruction_step,process.extendclue3d,process.analyze_step,process.endjob_step)



#    process.schedule = cms.Schedule(process.raw2digi_step,process.L1Reco_step,process.reconstruction_step,process.recosim_step,process.endjob_step,process.FEVTDEBUGHLToutput_step)
    from PhysicsTools.PatAlgos.tools.helpers import associatePatAlgosToolsTask
    associatePatAlgosToolsTask(process)



    # Customisation from command line

    #Have logErrorHarvester wait for the same EDProducers to finish as those providing data for the OutputModule
    from FWCore.Modules.logErrorHarvester_cff import customiseLogErrorHarvesterUsingOutputCommands
    process = customiseLogErrorHarvesterUsingOutputCommands(process)

    # Add early deletion of temporary data products to reduce peak memory need
    from Configuration.StandardSequences.earlyDeleteSettings_cff import customiseEarlyDelete
    process = customiseEarlyDelete(process)
    # End adding early deletion

else:
    process.schedule = cms.Schedule(process.analyze_step2)#,process.FEVTDEBUGHLToutput_step)
