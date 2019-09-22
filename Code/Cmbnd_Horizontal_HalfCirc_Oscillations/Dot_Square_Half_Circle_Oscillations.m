%%
close all;
clear all;
%prompt details of simulation
prompt = {'Enter Rect Color (Grey, Red, Green, Blue):','Enter Dot Color','Enter Rect Size:',...
    'Enter Dot Size','Enter Rect Amplitude constant', 'Enter Dot Amplitude Constant',...
    'Enter Dot Frequency of Oscillation','Enter Dot Frequency of Oscillation'};
dlgtitle = 'OscillatingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
rectColor = (answer{1,1});
dotColor = (answer{2,1});
rectSizePix = str2num(answer{3,1});
dotSizePix = str2num(answer{4,1}); 
rectAmplitude = screenXpixels * str2num(answer{5,1}); %recommended 0.25
dotAmplitude = screenYpixels * str2num(answer{6,1});
rectFrequency = str2num(answer{7,1}); %recommended 0.2-0.5
dotFrequency = str2num(answer{8,1});

if strcmp(rectColor,'Grey')
    rectColor = [0.5 0.5 0.5];
    elseif strcmp(rectColor, 'Red')
        rectColor = [1 0 0];
        elseif strcmp(rectColor,'Blue')
            rectColor = [ 0 1 0];
                elseif strcmp(rectColor,'Green')
                    rectColor = [ 0 0 1];  
end
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

% Clear the workspace and the screen
sca;
%close all;
%clearvars;

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

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

dotXpos = 0.25*screenXpixels; %these things center the dot in the middle
dotYpos = 0.25*screenYpixels;
dotCenter = [screenXpixels/4 screenYpixels/4];

% Our square will oscilate with a sine wave function to the left and right
% of the screen. These are the parameters for the sine wave
% See: http://en.wikipedia.org/wiki/Sine_wave

angFreq = 2 * pi * rectFrequency;
angFreq2 = 2 * pi * dotFrequency;

startPhase = 0;
time = 0;
index= 0;
% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

%for i = i:40
 %   thetaMax = ((1/6)*pi); %30 degree maximum
  %  theta = thetaMax *  sin(angFreq *i + startPhase); %this bounds the oscillation
   % index = index + 1;
    %xpos(index) = 0.5*sin(theta);
    %ypos(index) = 0.5*sin(theta);
%end 
    
% Loop the animation until a key is pressed
while ~KbCheck
    
    % Position of the square on this frame
    % oscillates in a circle LIT xpos = amplitude * cos(angFreq *time + startPhase);
    xpos = rectAmplitude * cos(angFreq *time + startPhase);
    ypos = rectAmplitude * sin(angFreq * time + startPhase);
    
    %for the dot
    gridPos = dotA mplitude * sin(angFreq2 * time + startPhase);

    % Add this position to the screen center coordinate. This is the point
    % we want our square to oscillate around
    squareXpos = xCenter + xpos;
    squareYpos = yCenter + ypos; 
 
    if squareXpos >  1000
        squareYpos = yCenter + ypos;
        %rectColor = [0 0 0];
    else
        squareYpos = yCenter + ypos;
        squareXpos = xCenter - xpos;
        %rectColor = [1 0 0]; 
    end 
    
    
    % Center  the rectangle on the centre of the screen
    centeredRect = CenterRectOnPointd(rectSizePix, squareXpos, squareYpos );

    % Draw the rect to the screen
    %for some reason getting error with screen usage
    Screen('FillRect', window, rectColor, centeredRect);
    Screen('DrawDots', window, [dotXpos + gridPos; dotYpos],...
        dotSizePix, dotColor, dotCenter, 2);
    
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
  
    % Increment the time
    time = time + ifi;
     

end

% Clear the screen
sca;