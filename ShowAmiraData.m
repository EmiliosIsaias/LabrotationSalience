%% INIT
addpath ('Z:\Josephine\Histo\Cohort_12_33-38\#34\#34_reconstruction')
addpath ('Z:\Josephine')
clearvars
close all

% load Data
load vpm_pom_coordinates_predictions.mat
brain = LoadTiffStack('Brain_stack.tif'); brain = smooth3(brain);
% tetr = LoadTiffStack('Brain_Tetrodes_stack.tif'); tetr = smooth3(brain);
pom = LoadTiffStack('PO_stack.tif'); pom = smooth3(pom);
vpm = LoadTiffStack('VPM_stack.tif'); vpm = smooth3(vpm);


px2micm = [8.66,8.66, -50];
% refs = [-748, -902, 8.2]; -> old references
refs = [-796, -890, 14.2];
clMap = [1,0,0; ...   VPM red  
        0,1,0];     % POm green

bxOpts = {'Box', 'off', 'Color', 'none', 'Clipping', 'off'};
pcOpts = {'EdgeColor', 'none', 'FaceAlpha', 0.3, 'FaceColor'};
x2m = @(x) x.vertices .* px2micm + refs.*px2micm;

%% Transform pixels to micrometers and reduce polygon faces
brain_struct = isosurface(brain);
brain_patch = reducepatch(brain_struct);
brain_patch.vertices = x2m(brain_patch);

pom_struct = isosurface(pom);
pom_patch = reducepatch(pom_struct);
pom_patch.vertices = x2m(pom_patch);

vpm_struct = isosurface(vpm);
vpm_patch = reducepatch(vpm_struct);
vpm_patch.vertices = x2m(vpm_patch);
%% Plot 3D brain     
fig3d = figure('Name', '3D model and predictions','Color','w');
ax = axes('Parent', fig3d, 'NextPlot', 'add', bxOpts{:});

%{
[brain_faces, brain_vertices] = isosurface(brain);
brain_vertices_micm = brain_vertices.*px2micm + refs.*px2micm;
pb = patch('Faces', brain_faces, 'Vertices', brain_vertices_micm);
pb.EdgeColor = 'none'; pb.FaceAlpha = 0.3;
hold on
%}

% pb = patch(ax, brain_patch, pcOpts{:}, 'k');

%{ 
[pom_faces, pom_vertices] = isosurface(pom);
pom_vertices_micm = pom_vertices.*px2micm + refs.*px2micm;
pom_centroid = mean(pom_vertices_micm);

% Plotting the centroid of POm
scatter3(pom_centroid(1), pom_centroid(2), pom_centroid(3), [], "black", ...
    'filled', 'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)

pp = patch('Faces', pom_faces, 'Vertices', pom_vertices_micm);
pp.FaceColor = 'g'; pp.EdgeColor = 'none'; pp.FaceAlpha = 0.3;
%}

pp = patch(ax, pom_patch, pcOpts{:}, 'g');

%{
[vpm_faces, vpm_vertices] = isosurface(vpm);
vpm_vertices_micm = vpm_vertices.*px2micm + refs.*px2micm;
vpm_centroid = mean(vpm_vertices_micm);

% Plotting the centroid of VPM
scatter3(vpm_centroid(1), vpm_centroid(2), vpm_centroid(3), [], "black", ...
    'filled', 'MarkerEdgeColor','none','MarkerFaceAlpha',0.6)

pv = patch('Faces', vpm_faces, 'Vertices', vpm_vertices_micm);
pv.FaceColor = 'r'; pv.EdgeColor = 'none'; pv.FaceAlpha = 0.3;
%}

pv = patch(ax, vpm_patch, pcOpts{:}, 'r');

% Plotting the predictions in the 3D model
scatter3(ax, -coords(:,1), coords(:,3), coords(:,2), [], ...
    clMap(-prediction+2,:), 'filled', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceAlpha', 0.6)

% add labels, legend and title to figure
lgObj = legend(ax, [pp, pv], {'POm', 'VPM'}); set(lgObj, bxOpts{1:4}, ...
    'AutoUpdate', 'off')
xlabel(ax, 'm/l axis'); ylabel(ax, 'd/v axis'); zlabel(ax, 'a/p axis')
clr = "{\\color[rgb]{";
ttlStr = clr+"%f, %f, %f}VPM} and "+clr+"%f, %f, %f}POm} predictions";
title(ax, sprintf(ttlStr, clMap'))

origin = [-3, -4.5, -3]*1e3;
pointing = origin + 1e3;

lineMat = pagemtimes(ones(2,3,3), reshape(origin, [1,1,3]));
for cp = 1:3
    lineMat(2,cp,cp) = pointing(cp);
end

plot3(ax, lineMat(:,:,1), lineMat(:,:,2),lineMat(:,:,3), ...
    "LineWidth", 1, "Color", "k")

axis equal

%% Save results
outFig = fullfile('Z:\Josephine', ...
    '3D-brain with vpm and pom predictions.fig');
if ~exist(outFig, "file")
    savefig(gcf, outFig)
end