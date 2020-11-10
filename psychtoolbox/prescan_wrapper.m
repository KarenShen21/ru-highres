function prescan_wrapper(subjnum,cbtype)
%subjnum is the subject number. 101, 102, ...
%cbtype is counterbalances order (A,I,A,I or I,A,I,A)

currentdir = pwd;


%% practice
CardGameTask_prac(subjnum,cbtype)
BonusTask_prac(subjnum)

