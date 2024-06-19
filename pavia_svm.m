hcube = hypercube('/Users/katiekintzell/Desktop/paviaU.dat');
gtLabel = load('/Users/katiekintzell/Desktop/paviauRoofingGT.mat');
gtLabel = gtLabel.paviauRoofingGT;
numClasses = 16;

%band = [90:95]
%hcube = removeBands(hcube, BandNumber=band);

rgbImg = colorize(hcube, method="rgb");

hsData = hcube.DataCube;
[M,N,C]=size(hsData);
hsDataFiltered = zeros(size(hsData));
for band = 1:C
    bandImage = hsData(:,:,band);
    bandImageFiltered = imgaussfilt(bandImage, 2);
    bandImageGray = mat2gray(bandImageFiltered);
    hsDataFiltered(:,:,band)=uint8(bandImageGray*255);
end

DataVector = reshape(hsDataFiltered, [M*N,C]);
gtVector = gtLabel(:);
gtLocs = find(gtVector~=0);
classLabel = gtVector(gtLocs);
per = 0.1;
cv = cvpartition(classLabel,HoldOut=1-per);
locTrain = gtLocs(cv.training);
locTest = gtLocs(~cv.training);

svmMdl = fitcecoc(DataVector(locTrain,:),gtVector(locTrain,:));
[svmLabelOut,~]=predict(svmMdl,DataVector(locTest,:));

svmAccuracy=sum(svmLabelOut == gtVector(locTest))/numel(locTest);
disp(["Overall Accuracy of the test data using SVM = ",num2str(svmAccuracy)])

svmPredLabel = gtLabel;
svmPredLabel(locTest)=svmLabelOut;

cmap = parula(numClasses);
figure
tiledlayout(1,3,TileSpacing = "loose")
nexttile
imshow(rgbImg)
title("RGB Image")
nexttile
imshow(gtLabel, cmap)
title("Ground Truth Map")
nexttile
imshow(svmPredLabel, cmap)
colorbar
title("SVM Classification Map")
