%function class = classify(library,classes,filename)
addpath('mmread');
addpath('/u/s/l/slagree/Desktop/tensor_toolbox/');
addpath('opticalflow/mex');
addpath('opticalflow');
addpath('lscca/utilities');

depth=1;

%set up images, and classes which will be parameters
library=importdata('movielist.txt');


video1=readImage(library{5},1);
depth1=loadDepth(library{5});
video2=readImage(library{19},1);
depth2=loadDepth(library{19});
video3=readImage(library{23},1);
depth3=loadDepth(library{23});
