
Download the MSRDailyActivity3D dataset from
http://research.microsoft.com/en-us/um/people/zliu/ActionRecoRsrc/
Extract contents of the zip files into /scratch/action/videos

Then run classify.m
The parameters to set are at the top of the classify script.

The first time you load each sequence file it will have to load the video/depth sequence and create a matlab tensor in the format we need.  
Then it saves it as a .mat file, so we don't have to do that every time.
It will take longer the first time and then be able to load quickly after that.


