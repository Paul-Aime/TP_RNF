% TP "Réseaux de Neurones Formels"
%  M2R CNA
%
% Apprentissage sur un réseau MLP pour la classification

% Base P300 Speller

close all
clear
clc
disp(datetime)

addpath('.\Netlab')
addpath('.\P300')
addpath('.\func')

dir_data_path = 'P300\long';

save_log_NET = 0;

%% Configuration

% Paramètres d'étude principaux
n_sources_tab = [1 4];                     % assert(max(n_sources_tab) <= 4)
n_hidden_tab = [1 2 5 10 20];              % Différentes tailles pour la couche cachée
idx_subjects = 14;                         % assert(max(idx_subjects) <= 20))
percentS_learn_valid_test = {[60 30 10]};  % assert(sum == 100)
% percentS_learn_valid_test = [[60 30 10] ; ...
%                              [50 25 25] ; ...
%                              [40 20 40] ; ...
%                              [30 15 55] ; ...
%                              [20 10 70] ; ...
%                              [10 5 85] ; ...
%                              [6 3 91] ; ...
%                              [4 2 94] ; ...
%                              [2 1 97] ; ...
%                              [1 0.5 98.5] ; ...
%                              [0.4 0.2 99.4] ]';

% Paramètres d'étude secondaires
optimizer = 'graddesc';       % 'conjgrad', 'scg', 'graddesc'
type_err = 'auc';             % Stop criteria : 'auc', 'costfunc'
n_output_neurons = 1;         % 1, 2
if n_output_neurons == 1
    outfunc = 'logistic';     % 'logistic', 'linear'
elseif n_output_neurons == 2
    outfunc = 'softmax';      % 'softmax', 'logistic', 'linear'
end

% Paramètres à fixer
n_iter_max = 100;
delta_iter_valid = 5;   % Intervalle entre deux validations
flag_CR = 1;            % Données centrées réduites (1) ou non (0)

% Paramètres d'affichage
disp_learning_curves = 1;
% disp_roc = 0; % TODO
% disp_conf_mat = 0; % TODO
          
RGB_colors = {[0,      0.4470, 0.7410], ...
              [0.8500, 0.3250, 0.0980], ...
              [0.4660, 0.6740, 0.1880], ...
              [0.4940, 0.1840, 0.5560], ...
              [0.9290, 0.6940, 0.1250], ...
              [0.3010, 0.7450, 0.9330] };
          
%% Strcuture de savegarde des données
cnt_save = 0;

log_NET = struct('CR', {}, ...
                 'idx_subject', {}, ...   
                 'n_sources', {}, ...
                 'percent_learn', {}, ...
                 'percent_valid', {}, ...
                 'percent_test', {}, ...
                 'net', {}, ...
                 'n_hidden', {}, ...
                 'n_output', {}, ...
                 'outfunc', {}, ...
                 'optimizer', {}, ...
                 'type_err', {}, ...
                 'n_iter_max', {}, ...
                 'validation_num_iter', {}, ...
                 'validation_err', {}, ...
                 'test_err', {}  );

%% Main loops

for idx_per = size(percentS_learn_valid_test, 2)
    percent_learn_valid_test = percentS_learn_valid_test{idx_per};
    
    for idx_subject = idx_subjects
        if disp_learning_curves
            fig_handle = figure(idx_subject);
            [subplot_dim1, subplot_dim2] = subplotDim(size(n_sources_tab, 2));
            set(fig_handle, 'Name', ['Subject ' num2str(idx_subject)], 'NumberTitle', 'off')
        end

        cnt_source = 0; % Juste pour l'indice de subplot
        for n_source = n_sources_tab
            cnt_source = cnt_source + 1;
            cnt_plot = 0;
            p = []; % plot's handle
            legends = {};

            % ----------------------------------
            % Chargement de la base de données, répartition en Learn, Valid et Test
            % ----------------------------------
            [data, class, n_data] = fLoadP300DataSet(dir_data_path, idx_subject, n_source, percent_learn_valid_test, flag_CR);

            if n_output_neurons == 1
               class.Learn = class.Learn(:, 1);
               class.Valid = class.Valid(:, 1);
               class.Test  = class.Test(:, 1);
            end

            for idx_hidden = 1 : size(n_hidden_tab, 2)
                n_hidden = n_hidden_tab(idx_hidden);
                if (disp_learning_curves) RGB_color = RGB_colors{idx_hidden}; end

                %-------------------------
                % Création et initialisation du MLP
                %-------------------------
                net = mlp(size(data.Learn, 2), n_hidden, n_output_neurons, outfunc, 0);

                options     = zeros(1,18);  
                options(1)  = -1;           % This provides or nor display of error values.
                options(2)  = -1;           % Stopping criterion of the weights gradient
                options(3)  = -1;           % Stopping criterion of the error gradient
                options(14) = 1;            % Number of training cycles. assert(options(14)==1)
                options(17) = 0.6;          % Momentum.       
                options(18) = 0.001;        % Learning rate.        

                err_learn_tot = [];
                err_valid_tot = [];
                resnet = [];

                %-------------------------
                % Apprentissage et validation
                %-------------------------
                cnt_iter = 0;
                for i = 1 : round(n_iter_max / delta_iter_valid)
                    for j = 1 : delta_iter_valid
                        cnt_iter = cnt_iter + 1;

                        % Apprentissage
                        [net, options] = netopt(net, options, data.Learn, class.Learn, optimizer);

                        err_learn = computeErr(net, data.Learn, class.Learn, type_err);
                        err_learn_tot = [err_learn_tot err_learn];
                    end
                    clear j

                    resnet = [resnet net];

                    % Erreur de validation durant l'apprentissage
                    err_valid = computeErr(net, data.Valid, class.Valid, type_err);
                    err_valid_tot = [err_valid_tot err_valid];

                    % Affichage des profils d'erreur d'apprentissage et de validation
                    if disp_learning_curves
                        figure(idx_subject)
                            subplot(subplot_dim1, subplot_dim2, cnt_source)
                            title([num2str(n_source) ' sources'])
                                cnt_plot = cnt_plot + 1;
                                p(cnt_plot) = plot(err_learn_tot, '-', 'Color', RGB_color);
                                    legends = [legends, 'noLegend'];
                                    hold on
                                cnt_plot = cnt_plot + 1;
                                p(cnt_plot) = plot(cnt_iter, err_valid, 'x', 'Color', RGB_color);
                                    legends = [legends, 'noLegend'];
                                drawnow
                    end
                end
                clear i

                %-------------------------
                % Récupération du paramétrage "optimal" du réseau
                %-------------------------
                if strcmp(type_err, 'auc')
                    [err_valid_best, idx_best] = max(err_valid_tot);
                elseif strcmp(type_err, 'costfunc')
                    [err_valid_best, idx_best] = min(err_valid_tot);
                end

                net_end = resnet(idx_best);
                idx_best = idx_best * delta_iter_valid;

                % S'assurer que l'on récupère le bon état du net
                err_tmp = computeErr(net_end, data.Valid, class.Valid, type_err);
                if strcmp(type_err, 'costfunc')
                    if min(err_valid_tot) ~= err_tmp
                        disp('Problème de récupération du net optimal')
                        return
                    end
                elseif strcmp(type_err, 'auc')
                    if max(err_valid_tot) ~= err_tmp
                        disp('Problème de récupération du net optimal')
                        return
                    end
                end
                clear err_tmp

                %-------------------------
                % Evaluation sur la base de test
                %-------------------------            
                err_test = computeErr(net_end, data.Test, class.Test, type_err);
                if disp_learning_curves
                    cnt_plot = cnt_plot + 1;
                        p(cnt_plot) = plot(idx_best, err_test, '.', 'Color', RGB_color, 'MarkerSize', 30);
                        legends = [legends ['nbHidden  = ' num2str(n_hidden_tab(idx_hidden)) ' | Test = ' num2str(err_test, '%.3f')] ];
                end

            %-------------------------
            % Sauvegarde des données
            %-------------------------
            cnt_save = cnt_save + 1;
            if mod(cnt_save, 100) == 0 % Affichage de la progression
                disp(cnt_save)
            end

            log_NET(cnt_save).CR = flag_CR;
            log_NET(cnt_save).idx_subject = idx_subject;
            log_NET(cnt_save).n_sources = n_source;
            log_NET(cnt_save).percent_learn = percent_learn_valid_test(1);
            log_NET(cnt_save).percent_valid = percent_learn_valid_test(2);
            log_NET(cnt_save).percent_test = percent_learn_valid_test(3);
            log_NET(cnt_save).net = net_end;
            log_NET(cnt_save).n_hidden = net_end.nhidden;
            log_NET(cnt_save).n_output = net_end.nout;
            log_NET(cnt_save).outfunc = net_end.outfn;
            log_NET(cnt_save).optimizer = optimizer;
            log_NET(cnt_save).type_err = type_err;
            log_NET(cnt_save).n_iter_max = n_iter_max;
            log_NET(cnt_save).validation_num_iter = idx_best;
            log_NET(cnt_save).validation_err = err_valid_best;
            log_NET(cnt_save).test_err = err_test;




            end %end loop on n_hidden
            clear err_learn err_valid err_test
            clear idx_best
            clear n_hidden idx_hidden cnt_iter
            clear err_learn_tot err_valid_tot
            clear RGB_color
    %         clear net resnet

            if disp_learning_curves
                [p, legends] = formatLegends(p, legends, 'noLegend');
                lgd = legend(p, legends);
                if strcmp(type_err, 'auc') location = 'southeast'; else location = 'northeast'; end
                set(lgd, 'Location', location)
                xlabel("Iterations")
                ylabel("Area under ROC curve (AUC)")
            end

%             if disp_roc
%                 scores = mlpfwd(net, data.Test);
%                 [X, Y, ~, ~] = perfcurve(class.Test, scores, 1);
%                 figure(100)
%                 plot(X,Y)
%                 hold on
%             end

            clear lgd location legends cnt_plot
        end %end loop on idx_source
        clear cnt_source n_source p
    end %end loop on idx_subject
    clear idx_subject 
    clear fig_handle subplot_dim1 subplot_dim2
end %end loop on percent_learn_valid_test

clear RGB_colors


if save_log_NET
    save(['log_NET_' datestr(datetime, 'mm-dd_HH-MM-SS') '.mat'], 'log_NET')
end
