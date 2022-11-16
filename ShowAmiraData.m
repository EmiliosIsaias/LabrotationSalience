addpath ('Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction')
addpath ('Z:\Josephine')
clearvars
close all

% load Data
load vpm_pom_coordinates_predictions.mat
brain = LoadTiffStack('Brain_stack.tif'); brain = smooth3(brain);
pom = LoadTiffStack('PO_stack.tif'); pom = smooth3(pom);
vpm = LoadTiffStack('VPM_stack.tif'); vpm = smooth3(vpm);

px2micm = [8.66,8.66, -50];
% refs = [-748, -902, 8.2]; -> old references
refs = [-796, -890, 14.2];
clMap = lines(2);

bxOpts = {'Box', 'off', 'Color', 'none'};

% plot 3D brain     
figure('Name', '3D model and predictions','Color','w')

[brain_faces, brain_vertices] = isosurface(brain);
brain_vertices_micm = brain_vertices.*px2micm + refs.*px2micm;
pb = patch('Faces', brain_faces, 'Vertices', brain_vertices_micm);
pb.EdgeColor = 'none'; pb.FaceAlpha = 0.3;
hold on

[pom_faces, pom_vertices] = isosurface(pom);
pom_vertices_micm = pom_vertices.*px2micm + refs.*px2micm;
pom_centroid = mean(pom_vertices_micm);
scatter3(pom_centroid(1), pom_centroid(2), pom_centroid(3), [], "black", ...
    'filled', 'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)
pp = patch('Faces', pom_faces, 'Vertices', pom_vertices_micm);
pp.FaceColor = 'g'; pp.EdgeColor = 'none'; pp.FaceAlpha = 0.3;

[vpm_faces, vpm_vertices] = isosurface(vpm);
vpm_vertices_micm = vpm_vertices.*px2micm + refs.*px2micm;
vpm_centroid = mean(vpm_vertices_micm);
scatter3(vpm_centroid(1), vpm_centroid(2), vpm_centroid(3), [], "black", ...
    'filled', 'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)
pv = patch('Faces', vpm_faces, 'Vertices', vpm_vertices_micm);
pv.FaceColor = 'r'; pv.EdgeColor = 'none'; pv.FaceAlpha = 0.3;

% Plotting the predictions in the 3D model
scatter3(-coords(:,1), coords(:,3), coords(:,2), [], clMap(-prediction+2,:), ...
    'filled', 'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)

% add labels, legend and title to figure
lgObj = legend([pp, pv], {'POm', 'VPM'}); set(lgObj, bxOpts{:}, ...
    'AutoUpdate', 'off')
xlabel ('m/l axis'); ylabel ('d/v axis'); zlabel('a/p axis')
title('{\color[rgb]{0, 0.4470, 0.7410}VPM} and {\color[rgb]{0.8500, 0.3250, 0.0980}POm} predictions')

set(gca, bxOpts{1:4});
savefig(gcf, fullfile('Z:\Josephine','3D-brain with vpm and pom predictions.fig'))