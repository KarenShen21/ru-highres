function postscan_wrapper(subjnum,cbtype)
%subjnum is the subject number. 101, 102, ...
%cbtype is counterbalances order (A,I,A,I or I,A,I,A)

currentdir = pwd;



%% WTP task
disp(' ')
disp(' ')
fprintf('Please get the Experimenter. \nBefore we count your point total, you will complete the Purchasing Task.\n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end
DualExchangeTask(subjnum)


%% bonus game task
disp(' ')
disp(' ')
fprintf('Please get the Experimenter. You are about to start the Bonus Game.\n')
quitwrapper = stop_wrapper;
if quitwrapper
    return
end
BonusTask(subjnum)


cd(currentdir)



function quitwrapper = stop_wrapper()
keep_waiting = 1;
while keep_waiting
    yes_no = input('yes/no: ', 's');
    if strcmp(yes_no, 'yes')
        keep_waiting = 0;
        quitwrapper = 0;
    elseif strcmp(yes_no, 'no')
        quitwrapper = 1;
        return;
    else
        fprintf('Please respond with either ''yes'' or ''no''.\n')
    end
end
