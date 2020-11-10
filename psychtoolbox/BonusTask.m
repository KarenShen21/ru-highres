function BonusTask(subjectnum)

bonus = 5;

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


warm1 = [204 0 0];
warm2 = [255 153 51];
warm3 = [255 255 153];


%%%timing%%%
ITI_list = [ones(1,20) repmat(1.25,1,15) repmat(1.25,1,10) repmat(1.75,1,5)];
ITI_list = Shuffle(ITI_list);
ISI_list = [repmat(.5,1,20) repmat(.25,1,15) repmat(.75,1,10) repmat(.5,1,5)];
ISI_list = Shuffle(ISI_list);
outcomedur = .75;


deck1_color = warm1;
deck2_color = warm2;
deck3_color = warm3;


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
    Screen('CloseAll');
    [window,screenRect] = Screen('OpenWindow', 0, gray, []);
    
    HideCursor;
    ListenChar(2);
    
    centerhoriz = screenRect(3)/2;
    centervert = screenRect(4)/2;
    scale_res = [1 1];
    
    
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
        
    
    moveleft = -300;
    moveright = 300;
    LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    
    
    %%%Setting the intro screen%%%
    instruction_msg = sprintf('Congrats! You have earned enough points to play the Bonus Game to earn $%d.', bonus);
    Screen('TextSize', window, floor((25*scale_res(2))));
    longest_msg = 'On each trial, you will see a letter followed by two decks from the Letter Game.';
    [normBoundsRect, ~] = Screen('TextBounds', window, longest_msg);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, instruction_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
    Screen('DrawText', window, 'Your job is to pick the deck that is most likely to yield the letter.', (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
    Screen('DrawText', window, 'Use the left and right arrows to make your choice.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(60*scale_res(2))), black);
    Screen('DrawText', window, 'Press the spacebar when you are ready to begin.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(95*scale_res(2))), black);

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
    
   
    
    %%%saving data info%%%
    outputname = fullfile(outputdir, [subjectnum '_BonusGame.mat']);
    
    letters = {'D', 'D', 'D', 'K', 'K', 'K', 'X', 'X', 'X', 'Z', 'Z', 'Z'};
    choices = [1 3; 2 1; 3 2; 1 2; 2 3; 3 1; 1 3; 1 2; 3 2; 2 3; 1 2; 3 1]; 
    answers = [1      1    2  1    2      1    3  1    3    2      2  3  ];
    ease    = [1      0    0  0    1      1    1  1    1    0      1  1  ]; % twice as likely?
    ntrials = length(answers);
    
    %{
            deck1 = [repmat({'D'},1,16) repmat({'K'},1,12) repmat({'X'},1,8) repmat({'Z'},1,4)]; 
            deck2 = [repmat({'Z'},1,16) repmat({'D'},1,12) repmat({'K'},1,8) repmat({'X'},1,4)]; 
            deck3 = [repmat({'X'},1,16) repmat({'Z'},1,12) repmat({'D'},1,8) repmat({'K'},1,4)]; 
            
            D: D1 > D2, D1 > D3, D2 > D3
            K: D1 > D2, D2 > D3, D1 > D3
            X: D1 > D2, D3 > D2, D3 > D1
            Z: D2 > D1, D2 > D3, D3 > D1
            
            they need to get 10/12 correct to be above chance
    %}
    
    rand_order = randperm(ntrials);
    accuracy = zeros(ntrials,1);
    trialease = zeros(ntrials,1);
    
    startsecs = GetSecs;
    for k = 1:ntrials
        abort = 0;
        kk = rand_order(k);
        ITI = ITI_list(kk);
        ISI = ISI_list(kk);
        deckorder = choices(kk,:);
        trialease(k,1) = ease(kk);
        
        left_card_val = deckorder(1);
        right_card_val = deckorder(2);
        
        eval(['left_card_color = deck' num2str(deckorder(1)) '_color;']) %deck1_color
        eval(['right_card_color = deck' num2str(deckorder(2)) '_color;']) %deck1_color
        
        
        %%%ITI PERIOD: DRAW FIXATION CROSS%%%
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ITI); %timing loop
        
        
        %%%LETTER PERIOD%%%
        Screen('TextSize', window, 65);
        [normBoundsRect, ~] = Screen('TextBounds', window, letters{kk});
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, letters{kk}, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), black);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        WaitSecs(.5); %timing loop
        
        
        %%%DECISION PERIOD%%%
        %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
        %Screen('FillRect', windowPtr [,color] [,rect] )
        %squares
        Screen('FillRect', window, left_card_color, LeftRect);
        Screen('FillRect', window, right_card_color, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        %letter
        Screen('TextSize', window, 65);
        [normBoundsRect, ~] = Screen('TextBounds', window, letters{kk});
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, letters{kk}, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), black);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        
        
        Screen('FillRect', window, left_card_color, LeftRect);
        Screen('FillRect', window, right_card_color, RightRect);
        Screen('FrameRect',window,black,LeftRect,7);
        Screen('FrameRect',window,black,RightRect,7);
        %letter
        Screen('TextSize', window, 65);
        [normBoundsRect, ~] = Screen('TextBounds', window, letters{kk});
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, letters{kk}, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), black);
        Screen('TextStyle', window, 0);
        
        
        %%%MAKE CHOICE%%%
        press = 0;
        while ~press
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if find(responsecode) == L_arrow %LEFT
                Screen('FrameRect',window,white,LeftRect,7);
                press = 1;
                choice = left_card_val;
                Screen('Flip', window);
            elseif find(responsecode) == R_arrow %RIGHT
                Screen('FrameRect',window,white,RightRect,7);
                press = 1;
                choice = right_card_val;
                Screen('Flip', window);
            elseif find(responsecode) == esc_key
                abort = 1;
            end
        end
        WaitSecs(.5);
        
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        WaitSecs(ISI); %timing loop
        
        if choice == answers(kk)
            msg = 'Correct!';
            accuracy(k,1) = 1;
            answercolor = [0 255 0];
        elseif choice ~= answers(kk)
            msg = 'Wrong!';
            accuracy(k,1) = 0;
            answercolor = [255 0 0];
        end
        
        Screen('TextSize', window, 50);
        [normBoundsRect, ~] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), answercolor);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        WaitSecs(outcomedur);
        
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        
        if abort
            ListenChar(0);
            Screen('CloseAll');
            save(outputname, 'accuracy','trialease');
            cd(currentdir);
            return;
        end
        
    end
    
    msg = sprintf('You got %d%% correct!', round(100*mean(accuracy)));
    Screen('TextSize', window, 50);
    [normBoundsRect, ~] = Screen('TextBounds', window, msg);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), black);
    Screen('TextStyle', window, 0);
    Screen('Flip', window);
    
    
    %save data
    save(outputname, 'accuracy', 'trialease');
    
    go = 1;
    while go
        [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
           if keyCode(1) == esc_key %esc to close
                ListenChar(0);
                Screen('CloseAll');
                return;
            end
        end
    end
    ListenChar(0);
    Screen('CloseAll');
    
    
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    keyboard
end
