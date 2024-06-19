%gets radiance values for specified bands
%used this: http://mres.uni-potsdam.de/index.php/2017/03/25/importing-and-processing-eo-1-hyperion-images-with-matlab/

clear
HYP = hdfread('/Users/katiekintzell/Desktop/EO1H0140342008067110PW/EO1H0140342008067110PW.L1R',...
    '/EO1H0140342008067110PW.L1R', ...
    'Index', {[1 1 1],[1 1 1],[3189 242 256]});


%moves bands to 3d
HYP = permute(HYP,[1 3 2]);

%calculate radiance for SWIR bands (bands 71 to 242) by dividing HYP by 80:
HYPR(:,:,1:70) = HYP(:,:,1:70)/40;
HYPR(:,:,71:242) = HYP(:,:,71:242)/80;

%enter 3 bands here
HYP1 = HYPR(:,:,29);
HYP2 = HYPR(:,:,23);
HYP3 = HYPR(:,:,16);

%convert data types to save storage
HYP1 = uint8(HYP1);
HYP2 = uint8(HYP2);
HYP3 = uint8(HYP3);

%increase contrast, concatenate 3 bands!
HYP1 = histeq(HYP1);
HYP2 = histeq(HYP2);
HYP3 = histeq(HYP3);
HYPC = cat(3,HYP1,HYP2,HYP3);

imshow(HYPC), axis off
print -dtiff -r1200 magadi.tif