%function class = classify(library,classes,filename)
addpath('mmread');
addpath('tensor_toolbox/');
addpath('opticalflow/mex');
addpath('opticalflow');
addpath('lscca/utilities');

%use depth and video tensors
depth=1;
useVideo=1;

% to choose how many top correlations to use, change tensorCCA.m

%how many nearest neighbors for classification
nn=10;

%set up images, and classes which will be parameters
library=importdata('library.txt');  % "training" videos to compare against
test=importdata('test.txt');  % "test" videos


savefile='depth';

opticalFlow=1;  %compute optical flow on video
numImages=length(library);
numTest=length(test)
class=zeros(numImages,1);
classTest=zeros(numTest,1);
prediction=zeros(numTest,1);

%%set up classes
for i=1:numImages
    fname=library{i};
    cl=str2num(fname(2:3));
    class(i)=cl;
end
for i=1:numTest
    fname=test{i};
    cl=str2num(fname(2:3));
    classTest(i)=cl;
end


for j=1:numTest
    predictFilename=test{j};
    
    %set up tensors for the sequence we are trying to classify
    if useVideo
        vidFrames =readImage(predictFilename,opticalFlow);
        % Create a MATLAB movie struct from the video frames.
        redQuery=squeeze(vidFrames(:,:,1,:));
        greenQuery=squeeze(vidFrames(:,:,2,:));
        blueQuery=squeeze(vidFrames(:,:,3,:));
        scores=zeros(numImages,1);
    end
    if depth
        depthQuery=loadDepth(library{j});
    end
    
    %compare target sequence to all sequences in the library
    for i=1:numImages
        disp([num2str(i),':',num2str(j)]);
        trainFilename=library{i};
        
        % Read in all video frames.
        if useVideo    
            vidFrames = readImage(library{i},opticalFlow);

            % Create a MATLAB movie struct from the video frames.
            redTarget=squeeze(vidFrames(:,:,1,:));
            greenTarget=squeeze(vidFrames(:,:,2,:));
            blueTarget=squeeze(vidFrames(:,:,3,:));

            corrsR=tensorCCA(redQuery,redTarget);
            corrsG=tensorCCA(greenQuery,greenTarget);
            corrsB=tensorCCA(blueQuery,blueTarget);
            finalScore=sum([sum(corrsR),sum(corrsG),sum(corrsB)]);
        else
            finalScore=0;
        end
        if depth
            depthTarget=loadDepth(library{i});
            corrsD=tensorCCA(depthQuery,depthTarget);
            finalScore=sum([finalScore,sum(corrsD)]);
        end

        scores(i)=finalScore;
           
    end
    
    %find the library sequences with the highest score
    [B,I]=sort(scores);
    nearest=zeros(nn,1);
    for i=1:nn
        nearest(i)=class(I(end-nn+i));
    end
    
    %the predicted class is the most common class in the top NN matches
    pred=mode(nearest)
    prediction(j)=pred;
end

prediction
classTest
acc=mean(classTest==prediction)
save(savefile,'prediction','class','depth','acc');
