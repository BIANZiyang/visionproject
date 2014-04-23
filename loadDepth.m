function img = loadDepth(filename)

filename=['/scratch/action/videos/',filename];
prefix=[filename(1:end-7),'depth'];
matfile=[prefix,'.mat'];


if exist(matfile, 'file') == 2
    load(matfile);
else
    fid = fopen([prefix,'.bin'],'r');
    frames=fread(fid,1,'int32');
    cols=fread(fid,1,'int32');
    rows=fread(fid,1,'int32');
    
    video=zeros(rows,cols,frames);
    skeleton=zeros(rows,cols,frames);
    
    for f=1:frames
        for r=1:rows
            currentRow=fread(fid,cols,'int32');
            skeletonRow=fread(fid,cols,'uint8');
            video(r,:,f)=double(currentRow');
            skeleton(r,:,f)=skeletonRow';
        end
    end
    fclose(fid);
    
    width=60;%vid.width;
    height=60;%vid.height;
    newFrames=60;
    img=zeros(height,width,newFrames);
    ChannelImg=zeros(height,width,frames);
    for i=1:frames
        threechannels=video(:,:,i);
        ChannelImg(:,:,i)=imresize(threechannels(:,:),[60,60],'nearest');
    end
    newTensor=zeros(60,60,60);
    for i=1:60
        newTensor(i,:,:)=imresize(squeeze(ChannelImg(i,:,:)),[60 60],'nearest') ;
    end
    img=newTensor;
    save(matfile,'img');
end
