%%
%clear vars and workspace
close all;
clear all;
%prompt details of simulation
prompt = {'Enter Dot Color (Grey, Red, Green, Blue):','Enter Second Dot Color:','Enter First Dot Size:','Enter Second Dot Size:',...
    'Enter Dot 1 amplitude constant:','Enter Dot 2 Amplitude Constant','Enter Dot 1 Frequency of Oscillation:', 'Enter Dot 2 Frequency of Oscillation:'};
dlgtitle = 'MovingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
dotColor = (answer{1,1});
dotColor2 = (answer{2,1});
dotSizePix = str2num(answer{3,1});
dotSizePix2 = str2num(answer{4,1});
dot1Amplitude = screenYpixels * str2num(answer{5,1});
dot2Amplitude = screenYpixels * str2num(answer{6,1});
dot1frequency = str2num(answer{7,1});
dot2frequency = str2num(answer{8,1});


if strcmp(dotColor,'Grey') 
    dotColor = [0.5 0.5 0.5]; 
    elseif strcmp(dotColor, 'Red')
        dotColor = [1 0 0];
        elseif strcmp(dotColor,'Blue')
            dotColor = [ 0 1 0];
                elseif strcmp(dotColor,'Green')
                    dotColor = [ 0 0 1];  
end
if strcmp(dotColor2,'Grey') 
    dotColor2 = [0.5 0.5 0.5]; 
    elseif strcmp(dotColor2, 'Red')
        dotColor2 = [1 0 0];
        elseif strcmp(dotColor2,'Blue')
            dotColor2 = [ 0 1 0];
                elseif strcmp(dotColor2,'Green')
                    dotColor2 = [ 0 0 1];  
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
dot1Xpos = 0.50*screenXpixels; %these things center the dot in the middle
dot1Ypos = 0.50*screenYpixels;


%variables and stuff
angFreq1 = 2 * pi * dot1frequency;
angFreq2 = 2 * pi * dot2frequency;
startPhase = 0;
time = 0;
vbl = Screen('Flip', window);
waitframes = 1;
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
while ~KbCheck
    
    %position the circle on these frames for the circular oscillations
    xpos = dot1Amplitude * cos(angFreq1 *time + startPhase);
    ypos = dot1Amplitude * sin(angFreq1 * time + startPhase);
    %for the horizontal oscillation
    xGridPos = dot2Amplitude * sin(angFreq2 * time + startPhase);

      
    % Add this position to the screen center coordinate. This is the point
    % we want our shape to oscillate around
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
    Screen('DrawDots', window, [dot1Xpos + xGridPos; dot1Ypos],...
        dotSizePix2, dotColor2, dotCenter, 2);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
 
    % Increment the time
    time = time + ifi;
    
    
    
    
    
    
end
sca;