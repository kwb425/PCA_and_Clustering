%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA, it's nothing more then an axis rotation
% (or data rotation, depending on your perspective).
%
%                                                  Written by Kim, Wiback,
%                                                  2016. 06. 13. Ver. 1.1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kill





%% Data Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%
% Random x, y, z
%%%%%%%%%%%%%%%%
orig_x = randn(1000, 1);
orig_y = orig_x + rand(1000, 1);
orig_z = orig_y + rand(1000, 1);



%%%%%%%%%%
% Plotting
%%%%%%%%%%
plot3(orig_x, orig_y, orig_z, 'ro', 'markersize', 20)
hold on
orig_data = [orig_x, orig_y, orig_z];





%% PCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%
% Do PCA
%%%%%%%%

%%% Analysis
[coeff, score, latent, ~, explained, ~] = pca(orig_data);

%%% Centering before projection (this is because PCA centers the data.)
orig_data = zscore(orig_data);

%%% How many PC's do we need...
fprintf('%s: %d\n%s: %d\n%s: %d\n', ...
    'PC1', explained(1), ...
    'PC2', explained(2), ...
    'PC3', explained(3))



%%%%%%%%%%%%%%%%%%%%
% Projecting to PC 1
%%%%%%%%%%%%%%%%%%%%
pca_ed_data = orig_data * coeff(:, 1);
plot(pca_ed_data, 'go')



%%%%%%%%%%%%%%%%%%%%
% Projecting to PC 2 
%%%%%%%%%%%%%%%%%%%%
% For visual ease, we plot them on same axis as PC1.
pca_ed_data = orig_data * coeff(:, 2);
plot(pca_ed_data, 'bo')





%% PCA <-> Original %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%
% Original -> PCA
%%%%%%%%%%%%%%%%%
pca_ed_data = orig_data * coeff(:, 1:3);



%%%%%%%%%%%%%%%%%
% PCA -> Original
%%%%%%%%%%%%%%%%%
% Notice, it's merely a rotation.
back_orig_data = pca_ed_data / coeff;

%%% Plotting
plot3(back_orig_data(:, 1), back_orig_data(:, 2), back_orig_data(:, 3), ...
    'r+', 'markersize', 10)
legend('orig', 'pc1', 'pc2', 'back2orig')