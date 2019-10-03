function[y,Fs] = soundfun2(fileName)
[y,Fs] = audioread(fileName);
sound(y,Fs);
pause(10)
sound(y,Fs);
end
