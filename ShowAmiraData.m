cd ("Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction")
clearvars

% load Data
brain = LoadTiffStack('Brain_stack.tif');
pom = LoadTiffStack('PO_stack.tif');
vpm = LoadTiffStack('VPM_stack.tif');

% plot Data
[brain_faces, brain_vertices] = isosurface(brain);
figure; p = patch('Faces', brain_faces, 'Vertices', brain_vertices);
p.FaceColor = 'r';
p.EdgeColor = 'none';
p.FaceAlpha = 0.3;
hold on
isosurface(pom)
isosurface(vpm)