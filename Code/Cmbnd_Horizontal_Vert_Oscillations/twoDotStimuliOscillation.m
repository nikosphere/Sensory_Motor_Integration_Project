%%
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

%dotColor = [0.5 0.5 0.5];

dotXpos = 0.25*screenXpixels; %these things center the dot in the middle
dotYpos = 0.25*screenYpixels;
dotCenter = [screenXpixels/4 screenYpixels/4];
dotCenter2 = [screenXpixels/2 screenYpixels/4];

%dotSizePix = input('Enter the dot size in pixels:'); 

angFreq = 2 * pi * dot1frequency;
angFreq2 = 2 *pi * dot2frequency;
startPhase = 0;
time = 0;
vbl = Screen('Flip', window);
waitframes = 1;
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);


while ~KbCheck
 
    
    % Position of dot 1 on this frame
    gridPos = dot1Amplitude * sin(angFreq * time + startPhase);
    % Position of dot 2 on this frame
    gridPos2 = dot2Amplitude * cos(angFreq2 * time + startPhase);

    % Draw all of our dots to the screen in a single line of code adding
    % the sine oscilation to the X coordinates of the dots
    Screen('DrawDots', window, [dotXpos + gridPos, dotYpos],...
        dotSizePix, dotColor, dotCenter, 2);
    Screen('DrawDots', window, [dotXpos, dotYpos + gridPos2], ...
        dotSizePix2, dotColor2, dotCenter2, 2);
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Increment the time
    time = time + ifi;
 
end
sca;