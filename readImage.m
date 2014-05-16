function img= readImage(filename,opticalflow)

filename=['/scratch/action/videos/',filename];
prefix=filename(1:end-4);
if opticalflow==0
    matfile=[prefix,'.mat'];
else
    matfile=[prefix,'medium_OF.mat'];
end

if exist(matfile, 'file') == 2
    load(matfile);
else   
    vid=mmread(filename);
    frames=vid.nrFramesTotal;
    width=60;%vid.width/4;
    height=60;%vid.height/4;
    newFrames=60;
    img=zeros(height,width,3,newFrames);
    for colorChannel=1:3
        ChannelImg=zeros(height,width,frames);
        for i=1:frames        
            threechannels=vid.frames(i).cdata;
            ChannelImg(:,:,i)=imresize(squeeze(threechannels(:,:,colorChannel)),[height,width],'nearest'); 
        end
        newTensor=zeros(height,width,60);
        for i=1:height
            newTensor(i,:,:)=imresize(squeeze(ChannelImg(i,:,:)),[width 60],'nearest') ;
        end
        img(:,:,colorChannel,:)=newTensor;
    end
    if opticalflow
         ofimg=zeros(height,width,3,newFrames-1);
         for i=1:newFrames-1
            frame1=squeeze(mat2gray(img(:,:,:,i)));
            frame2=squeeze(mat2gray(img(:,:,:,i+1)));
            ZZ=computeOpticalFlow(frame1,frame2);
            ofimg(:,:,:,i)=computeOpticalFlow(frame1,frame2);
         end
         img=ofimg;
    end
    save(matfile,'img')
end
