

filename=['/scratch/action/videos/a15_s02_e01_rgb.avi'];
prefix=[filename(1:end-7),'depth'];
matfile=[prefix,'.mat'];


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
de=video;