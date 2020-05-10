%%%%%% read the input audio file %%%%%%
[f,fs]=audioread('audio1.wav');
%%%%%% get required delay for each unit impulse %%%%%
t1=.25;
t2=.5;
t3=.75;
%%%%%% apply shifting (delay) and scalar multiplication (our LTI System) to
%%%%%% each unit impulse 
h0=[zeros(1,0) 1 zeros(1,fs)];
h1=[zeros(1,t1*fs) .9 zeros(1,fs-t1*fs)];
h2=[zeros(1,t2*fs) .8 zeros(1,fs-t2*fs)];
h3=[zeros(1,t3*fs) .7 zeros(1,fs-t3*fs)];
%%%%%% summation of these h's is our impulse response h
h=h0+h1+h2+h3;
%%%%%% convolute the input signal and impulse response to get output signal
%%%%%% y (signal with the echo applied)
y=conv(f,h);
%%%%%% get the maximum length between y & h %%%%%%
l=max([length(y);length(h)]);
%%%%%% apply discrete fourier transform to h and y
%%%%%% after setting length of each to the maximum length l
Freqy=fft([y;zeros(l-length(y),1)]);
Freqh=zeros((l-length(h)),1);
hdash=h';
Freqh=[hdash;Freqh];
Freqh=fft(Freqh);
%%%%% deconvolute h & y by division then apply ifft to switch to time
%%%%% domain then take only the real part 
%%%%% Removed is the signal after removing echo (original signal)
Removed=real(ifft(Freqy./Freqh));
sound(Removed,fs);
%%%%% plot signals (Input-Echo-ImpulseResponse-RemvedEcho)
subplot(4,1,1);
plot(f);
subplot(4,1,2);
plot(y);
subplot(4,1,3);
plot(h);
subplot(4,1,4);
plot(Removed);