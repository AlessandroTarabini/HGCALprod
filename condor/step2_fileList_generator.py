from optparse import OptionParser
import ROOT
import os

global opt, args, runAllSteps

parser = OptionParser()

# input options
parser.add_option('',   '--path',  dest='PATH',  type='string',default='',   help='Path for step2 files')

(opt, args) = parser.parse_args()

fileList = ''
fpath = "/data_CMS/cms/" + os.environ['USER'] + "/" + opt.PATH + "/step2/"
for filename in os.listdir(fpath):
    inFile = ROOT.TFile.Open(fpath+filename ,"READ")
    if(inFile.GetListOfKeys().Contains('Events')):
        idx = filename.split('_')[1].split('.')[0]
        fileList += str(idx)+'\n'
f = open('step2files.txt', 'w')
f.write(fileList)
f.close()
