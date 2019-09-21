%%
clear all;
%prompt details of simulation
prompt = {'Enter Square Color (Grey, Red, Green, Blue):','Enter Square Size [0 0 x y]:','Enter amplitude constant:','Enter Frequency of Oscillation'};
dlgtitle = 'OscillatingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
rectColor = (answer{1,1});
rectSizePix = str2num(answer{2,1}); 
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
sca; 
PsychDefaultSetup(2); 

rand('seed', sum(100 * clock));

screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
%Screen('Preference','Sk ipSyncTests', 0);  %use this to override the random that goes on with de-syncing
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ifi = Screen('GetFlipInterval', window);


squareXpos = 0.50 *screenXpixels; %these things center the square in the middle
squareYpos = 0.50*screenYpixels;



%amplitude = screenYpixels * (input('Enter what amplitude constant you want:'));
%frequency = input('Enter the Frequency of Oscillation:');
angFreq = 2 * pi * frequency;
startPhase = 0;
time = 0;
vbl = Screen('Flip', window);
waitframes = 1;
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);


while ~KbCheck

     
    % Position of the square on this frame
    xpos = amplitude * cos(angFreq *time + startPhase);
    centeredRect = CenterRectOnPointd(rectSizePix, squareXpos + xpos, squareYpos  );

    % Draw the square to the screen in a single line of code adding
    % the cos  oscilation to the X coordinates of the dots
    Screen('FillRect', window, rectColor, centeredRect);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Increment the time
    time = time + ifi;

end
sca;
