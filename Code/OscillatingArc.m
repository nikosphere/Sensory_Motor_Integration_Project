%% clear workspace
clear all;

%%
%prompt details of simulation
screenXpixels = 1920;
screenYpixels = 1080;
baseRect = [0 0 200 200];
prompt = {'Enter Arc Color (Grey, Red, Green, Blue):','Enter Arc Radius:','Enter Arc Angle','Enter amplitude constant:','Enter Frequency of Oscillation'};
dlgtitle = 'OscillatingDotDemo';
answer = inputdlg(prompt,dlgtitle);
arcColor = (answer{1,1});
arcRadius = str2num(answer{2,1}); %put down 50-100 
arcAngle = str2num(answer{3,1}); %put down 60
amplitude = screenXpixels * str2num(answer{4,1}); %recommended 0.25
frequency = str2num(answer{5,1}); %recommended 0.2-0.5

if strcmp(arcColor,'Grey')
    arcColor = [0.5 0.5 0.5];
    elseif strcmp(arcColor, 'Red')
        arcColor = [1 0 0];
        elseif strcmp(arcColor,'Blue')
            arcColor = [ 0 1 0];
                elseif strcmp(arcColor,'Green')
                    arcColor = [ 0 0 1];  
end
    
%%
%sca;
% Here we call some default  settings for setting up Psychtoolbox
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

%variables
%positionOfMainCircle = [350 250 450 350] ;

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
    arcXpos = xCenter + xpos;
    arcYpos = yCenter + ypos; 
 
    if arcXpos >  1000
        arcYpos = yCenter + ypos;
        %rectColor = [0 0 0];
    else
        arcYpos = yCenter + ypos;
        arcXpos = xCenter - xpos;
        %rectColor = [1 0 0]; 
    end 
    
    
    % Center  the rectangle on the centre of the screen
    %gridXpos = 0.25*screenXpixels; %these th ings center the dot in the middle
    %gridYpos = 0.25*screenYpixemls;
    centeredArc = CenterRectOnPointd(baseRect, arcXpos, arcYpos );

    % Draw the arc to the screen
    Screen('FillArc', window, Red, centeredArc ,arcAngle,arcRadius ); 

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
 
    % Increment the time
    time = time + ifi;
    
    
    
end
sca;

