function CardGameTask_prac(subjectnum,cbtype)
%cbtype = 1, then A, I, A, I

if cbtype == 1
    feedbackorder = [1 2];
else
    feedbackorder = [2 1];
end

% Converts argument passed to function into a char array if necessary.
if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end


%rand('state',sum(100*clock));
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


% TRIAL INFO --> going from 36 to 40 trials (~4 extra minutes of data)
ntrials = 10; %

%%%scanning timing%%%
%ITI_list = [repmat(5,1,20) repmat(6.5,1,10) repmat(8,1,5) repmat(9.5,1,3) 11 11];
%ITI_list = Shuffle(ITI_list);
%ISI_list = [repmat(3.5,1,20) repmat(4.25,1,10) repmat(5,1,5) repmat(5.75,1,3) 6.5 6.5];
%ISI_list = Shuffle(ISI_list);
%responsewindow = 2.5;
%outcomedur = 1;

%%%behavioral pilot timing%%%
ITI_list = [repmat(1.0,1,20) repmat(1.5,1,10) repmat(2.0,1,5) repmat(2.5,1,3) 3.0 3.0];
ITI_list = Shuffle(ITI_list);
ISI_list = [repmat(0.5,1,20) repmat(1.0,1,10) repmat(1.5,1,5) repmat(2.0,1,3) 2.5 2.5];
ISI_list = Shuffle(ISI_list);
responsewindow = 2.5;
outcomedur = 1;



%General timing (in seconds):
%Decision phase (max, leftover goes to ISI):	2.5
%ISI (weighted avg):	4.5
%outcome (fixed):	1
%ITI (weighted avg):	7
%Total trial length:	15



try
    
    
    %%%MAKE BUTTON CODES PORTABLE. ALL BUTTON CHANGES SHOULD BE HERE%%%
    KbName('UnifyKeyNames'); %I think this only helps with the escape key
    
    L_arrow = KbName('LeftArrow');
    D_arrow = KbName('DownArrow');
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
    Screen('CloseAll');
    [window,screenRect] = Screen('OpenWindow', 0, gray, []);
    
    HideCursor;
    ListenChar(2);
    WaitSecs(.5);
    
    centerhoriz = screenRect(3)/2;
    centervert = screenRect(4)/2;
    scale_res = [1 1];
    
    %Create offscreen window to save displays to
    %[display]=Screen('OpenOffscreenWindow',window,screencolor);
    
    %%%set image and rect sizes%%%
    above_fixation = (15*scale_res(2));
    scale_pic_size = 1.2; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
    
    xDim_S = (225*scale_res(1))*scale_pic_size; % size of the suit (pixels)
    yDim_S = xDim_S;
    
    xDim_F = (200*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    
    xDim_O = (180*scale_res(1))*scale_pic_size; % size of the oval (pixels)
    yDim_O = xDim_O;
    
    
    moveleft = -300;
    moveright = 300;
    LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    MiddleRect = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation];
    
    oval_rect = [(screenRect(3)/2-xDim_O/2) (screenRect(4)/2-yDim_O/2) (screenRect(3)/2+xDim_O/2) (screenRect(4)/2+yDim_O/2)];
    
    
    %% test buttons
    keep_going = 1;
    while keep_going
        
        Screen('TextSize', window, floor((25*scale_res(2))));
        longest_msg = 'Left Button               Middle Button               Right Button '; %You''ll see the outcome of one decision at the end of the task.
        [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-220, black);
        Screen('TextStyle', window, 0);
        
        Screen('FillRect', window, white, LeftRect);
        Screen('FillRect', window, white, RightRect);
        
        Screen('FillRect', window, white, MiddleRect);
        Screen('FrameRect',window, black, MiddleRect,7);
        
        Screen('FrameRect',window, black, LeftRect,7);
        Screen('FrameRect',window, black, RightRect,7);
        Screen('Flip',window);
        
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-220, black);
        Screen('TextStyle', window, 0);
        Screen('FillRect', window, white, LeftRect);
        Screen('FillRect', window, white, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        Screen('FillRect', window, white, MiddleRect);
        Screen('FrameRect',window,black,MiddleRect,7);
        press = 0;
        while ~press
            RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if find(responsecode) == L_arrow %LEFT
                Screen('FrameRect',window,[0 0 255],LeftRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == D_arrow %Middle
                Screen('FrameRect',window,[0 0 255],MiddleRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == R_arrow %RIGHT
                Screen('FrameRect',window,[0 0 255],RightRect,7);
                press = 1;
                Screen('Flip', window);
            elseif find(responsecode) == esc_key
                press = 1;
                keep_going = 0;
            end
        end
        if press
            WaitSecs(.750);
        end
    end
    Screen('Flip', window);
    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
    Screen('Flip', window);
    WaitSecs(.750);
    
    
    
    count = 0;
    for gametype = feedbackorder
        count = count + 1;
        
        if gametype == 1
            %affective game
            deck1 = [ones(1,10) repmat(2,1,10) repmat(3,1,10) repmat(4,1,10)];
            deck1 = Shuffle(deck1);
            deck2 = deck1;
            deck2 = Shuffle(deck2);
            deck3 = deck1;
            deck3 = Shuffle(deck3);
            
            type = 'affective';
            if count < 3
                instruction_msg = sprintf('Practice %d of %d: Get points in the Point Game!', count, length(feedbackorder));
            else
                instruction_msg = sprintf('Practice %d of %d: You need more points to play in the Bonus Game!', count, length(feedbackorder));
            end
            deck1_color = cool1;
            deck2_color = cool2;
            deck3_color = cool3;
        elseif gametype == 2
            
            deck1 = [repmat({'B'},1,16) repmat({'H'},1,12) repmat({'S'},1,8) repmat({'Y'},1,4)];
            deck1 = Shuffle(deck1);
            deck2 = [repmat({'Y'},1,16) repmat({'B'},1,12) repmat({'H'},1,8) repmat({'S'},1,4)];
            deck2 = Shuffle(deck2);
            deck3 = [repmat({'S'},1,16) repmat({'Y'},1,12) repmat({'B'},1,8) repmat({'H'},1,4)];
            deck3 = Shuffle(deck3);
            
            %{
            
            PRAC conversion:
            D = B
            K = H
            X = S
            Z = Y
            
            D: D1 > D2, D1 > D3, D2 > D3
            K: D1 > D2, D2 > D3, D1 > D3
            X: D1 > D2, D3 > D2, D3 > D1
            Z: D2 > D1, D2 > D3, D3 > D1
            
            %}
            
            type = 'informative';
            if count < 3
                instruction_msg = sprintf('Run %d of %d: Gain information in the Letter Game!', count, length(feedbackorder));
            else
                instruction_msg = sprintf('Run %d of %d: You need more information to do well in the Bonus Game!', count, length(feedbackorder));
            end
            deck1_color = warm1;
            deck2_color = warm2;
            deck3_color = warm3;
        end
        
        deckorders = [1 2 3; 1 3 2; 3 2 1; 3 1 2; 2 3 1; 2 1 3];
        
        
        Screen('TextSize', window, floor((30*scale_res(2))));
        Screen('TextFont', window, 'Helvetica');
        
        % oldStyle=Screen('TextStyle', windowPtr [,style]);
        % [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
        Screen('TextStyle', window, 0);
        
        
        
        %%%Setting the intro screen%%%
        Screen('TextSize', window, floor((25*scale_res(2))));
        longest_msg = instruction_msg;
        [normBoundsRect, notused] = Screen('TextBounds', window, longest_msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, instruction_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
        Screen('TextStyle', window, 0);
        Screen('DrawText', window, 'On each trial, you will see three decks.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
        if gametype == 1 %affective
            Screen('DrawText', window, 'Each deck contains points.', (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
        elseif gametype == 2 %informative
            Screen('DrawText', window, 'Each deck contains different sets of letters.', (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
        end
        Screen('DrawText', window, 'Use the left, middle, and right buttons to make your choice.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(35*scale_res(2))), black);
        Screen('DrawText', window, 'Press the spacebar to start the practice.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(70*scale_res(2))), black);
        %oldTextSize=Screen('TextSize', windowPtr [,textSize]);
        
        Screen('Flip', window);
        
        
        
        
        %start sequence. will change this to receive a scanner pulse
        go = 1;
        while go
            [keyIsDown, notused, keyCode] = KbCheck; %Keyboard input
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
        
        
        %%%START TRIAL LOOP%%%
        
        %%%saving data info%%%
        outputname = fullfile(outputdir, [subjectnum '_' type 'feedback_' num2str(count) '.mat']);
        startsecs = GetSecs;
        for k = 1:ntrials
            abort = 0;
            lapse = 0;
            
            eventsecs = GetSecs; %start event clock
            
            
            if k == 1
                delayt = 4;
                WaitSecs(delayt);
            else
                delayt = 0;
            end
            
            
            ITI = ITI_list(k);
            ISI = ISI_list(k);
            
            %deckorder = deckorders(ceil(rand*6),:);
            deckorder = deckorders(1,:);

            eval(['left_card_val = deck' num2str(deckorder(1)) '(k);'])
            eval(['middle_card_val = deck' num2str(deckorder(2)) '(k);'])
            eval(['right_card_val = deck' num2str(deckorder(3)) '(k);'])
            
            eval(['left_card_color = deck' num2str(deckorder(1)) '_color;']) %deck1_color
            eval(['middle_card_color = deck' num2str(deckorder(2)) '_color;']) %deck1_color
            eval(['right_card_color = deck' num2str(deckorder(3)) '_color;']) %deck1_color
            
            
            
            %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
            %Screen('FillRect', windowPtr [,color] [,rect] )
            Screen('FillRect', window, left_card_color, LeftRect);
            Screen('FillRect', window, middle_card_color, MiddleRect);
            Screen('FillRect', window, right_card_color, RightRect);
            Screen('FrameRect',window,black,LeftRect,7);
            Screen('FrameRect',window,black,MiddleRect,7);
            Screen('FrameRect',window,black,RightRect,7);
            Screen('Flip', window);
            decisionphase_onset = GetSecs - startsecs;
            
            
            Screen('FillRect', window, left_card_color, LeftRect);
            Screen('FillRect', window, middle_card_color, MiddleRect);
            Screen('FillRect', window, right_card_color, RightRect);
            Screen('FrameRect',window,black,LeftRect,7);
            Screen('FrameRect',window,black,MiddleRect,7);
            Screen('FrameRect',window,black,RightRect,7);
            
            
            
            RT_start = GetSecs; %start RT clock
            
            
            %%%MAKE CHOICE%%%
            press = 0;
            while ~press
                RT = 0;
                [~, ~, responsecode] = KbCheck; %Keyboard input
                if GetSecs - (eventsecs+delayt) > responsewindow
                    Screen('Flip', window);
                    msg = 'Respond faster!';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 0);
                    Screen('TextSize', window, 40);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
                    Screen('Flip', window);
                    lapse = 1;
                    press = 1;
                    choice = 0;
                    deckchoice = 0;
                    RT_onset = 0;
                else
                    if find(responsecode) == L_arrow %LEFT
                        Screen('FrameRect',window,white,LeftRect,7);
                        RT = GetSecs - RT_start;
                        press = 1;
                        choice = left_card_val;
                        Screen('Flip', window);
                        RT_onset = GetSecs - startsecs;
                        deckchoice = deckorder(1);
                    elseif find(responsecode) == D_arrow %Middle
                        Screen('FrameRect',window,white,MiddleRect,7);
                        RT = GetSecs - RT_start;
                        press = 1;
                        choice = middle_card_val;
                        RT_onset = GetSecs - startsecs;
                        Screen('Flip', window);
                        deckchoice = deckorder(2);
                    elseif find(responsecode) == R_arrow %RIGHT
                        Screen('FrameRect',window,white,RightRect,7);
                        RT = GetSecs - RT_start;
                        press = 1;
                        choice = right_card_val;
                        RT_onset = GetSecs - startsecs;
                        Screen('Flip', window);
                        deckchoice = deckorder(3);
                    elseif find(responsecode) == esc_key
                        abort = 1;
                    end
                end
            end
            WaitSecs(.750);
            
            
            Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
            Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
            Screen('Flip', window);
            while GetSecs - (eventsecs+delayt+responsewindow) < ISI %timing loop
                [responded, responsetime, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort = 1;
                end
            end
            feedback_onset = 0;
            if ~lapse
                Screen('FillOval', window, black, oval_rect);
                if gametype == 1 %affective
                    msg = num2str(choice);
                elseif gametype == 2 %informative
                    choice = choice{1};
                    msg = choice;
                end
                Screen('TextSize', window, 50);
                [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                Screen('TextStyle', window, 1);
                Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                Screen('TextStyle', window, 0);
                Screen('Flip', window);
                feedback_onset = GetSecs - startsecs;
            end
            
            while GetSecs - (eventsecs+delayt+ISI+responsewindow) < outcomedur %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort = 1;
                end
            end
            
            %%%save data here%%%
            data(k).choice = choice;
            data(k).RT = RT;
            data(k).RT_onset = RT_onset;
            data(k).lapse = lapse;
            data(k).deckorder = deckorder;
            data(k).deckchoice = deckchoice;
            data(k).ITI = ITI;
            data(k).ISI = ISI;
            data(k).decisionphase_onset = decisionphase_onset;
            data(k).feedback_onset = feedback_onset;
            
            
            %%%ITI PERIOD: DRAW FIXATION CROSS%%%
            Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
            Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
            Screen('Flip', window);
            while GetSecs - (eventsecs+delayt+ISI+responsewindow+outcomedur) < ITI %timing loop
                [keyIsDown, secs, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort = 1;
                end
            end
            
            if abort
                ListenChar(0);
                Screen('CloseAll');
                end_secs = GetSecs;
                run_time = end_secs - startsecs;
                save(outputname, 'data','run_time');
                return;
            end
        end
        WaitSecs(4); %wait 4 seconds at the end to let last feedback HRF return to baseline.
        end_secs = GetSecs;
        run_time = end_secs - startsecs;
        save(outputname, 'data','run_time');
    end
    
    ListenChar(0);
    Screen('CloseAll');
    
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    keyboard
end
