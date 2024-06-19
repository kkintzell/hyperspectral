
% displays hyperion data as a gray-scale image

clear

% reading image
HYP = hdfread('/Users/katiekintzell/Desktop/EO1H0140342005026110PW/EO1H0140342005026110PW.L1R',... 
    '/EO1H0140342005026110PW.L1R',...
    'Index', {[1 1 1],[1,1,1],[3189,242,256]});

% shows how the hyperspectral image is stored (gives dimension and data
% type)
whos

% permutes the array to move the bands to the third dimension (each array
% element represents one pixel contains signed 16-bit integers)
HYP = permute(HYP,[1 3 2]);


% calculates radiance values for SWIR bands
HYPR(:,:,1:70)= HYP(:,:,1:70)/40;
HYPR(:,:,71:242)= HYP(:,:,71:242)/80;

% reads wavelenghts corresponding to all 242 spectral bands
% writes text from file into array C
fid = fopen('/Users/katiekintzell/Desktop/EO1H0140342005026110PW/EO1H0140342005026110PW.hdr');
C = textscan(fid, '%f %f %f %f %f %f %f %f', ...
    'Delimiter',',','Headerlines',257,'CollectOutput',1);
fclose(fid);

% retrieves wavelenghts
wavelengths = C{1};
wavelengths = wavelengths';
wavelengths = wavelengths(isnan(wavelengths(:))==0);

% plots radiances of blue (VNIR) and red (SWIR) bands 
plot(wavelengths(1:60),squeeze(HYPR(536,136,1:60)),'b')
hold on
plot(wavelengths(71:242),squeeze(HYPR(536,136,71:242)),'r')
hold off

% extracts radiane values for bands 29, 23, and 16 
HYP1 = HYPR(:,:,29);
HYP2 = HYPR(:,:,23);
HYP3 = HYPR(:,:,16);

% want to convert the signed interger 16-bit data to unsigned integer 8-bit
% data

% creates 100 class histograms
subplot(1,3,1), histogram(double(HYP1(:)),100), title('Band 29');
subplot(1,3,2), histogram(double(HYP2(:)),100), title('Band 23');
subplot(1,3,3), histogram(double(HYP3(:)),100), title('Band 16');


% convert data
HYP1 = uint8(HYP1);
HYP2 = uint8(HYP2);
HYP3 = uint8(HYP3);

% display radiance values again using converted data
subplot(1,3,1), imhist(single(HYP1(:)),30), title('Band 29');
subplot(1,3,2), imhist(single(HYP2(:)),30), title('Band 23');
subplot(1,3,3), imhist(single(HYP3(:)),30), title('Band 16');

% enhance constrast of the image and concatenate the three bands into an
% array the size of the original image
HYP1 = histeq(HYP1);
HYP2 = histeq(HYP2);
HYP3 = histeq(HYP3);

subplot(1,3,1), imhist(HYP1(:)), title('Band 29');
subplot(1,3,2), imhist(HYP2(:)), title('Band 23');
subplot(1,3,3), imhist(HYP3(:)), title('Band 16');

HYPC = cat(3,HYP1,HYP2,HYP3)

% display image!
imshow(HYPC);

%display part of image
%imshow(HYPC(900:1100,:,:))

% save image
print -r600 -dtiff convertedimage.tif

