%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% k-means clustering:
% 1. random initial points
% 2. Assign other points to the closest random point
% 3. Update the random initial points' centre so that they can encompass
%    the newly assigned points.
% 4. Loop 2 ~ 3 until there is no more change.
% 
%                                                  Written by Kim, Wiback,
%                                                  2016. 06. 14. Ver. 1.1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kill





%% Pre-processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%
% Data
%%%%%%

%%% Loading
data = load('sample_data.mat');
data = dataset2table(data.data);

%%% Data to cell (for format consistency)
data = [data.Gender, ... % Binary
    num2cell(data.Age), ... % Continuous
    num2cell(data.Height), ... % Continuous
    num2cell(data.ShoeSize), ... % Continuous
    data.FavDay, ... % Categorical
    num2cell(data.FavNum), ... % Continuous, but too random
    num2cell(data.CGames), ... % Continuous
    num2cell(data.Studying), ... % Continuous
    num2cell(data.Sleeping), ... % Continuous
    data.CourseInterest]; ... % Categorical

%%% Let's choose only 3 (for ease).
data_input = [data(:, 3), data(:, 4), data(:, 7)];    
data_input = cell2mat(data_input);



%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
% number of points to generate
density = 100;
% how many clusters to try out
how_many_clusters = 5;





%% Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% k-means for silhouette analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The silhouette value for each point is a measure of 
% how similar that point is to points in its own cluster (higher, better).
silhouette_holder = zeros(size(data_input, 1), how_many_clusters-1);
for trial = 2:how_many_clusters
    
    %%% Get cluster indices from k-means.
    [cidx, cectroid] = ...
        kmeans(data_input, trial, 'distance', 'sqeuclidean', 'replicates', 10);
    
    %%% Get silhouette measures for all points.
    s = silhouette(data_input, cidx, 'sqeuclidean');
    
    %%% Save for later use.
    silhouette_holder(:, trial-1) = s;
end
% Plot distribution of the silhouette values for all cluster parameters
boxplot(silhouette_holder, 'labels', 2:how_many_clusters);



%%%%%%%%%%%%%%%%%
% Optimal k-means
%%%%%%%%%%%%%%%%%

%%% Choose the best k, and do the clustering.
[~, k_minus_one] = max(median(silhouette_holder));
cidx = kmeans(data_input, k_minus_one+1, ...
    'distance', 'sqeuclidean', 'replicates', 10);

%%% Data plot
subplot(1, 2, 1);
scatter3(data_input(:, 1), data_input(:, 2), data_input(:, 3), 'ko');
axis equal

%%% Clustering plot
col = colormap('prism');
subplot(1, 2, 2);
hold on
% In different colors
for which_cluster = 1:k_minus_one+1
    scatter3(data_input(cidx == which_cluster, 1), ...
        data_input(cidx == which_cluster, 2), ...
        data_input(cidx == which_cluster, 3), ...
        'MarkerFaceColor', col(which_cluster, :))
end

%%% Testing plot
% Females in red dots
female_index = strcmp(data(:, 1), 'TRUE');
plot3(data_input(female_index, 1), ...
    data_input(female_index, 2), ...
    data_input(female_index,3), ...
    'ro', ...
    'markersize', 15);
% Males in blue dots
plot3(data_input(~female_index, 1), ...
    data_input(~female_index, 2), ...
    data_input(~female_index, 3), ...
    'bo', ...
    'markersize', 15);
% Decoration
view([max(data_input(:, 1))/2, ...
    min(data_input(:, 2)), ...
    max(data_input(:, 3))*2])
axis equal

%%% Numeric varidation
% Indice of the female points correctely classified as cluster 1
female_correct_c_1 = ((cidx==1) == female_index);
% Indice of the female points correctely classified as cluster 2
female_correct_c_2 = ((cidx==2) == female_index);
% Extract higher accuracy.
if sum(female_correct_c_1) > sum(female_correct_c_2)
    correct = female_correct_c_1;
else
    correct = female_correct_c_2;
end
% Display the numeric accuracy.
text(min(data_input(:, 1)), min(data_input(:, 2)), ...
    sprintf('Female Correct rate: %f%%', ...
    sum(correct)/length(correct)*100));