%Reading the two audio files
[audio1,fs1]=audioread("audio1.wav");
[audio2,fs2]=audioread("audio2.wav");

%performing fourier transform on the audio files
a=abs((fft(audio1)));
b=abs((fft(audio2)));

%%%%%%%%%%%%%%%%%%ploting the audio files in frequancy domain%%%%%%%%%%%%%%%%%
subplot(2,1,1);
plot(a);
title("Audio 1 in frequency domain");
xlabel("frequency(hz)");
ylabel("Fourier transform coefficient");

subplot(2,1,2);
plot(b);
title("Audio 2 in frequency domain");
xlabel("frequency(hz)");
ylabel("Fourier transform coefficient");
figure;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%initializing the output signal array
nrow = max(size(audio1, 1), size(audio2, 1));
out1 = zeros(nrow, 1);
out2 = zeros(nrow, 1); 
out=zeros(nrow, 1);
out1(1 : size(audio1, 1), 1) = audio1(:,1); 
out2(1 : size(audio2, 1), 1) = audio2(:,1);

A=0.001;  
horse=size(audio1);
horse=horse(1);

%hiding audio one in audio two
for i=1:1:nrow
    out(i,1)=(out2(i,1))+ out1(i,1)*cos(horse*i);
end

for i=1:1:horse-2200
    out(i,1)=A*out(i,1);
end

%playling the output audio file with the hidden audio in it
sound(out,fs2);
pause(6);
 
%%%%%%%%%%ploting the magnitude spectrum of the output audio%%%%%%%%%%%%%
plot(abs(fft(out)));
title("x[n] in frequency domain");
xlabel("frequency(hz)");
ylabel("Fourier transform coefficient");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%extracting the hidden audio file
y=zeros(nrow, 1);
 for i=1:1:nrow
     y(i,1)=out(i,1)*cos(horse*i);
 end
 
for i=horse-2000:1:nrow
   y(i,1)=0;
end

y=y*1000;
y = lowpass(y,0.3);

%playing the hidden audio file after extraction
sound(y,fs1);
 