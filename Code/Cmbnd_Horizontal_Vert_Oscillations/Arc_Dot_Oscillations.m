%%
clear all;
%prompt details of simulation
prompt = {'Enter Dot Color (Grey, Red, Green, Blue):','Enter Arc Color:',...
    'Enter First Dot Size:','Enter Rect Size [0 0 x y]','Enter Arc Size:',...
    'Enter Arc Angle:','Enter Dot 1 amplitude constant:','Enter Arc Amplitude Constant',...
    'Enter Dot 1 Frequency of Oscillation:', 'Enter Arc Frequency of Oscillation:'};
dlgtitle = 'MovingDotDemo';
answer = inputdlg(prompt,dlgtitle);
screenXpixels = 1920;
screenYpixels = 1080;
dotColor = (answer{1,1});
arcColor = (answer{2,1});
dotSizePix = str2num(answer{3,1});
rectSizePix = str2num(answer{4,1}); %helps with arc formation
arcSizePix = str2num(answer{5,1}); %put down 50-150
arcAngle = str2num(answer{6,1}); %put down 60
dot1Amplitude = screenYpixels * str2num(answer{7,1});
arcAmplitude = screenYpixels * str2num(answer{9,1});
dot1frequency = str2num(answer{9,1});
arcfrequency = str2num(answer{10,1});

if strcmp(dotColor,'Grey') 
    dotColor = [0.5 0.5 0.5]; 
    elseif strcmp(dotColor, 'Red')
        dotColor = [1 0 0];
        elseif strcmp(dotColor,'Blue')
            dotColor = [ 0 1 0];
                elseif strcmp(dotColor,'Green')
                    dotColor = [ 0 0 1];  
end

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


arcXpos = 0.75*screenXpixels; %these things center the square in the middle
arcYpos = 0.50*screenYpixels;


%dotSizePix = input('Enter the dot size in pixels:'); 

angFreq = 2 * pi * dot1frequency;
angFreq2 = 2 *pi * arcfrequency;
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
    gridPos2 = arcAmplitude * cos(angFreq2 * time + startPhase);

    centeredArc = CenterRectOnPointd(rectSizePix, arcXpos, arcYpos + gridPos2 );
       

    % Draw all of our dots to the screen in a single line of code adding
    % the sine oscilation to the X coordinat es of the dots
    Screen('DrawDots', window, [dotXpos + gridPos, dotYpos],...
        dotSizePix, dotColor, dotCenter, 2);
     Screen('FillArc', window, arcColor, centeredArc ,arcAngle,arcSizePix ); 
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

    % Increment the time
    time = time + ifi;
 
end
sca;