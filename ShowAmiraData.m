cd ("Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction")
addpath 'Z:\Josephine\MATLAB'
clearvars

% load Data
brain = LoadTiffStack('Brain_stack.tif');
pom = LoadTiffStack('PO_stack.tif');
vpm = LoadTiffStack('VPM_stack.tif');

% plot Data
figure
[brain_faces, brain_vertices] = isosurface(brain);

hold on
isosurface(pom)
isosurface(vpm)