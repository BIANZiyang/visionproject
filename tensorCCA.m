function score = tensorCCA(tensorA,tensorB)



    AA=tensor(tensorA);
    BB=tensor(tensorB);


    %For each axes of image, unroll
    Ax=tenmat(AA,[2 3], 1);
    Ay=tenmat(AA,[1 3], 2);
    Az=tenmat(AA,[1 2], 3);


    Bx=tenmat(BB,[2 3], 1);
    By=tenmat(BB,[1 3], 2);
    Bz=tenmat(BB,[1 2], 3);
    options.PrjX = 1;
    options.PrjY = 1;
    options.RegX = 1;
    options.RegY = 1;
    
%     [x1 y1 r1]=CCA(double(Ax),double(Bx),options);
%     [x2 y2 r2]=CCA(double(Ay),double(By),options); 
%     [x3 y3 r3]=CCA(double(Az),double(Bz),options); 
%    corrs=[r1;r2;r3];

     [x1 y1 r1]=canoncorr(double(Ax),double(Bx));
     [x2 y2 r2]=canoncorr(double(Ay),double(By)); 
     [x3 y3 r3]=canoncorr(double(Az),double(Bz));  
     corrs=[r1,r2,r3];

     %use top correlations
%     corrs=[r1(1:10),r2(1:10),r3(1:10)];
    
    score=sort(corrs,'descend');
