#ifndef HGCAL_RECO_ANALYSIS_HGCMLANALYZER_H
#define HGCAL_RECO_ANALYSIS_HGCMLANALYZER_H

#include <vector>
#include "DataFormats/DetId/interface/DetId.h"

struct caloparticle {
  int idx_;
  int pdgid_;
  double energy_;
  double pt_;
  double eta_;
  double phi_;
  int ntrkmatchcp_;
  std::vector<DetId> rechitdetid_;
  std::vector<double> rechitenergy_;
  std::vector<double> rechitenergyuncorr_;

  inline std::string print() {
    std::ostringstream lStr;
    lStr << "CP " << idx_
       << " pdg " << pdgid_
       << " E " << energy_ 
       << " eta " << eta_ << " phi " << phi_ 
	 << " nhits " << rechitenergy_.size() 
	 << std::endl;
    return lStr.str();
  };

};

struct layercluster {
  double energy_;
  double eta_;
  double phi_;
  int algo_;
  double x_;
  double y_;
  double z_;
  int nrechits_;
  int layer_;
  int idx2Trackster_;
  int tsMult_;
};

struct ttrackster {
  int idx_;
  int type_;  // pdgid
  double energy_;
  double eta_;
  double phi_;
  double x_;
  double y_;
  double z_;
  double pcaeigval0_;
  double pcasig0_;
  double pcaeigval1_;
  double pcasig1_;
  double pcaeigval2_;
  double pcasig2_;
  double cpenergy_;
  double cpeta_;
  int cppdgid_;
  int outInHopsPerformed_;
  std::vector<DetId> rechitdetid_;
  std::vector<double> rechitenergy_;
};

struct Triplet {
  double eA_;
  double eB_;
  double eC_;
  double etaB_;
  double drB_ ; 
  int layerA_;
  int layerB_;
  int layerC_;
  double cosAlphaInner_;
  double cosAlphaOuter_;
  double cosBeta_;
  int inner_in_links_;
  int inner_out_links_;
  int outer_in_links_;
  int outer_out_links_;

  void initialise(){
    eA_ = -1;
    eB_ = -1;
    eC_ = -1;
    etaB_ = -5;
    drB_ = -1;
    layerA_ = 0;
    layerB_ = 0;
    layerC_ = 0;
    cosAlphaInner_ = -1;
    cosAlphaOuter_ = -1;
    cosBeta_ = -1;
    inner_in_links_ = -1;
    inner_out_links_ = -1;
    outer_in_links_ = -1;
    outer_out_links_ = -1;
  };
};


#endif
