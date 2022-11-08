cd ("Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction")
clearvars

% load Data
brain = LoadTiffStack('Brain_stack.tif'); brain = smooth3(brain);
pom = LoadTiffStack('PO_stack.tif'); pom = smooth3(pom);
vpm = LoadTiffStack('VPM_stack.tif'); vpm = smooth3(vpm);

% plot Data
[brain_faces, brain_vertices] = isosurface(brain);
figure; pb = patch('Faces', brain_faces, 'Vertices', brain_vertices);
pb.EdgeColor = 'none'; pb.FaceAlpha = 0.3;
hold on

[pom_faces, pom_vertices] = isosurface(pom);
pp = patch('Faces', pom_faces, 'Vertices', pom_vertices);
pp.FaceColor = 'g'; pp.EdgeColor = 'none'; pp.FaceAlpha = 0.3;

[vpm_faces, vpm_vertices] = isosurface(vpm);
pv = patch('Faces', vpm_faces, 'Vertices', vpm_vertices);
pv.FaceColor = 'r'; pv.EdgeColor = 'none'; pv.FaceAlpha = 0.3;