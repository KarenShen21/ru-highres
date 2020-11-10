function DualExchangeTask(subjectnum)

% Converts argument passed to function into a char array if necessary.
if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end


%parameters and display preferences
% rand('state',sum(100*clock));
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

%defining some colors for later [r g b]
gray = [190 190 190];
black = [0 0 0];
white = [255 255 255];

cool1 = [0 0 204];
cool2 = [51 255 255];
cool3 = [153 255 153];
warm1 = [204 0 0]; %red
warm2 = [255 153 51];
warm3 = [255 255 153];


%% BUILD THE TRIALS
%Informative trials -- "more attractive and expensive option"
inf_choices = [1 4; 1 5; 1 6; 2 4; 2 5; 2 6; 3 4; 3 5; 3 6];
inf_prices = combnk(1:2:7,2);
inf_pairings = zeros(length(inf_choices) * length(inf_prices),4);
count = 0;
for c = 1:length(inf_choices)
    for p = 1:length(inf_prices)
        count = count + 1;
        inf_pairings(count,1) = inf_choices(c,1); %aff_card
        inf_pairings(count,2) = inf_choices(c,2); %inf_card
        inf_pairings(count,3) = inf_prices(p,1); %aff_price
        inf_pairings(count,4) = inf_prices(p,2); %inf_price
    end
end
%Affective trials -- "more attractive and expensive option"
aff_choices = [4 1; 5 1; 6 1; 4 2; 5 2; 6 2; 4 3; 5 3; 6 3];
aff_prices = combnk(1:2:7,2);
aff_pairings = zeros(length(aff_choices) * length(aff_prices),4);
count = 0;
for c = 1:length(aff_choices)
    for p = 1:length(aff_prices)
        count = count + 1;
        aff_pairings(count,1) = aff_choices(c,1); %inf_card
        aff_pairings(count,2) = aff_choices(c,2); %aff_card
        aff_pairings(count,3) = aff_prices(p,1); %inf_price
        aff_pairings(count,4) = aff_prices(p,2); %aff_price
    end
end
all_trials = [aff_pairings ones(length(aff_pairings),1); inf_pairings ones(length(inf_pairings),1)*2];
%max spent: $6.12
%min spent: $2.52
ntrials = length(all_trials);
try
    
    KbName('UnifyKeyNames'); %I think this only helps with the escape key
    
    %%%MAKE BUTTON CODES PORTABLE. ALL BUTTON CHANGES SHOULD BE HERE%%%
    L_arrow = KbName('LeftArrow');
    R_arrow = KbName('RightArrow');
    
    esc_key = KbName('ESCAPE');
    space_key = KbName('space');
    go_button = space_key;
    
    %%%Make outputdir if it does not already exist%%%
    maindir = pwd;
    outputdir = fullfile(maindir,'BehavioralData',subjectnum);
    if ~exist(outputdir,'dir')
        mkdir(outputdir);
    end
    
    %setting up the screens
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('CloseAll');
    [window,screenRect] = Screen('OpenWindow', 0, gray, []);
    
    HideCursor;
    ListenChar(2);
    WaitSecs(.5);
    
    centerhoriz = screenRect(3)/2;
    centervert = screenRect(4)/2;
    scale_res = [1 1];
    
    %SET OUTCOMES
    deck1 = [ones(1,10) repmat(2,1,10) repmat(3,1,10) repmat(4,1,10)];
    deck1 = Shuffle(deck1);
    deck2 = deck1;
    deck2 = Shuffle(deck2);
    deck3 = deck1;
    deck3 = Shuffle(deck3);
    deck1_color = cool1;
    deck2_color = cool2;
    deck3_color = cool3;
    
    deck4 = [repmat({'D'},1,16) repmat({'K'},1,12) repmat({'X'},1,8) repmat({'Z'},1,4)];
    deck4 = Shuffle(deck4);
    deck5 = [repmat({'Z'},1,16) repmat({'D'},1,12) repmat({'K'},1,8) repmat({'X'},1,4)];
    deck5 = Shuffle(deck5);
    deck6 = [repmat({'X'},1,16) repmat({'Z'},1,12) repmat({'D'},1,8) repmat({'K'},1,4)];
    deck6 = Shuffle(deck6);
    deck4_color = warm1;
    deck5_color = warm2;
    deck6_color = warm3;
    
    
    
    
    Screen('TextSize', window, floor((30*scale_res(2))));
    Screen('TextFont', window, 'Helvetica');
    
    % oldStyle=Screen('TextStyle', windowPtr [,style]);
    % [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
    Screen('TextStyle', window, 0);
    
    
    %Create offscreen window to save displays to
    %[display]=Screen('OpenOffscreenWindow',window,screencolor);
    
    %%%set image and rect sizes%%%
    above_fixation = (15*scale_res(2));
    scale_pic_size = 1.2; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
    
    
    xDim_F = (200*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    
    
    
    moveleft = -250;
    moveright = 250;
    LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    
    
    xDim_O = (180*scale_res(1))*scale_pic_size; % size of the oval (pixels)
    yDim_O = xDim_O;
    oval_rect = [(screenRect(3)/2-xDim_O/2) (screenRect(4)/2-yDim_O/2) (screenRect(3)/2+xDim_O/2) (screenRect(4)/2+yDim_O/2)];
    
    
    %%%Setting the intro screen%%%
    %Screen('TextStyle', window, 1);
    Screen('TextSize', window, floor((25*scale_res(2))));
    longest_msg = 'Additional information will increase your odds of winning money in the Bonus Game.'; %You''ll see the outcome of one decision at the end of the task.
    [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, 'You''re almost done! Now you''ll play the Purchasing Game.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, 'You have $2 to spend on additional points and additional information.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(120*scale_res(2))), black);
    Screen('DrawText', window, 'Additional points will increase your odds of playing the Bonus Game.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(60*scale_res(2))), black);
    Screen('DrawText', window, 'On each trial, you will see two decks you''ve seen before.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(0*scale_res(2))), black);
    Screen('DrawText', window, 'Each deck will have a price presented below it.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(30*scale_res(2))), black);
    Screen('DrawText', window, 'Use the left and right buttons to indicate your purchase.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(90*scale_res(2))), black);
    Screen('DrawText', window, 'Press the spacebar to advance the screen.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(120*scale_res(2))), black);
    
    %oldTextSize=Screen('TextSize', windowPtr [,textSize]);
    Screen('Flip', window);
    
    
    
    %start sequence. will change this to receive a scanner pulse
    go = 1;
    while go
        [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
            if keyCode(1) == go_button
                go = 0;
            end
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                ListenChar(0);
                return;
            end
        end
    end
    
    moveleft = -300;
    moveright = 300;
    above_fixation_top = 300;
    above_fixation_bot = -300;
    LeftRect_top = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation_top) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation_top)];
    RightRect_top = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation_top) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation_top)];
    MiddleRect_top = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation_top (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation_top];
    LeftRect_bot = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation_bot) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation_bot)];
    RightRect_bot = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation_bot) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation_bot)];
    MiddleRect_bot = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation_bot (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation_bot];
    
    deckorders = [1 2 3; 1 3 2; 3 2 1; 3 1 2; 2 3 1; 2 1 3];
    deckorder = deckorders(1,:);
    %affective
    eval(['left_card_color = deck' num2str(deckorder(1)) '_color;']) %deck1_color
    eval(['middle_card_color = deck' num2str(deckorder(2)) '_color;']) %deck1_color
    eval(['right_card_color = deck' num2str(deckorder(3)) '_color;']) %deck1_color
    Screen('FillRect', window, left_card_color, LeftRect_top);
    Screen('FillRect', window, middle_card_color, MiddleRect_top);
    Screen('FillRect', window, right_card_color, RightRect_top);
    Screen('FrameRect',window,black,LeftRect_top,7);
    Screen('FrameRect',window,black,MiddleRect_top,7);
    Screen('FrameRect',window,black,RightRect_top,7);
    %informative
    eval(['left_card_color = deck' num2str(deckorder(1)+3) '_color;']) %deck1_color
    eval(['middle_card_color = deck' num2str(deckorder(2)+3) '_color;']) %deck1_color
    eval(['right_card_color = deck' num2str(deckorder(3)+3) '_color;']) %deck1_color
    Screen('FillRect', window, left_card_color, LeftRect_bot);
    Screen('FillRect', window, middle_card_color, MiddleRect_bot);
    Screen('FillRect', window, right_card_color, RightRect_bot);
    Screen('FrameRect',window,black,LeftRect_bot,7);
    Screen('FrameRect',window,black,MiddleRect_bot,7);
    Screen('FrameRect',window,black,RightRect_bot,7);
    
        %%%Setting the intro screen%%%
    %Screen('TextStyle', window, 1);
    Screen('TextSize', window, floor((25*scale_res(2))));
    longest_msg = 'To get points, choose the cards above.'; %You''ll see the outcome of one decision at the end of the task.
    [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(160*scale_res(2))), black);
    Screen('DrawText', window, 'To get letters, choose the cards below.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(110*scale_res(2))), black);
    
        Screen('Flip', window);

     %start sequence. will change this to receive a scanner pulse
    go = 1;
    WaitSecs(2);
    while go
        [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
            if keyCode(1) == go_button
                go = 0;
            end
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                ListenChar(0);
                return;
            end
        end
    end
    
    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
    Screen('Flip', window);
    WaitSecs(2);
    
    %timing
    ITI_list = [0.75 0.75 0.75 1.5 1.5 2.25];
    ISI_list = [0.5 0.5 0.5 1.0 1.0 1.5];
    
    %%%saving data info%%%
    outputname = fullfile(outputdir, [subjectnum '_wtp.mat']);
    
    %%%START TRIAL LOOP%%%
    startsecs = GetSecs;
    rand_trials = randperm(length(all_trials));
    for k = 1:ntrials
        
        deck1 = Shuffle(deck1);
        deck2 = Shuffle(deck2);
        deck3 = Shuffle(deck3);
        deck4 = Shuffle(deck4);
        deck5 = Shuffle(deck5);
        deck6 = Shuffle(deck6);
        
        ISI_list = Shuffle(ISI_list);
        ITI_list = Shuffle(ITI_list);
        ISI = ISI_list(1);
        ITI = ITI_list(1);
        
        kk = rand_trials(k);
        
        
        flip = rand < 0.5;
        if flip
            left_card_price = all_trials(kk,3);
            eval(['left_card_color = deck' num2str(all_trials(kk,1)) '_color;'])
            right_card_price = all_trials(kk,4);
            eval(['right_card_color = deck' num2str(all_trials(kk,2)) '_color;'])
            eval(['left_card_val = deck' num2str(all_trials(kk,1)) '(1);'])
            eval(['right_card_val = deck' num2str(all_trials(kk,2)) '(1);'])
        else
            left_card_price = all_trials(kk,4);
            eval(['left_card_color = deck' num2str(all_trials(kk,2)) '_color;'])
            right_card_price = all_trials(kk,3);
            eval(['right_card_color = deck' num2str(all_trials(kk,1)) '_color;'])
            eval(['left_card_val = deck' num2str(all_trials(kk,2)) '(1);'])
            eval(['right_card_val = deck' num2str(all_trials(kk,1)) '(1);'])
        end
        
        
        Screen('TextSize', window, floor((50*scale_res(2))));
        Screen('DrawText', window,[num2str(left_card_price) '¢'], (centerhoriz-275), (centervert+(170*scale_res(2))), black);
        Screen('DrawText', window,[num2str(right_card_price) '¢'], (centerhoriz+235), (centervert+(170*scale_res(2))), black);
        
        
        %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
        %Screen('FillRect', windowPtr [,color] [,rect] )
        Screen('FillRect', window, left_card_color, LeftRect);
        Screen('FillRect', window, right_card_color, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        Screen('Flip', window);
        decisionphase_onset = GetSecs - startsecs;
        
        
        Screen('FillRect', window, left_card_color, LeftRect);
        Screen('FillRect', window, right_card_color, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        Screen('TextSize', window, floor((50*scale_res(2))));
        Screen('DrawText', window,[num2str(left_card_price) '¢'], (centerhoriz-275), (centervert+(170*scale_res(2))), black);
        Screen('DrawText', window,[num2str(right_card_price) '¢'], (centerhoriz+235), (centervert+(170*scale_res(2))), black);
        
        RT_start = GetSecs; %start RT clock
        
        %%%MAKE CHOICE%%%
        press = 0;
        while ~press
            RT = 0;
            [responded, responsetime, responsecode] = KbCheck; %Keyboard input
            if find(responsecode) == L_arrow %LEFT
                Screen('FrameRect',window,white,LeftRect,7);
                RT = GetSecs - RT_start;
                press = 1;
                choice = left_card_val;
                Screen('Flip', window);
                RT_onset = GetSecs - startsecs;
                price = left_card_price;
                if left_card_price > right_card_price
                    exchange = 1;
                else
                    exchange = 0;
                end
            elseif find(responsecode) == R_arrow %RIGHT
                Screen('FrameRect',window,white,RightRect,7);
                RT = GetSecs - RT_start;
                press = 1;
                choice = right_card_val;
                RT_onset = GetSecs - startsecs;
                Screen('Flip', window);
                price = right_card_price;
                if right_card_price > left_card_price
                    exchange = 1;
                else
                    exchange = 0;
                end
            elseif find(responsecode) == esc_key
                press = 1;
                ListenChar(0);
                Screen('CloseAll');
                return;
            end
        end
        WaitSecs(.750);
        
        
        
        %%%ISI PERIOD: DRAW FIXATION CROSS%%%
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ISI);
        
        
        %%%SHOW OUTCOME
        msg = choice;
        if iscell(msg)
            msg = msg{1};
        end
        if ~ischar(msg)
            msg = num2str(msg);
        end
        %ListenChar(0);
        %Screen('CloseAll');
        %keyboard;
        
        Screen('FillOval', window, black, oval_rect);
        Screen('TextSize', window, 50);
        [normBoundsRect, ~] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        WaitSecs(1);
        
        
        %%%ITI PERIOD: DRAW FIXATION CROSS%%%
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ITI);
        
        
        %%%record data here%%%
        data(k).condition = all_trials(kk,5);
        data(k).RT = RT;
        data(k).RT_onset = RT_onset;
        data(k).exchange = exchange;
        data(k).ITI = ITI;
        data(k).decisionphase_onset = decisionphase_onset;
        data(k).price = price;
        
        
    end
    WaitSecs(2);
    
    %save data
    save(outputname, 'data','');
    
    
    total_spent = sum([data.price])/100;
    longest_msg = sprintf('You spent a total of $%.2f on cards.',total_spent);
    [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(0*scale_res(2))), black);
    Screen('Flip', window);
    WaitSecs(4);
    
    go = 1;
    while go
        [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
        if keyIsDown
            keyCode = find(keyCode);
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                ListenChar(0);
                return;
            end
        end
    end
    
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    cd(maindir);
    keyboard
end
cd(maindir);
