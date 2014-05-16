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
    
    width=60;%cols;
    height=60; %rows;
    newFrames=60;
    img=zeros(height,width,newFrames);
    ChannelImg=zeros(height,width,frames);
    for i=1:frames
        threechannels=video(:,:,i);
        ChannelImg(:,:,i)=imresize(threechannels(:,:),[height,width],'nearest');
    end
    newTensor=zeros(height,width,newFrames);
    for i=1:height
        newTensor(i,:,:)=imresize(squeeze(ChannelImg(i,:,:)),[width newFrames],'nearest') ;
    end
    img=newTensor;
    save(matfile,'img');
end
