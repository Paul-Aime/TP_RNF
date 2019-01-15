% TP "Réseaux de Neurones Formels"
%  M2R CNA
%
% Apprentissage sur un réseau MLP pour la classification
%   Visualisation pour étude des résultats

% Base P300 Speller

close all
clearvars -except log_NET
clc
disp(datetime)

addpath('.\func')

%% Load database

already_load = 0;

if ~already_load
    load('log_NET_17600.mat')
end

%% Fig. 1 - AUC en fonction de n_hidden, pour 1 à 4 sources

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'};

field_to_multi_plot = {'n_sources'};
multi_plotted_field_values = {{1, 2, 3, 4}};

fields_to_average = {'idx_subject', 'percent_learn'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, ...
                           {20, 30, 40, 50, 60}};

field_to_study_x = 'n_hidden';
field_to_study_y = 'test_err';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);

figure('Name', 'AUC en fonction de nhidden, pour 1 à 4 sources')
    for i = 1:size(Y, 2)
        errorbar(X{i}, Y{i}, Y_std{i}.^2)
%         text(X{i}, Y{i}, num2str(n_points{i}), 'FontSize', 8)
        hold on
    end
    xlabel('Nombre de neurones sur la couche cachée')
    ylabel('Area under ROC curve (AUC)')
    legends = {'1 source', '2 sources', '3 sources', '4 sources'};
    legend(legends)
    
%% Fig. 2 - AUC en fonction du nombre de sources, pour 1, 5, 10, 15, 20 neurones sur la couche cachée

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'n_hidden'};
multi_plotted_field_values = {{1, 5, 10, 15, 20}};

fields_to_average = {'idx_subject', 'percent_learn'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, ...
                           {20, 40, 50, 60}};

field_to_study_x = 'n_sources';
field_to_study_y = 'test_err';

[X, Y, Y_std] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "AUC en fonction du nombre de sources, pour 1, 5, 10, 15, 20 neurones sur la couche cachée")
    for i = 1:size(Y, 2)
        errorbar(X{i}, Y{i}, Y_std{i}.^2)
        hold on
    end
    xlabel("Nombre de sources")
    ylabel('Area under ROC curve (AUC)')
    legends = {'n_{hidden} = 1', 'n_{hidden} = 5', 'n_{hidden} = 10', 'n_{hidden} = 15', 'n_{hidden} = 20'};
    legend(legends)
    
%% Fig. 3 - AUC en fonction du nombre d'exemples, pour 1 à 4 sources

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'n_sources'};
multi_plotted_field_values = {{1, 2, 3, 4}};

fields_to_average = {'idx_subject'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}};

field_to_study_x = 'percent_learn';
field_to_study_y = 'test_err';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "AUC en fonction du nombre d'exemples, pour 1 à 4 sources")
    X_tot = [];
    Y_tot = [];
    for i = 1:size(Y, 2)
        X_tot = [X{i} X_tot];
        Y_tot = [Y{i} Y_tot];
        errorbar(X{i}, Y{i}, Y_std{i}.^2)
%         text(X{i}, Y{i}, num2str(n_points{i}), 'FontSize', 8)
        hold on
    end
    plot(mean(X_tot, 2), mean(Y_tot, 2), 'g:', 'LineWidth', 2)
    xlabel("Taille de la base d'apprentissage (en %)")
    ylabel('Area under ROC curve (AUC)')
    legends = {'1 source', '2 sources', '3 sources', '4 sources', 'Moyenne'};
    legend(legends)
    ax = gca;
    ax.XTick = X{i};
    grid on
    
%% Fig. 4 - AUC en fonction de l'individu, pour 1 à 4 sources

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc', 'percent_learn'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic', 60}; 

field_to_multi_plot = {'n_sources'};
multi_plotted_field_values = {{1, 2, 3, 4}};

fields_to_average = {'n_hidden'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}};

field_to_study_x = 'idx_subject';
field_to_study_y = 'test_err';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "AUC en fonction de l'individu, pour 1 à 4 sources")
    Y_tmp = [];
    for i = 1:size(Y, 2)
        Y_tmp = [Y_tmp Y{i}];
    end
    bar(Y_tmp)
    ax = gca;
    ax.XTick = 1:20;
    xlabel("Identifiant de l'individu")
    ylabel('Area under ROC curve (AUC)')
    legends = {'1 source', '2 sources', '3 sources', '4 sources'};
    legend(legends)
    
%% Fig. 5 - AUC en fonction du nombre de neurones cachés, pour différentes tailles de BA

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'percent_learn'};
multi_plotted_field_values = {{0.4, 1, 2, 4, 6, 10, 20, 30, 40, 50, 60}};

fields_to_average = {'idx_subject'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}};

field_to_study_x = 'n_hidden';
field_to_study_y = 'test_err';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "AUC en fonction du nombre d'exemples, pour 1 à 4 sources")
    for i = 1:size(Y, 2)
        errorbar(X{i}, Y{i}, Y_std{i}.^2)
%         text(X{i}, Y{i}, num2str(n_points{i}), 'FontSize', 8)
        hold on
    end
    xlabel("Nombre de neurones sur la couche caché")
    ylabel('Area under ROC curve (AUC)')
    legends = {'0.4', '1', '2', '4', '6', '10', '20', '30', '40', '50', '60'};
    legend(legends)
    
%% Fig. 6 - AUC en fonction du nombre d'itérations, pour 1 à 4 sources

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'n_sources'};
multi_plotted_field_values = {{1, 2, 3, 4}};

fields_to_average = {'idx_subject', 'percent_learn'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, ...
                          {30, 40, 50, 60}};

field_to_study_x = 'validation_num_iter';
field_to_study_y = 'test_err';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "AUC en fonction du nombre d'itérations, pour 1 à 4 sources")
    for i = 1:size(Y, 2)
        errorbar(X{i}, Y{i}, Y_std{i}.^2)
%         text(X{i}, Y{i}, num2str(n_points{i}), 'FontSize', 8)
        hold on
    end
    xlabel("Nombre d'itérations avant arrêt de l'apprentissage")
    ylabel('Area under ROC curve (AUC)')
    legends = {'1 source', '2 sources', '3 sources', '4 sources'};
    legend(legends)
    
%% Fig. 7 - Nombre d'itérations avant arrêt de l'apprentissage en fonction du nombre de sources

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'CR'};       % Astuce pour pas bugger dans extactData
multi_plotted_field_values = {{1}}; % TODO corriger ça

fields_to_average = {'idx_subject', 'percent_learn'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}, ...
                          {10, 20, 30, 40, 50, 60}};

field_to_study_x = 'n_sources';
field_to_study_y = 'validation_num_iter';

[X, Y, Y_std] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "Nombre d'itérations avant arrêt de l'apprentissage en fonction du nombre de sources")
    legends = {};
    for i = 1:size(Y, 2)
        errorbar(X{i}, Y{i}, Y_std{i})
%         plot(X{i}, Y{i})
        hold on
    end
    xlabel('Nombre de sources')
    ylabel("Nombre d'itérations avant arrêt de l'apprentissage")
    
%% Fig. 8 - Nombre d'itérations avant arrêt de l'apprentissage en fonction du nombre d'exemples

fields_to_fix = {'CR', 'optimizer', 'type_err', 'n_output', 'outfunc'};
fixed_fields_values = {1, 'graddesc', 'auc', 1, 'logistic'}; 

field_to_multi_plot = {'n_sources'};
multi_plotted_field_values = {{1, 2, 3, 4}};

fields_to_average = {'idx_subject'};
averaged_fields_values = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}};

field_to_study_x = 'percent_learn';
field_to_study_y = 'validation_num_iter';

[X, Y, Y_std, n_points] = extractData(log_NET, ...
                            fields_to_fix, fixed_fields_values, ...
                            field_to_multi_plot, multi_plotted_field_values, ...
                            fields_to_average, averaged_fields_values, ...
                            field_to_study_x, field_to_study_y);
                            
figure('Name', "Nombre d'itérations avant arrêt de l'apprentissage en fonction du nombre d'exemples")
    legends = {};
    for i = 1:size(Y, 2)
%         plot(X{i}, Y{i})
        errorbar(X{i}, Y{i}, Y_std{i})
%         text(X{i}, Y{i}, num2str(n_points{i}), 'FontSize', 8)        
        hold on
    end
    xlabel("Taille de la base d'apprentissage (en %)")
    ylabel("Nombre d'itérations avant arrêt de l'apprentissage")
    legends = {'1 source', '2 sources', '3 sources', '4 sources'};
    legend(legends)

%%

clearvars -except log_NET