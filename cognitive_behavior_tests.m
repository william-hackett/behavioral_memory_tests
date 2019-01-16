%%Close all screens and clear variables
%%Code written by Will

sca;
close all;
clearvars;

%%Ask for experiment ID number
exp_id = input('What is the run number? \n');

%% Set up Psychtoolbox %%
%%Code written by Will

PsychDefaultSetup(2);

%%Select screen
screens = Screen('Screens');
screenNumber = max(screens);

Screen('Preference', 'SkipSyncTests', 1);

%%Open screen with white background
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white/2;
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

%%Get size of screen in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

%%Set to top priority level for temporal precision
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

ifi = Screen('GetFlipInterval', window);

%% Introduction to the experiment %%
%%Code written by Will

Screen('TextSize', window, 40);
Screen('TextFont', window, 'Arial');
DrawFormattedText(window, 'MATLAB Memory Report: \n', 'center', 0.3*screenYpixels, black)
Screen('TextSize', window, 20);
DrawFormattedText(window, ['Hello! During this session, you will be participating in three classic cognitive science experiments. \n', ...
    '\nEach task will test a different aspect of your memory.\n', ...
    '\nAt the end of the three tasks, you will get a visualization of your results. \n', ...
    '\n\n\nPress <spacebar> to continue.'], 'center', 'center', black);
vbl = Screen('Flip', window);

%%Wait for participant to hit spacebar to flip to the next screen

hasAnswered = false;
keyIsDown = false;
escapeKey = KbName('q');
targetKey = KbName('space');

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%% Serial Position Task %%
%%Code written by Will

%%Introductory page for Serial Position Task

Screen('TextSize', window, 40);
DrawFormattedText(window, 'Serial Position Task \n', 'center', 0.2*screenYpixels, black);
Screen('TextSize', window, 20);
DrawFormattedText(window, ['Working memory is the processing system that allows you to retain information for current use. \n', ...
    '\nA typical person can only store about 5 to 9 pieces of information in working memory for about 30 seconds. \n', ...
    '\n\n\nDuring this task, you will have to remember multiple pieces of information from a list. \n', ...
    '\nYou will find that the order of presentation will affect your ability to recall that information. \n', ...
    '\n\n\nPress <spacebar> to continue to the instructions for the Serial Position Task.'], 'center', 'center', black);
Screen('Flip', window);

%%Wait for participant to hit spacebar to flip to next screen

hasAnswered = false;
keyIsDown = false;
pause(0.5)

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%%Instruction page for Serial Position Task

Screen('TextSize', window, 40);
DrawFormattedText(window, 'Serial Position Task Instructions \n', 'center', 0.2*screenYpixels, black);
Screen('TextSize', window, 20);
DrawFormattedText(window, ['You will be presented with a list of 12 words, one at a time. \n', ...
    '\nAfter the full list of words has been presented, 12 boxes will appear. \n', ...
    '\nRemember as many words as possible and type them in the boxes. \n', ...
    '\n\n\nYou can take as much time as you need to type in the words. \n', ...
    '\nOrder does not matter, but make sure you haven''t made any typos. \n', ...
    '\nWhen you are finished, press the continue button to move on to the next trial. \n', ...
    '\nThere will be 5 trials total with 12 words each. \n', ...
    '\n\n\nPress <spacebar> when you are ready to begin.'], 'center', 'center', black);
Screen('Flip', window);

%%Wait for participant to hit spacebar to flip to next screen

hasAnswered = false;
keyIsDown = false;
pause(0.5)

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%% Serial Position Task Trial %%
%%Code written by Will

%%Create a list of 12 words per trial
numTrials = 5;

sptStimuli = cell(1,numTrials);
sptStimuli{1} = ["cat","door","glass","tree","doctor","shovel", ...
    "book","clothing","mountain","city","mother","hand"];
sptStimuli{2} = ["pen","hammer","sock","bed","plane","radio",...
    "canoe","computer","phone","bird","skirt","fork"];
sptStimuli{3} = ["chair","cheese","hail","closet","shoe","pants",...
    "stone","pencil","mouse","flower","apple","taxi"];
sptStimuli{4} = ["butter","foot","pan","kitchen","shirt","truck",...
    "snake","sofa","horse","fire","bag","lamp"];
sptStimuli{5} = ["banana","knife","fly","car","bowl","dog",...
    "comb","subway","hospital","sun","box","bell"];

%%Present each word from one list in a random order
numSecs = 1;
randTrial = randperm(numTrials);
trialInput = cell(1,numTrials);
trialResults = cell(1,numTrials);

%%Randomize Spt Stimuli. Display one at a time for numSecs

for ii = 1:numTrials
    randOrder = randperm(length(sptStimuli{randTrial(ii)}));
    sptStimuli{randTrial(ii)} = (sptStimuli{randTrial(ii)}(randOrder));
    for jj = 1:length(randOrder)
        Screen('TextSize', window, 60);
        DrawFormattedText(window, char(sptStimuli{randTrial(ii)}(1,jj)), 'center', 'center', black);
        vbl = Screen('Flip', window, vbl + numSecs - ifi/2);
    end
    
    %% Make the empty square grid %%
    %%Code written by Will
    
    numRects = length(sptStimuli{randTrial(ii)});
    
    xDim = 500;
    xCenter = screenXpixels/2;
    
    yDim = (screenYpixels - 150)/12;
    yStart = (screenYpixels - yDim*numRects)/2;
    yStart = yStart + 0.5*yDim;
    
    baseRect = [0 0 xDim yDim];
    allRects = nan(numRects, 4);
    blue = [0 200 255];
    penWidthPixels = 4;
    
    %%Display grid
    for jj = 1:numRects
        yPos = yStart + yDim*(jj-1);
        allRects(jj, :) = CenterRectOnPointd(baseRect,xCenter,yPos);
        Screen('FrameRect', window, blue, allRects(jj, :), penWidthPixels);
    end
    
    vbl = Screen('Flip', window, vbl + numSecs - ifi/2, 1, 1);
    Screen('TextSize', window, 30);
    trialInput{randTrial(ii)} = string(zeros(1,12));
    trialResults{randTrial(ii)} = zeros(1,12);
    
    for jj = 1:numRects %%Record input from participant. Display on screen
        trialInput{randTrial(ii)}(1,jj) = GetEchoString(window, '>', 550, (allRects(jj,2) + 20), black, white);
        
        %%Compare input to word displayed and compute accuracy
        if contains(trialInput{randTrial(ii)}(1,jj), sptStimuli{randTrial(ii)}) 
            sptIndex = find(strcmp(trialInput{randTrial(ii)}(1,jj), sptStimuli{randTrial(ii)}));
            trialResults{randTrial(ii)}(1,sptIndex) = 1;
        end
        if jj < numRects
            vbl = Screen('Flip', window, vbl + 0.2 - ifi/2, 1, 1);
        elseif jj == numRects
            vbl = Screen('Flip', window, vbl + 0.2 - ifi/2);
        end
    end
end

DrawFormattedText(window, ['You have completed the Serial Position Task!\n\n\n', ...
    'Hit any key to continue.'], 'center', 'center', black);
KbStrokeWait;
Screen('Flip', window);

%%Record Accuracy of Inputs in a matrix
positionResults = zeros(1,12);

for ii = 1:numRects
    for trial = 1:numTrials
        positionResults(1,ii) = positionResults(1,ii) + (trialResults{trial}(1,ii));
    end
    positionResults(1,ii) = (positionResults(1,ii)/numTrials) * 100;
end

%%Save data to csv file
filename = ['SPTData' num2str(exp_id) '.csv'];
folder = '/Users/Will/Documents/MATLAB/FinalProject/Serial_Position_Task_Performances';
fid = fopen(fullfile(folder,filename),'w');
fprintf(fid, '%s, %s, \n', "Position", "Percent Recalled");

%%Add results
for ii = 1:numRects
    fprintf(fid, '%f, %f, \n', [ii positionResults(1,ii)]);
end

fclose(fid);

%% Reference points of what data should look like

referenceResults = [61 48 38 34 35 38 45 53 62 69 82 95];


%% Make graph of percentage correct data
%%Code written by Will

SPT_graph = figure;
%%% plot data from all trials
plot(1:numRects,positionResults, '-o', 'LineWidth', 2,...
    'Color', [0.5 0 0],...
    'MarkerFaceColor', [0.5 0 0],...
    'MarkerEdgeColor', [0.5 0 0],...
    'MarkerSize', 7);
hold on
%%% plot reference points
plot(1:numRects,referenceResults,'-d', 'LineWidth', 2,...
    'Color', [0 0 0.5],...
    'MarkerFaceColor', [0 0 0.5],...
    'MarkerEdgeColor', [0 0 0.5],...
    'MarkerSize', 7);
hold off
xlim([0 numRects+1])
ylim([0 110])
xticks(1:numRects)
yticks([0 20 40 60 80 100])
xlabel('Position in List');
ylabel('Percent Recalled');
title('Serial Position Task Results');
legend('Your Results','Reference Results');

%% Save graph as image and then display it on PTB
%%Code written by Julia
saveas(SPT_graph,['Serial_Position_Task_' num2str(exp_id) '.jpg']);
img = imread(['Serial_Position_Task_' num2str(exp_id) '.jpg']); 
[s1, s2, s3] = size(img);
aspectRatio = s2 / s1;

%%Resize but maintain ratio
imageHeight = screenYpixels .*.9;
imageWidth = imageHeight .* aspectRatio;


%%% center rectangle
baserect = [0 0 imageWidth imageHeight];
newRect = CenterRectOnPointd(baserect, screenXpixels / 2,...
        screenYpixels / 2);

%%% display on PTB    
Screen('FillRect', window, grey);
imageTexture = Screen('MakeTexture', window, img);
Screen('DrawTextures', window, imageTexture, [], newRect);
Screen('Flip', window);

KbStrokeWait;
Screen('Flip', window);

numFrames = 2;
blankTime = .4;
presTime = numFrames*ifi;
%% Set up for Experiment - Partial Report Task
%%Code written by Julia

%Different display seconds amounts; each presented; arrow display
%distributed evenly as well
numTrials = 24; %number of real trials
numPracticeTrials = 4; %number of practice trials
%set up vector of number of different seconds for arrow display time
numSecs = [.02 .02 .02 .02 .02 .02 .1 .1 .1 .1 .1 .1 .3 .3 .3 .3 .3 .3 1 1 1 1 1 1];
numSecs = numSecs(randperm(length(numSecs))); %randomize
%%% set up vector of different arrow display positions (rows 1 -3)
arrow_pos = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3];
arrow_pos = arrow_pos(randperm(length(arrow_pos)));

%%%% Blank Response CSV
Partial_Report_Task = cell(numTrials,5);

%%% Making the empty square grid
dim = 100;
baseRect = [0 0 dim dim];

%%% make mesh grid
[xPos, yPos] = meshgrid(-1:1:1, -1:1:1);

%%% find number of squares
[s1, s2] = size(xPos);
numSquares = s1 * s2;
xPos = reshape(xPos, 1, numSquares);
yPos = reshape(yPos, 1, numSquares);


%%%Adjust size based on dimensions of baseRect
xPos = xPos .* dim + xCenter;
yPos = yPos .* dim + yCenter;

%%% calculate position of all squares and center them based on differnt
%%% positions
allRects = nan(4, 9);
for ii = 1:numSquares
    allRects(:, ii) = CenterRectOnPointd(baseRect,...
        xPos(ii), yPos(ii));
end
%%% line thickness for framing
penWidthPixels = 4;

%%% Making Letter Grid (all consonants)
letters = {'B', 'C', 'D', 'F', 'G', 'H' 'J', 'K', 'L', 'M', 'N', 'P','Q','R','S','T','V','W','X','Z'};

%% run through trials & practice trials (Start of Experiment on PTB)
%%Code written by Julia

for ii = 1:numTrials + numPracticeTrials
    if ii == 1 %give instructions for first trial and practice trials
        Screen('TextSize', window, 25);
        Screen('TextFont', window, 'Arial');
        Screen('FillRect', window, white);
        DrawFormattedText(window, 'Partial Report Task \n\n\n In this experiment, you are asked to remember the letters that appear in a grid. \n If you are ready, press any key to continue.', 'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
        DrawFormattedText(window, ['Partial Report Task Instructions: \n\n\n\n In this task, you will see a 3x3 grid\n', ...
            '\n After a short time, the various letters will very briefly appear in the grid\n', ...
            '\n After, an arrow will appear and point to one of the three rows.\n', ...
            '\n Your job is to remember the letters that appeared in that specific row  as best you can and type them in\n',  ...
            '\n Make sure not to make any typos!\n',...
            '\n Once you do type in all your letters, press the enter key to enter your response and  continue to the next trial\n', ...
            '\n Let''s do some practice first, press the <spacebar> to continue.'], 'center', 'center', black);
        Screen('Flip', window);
        hasAnswered = false;
        keyIsDown = false;
        pause(0.5)
        
        while ~hasAnswered
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(escapeKey)
                    sca;
                    return;
                elseif keyCode(targetKey)
                    hasAnswered = true;
                end
            end
        end  
    end
    
    if ii == 5 %% give instructions for official experiment
        Screen('TextSize', window, 25);
        Screen('TextFont', window, 'Arial');
        DrawFormattedText(window, 'Ok, now that you get the hang of it, let''s start the experiment. Press any key to continue', 'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
    end
    
    %%% create blank cell to fill in with letters
    temp_cell = cell(3,3);
    %%randomize letters
    letters = letters(randperm(length(letters)));
    %%% Put letters into 3x3 cell
    
    for x = 1:(length(temp_cell))^2
        temp_cell(x) = letters(x);
    end
    
    %%%  Account for practice trials
    trial = ii - numPracticeTrials;
    
    %%% Draw Grid with frame rect and set amount of squares
    Screen('FrameRect', window, black,...
        allRects, penWidthPixels);
    
    vbl = Screen('Flip', window);
    pause(1);
    
    %%% fill in empty grid with set of letters
    for jj= 1:9
        DrawFormattedText(window, temp_cell{jj},xPos(jj)-10,yPos(jj),black);
    end
    
    Screen('FrameRect', window, black,...
        allRects, penWidthPixels);
    
    %%% don't clear screen, but flip into letters
    vbl = Screen('Flip', window,[],1);
    
    %%% accounts for practice trials & displays letters for set amount of time from numSecs
   
    %%% briefly flash letters
    vbl = Screen('Flip', window, vbl + .3 - ifi/2);

    %%% flip to blank grid, the response prompt (arrow) appears after a varied amt of time
    Screen('FrameRect', window, black,...
        allRects, penWidthPixels);
    
    % make an arrow
    if ii <= numPracticeTrials %accounts for practice trials
        p_arrow = arrow_pos((randi(length(arrow_pos))));
        arrow_head   = [ xPos(1)-85, yPos(p_arrow) ];
    else
        arrow_head   = [ xPos(1)-85, yPos(arrow_pos(trial)) ]; % make coordinates of arrow head
    end
    width  = 20;           % the width of arrow head
    coords = [ arrow_head-[0,width]         % bottom
        arrow_head+[0,width]         % top
        arrow_head+[width,0] ];      % vertex
    
    vbl = Screen('Flip', window, vbl + presTime - 0.5* ifi);
    
    %%%display arrow
    Screen('FillPoly', window, black, coords,1);
    
     Screen('FrameRect', window, black,...
        allRects, penWidthPixels);
      
    %%% different wait times b/w stimulus and response prompt (key part of
    %%% experiment)
    if ii < 5
        vbl = Screen('Flip', window, vbl + numSecs(randi(length(numSecs))) - ifi/2,1);
    else
        vbl = Screen('Flip', window, vbl + numSecs(trial) - ifi/2,1);
    end
    
    %% initialize variables
    %%Code written by Julia
    hasAnswered = false;
    hasAnswered1 = true;
    hasAnswered2 = true;
    correct_counter = 0; %initialize correct response counter
    KbName('UnifyKeyNames');
    
    while KbCheck; end  %%clear out KbCheck
    
    %%% fill in 1st square
    while ~hasAnswered
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyIsDown && find(keyCode)>=4 && find(keyCode)<=29 %%ensure key is a letter
            response = KbName(keyCode);
            response = upper(response); %capitalize letter
            if ii <= numPracticeTrials
                DrawFormattedText(window, response, xPos(1)-10, yPos(p_arrow),black); %%draw letter into first box, of selected row
            else
                DrawFormattedText(window, response, xPos(1)-10, yPos(arrow_pos(trial)),black); %%draw letter into first box, of selected rows
            end
            Screen('FrameRect', window, black, allRects, penWidthPixels);
            Screen('FillPoly', window, black, coords,1);
            Screen('Flip', window,0, 1);
            hasAnswered = true;
            hasAnswered1 = false;
        end
    end
    if  ii > numPracticeTrials %%record data from experimental trials only
        if arrow_pos(trial) == 1
            if strcmp(response,temp_cell{1,1})
                correct_counter = correct_counter + 1;
            end
        elseif arrow_pos(trial) == 2
            if strcmp(response,temp_cell{2,1})
                correct_counter = correct_counter + 1;
            end
        else
            if strcmp(response,temp_cell{3,1})
                correct_counter = correct_counter + 1;
            end
        end
    end
    while KbCheck; end %% clear out KbCheck
    
    %% fill in second square
    %%Code written by Julia
    while ~hasAnswered1
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyIsDown && find(keyCode)>=4 && find(keyCode)<=29
            response = KbName(keyCode);
            response = upper(response);
            if ii <= numPracticeTrials
                DrawFormattedText(window, response, xPos(4)-10, yPos(p_arrow),black); %%draw letter into second box, of selected row
            else
                DrawFormattedText(window, response, xPos(4)-10, yPos(arrow_pos(trial)),black); %%draw letter into second box, of selected rows
            end
            Screen('Flip', window, 0, 1);
            hasAnswered1 = true;
            hasAnswered2 = false;
        end
    end
    if  ii > numPracticeTrials
        if arrow_pos(trial) == 1
            if strcmp(response,temp_cell{1,2})
                correct_counter = correct_counter + 1;
            end
        elseif arrow_pos(trial) == 2
            if strcmp(response,temp_cell{2,2})
                correct_counter = correct_counter + 1;
            end
        else
            if strcmp(response,temp_cell{3,2})
                correct_counter = correct_counter + 1;
            end
        end
    end
    while KbCheck; end
    
    %% fill in third square
    %%Code written by Julia
    
    while ~hasAnswered2
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyIsDown && find(keyCode)>=4 && find(keyCode)<=29
            response = KbName(keyCode);
            response = upper(response);
            if ii <= numPracticeTrials
                DrawFormattedText(window, response, xPos(7)-10, yPos(p_arrow),black); %%draw letter into first box, of selected row
            else
                DrawFormattedText(window, response, xPos(7)-10, yPos(arrow_pos(trial)),black); %%draw letter into first box, of selected rows
            end
            Screen('Flip', window, 0, 1);
            hasAnswered2 = true;
        end
    end
    if  ii > numPracticeTrials
        if arrow_pos(trial) == 1
            if strcmp(response,temp_cell{1,3})
                correct_counter = correct_counter + 1;
            end
        elseif arrow_pos(trial) == 2
            if strcmp(response,temp_cell{2,3})
                correct_counter = correct_counter + 1;
            end
        else
            if strcmp(response,temp_cell{3,3})
                correct_counter = correct_counter + 1;
            end
        end
    end
    
    KbStrokeWait;
    
    vbl = Screen('Flip', window, vbl + presTime - 0.5* ifi);
   
    letters_array = char(letters(1:9))'; %% record letters as row
    if ii > numPracticeTrials
        Partial_Report_Task{trial,1} = trial;
        Partial_Report_Task{trial,2} = numSecs(trial);
        Partial_Report_Task{trial,3} = letters_array;
        Partial_Report_Task{trial,4} = arrow_pos(trial);
        Partial_Report_Task{trial,5} = correct_counter;
    end
    
end

%% End Experiment and Record Data
%%Code written by Julia
DrawFormattedText(window, ['You have completed the Partial Report Task! Keep up the good work.\n\n\n',...
    'Hit any key to continue.'],'center', 'center', black);
KbStrokeWait;
Screen('Flip', window);

%% Make CSV file using results based on experimental ID
%%Code written by Julia
filename = ['Partial_Report_Task_Data_' num2str(exp_id) '.csv'];
folder = '/Users/Will/Documents/MATLAB/FinalProject/Partial_Report_Task_Performances';
fid = fopen(fullfile(folder,filename),'w');
fprintf(fid, '%s, %s, %s, %s, %s \n', 'Frame ID', 'Time Presented', 'Letter Array', 'Row', 'Amount Correct');
fclose(fid);

%Add data
for ii = 1:numTrials
    fid = fopen(fullfile(folder,filename), 'a');
    fprintf(fid, '\n %d, %.2f, %s, %d, %.3f \n', Partial_Report_Task{ii,:});
    fclose(fid);
end

%% process data for percent accuracy
%%Code written by Julia

amt_1 = 0;
amt_03 = 0;
amt_01 = 0;
amt_002 = 0;
%%% find amt of times correct for each time interval
for ii = 1:numTrials
    if Partial_Report_Task{ii,2} == 1
        amt_1 = amt_1 + Partial_Report_Task{ii,5};
    elseif Partial_Report_Task{ii,2} == 0.3000
        amt_03 = amt_03 + Partial_Report_Task{ii,5};
    elseif Partial_Report_Task{ii,2} == 0.1000
        amt_01 = amt_01 + Partial_Report_Task{ii,5};
    else
        amt_002 = amt_002 + Partial_Report_Task{ii,5};
    end 
end 

%%% calculate percent accuracies for different time intervals *3 because of
%%% 3 letters in each row
percent_1 = amt_1/(3*(numTrials/4)) * 100;
percent_03 = amt_03/(3*(numTrials/4)) * 100;
percent_01 = amt_01/(3*(numTrials/4)) * 100;
percent_002 = amt_002/(3*(numTrials/4)) * 100;


%Set points
Y  = [percent_002 percent_01 percent_03 percent_1];
%%% reference points of what typical data should look like
Y_r = [65 55 45 35];


%%% make graph of percentage correct data
Partial_Report_Graph = figure;
%%%% plot data from all trials
plot(Y,'-o', 'LineWidth',2,...
    'Color',[.5 0 0],...
    'MarkerEdgeColor',[.5 0 0],...
    'MarkerFaceColor',[.5 0 0],...
    'MarkerSize',7);
hold on
%%% plot reference points
plot(Y_r,'b-d', 'LineWidth',2,...
    'Color',[0 0 .5],...
    'MarkerEdgeColor',[0 0 .5],...
    'MarkerFaceColor',[0 0 .5],...
    'MarkerSize',7);
hold off
title('Partial Report Task Results');
ylim([0 100]);
xticks([0 1 2 3 4 5]);
xticklabels({'','.0200','.100', '.300', '1.00', ''})
xlabel('Time Interval Between Stimulus Display and Response Prompt(sec)');
ylabel('Percent Recalled');
legend('Your Results','Reference Results');

%%% save graph as image and then display it on PTB
saveas(Partial_Report_Graph,['Partial_Report_Graph_' num2str(exp_id) '.jpg']);
img = imread(['Partial_Report_Graph_' num2str(exp_id) '.jpg']); 
[s1, s2, s3] = size(img);
aspectRatio = s2 / s1;

%%% resize but maintain ratio
imageHeight = screenYpixels .*.9;
imageWidth = imageHeight .* aspectRatio;

%%% center rectangle
baserect = [0 0 imageWidth imageHeight];
newRect = CenterRectOnPointd(baserect, screenXpixels / 2,...
        screenYpixels / 2);

%%% display on PTB
Screen('FillRect', window, grey);
imageTexture = Screen('MakeTexture', window, img);
Screen('DrawTextures', window, imageTexture, [], newRect);
Screen('Flip', window);

KbStrokeWait;
Screen('Flip', window);

%% Mental Scanning Task %%
%%Code written by Will

%%Introductory page for Mental Scanning Task

Screen('FillRect', window, white);
Screen('TextSize', window, 40);
DrawFormattedText(window, 'Mental Scanning Task \n', 'center', 0.2*screenYpixels, black);
Screen('TextSize', window, 20);
DrawFormattedText(window, ['Visual perception involves seeing and perceiving something in your visual field. \n', ...
    '\nYou then store a mental image of the object in your memory as a visual representation. \n', ...
    '\nThere is a proposed close relationship between visual perception and visual representation. \n', ...
    '\nFor instance, if you mentally scan the path between two places, it will be closely related to \n', ...
    '\nthe actual distance of the path between those two places. Distance in real life is reflected in visual representations.\n', ...
    '\n\n\nDuring this task, you will be presented with a random pattern of dots, followed by an arrow. \n', ...
    '\nThe time it takes you to mentally scan these stimuli afterward will be related to the distance between them when they were presented. \n', ...
    '\n\n\nPress <spacebar> to continue to the instructions for the Serial Position Task.'], 'center', 'center', black);
vbl = Screen('Flip', window);

%%Wait for participant to hit spacebar to flip screen
hasAnswered = false;
keyIsDown = false;
escapeKey = KbName('q');
targetKey = KbName('space');

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%%Instruction page for Mental Scanning Task

Screen('TextSize', window, 40);
DrawFormattedText(window, 'Mental Scanning Task Instructions \n', 'center', 0.2*screenYpixels, black);
Screen('TextSize', window, 20);
DrawFormattedText(window, ['A random pattern of dots will be flashed briefly on the screen. \n', ...
    '\nAfter they disappear, an arrow will appear. \n', ...
    '\nIs this arrow pointing in the direction of one of the previously displayed dots? \n', ...
    '\n\n\nPress ''y'' to answer yes or ''n'' to answer no. \n', ...
    '\nDistance between the arrow and the dots may vary in each trial. \n', ...
    '\nYour job is to distinguish whether the arrow points towards one of the dots regardless of distance. \n', ...
    '\nThere will be 32 trials total. If you get a trial incorrect, it will be repeated later on. \n', ...
    '\nTry to answer as quickly and accurately as possible. If you''re making a lot of mistakes, slow down. \n', ...
    '\n\n\nPress <spacebar> when you are ready to begin.'], 'center', 'center', black);
Screen('Flip', window);

%%Wait for participant to hit spacebar to flip to next screen
hasAnswered = false;
keyIsDown = false;
pause(0.5)

while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(targetKey)
            hasAnswered = true;
        end
    end
end

%%Create random pattern of numPoints dots for numTrials trials

numPoints = 4;
numTrials = 32;

%%Create cell to hold participant data
MentalScanningData = cell(numTrials,4);

%%Assign values to construct dots
dotSizePix = 20;
dotColor = [0 0 255];
minDistance = 20+dotSizePix; %%Minimum distance between each dot
dotCoords = cell(numTrials,1);

%%Use for loop to create random x and y values for each dot
for trial = 1:numTrials
    dotCoords{trial} = zeros(2,4);
    dotCoords{trial}(1,1) = randi([dotSizePix+20,screenXpixels-(dotSizePix+20)]);
    dotCoords{trial}(2,1) = randi([dotSizePix+20,screenYpixels-(dotSizePix+20)]);
    for ii = 2:numPoints
        uniqueDots = false;
        while ~uniqueDots
            dotCoords{trial}(1,ii) = randi([dotSizePix+20,screenXpixels-(dotSizePix+20)]);
            dotCoords{trial}(2,ii) = randi([dotSizePix+20,screenYpixels-(dotSizePix+20)]);
            for jj = 1:(ii-1)
                dotDistance = pdist2([dotCoords{trial}(1,ii),dotCoords{trial}(1,jj)],...
                    [dotCoords{trial}(2,ii),dotCoords{trial}(2,jj)],'euclidean'); %%Calculate distance between dots
                if dotDistance < minDistance
                    uniqueDots = false; %%If dots are not minDistance apart, repeat loop
                    break
                elseif dotDistance > minDistance
                    uniqueDots = true;
                end
            end
        end
    end
end

arrowDist = [20, 40, 60, 80]; %%Vector of options for arrow distances
distVec = zeros(1,numTrials); %%Vector of arrow distance for each trial
for ii = 1:(numTrials/length(arrowDist))
    startVal = (ii-1)*length(arrowDist);
    distVec(1,[startVal + 1, startVal + 2, startVal + 3, startVal + 4]) = arrowDist(randperm(length(arrowDist)));
end

numDotSecs = 2; %%Duration of time for which dots should be presented on screen
randTrial = randperm(numTrials); %%Randomize the order of trials

for trial = 1:numTrials
    Screen('DrawDots',window,dotCoords{randTrial(trial)},dotSizePix,dotColor,[0,0],2,1); %%draw dots on screen
    vbl = Screen('Flip', window, vbl - ifi/2);      %%Draw dots onto screen
    arrow_head = [dotCoords{randTrial(trial)}(1,1) dotCoords{randTrial(trial)}(2,1)]; %%make coordinates of arrow head equal to one of the dots
    width = 20;           %%the width of arrow head
    onScreen = false;
    while ~onScreen                       
        if arrow_head(1) > screenXpixels/2          %right half of screen
            if arrow_head(2) < screenYpixels/2      %top half of screen
                absAngle = randi([180 269]);    %%angle associated with point in order to properly rotate arrow and perform translation
                triAngle = absAngle - 180;      %%triAngle is the angle to be used for trigonometry later in code
                arrowAngle = 360 - triAngle;    %%arrowAngle is the angle of rotation for the arrowhead
            elseif arrow_head(2) > screenYpixels/2  %bottom half of screen
                absAngle = randi([90 179]);
                triAngle = 180 - absAngle;
                arrowAngle = triAngle;
            end
        elseif arrow_head(1) < screenXpixels/2      %left half of screen
            if arrow_head(2) < screenYpixels/2      %top half of screen
                absAngle = randi([270 359]);
                triAngle = 360 - absAngle;
                arrowAngle = 180 + triAngle;
            elseif arrow_head(2) > screenYpixels/2  %bottom half of screen
                absAngle = randi([0 89]);
                triAngle = absAngle;
                arrowAngle = 180 - triAngle;
            end
        end
        
        arrowDistance = distVec(1,randTrial(trial));    %%distance the arrow should be from the point in this trial
        adjacentLeg = abs(cosd(triAngle) * arrowDistance);  %%number of pixels to move in x plane
        oppositeLeg = abs(sind(triAngle) * arrowDistance);  %%number of pixels ot move in y plane
        
        if absAngle >= 0 && absAngle < 90
            arrow_head(1) = arrow_head(1) + adjacentLeg;    %%find the final coordinates of the arrowhead by
            arrow_head(2) = arrow_head(2) - oppositeLeg;    %%adding or subtracting adjacent and opposite leg
        elseif absAngle >= 90 && absAngle < 180             %%values, based on position in screen
            arrow_head(1) = arrow_head(1) - adjacentLeg;
            arrow_head(2) = arrow_head(2) - oppositeLeg;
        elseif absAngle >= 180 && absAngle < 270
            arrow_head(1) = arrow_head(1) - adjacentLeg;
            arrow_head(2) = arrow_head(2) + oppositeLeg;
        elseif absAngle >= 270 && absAngle < 360
            arrow_head(1) = arrow_head(1) + adjacentLeg;
            arrow_head(2) = arrow_head(2) + oppositeLeg;
        end
        
        coords = [ arrow_head-[0,width]     % bottom point of triangle
            arrow_head+[0,width]            % top point of triangle
            arrow_head+[width,0] ];         % vertex of triangle
        for ii = 1:length(coords)
            %%make sure the arrowhead point coordinates are on the screen
            %%if not,redo iteration of while loop
            if (coords(ii,1) < 0) || (coords(ii,1) > screenXpixels)
                onScreen = false;
                break
            elseif (coords(ii,1) > 0) && (coords(ii,1) < screenXpixels)
                onScreen = true;
            end
            if (coords(ii,2) < 0) || (coords(ii,2) > screenYpixels)
                onScreen = false;
                break
            elseif (coords(ii,2) > 0) && (coords(ii,2) < screenYpixels)
                onScreen = true;
            end
        end
    end
    if randTrial(trial) > 16
        arrowAngle = arrowAngle + 20;   %%Make the arrow point away from the point in half of the trials
    end
    Screen('glPushMatrix', window)  %%OpenGL functions used to rotate arrowhead correctly
    Screen('glTranslate', window, arrow_head(1), arrow_head(2))
    Screen('glRotate', window, arrowAngle, 0, 0);       %%rotate arrowhead by arrowAngle
    Screen('glTranslate', window, -arrow_head(1), -arrow_head(2))
    Screen('FillPoly', window, black, coords,1);        %%draw the actual arrowhead
    Screen('glPopMatrix', window)   %%Return to original coordinate system from OpenGL frame of reference
    
    Screen('Flip', window, vbl + numDotSecs - ifi/2); %%Flip the arrow on screen
    
    hasAnswered = false;
    yesKey = KbName('y');
    noKey = KbName('n');
    correct_count = 0;
    tStart = GetSecs;       %%Start recording response time
    
    while ~hasAnswered
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(escapeKey)
            sca;
            return;
        elseif keyCode(yesKey)
            hasAnswered = true;
            if randTrial(trial) < 16 
                correct_count = 1;  %%Record whether the participant answered correctly
            end 
        elseif keyCode(noKey)
            hasAnswered = true;
            if randTrial(trial) > 16
                correct_count = 1;  %%Record whether the participant answered correctly
            end
        end
    end
    end
    tEnd = GetSecs; %%End recording participant response time
    Screen('Flip', window);
    rt = tEnd - tStart;     %%Find response time
    %%Record trial data in previously-created cell
    MentalScanningData{trial,1} = trial; 
    MentalScanningData{trial,2} = arrowDistance;
    MentalScanningData{trial,3} = correct_count;
    MentalScanningData{trial,4} = rt;
end

%%Code by Julia

%%Screen telling participant that experiment is over
DrawFormattedText(window, 'All done! Thank you for participating. Hit any key to leave.',...
    'center', 'center', black);
KbStrokeWait;
Screen('Flip', window);

%%Write cvs file for mental scanning data
filename = ['Mental_Scanning_Data_' num2str(exp_id) '.csv'];
folder = '/Users/Will/Documents/MATLAB/FinalProject/Mental_Scanning_Performances';
fid = fopen(fullfile(folder,filename),'w');
fprintf(fid, '%s, %s, %s, %s \n', 'Frame ID', 'Distance in Pixels', 'Accuracy', 'Response Time (Sec)');
fclose(fid);

for ii = 1:numTrials
    fid = fopen(fullfile(folder,filename), 'a');
    fprintf(fid, '\n %d, %d, %d, %.3f \n', MentalScanningData{ii,:});
    fclose(fid);
end

%%Create matrix in order to find average response time by distance of arrow from dot
dist_resp_mat = zeros(32,2);
for ii = 1:numTrials 
    dist_resp_mat(ii,1) = MentalScanningData{ii,2}; 
    dist_resp_mat(ii,2) = MentalScanningData{ii,4};
end 

%%Average response time based on distance from dot
twenty_avg = mean(dist_resp_mat(find(dist_resp_mat(:,1) == 20.0000),2));
forty_avg = mean(dist_resp_mat(find(dist_resp_mat(:,1) == 40.0000),2));
sixty_avg = mean(dist_resp_mat(find(dist_resp_mat(:,1) == 60.0000),2));
eighty_avg = mean(dist_resp_mat(find(dist_resp_mat(:,1) == 80.0000),2)); 


%%Set points for graph
Y  = [twenty_avg 1; forty_avg 1.25; sixty_avg 1.5; eighty_avg 1.75];
%% reference points of what data should look like
%%Code by Julia

%%Make graph of percentage correct data
Mental_Scanning_Graph = figure;
%%Plot data from all trials
bar(Y,'grouped');
bar_name = bar(Y,'grouped');
set(bar_name(1),'FaceColor',[.5 0 0])
set(bar_name(2),'FaceColor',[0 0 .5])
title('Mental Scanning Task Results');
ylim([0 4]);
xticks([0 1 2 3 4 5]);
xticklabels({'','.20','.40', '60', '80', ''})
xlabel('Distance in Pixels');
ylabel('Response Time(sec)');
legend('Your Results','Reference Results');

%% save graph as image and then display it on PTB
%%Code by Julia

saveas(Mental_Scanning_Graph,['Mental_Scanning_Graph' num2str(exp_id) '.jpg']);
img = imread(['Mental_Scanning_Graph' num2str(exp_id) '.jpg']); 
[s1, s2, s3] = size(img);
aspectRatio = s2 / s1;

%%% resize but maintain ration
imageHeight = screenYpixels .*.9;
imageWidth = imageHeight .* aspectRatio;

%%% center rectangle
baserect = [0 0 imageWidth imageHeight];
newRect = CenterRectOnPointd(baserect, screenXpixels / 2,...
        screenYpixels / 2);

%%% display on PTB
Screen('FillRect', window, grey);
imageTexture = Screen('MakeTexture', window, img);
Screen('DrawTextures', window, imageTexture, [], newRect);
Screen('Flip', window);

KbStrokeWait;
close all
sca;