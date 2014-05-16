%% CCA Implementation
% Data synthesis
N = 100;
dimx1 = 50;
dimx2 = 50;
X1 = rand(N, dimx1)*2-0.5;
X2 = rand(N, dimx2)*2-0.5;

%% Find threshold
% v values for interval
% idx of constraints

% max iteration
maxiter = 100;

%% Sparsity parameters
%% Bigger c1, and c2, less tight sparsity penelty.
c1 = sqrt(size(X1,1))*sqrt(size(X1,2));
c2 = sqrt(size(X2,1))*sqrt(size(X2,2));
c3 = 1e-20; % convergence check. Stopping condition.
tic
[ w1, w2, fval, r, status, iter] = scca_ver2(X1, X2, c1, c2, c3, maxiter);
r % correlation
w1; % Weight vetor or mask of data X1 from CCA
w2; % Weight vetor or mask of data X2 from CCA
fval; %objective function value
figure;plot(X1*w1,X2*w2,'ro');
title(['CCA projection corr=',sprintf('%.4f\n',r)]);

