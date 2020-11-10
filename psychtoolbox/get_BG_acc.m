function acc = get_BG_acc(subjnum)

%/Users/dvsmith/Dropbox/Projects/Rutgers/AffectiveInformative/ExperimentFiles/BehavioralData/221
subj = num2str(subjnum);

maindir = pwd;
fname = fullfile(maindir,'BehavioralData',subj,[subj '_BonusGame.mat']);
load(fname)
acc = mean(accuracy);