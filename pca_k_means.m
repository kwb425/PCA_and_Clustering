%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA -> k-means (on score & loading spaces, thus it's hard to interpret.)
%
%                                                  Written by Kim, Wiback,
%                                                     2016.06.11. Ver.1.1.
%                                                     2016.06.15. Ver.1.2.
%                                                     2016.06.16. Ver.1.3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pca_k_means





%% Main figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%
% Upper most figure
%%%%%%%%%%%%%%%%%%%
screen_size = get(0, 'screensize');
fg_size = [1000, 750];
S.fg = figure('units', 'pixels', ...
    'position', ...
    [(screen_size(3) - fg_size(1)) / 2, ... % 1/2*(Screen's x - figure's x)
    (screen_size(4) - fg_size(2)) / 2, ... % 1/2*(Screen's y - figure's y)
    fg_size(1), ... % The figure's x
    fg_size(2)], ... % The figure's y
    'menubar', 'none', ...
    'name','PCA & k-means', ...
    'numbertitle', 'off', ...
    'resize', 'off');



%%%%%%
% Axes
%%%%%%

%%% Scree axes
S.ax_scree = axes('units', 'pixels', ...
    'position', [35, 35, 930, 620], ...
    'NextPlot', 'replacechildren', ...
    'xtick', {}, ...
    'ytick', {}, ...
    'visible', 'off');
title(S.ax_scree, 'PCA Processing...', 'fontsize', 15)
box(S.ax_scree, 'on')

%%% Score & Cluters axes
S.ax_score_cluster = axes('units', 'pixels', ...
    'position', [35, 35, 450, 620], ...
    'NextPlot', 'replacechildren', ...
    'xtick', {}, ...
    'ytick', {}, ...
    'visible', 'off');
title(S.ax_score_cluster, 'Score plot', 'fontsize', 15)
box(S.ax_score_cluster, 'on')

%%% Loading & Cluters axes
S.ax_loading_cluster = axes('units', 'pixels', ...
    'position', [515, 35, 450, 620], ...
    'NextPlot', 'replacechildren', ...
    'xtick', {}, ...
    'ytick', {}, ...
    'visible', 'off');
title(S.ax_loading_cluster, 'Loading plot', 'fontsize', 15)
box(S.ax_loading_cluster, 'on')



%%%%%%%
% table
%%%%%%%
S.data_table = uitable(S.fg, 'units', 'pixels', ...
    'position', [35, 35, 930, 620]);
S.st_data_title = uicontrol('style', 'text', ...
    'units', 'pixels', ...
    'position', [35, 658, 930, 20], ...
    'string', 'Data', ...
    'fontsize', 15, ...
    'fontweight', 'bold', ...
    'visible', 'off');



%%%%%%%%%%%%%
% Process bar
%%%%%%%%%%%%%
S.et_process = uicontrol('style', 'edit', ...
    'units', 'pix', ...
    'position', [370, 685, 300, 30], ...
    'string', 'Process bar', ...
    'fontsize', 20, ...
    'ForegroundColor', 'red', ...
    'backgroundcolor', [1, 1, 1], ...
    'horizontalalign', 'center', ...
    'visible', 'off', ...
    'fontweight', 'bold');



%%%%%%%%%%%%%%%
% Action button
%%%%%%%%%%%%%%%
S.pb_action = uicontrol('style', 'pushbutton', ...
    'units', 'pix', ...
    'position', [370, 685, 300, 30], ...
    'string', 'Do PCA', ...
    'fontsize', 20, ...
    'ForegroundColor', 'red', ...
    'backgroundcolor', [0.7, 0.7, 0.7], ...
    'horizontalalign', 'center', ...
    'visible', 'on', ...
    'fontweight', 'bold');



%%%%%%%%%%%%%%%%%%%
% Setting functions
%%%%%%%%%%%%%%%%%%%

%%% The figure's callback for resume effect
set(S.fg, 'windowkeypressfcn', ...
    'uiresume(gcbf)') % To meet the function's characteristics, use gcbf.

%%% The action button's callback for analysis
set(S.pb_action, 'callback', {@pb_action_callback, S})





%% Nested Functions (callbacks) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pb_action_callback(~, ~, varargin)
        S = varargin{1};
        
        
        
        
        
        %% Action Button, PCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(get(S.pb_action, 'string'), 'Do PCA')
            
            
            
            %%%%%%%%%%%%%%%%%
            % Data processing
            %%%%%%%%%%%%%%%%%
            
            %%% GUI management
            set(S.pb_action, 'visible', 'off', 'enable', 'off')
            set(S.et_process, 'visible', 'on', ...
                'string', 'Binary & Continuous Only')
            set(S.st_data_title, 'visible', 'on')
            
            %%% Organizing original Data
            S.data = load('sample_data.mat');
            S.data = dataset2table(S.data.data);
            % Data to cell (for format consistency)
            S.data = [S.data.Gender, ... % Binary
                num2cell(S.data.Age), ... % Continuous
                num2cell(S.data.Height), ... % Continuous
                num2cell(S.data.ShoeSize), ... % Continuous
                S.data.FavDay, ... % Categorical
                num2cell(S.data.FavNum), ... % Continuous, but too random
                num2cell(S.data.CGames), ... % Continuous
                num2cell(S.data.Studying), ... % Continuous
                num2cell(S.data.Sleeping), ... % Continuous
                S.data.CourseInterest]; ... % Categorical
                
            %%% Setting display parameters
            S.colnames = {'Gender', ...
                'Age', ...
                'Height', ...
                'Shoesize', ...
                'Favorite Day', ...
                'Favorite Number', ...
                'Game Hours', ...
                'Studying Hours', ...
                'Sleeping Hours', ...
                'Course Interest'};
            colwidth = {930/10-5, 930/10-5, 930/10-5, ...
                930/10-5, 930/10-5, 930/10-5, 930/10-5, ...
                930/10-5, 930/10-5, 930/10-5};
            
            %%% Displaying the original Data
            set(S.data_table, 'data', ...
                S.data, ...
                'columnname', ...
                S.colnames, ...
                'columnwidth', ...
                colwidth)
            drawnow
            
            %%% Leaving only continuous & binary: gender
            % Female encoded as 1.
            S.data(strcmp(S.data(:, 1), 'TRUE'), 1) = {1};
            % Male encoded as 0.
            S.data(strcmp(S.data(:, 1), 'FALSE'), 1) = {0};
            % Then, display.
            set(S.data_table, 'data', S.data, ...
                'columnname', S.colnames, ...
                'columnwidth', colwidth)
            drawnow
            
            %%% Leaving only continuous & binary: Favorite Day
            % Kill categorical.
            S.data(:, 5) = {[]};
            % Then, display.
            set(S.data_table, 'data', S.data, ...
                'columnname', S.colnames, ...
                'columnwidth', colwidth)
            drawnow
            
            %%% Leaving only continuous & binary: Favorite Number
            % Kill categorical (can be seen as continuous though).
            S.data(:, 6) = {[]};
            % Then, display.
            set(S.data_table, 'data', S.data, ...
                'columnname', S.colnames, ...
                'columnwidth', colwidth)
            drawnow
            
            %%% Leaving only continuous & binary: Course Interest
            % Kill categorical.
            S.data(:, 10) = {[]};
            % Then, display.
            set(S.data_table, 'data', S.data, ...
                'columnname', S.colnames, ...
                'columnwidth', colwidth)
            drawnow
            
            %%% Do the same with the actual Data
            % Exclude categoricals, that is -5, -6, -10.
            S.data = S.data(:, [1, 2, 3, 4, 7, 8, 9]);
            % S.data to numerics
            S.data = cell2mat(S.data);
            
            %%% GUI management
            % PPT slide effect
            uiwait(S.fg)
            
            
            
            %%%%%%%%%%%
            % PCA: main
            %%%%%%%%%%%
            
            %%% GUI management
            set(S.et_process, 'string', 'PCA Processing...')
            set(S.ax_scree, 'visible', 'on')
            set(S.data_table, 'visible', 'off')
            set(S.st_data_title, 'visible', 'off')
            hold(S.ax_scree, 'on')
            title(S.ax_scree, 'PCA Processing...', 'fontsize', 15)
            
            %%% Do PCA.
            % Syntax: [coeff, score, latent, tsquared, explained, mu] = ...
            %          pca(data);
            % coeff; Loadings, eigenvectors of covariances matrix
            %        of the data (for variables comparision)
            % score; PC scores, representation of the data in PC space,
            %        scaled-data * coeff (for observations comparision)
            % latent; PC variances, eigenvalues of the covariances matrix
            %         of the data
            % explained; Amount of the data's variance explained by the PCs
            % latent & explained; cumsum(latent) / sum(latent) ==
            %                     cumsum(explained)
            [S.coeff, S.score, ~, ~, explained, ~] = pca(S.data);
    
            %%% Scree plot threshold
            thresh_hold = ...
                inputdlg('Put your Scree plot cut off point (e.g., 98).');
            thresh_hold = str2double(thresh_hold{1});
            title(S.ax_scree, ...
                sprintf('%s: %d%%', ...
                'Scree Plot with Threshold', ...
                thresh_hold))
            xlabel(S.ax_scree, 'Principal Component')
            ylabel(S.ax_scree, 'Variance Explained (%)')
            
            %%% Scree plot analysis
            % Dummy PC structure (all the PCs will be stacked here.)
            PC(length(explained)).selected = [];
            % Selecting the PCs by the scree plot analysis
            for cumulating = 1:length(explained)
                PC(cumulating).selected = bar(S.ax_scree, ...
                    cumulating, explained(cumulating), ...
                    'facecolor', 'b'); % Default PC color to blue
                % When the threshold is met, proceed.
                if  max(cumsum(explained(1:cumulating))) > thresh_hold
                    for select = 1:cumulating
                        set(PC(select).selected, ...
                            'facecolor', 'r') % Selected PC color to red
                    end
                    % Saving the PC's index for later use
                    S.how_many_pc = cumulating;
                    % Drawing cut off line
                    plot(S.ax_scree, ...
                        repmat(S.how_many_pc+1/2, 11, 1), ...
                        0:10:100, 'r-') % Max is always 100 (percentage).
                    % Texting cut off line
                    text(S.ax_scree, ...
                        S.how_many_pc+(1/2), 90, ...
                        sprintf('%s: %d', ...
                        'Cut off at PC', S.how_many_pc), ...
                        'fontsize', 10)
                    % Finally, disable the if statement,
                    % since we already extracted the PCs.
                    thresh_hold = 101;
                end
            end
            
            %%% GUI management
            % PPT slide effect
            uiwait(S.fg)
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%
            % PCA: score & loading
            %%%%%%%%%%%%%%%%%%%%%%
            
            %%% GUI management
            cla(S.ax_scree)
            set(S.ax_scree, 'visible', 'off')
            hold(S.ax_loading_cluster, 'off')
            hold(S.ax_score_cluster, 'off')
            set(S.ax_loading_cluster, 'visible', 'on')
            set(S.ax_score_cluster, 'visible', 'on')
            
            %%% score plot: 2D
            if S.how_many_pc == 2
                % Plotting
                plot(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), 'ro')
                % Texting
                text(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), ...
                    num2cell(1:length(S.data)), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 2D case
                set(S.ax_score_cluster, 'xtick', {}, 'ytick', {})
                % Labelling
                xlabel(S.ax_score_cluster, 'Score 1')
                ylabel(S.ax_score_cluster, 'Score 2')
                % Title
                title(S.ax_score_cluster, 'Score plot', 'fontsize', 15)                
                
                %%% Loading plot: 2D
                % Plotting
                plot(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), 'bo')
                % Texting
                text(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), ...
                    S.colnames([1, 2, 3, 4, 7, 8, 9]), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 2D case
                set(S.ax_loading_cluster, 'xtick', {}, 'ytick', {})                
                % Labelling
                xlabel(S.ax_loading_cluster, 'Loading 1')
                ylabel(S.ax_loading_cluster, 'Loading 2')
                % Title
                title(S.ax_loading_cluster, 'Loading plot', 'fontsize', 15)
                
                %%% Score plot: 3D
            elseif S.how_many_pc == 3
                % Plotting
                plot3(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), S.score(:, 3), 'ro')
                % Texting
                text(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), S.score(:, 3), ...
                    num2cell(1:length(S.data)), ...
                    'fontsize', 10)
                % GUI management for specific 3D case
                set(S.ax_score_cluster, ...
                    'xtick', {}, 'ytick', {}, 'ztick', {})                
                % Labelling
                xlabel(S.ax_score_cluster, 'Score 1')
                ylabel(S.ax_score_cluster, 'Score 2')
                zlabel(S.ax_score_cluster, 'Score 3')
                % View control 
                view(S.ax_score_cluster, ...
                    [max(S.score(:, 1)), ...
                    max(S.score(:, 2)), ...
                    max(S.score(:, 3)*1.5)])
                % Title
                title(S.ax_score_cluster, 'Score plot', 'fontsize', 15)
                
                %%% Loading plot: 3D
                % Plotting
                plot3(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), S.coeff(:, 3), 'bo')
                % Texting
                text(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), S.coeff(:, 3), ...
                    S.colnames([1, 2, 3, 4, 7, 8, 9]), ...
                    'fontsize', 10)
                % GUI management for specific 3D case
                set(S.ax_loading_cluster, ...
                    'xtick', {}, 'ytick', {}, 'ztick', {})                
                % Labelling
                xlabel(S.ax_loading_cluster, 'Loading 1')
                ylabel(S.ax_loading_cluster, 'Loading 2')
                zlabel(S.ax_loading_cluster, 'Loading 3')
                % View control 
                view(S.ax_loading_cluster, ...
                    [max(S.coeff(:, 1)), ...
                    max(S.coeff(:, 2)), ...
                    max(S.coeff(:, 3)*0.5)])
                % Title
                title(S.ax_loading_cluster, 'Loading plot', 'fontsize', 15)
                
                %%% Otherwise, escape after GUI management.
            else
                reset(S)
                return
            end
            
            %%% GUI management
            set(S.pb_action, 'string', 'Do Clustering')
            set(S.pb_action, 'visible', 'on')
            set(S.pb_action, 'enable', 'on')
            set(S.et_process, 'visible', 'off')
            % Updating S
            set(S.pb_action, 'callback', {@pb_action_callback, S})
            
            
            
            
            
            %% Action Button, Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(get(S.pb_action, 'string'), 'Do Clustering')
            S = varargin{1};
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Clustering: silhouette analysis
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% GUI management
            set(S.pb_action, 'visible', 'off')
            set(S.pb_action, 'enable', 'off')
            set(S.et_process, 'visible', 'on')
            set(S.et_process, 'string', 'Silhouette Analysis')
            cla(S.ax_loading_cluster)
            cla(S.ax_score_cluster)
            
            %%% Silhouette analysis: 2D
            % Maximum of five clusters will do.
            how_many_clusters = 5;
            if S.how_many_pc == 2
                % Dummies
                silhouette_holder_score = ...
                    zeros(size(S.score, 1), how_many_clusters-1);
                silhouette_holder_loading = ...
                    zeros(size(S.coeff, 1), how_many_clusters-1);
                % Silhouette ananlysis for each k
                for trial = 2:how_many_clusters
                    % Get cluster indices from k-means .
                    [cidx, ~] = ...
                        kmeans(S.score(:, 1:2), trial, ...
                        'distance', 'sqeuclidean', 'replicates', 10);
                    % Get silhouette measures for all points .
                    s = silhouette(S.score(:, 1:2), cidx, 'sqeuclidean');
                    % Save for later use .
                    silhouette_holder_score(:, trial-1) = s;
                    % Get cluster indices from k-means .
                    [cidx, ~] = ...
                        kmeans(S.coeff(:, 1:2), trial, ...
                        'distance', 'sqeuclidean', 'replicates', 10);
                    % Get silhouette measures for all points .
                    s = silhouette(S.coeff(:, 1:2), cidx, 'sqeuclidean');
                    % Save for later use .
                    silhouette_holder_loading(:, trial-1) = s;
                end
                
                %%% Silhouette analysis: 3D
            elseif S.how_many_pc == 3
                % Dummies
                silhouette_holder_score = ...
                    zeros(size(S.score, 1), how_many_clusters-1);
                silhouette_holder_loading = ...
                    zeros(size(S.coeff, 1), how_many_clusters-1);
                % Silhouette ananlysis for each k
                for trial = 2:how_many_clusters
                    % Get cluster indices from k-means .
                    [cidx, ~] = ...
                        kmeans(S.score(:, 1:3), trial, ...
                        'distance', 'sqeuclidean', 'replicates', 10);
                    % Get silhouette measures for all points .
                    s = silhouette(S.score(:, 1:3), cidx, 'sqeuclidean');
                    % Save for later use .
                    silhouette_holder_score(:, trial-1) = s;
                    % Get cluster indices from k-means .
                    [cidx, ~] = ...
                        kmeans(S.coeff(:, 1:3), trial, ...
                        'distance', 'sqeuclidean', 'replicates', 10);
                    % Get silhouette measures for all points .
                    s = silhouette(S.coeff(:, 1:3), cidx, 'sqeuclidean');
                    % Save for later use .
                    silhouette_holder_loading(:, trial-1) = s;
                end
                
                %%% Otherwise, escape after GUI management.
            else
                reset(S)
                return
            end
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Clustering: silhouette boxplot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% GUI management
            hold(S.ax_score_cluster, 'off')
            hold(S.ax_loading_cluster, 'off')
            
            %%% Plotting the silhouette values for all the 'k's .
            boxplot(S.ax_score_cluster, ...
                silhouette_holder_score, 'labels', ...
                2:how_many_clusters);
            % Labelling 
            xlabel(S.ax_score_cluster, 'Number of k')
            ylabel(S.ax_score_cluster, 'Silhouette Values')
            % Best k 
            [~, k_minus_one_score] = max(median(silhouette_holder_score));
            
            %%% Plotting the silhouette values for all the 'k's .
            boxplot(S.ax_loading_cluster, ...
                silhouette_holder_loading, ...
                'labels', 2:how_many_clusters);
            % Labelling 
            xlabel(S.ax_loading_cluster, 'Number of k')
            ylabel(S.ax_loading_cluster, 'Silhouette Values')
            % Best k 
            [~, k_minus_one_loading] = ...
                max(median(silhouette_holder_loading));
            
            %%% GUI management
            title(S.ax_score_cluster, ...
                'Score Silhouette', 'fontsize', 15)
            title(S.ax_loading_cluster, ...
                'Loading Silhouette', 'fontsize', 15)   
            set(S.ax_score_cluster, 'xtick', {}, 'ytick', {})
            set(S.ax_loading_cluster, 'xtick', {}, 'ytick', {})            
            % PPT slide effect
            uiwait(S.fg)
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Clustering: with optimal k
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%% GUI management
            set(S.et_process, 'string', 'Clustering...')
            % We have to reset the axes, since boxplot()
            % changed basic characteristics of the axes.
            hold(S.ax_score_cluster, 'off')
            hold(S.ax_loading_cluster, 'off')
            
            %%% Score clustering: 2D
            if S.how_many_pc == 2
                % Clustering 
                cidx_score = kmeans(S.score(:, 1:2), ...
                    k_minus_one_score+1, ...
                    'distance', 'sqeuclidean', 'replicates', 10);
                % Plotting 
                col = colormap('prism');
                for each_cluster = 1:k_minus_one_score+1
                    scatter(S.ax_score_cluster, ...
                        S.score((cidx_score == each_cluster), 1), ...
                        S.score((cidx_score == each_cluster), 2), ...
                        'MarkerFaceColor', col(each_cluster, :))
                    if each_cluster == 1
                        hold(S.ax_score_cluster, 'on')
                        set(S.ax_score_cluster, 'xtick', {}, 'ytick', {})
                        title(S.ax_score_cluster, ...
                            'Score Cluster', 'fontsize', 15)
                    end
                end
                % Texting 
                text(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), ...
                    num2cell(1:length(S.data)), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 2D case 
                set(S.ax_score_cluster, 'xtick', {}, 'ytick', {})
                % Labelling 
                xlabel(S.ax_score_cluster, 'Score 1')
                ylabel(S.ax_score_cluster, 'Score 2')
                % Legend 
                legend(S.ax_score_cluster, ...
                    strsplit([sprintf('Cluster: %d/', ...
                    1:k_minus_one_score), ...
                    sprintf('Cluster: %d', ...
                    k_minus_one_score+1)], '/'), ...
                    'location', 'northeast')
                
                %%% Loading clustering: 2D
                cidx_loading = kmeans(S.coeff(:, 1:2), ...
                    k_minus_one_loading+1, ...
                    'distance', 'sqeuclidean', 'replicates', 10);
                % Plotting 
                for each_cluster = 1:k_minus_one_loading+1
                    scatter(S.ax_loading_cluster, ...
                        S.coeff((cidx_loading == each_cluster), 1), ...
                        S.coeff((cidx_loading == each_cluster), 2), ...
                        'MarkerFaceColor', col(each_cluster, :))
                    if each_cluster == 1
                        hold(S.ax_loading_cluster, 'on')
                        set(S.ax_loading_cluster, 'xtick', {}, 'ytick', {})
                        title(S.ax_loading_cluster, ...
                            'Loading Cluster', 'fontsize', 15)
                    end
                end
                % Texting 
                text(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), ...
                    S.colnames([1, 2, 3, 4, 7, 8, 9]), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 2D case 
                set(S.ax_loading_cluster, 'xtick', {}, 'ytick', {})
                % Labelling 
                xlabel(S.ax_loading_cluster, 'Loading 1')
                ylabel(S.ax_loading_cluster, 'Loading 2')
                % Legend 
                legend(S.ax_loading_cluster, ...
                    strsplit([sprintf('Cluster: %d/', ...
                    1:k_minus_one_loading), ...
                    sprintf('Cluster: %d', ...
                    k_minus_one_loading+1)], '/'), ...
                    'location', 'northeast')
                
                %%% Score clustering: 3D
            elseif S.how_many_pc == 3
                % Clustering 
                cidx_score = kmeans(S.score(:, 1:3), ...
                    k_minus_one_score+1, ...
                    'distance', 'sqeuclidean', 'replicates', 10);
                % Plotting 
                col = colormap('prism');
                for each_cluster = 1:k_minus_one_score+1
                    plot3(S.ax_score_cluster, ...
                        S.score((cidx_score == each_cluster), 1), ...
                        S.score((cidx_score == each_cluster), 2), ...
                        S.score((cidx_score == each_cluster), 3), ...
                        'o', ...
                        'MarkerFaceColor', col(each_cluster, :))
                    if each_cluster == 1
                        hold(S.ax_score_cluster, 'on')
                        set(S.ax_score_cluster, 'xtick', {}, 'ytick', {})
                        title(S.ax_score_cluster, ...
                            'Score Cluster', 'fontsize', 15)
                    end
                end
                % Texting 
                text(S.ax_score_cluster, ...
                    S.score(:, 1), S.score(:, 2), S.score(:, 3), ...
                    num2cell(1:length(S.data)), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 3D case 
                set(S.ax_score_cluster, ...
                    'xtick', {}, 'ytick', {}, 'ztick', {})                
                % Labelling 
                xlabel(S.ax_score_cluster, 'Score 1')
                ylabel(S.ax_score_cluster, 'Score 2')
                zlabel(S.ax_score_cluster, 'Score 3')
                % View control 
                view(S.ax_score_cluster, ...
                    [max(S.score(:, 1)), ...
                    max(S.score(:, 2)), ...
                    max(S.score(:, 3)*1.5)])
                % Legend 
                legend(S.ax_score_cluster, ...
                    strsplit([sprintf('Cluster: %d/', ...
                    1:k_minus_one_score), ...
                    sprintf('Cluster: %d', ...
                    k_minus_one_score+1)], '/'), ...
                    'location', 'northeast')
                
                %%% Loading clustering: 3D
                cidx_loading = kmeans(S.coeff(:, 1:3), ...
                    k_minus_one_loading+1, ...
                    'distance', 'sqeuclidean', 'replicates', 10);
                % Plotting 
                for each_cluster = 1:k_minus_one_loading+1
                    plot3(S.ax_loading_cluster, ...
                        S.coeff((cidx_loading == each_cluster), 1), ...
                        S.coeff((cidx_loading == each_cluster), 2), ...
                        S.coeff((cidx_loading == each_cluster), 3), ...
                        'o', ...
                        'MarkerFaceColor', col(each_cluster, :))
                    if each_cluster == 1
                        hold(S.ax_loading_cluster, 'on')
                        set(S.ax_loading_cluster, 'xtick', {}, 'ytick', {})
                        title(S.ax_loading_cluster, ...
                            'Loading Cluster', 'fontsize', 15)
                    end
                end
                % Texting 
                text(S.ax_loading_cluster, ...
                    S.coeff(:, 1), S.coeff(:, 2), S.coeff(:, 3), ...
                    S.colnames([1, 2, 3, 4, 7, 8, 9]), ...
                    'verticalalignment', 'bottom', ...
                    'rotation', 45, ...
                    'fontsize', 10)
                % GUI management for specific 3D case 
                set(S.ax_loading_cluster, ...
                    'xtick', {}, 'ytick', {}, 'ztick', {})                                
                % Labelling 
                xlabel(S.ax_loading_cluster, 'Loading 1')
                ylabel(S.ax_loading_cluster, 'Loading 2')
                zlabel(S.ax_loading_cluster, 'Loading 3')
                % View control 
                view(S.ax_loading_cluster, ...
                    [max(S.coeff(:, 1)), ...
                    max(S.coeff(:, 2)), ...
                    max(S.coeff(:, 3)*0.5)])
                % Legend 
                legend(S.ax_loading_cluster, ...
                    strsplit([sprintf('Cluster: %d/', ...
                    1:k_minus_one_loading), ...
                    sprintf('Cluster: %d', ...
                    k_minus_one_loading+1)], '/'), ...
                    'location', 'northeast')
                
                %%% Otherwise, escape after GUI management.
            else
                reset(S)
                return
            end
            
            %%% GUI management
            set(S.et_process, 'visible', 'off')
            set(S.pb_action, 'string', 'Reset')
            set(S.pb_action, 'visible', 'on')
            set(S.pb_action, 'enable', 'on')
            
            
            
            
            
            %% Action Button, Resetting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(get(S.pb_action, 'string'), 'Reset')
            reset(S)
            return
        end
    end
end





%% Local Functions (not callbacks) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%
% Reset
%%%%%%%
function reset(S)

%%% Action button reset
set(S.pb_action, 'string', 'Do PCA')
set(S.pb_action, 'visible', 'on')
set(S.pb_action, 'enable', 'on')

%%% Process bar reset
set(S.et_process, 'string', 'Process bar')
set(S.et_process, 'visible', 'off')

%%% Data table reset
set(S.data_table, 'Data', [])
set(S.data_table, 'visible', 'on')
set(S.data_table, 'columnname', {})
set(S.st_data_title, 'string', 'Data')
set(S.st_data_title, 'visible', 'off')

%%% Axes reset
cla(S.ax_scree)
cla(S.ax_score_cluster)
cla(S.ax_loading_cluster)
set(S.ax_scree, 'visible', 'off')
set(S.ax_score_cluster, 'visible', 'off')
set(S.ax_loading_cluster, 'visible', 'off')
legend(S.ax_score_cluster, 'off')
legend(S.ax_loading_cluster, 'off')
end