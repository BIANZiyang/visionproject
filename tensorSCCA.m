function score = tensorCCA(tensorA,tensorB,sparse)



    AA=tensor(tensorA);
    BB=tensor(tensorB);


    %For each axes of image, unroll
    Ax=tenmat(AA,[2 3], 1);
    Ay=tenmat(AA,[1 3], 2);
    Az=tenmat(AA,[1 2], 3);


    Bx=tenmat(BB,[2 3], 1);
    By=tenmat(BB,[1 3], 2);
    Bz=tenmat(BB,[1 2], 3);



if sparse
    c1 = sqrt(size(Ax,1))*sqrt(size(Ax,2));
    c2 = sqrt(size(Ax,1))*sqrt(size(Ax,2));
    c3 = 1e-20; % convergence check. Stopping condition.
    maxiter = 100;
	[ w1, w2, fval, r1, status, iter] = scca_ver2(double(Ax),double(Bx), c1, c2, c3, maxiter);
	[ w1, w2, fval, r2, status, iter] = scca_ver2(double(Ay),double(By), c1, c2, c3, maxiter);
	[ w1, w2, fval, r3, status, iter] = scca_ver2(double(Az),double(Bz), c1, c2, c3, maxiter);
    r1(isnan(r1))=0;
    r2(isnan(r2))=0;
    r3(isnan(r3))=0;

else
%        options.PrjX = 1;
%        options.PrjY = 1;
%        options.RegX = 1;
%        options.RegY = 1;
%     
%      [x1 y1 r1]=CCA(double(Ax),double(Bx),options);
%      [x2 y2 r2]=CCA(double(Ay),double(By),options); 
%      [x3 y3 r3]=CCA(double(Az),double(Bz),options); 
%     corrs=[r1;r2;r3];

    [x1 y1 r1]=canoncorr(double(Ax),double(Bx));
    [x2 y2 r2]=canoncorr(double(Ay),double(By)); 
    [x3 y3 r3]=canoncorr(double(Az),double(Bz));  
end    
corrs=[r1,r2,r3];

    
    score=sort(corrs,'descend');
