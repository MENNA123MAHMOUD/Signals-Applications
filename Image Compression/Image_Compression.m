%%%%%%%%%%%%%%%%%%%%%%%%Read the input image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
InputImage = im2double(imread('D:\college\second year\second semester\signals\proj\image1.bmp'));
s=dir('D:\college\second year\second semester\signals\proj\image1.bmp');

%%%%%%get the size of the input file in pytes%%%%%%%%%%
InputImageSize = s.bytes;

%%%%%%%%%%%Extract the 3 channels from the image %%%%%%%%%%%%
Red_channel =InputImage(:,:,1);
Green_channel = InputImage(:,:,2);
Blue_channel = InputImage(:,:,3);

GetRedChannelOnly = InputImage;
GetGreenChannelOnly = InputImage;
GetBlueChannelOnly = InputImage;
GetRedChannelOnly(:,:,2) = 0;
GetRedChannelOnly(:,:,3) = 0;
GetGreenChannelOnly(:,:,1) = 0;
GetGreenChannelOnly(:,:,3) = 0;
GetBlueChannelOnly(:,:,1) = 0;
GetBlueChannelOnly(:,:,2) = 0;


%%%%%%%%%%%%%%%%%%%%ploting the RGB and the original image%%%%%%%%%%%%%%%
figure;
subplot(2,2,1),imshow(InputImage);
title('input image')
subplot(2,2,2),imshow(GetRedChannelOnly);
title('Red Channel image')
subplot(2,2,3),imshow(GetGreenChannelOnly);
title('Green channel image')
subplot(2,2,4),imshow(GetBlueChannelOnly);
title('Blue channel image')


%%%%%%%%%%%%%%%%%get the DCT convertion matrix%%%%%%%%%%%%%%%%
A = dctmtx(8);
%%%%%%%%%%%%%%convert to dct by the equation F = A * x * A'%%%%%%%%%%%%%%
funcOfDCT = @(block_struct) A * block_struct.data * A';
RedAfterDCT = blockproc(Red_channel , [8 8] , funcOfDCT);
GreenAfterDCT = blockproc(Green_channel , [8 8] , funcOfDCT);
BlueAfterDCT = blockproc(Blue_channel , [8 8] , funcOfDCT);

compressedImageSize = [0 0 0 0 ];
PSNR = [0 0 0 0];

figure;

%%%this for loop makes the elemination of the coefficients by the
%%%m X m size so it does it 4 times for m= 1 , 2 ,3 ,4 and calculates the
%%%PSNR and plots the output image

for m=1:1:4
    
    %%%%the elemenation matrix which has m X m 1's
    eleminating_coefficients = zeros(8, 8) ;
    eleminating_coefficients(1:m , 1: m ) =1 ;

    %%%%the three channels after elementationg the unwanted coefficients
    RedAfterElemination = blockproc(RedAfterDCT , [8 8] , @(block_struct) eleminating_coefficients .* block_struct.data);
    GreenAfterElemination = blockproc(GreenAfterDCT , [8 8] , @(block_struct) eleminating_coefficients .* block_struct.data);
    BlueAfterElemination = blockproc(BlueAfterDCT , [8 8] , @(block_struct) eleminating_coefficients .* block_struct.data);

    %%%%%compining the three channels again to make the compressed image 
    compressedImage = cat( 3 , RedAfterElemination , GreenAfterElemination , BlueAfterElemination);
    
    %%% applying the inverse of the DCT transform on each channel 
    %%% by the equation x = A' * F * A
    funcOfDCTInv = @(block_struct) A' * block_struct.data * A;
    OutputRed = blockproc(RedAfterElemination , [8 8] , funcOfDCTInv);
    OutputGreen = blockproc(GreenAfterElemination , [8 8] , funcOfDCTInv);
    OutputBlue = blockproc(BlueAfterElemination , [8 8] , funcOfDCTInv);

    %%%compining the three channels to make the ouput image
    OutputImage = cat(3 , OutputRed , OutputGreen , OutputBlue ) ;

    %%%output the compressed image for each m on the disk
    path = append('D:\college\second year\second semester\signals\proj\compress' ,int2str(m) ,'.png');
    imwrite(compressedImage , path)
    
    %%%%storing the size of the compressed file in bytes to show it later
    %%%%in the graph
    s=dir(path);
    compressedImageSize(m) = s.bytes;
    
    %%%output the output image for each m on the disk
    path = append('D:\college\second year\second semester\signals\proj\outputImages' , int2str(m) ,'.png');
    imwrite(OutputImage , path)
   
   
    %%%%%%%%%%%%%%%%%%%%ploting the output image for each m%%%%%%%%%%%%%%%
    str = append('Output image for m = ' , int2str(m));
    subplot(2,2,m),imshow(OutputImage);
    title(str);

    %%%%%%%%%%%calculating the PSNT and storing it to show it later%%%%%%%
    DiffrenceSquared = (OutputImage(:) - InputImage(:)) .^ 2 ; 
    MSE = sum(DiffrenceSquared)/(numel(OutputImage));
    PSNR(m) = 10*log10(255*255/MSE);
    
    
end


InputImageSize = [InputImageSize InputImageSize InputImageSize InputImageSize];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ploting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%the Image sizes graph%%%%%
figure;
grid on
b1 = bar(InputImageSize);
b1.FaceColor = 'y'; 
hold on 
b2 = bar(compressedImageSize,'BarWidth',0.5);
b2.FaceColor = 'c';
hold off
legend([b1 b2],'input size','compressed size')
xlabel({'m'})
ylabel({'Image Size (bytes)'})
title('Compare original and compressed images size')

%%%%%the PSNR graph%%%%%
figure;
m = [1 2 3 4];
bar(PSNR)
xlabel({'m'})
ylabel({'PSNR (DB)'})
title('Display PSNR')



