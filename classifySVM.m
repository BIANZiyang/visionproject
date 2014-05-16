%function class = classify(library,classes,filename)
addpath('mmread');
addpath('tensor_toolbox/');
addpath('opticalflow/mex');
addpath('opticalflow');
addpath('lscca/utilities');
addpath('libsvm-3.18/matlab')

load('svmfeatures.mat')

model=svmtrain(sameclass,features,'-b 1');
modelNoDepth=svmtrain(sameclass,features(:,1:90),'-b 1');


%use depth and video tensors
depth=1;
useVideo=1;

%set up images, and classes which will be parameters
library=importdata('library.txt');  % "training" videos to compare against
test=importdata('test.txt');  % "test" videos

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

features=[];
sameclass=[];

predictedClass=zeros(numTest,1);
predictedScore=zeros(numTest,1);
predictedClassNoDepth=zeros(numTest,1);
predictedScoreNoDepth=zeros(numTest,1);
for j=1:numTest
    predictFilename=test{j};
    
    %set up tensors for the sequence we are trying to classify
    if useVideo
        vidFrames =readImage(predictFilename,opticalFlow);
        % Create a MATLAB movie struct from the video frames.
        redQuery=squeeze(vidFrames(:,:,1,:));
        greenQuery=squeeze(vidFrames(:,:,2,:));
        blueQuery=squeeze(vidFrames(:,:,3,:));
    end
    if depth
        depthQuery=loadDepth(predictFilename);
    end
    
    %compare target sequence to all sequences in the library
    for i=1:numImages
        disp([num2str(i),':',num2str(j)]);
        trainFilename=library{i};
        
        corrVector=[];
        % Read in all video frames.
        if useVideo
            vidFrames = readImage(trainFilename,opticalFlow);
            
            % Create a MATLAB movie struct from the video frames.
            redTarget=squeeze(vidFrames(:,:,1,:));
            greenTarget=squeeze(vidFrames(:,:,2,:));
            blueTarget=squeeze(vidFrames(:,:,3,:));
            
            corrsR=tensorCCA(redQuery,redTarget);
            corrsG=tensorCCA(greenQuery,greenTarget);
            corrsB=tensorCCA(blueQuery,blueTarget);
            corrVector= [corrVector, corrsR(1:60), corrsG(1:60), corrsB(1:60)];
        end
        if depth
            depthTarget=loadDepth(trainFilename);
            corrsD=tensorCCA(depthQuery,depthTarget);
            corrVector=[corrVector,corrsD(1:60)];
        end
        
        [predict,accuracy,prob]=svmpredict(classTest(j),corrVector,model,'-b 1');
        if prob(1)>predictedScore(j)
           predictedClass(j)=class(i);
           predictedScore(j)=prob(1);
        end
        [predict,accuracy,prob]=svmpredict(classTest(j),corrVector(1:90),modelNoDepth,'-b 1');
        if prob(1)>predictedScoreNoDepth(j)
           predictedClassNoDepth(j)=class(i);
           predictedScoreNoDepth(j)=prob(1);
        end
    end

end

sumV=sum(predictedClass==classTest);
accuracy=sumV/length(predictedClass)

sumV=sum(predictedClassNoDepth==classTest);
accuracyNoDepth=sumV/length(predictedClass)
