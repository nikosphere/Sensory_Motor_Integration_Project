%%
%clear vars and workspace
close all;
clearvars;

%%
%prompt details of simulation
prompt = {'Enter Dot Color (Grey, Red, Green, Blue):','Enter Dot Size:','Enter amplitude constant:','Enter Frequency of Oscillation'};
dlgtitle = 'OscillatingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
dotColor = (answer{1,1});
dotSizePix = str2num(answer{2,1}); 
amplitude = screenXpixels * str2num(answer{3,1}); %recommended 0.25
frequency = str2num(answer{4,1}); %recommended 0.2-0.5

if strcmp(dotColor,'Grey')
    dotColor = [0.5 0.5 0.5];
    elseif strcmp(dotColor, 'Red')
        dotColor = [1 0 0];
        elseif strcmp(dotColor,'Blue')
            dotColor = [ 0 1 0];
                elseif strcmp(dotColor,'Green')
                    dotColor = [ 0 0 1];  
end
%%
sca;
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);
 
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);
%center coordinates of screen
[xCenter, yCenter] = RectCenter(windowRect);
dotCenter = [screenXpixels / 12  screenYpixels / 28];


%variables and stuff
angFreq = 2 * pi * frequency;
startPhase = 0;
time = 0;
vbl = Screen('Flip', window);
waitframes = 1;
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
while ~KbCheck
    
    %position the circle on these frames
    xpos = amplitude * cos(angFreq *time + startPhase);
    ypos = amplitude * sin(angFreq * time + startPhase);
     
    % Add this position to the screen center coordinate. This is the point
    % we want our square to oscillate around
    dotXpos = xCenter + xpos;
    dotYpos = yCenter + ypos; 
 
    if dotXpos >  1000
        dotYpos = yCenter + ypos;
        %rectColor = [0 0 0];
    else
        dotYpos = yCenter + ypos;
        dotXpos = xCenter - xpos;
        %rectColor = [1 0 0]; 
    end 
    
    
    % Center  the rectangle on the centre of the screen
    %gridXpos = 0.25*screenXpixels; %these things center the dot in the middle
    %gridYpos = 0.25*screenYpixels;
    
    % Draw the rect to the screen
    %Screen('FillRect', window, rectColor, centeredRect);
    %draw circle
    Screen('DrawDots', window, [dotXpos dotYpos],...
        dotSizePix, dotColor, dotCenter, 2);

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
 
    % Increment the time
    time = time + ifi;
    
    
    
    
    
    
end
sca;