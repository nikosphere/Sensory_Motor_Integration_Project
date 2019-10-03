function[y,Fs] = soundFun(fileName)
[y,Fs] = audioread(fileName);
t0 = clock;
randomTime = sort(randi(9,3,1));
while etime(clock,t0) < 20
    if sum(round(etime(clock,t0),2) == randomTime)>0
        sound(y,Fs);  
        randomTime(1)=[]; % since you sorted they will be removed in order
    end 
    
end
end
