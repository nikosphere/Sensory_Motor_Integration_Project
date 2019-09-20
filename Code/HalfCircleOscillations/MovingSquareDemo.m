%%
%prompt details of simulation
prompt = {'Enter Dot Color (Grey, Red, Green, Blue):','Enter Dot Size:','Enter amplitude constant:','Enter Frequency of Oscillation'};
dlgtitle = 'OscillatingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
rectColor = (answer{1,1});
dotSizePix = str2num(answer{2,1}); 
amplitude = screenXpixels * str2num(answer{3,1}); %recommended 0.25
frequency = str2num(answer{4,1}); %recommended 0.2-0.5

if strcmp(rectColor,'Grey')
    rectColor = [0.5 0.5 0.5];
    elseif strcmp(rectColor, 'Red')
        rectColor = [1 0 0];
        elseif strcmp(rectColor,'Blue')
            rectColor = [ 0 1 0];
                elseif strcmp(rectColor,'Green')
                    rectColor = [ 0 0 1];  
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

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 200 200];


% Our square will oscilate with a sine wave function to the left and right
% of the screen. These are the parameters for the sine wave
% See: http://en.wikipedia.org/wiki/Sine_wave
%amplitude = screenXpixels * 0.25;
%frequency = 0.2;
angFreq = 2 * pi * frequency;
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
    xpos = amplitude * cos(angFreq *time + startPhase);
    ypos = amplitude * sin(angFreq * time + startPhase);
    
    
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
    centeredRect = CenterRectOnPointd(baseRect, squareXpos, squareYpos );

    % Draw the rect to the screen
    Screen('FillRect', window, rectColor, centeredRect);

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
 
    % Increment the time
    time = time + ifi;
     

end

% Clear the screen
sca;