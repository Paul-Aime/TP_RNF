% TP "Réseaux de Neurones Formels"
%  M2R CNA
%
% Apprentissage sur un réseau MLP pour la classification
%   Visualisation en fonction d'un seuil d'AUC

% Base P300 Speller

close all
clearvars -except log_NET
clc
disp(datetime)

addpath('.\func')

%%

seuils = linspace(0.7, 0.988, 200);

n_hidden_log = [log_NET.n_hidden];
n_sources_log = [log_NET.n_sources];
percent_learn_log = [log_NET.percent_learn];

means_n_hidden = [];
means_n_sources = [];
means_percent_learn = [];

mins_n_hidden = [];
mins_n_sources = [];
mins_percent_learn = [];

for seuil = seuils
    idxs_seuil = find([log_NET.test_err] >= seuil);
    
    n_hidden_seuil = n_hidden_log(idxs_seuil);
    n_sources_seuil = n_sources_log(idxs_seuil);
    percent_learn_seuil = percent_learn_log(idxs_seuil);
    
    means_n_hidden = [means_n_hidden mean(n_hidden_seuil)];
    means_n_sources = [means_n_sources mean(n_sources_seuil)];
    means_percent_learn = [means_percent_learn mean(percent_learn_seuil)];
    
    if seuil>0.986
        a = 1;
    end
    mins_n_hidden = [mins_n_hidden min(n_hidden_seuil)];
    mins_n_sources = [mins_n_sources min(n_sources_seuil)];
    mins_percent_learn = [mins_percent_learn min(percent_learn_seuil)];
end


figure('Name', "Nombre de source moyen et minimum en fonction d'un seuil d'auc")
    plot(seuils, mins_n_sources, 'r', 'LineWidth', 3)
    hold on
    plot(seuils, means_n_sources, 'b', 'LineWidth', 3)
    legend('Nombre de sources minimal', 'Nombre de sources moyen')
    xlabel("Seuil d'AUC")
    ylabel('Nombre de sources')
    
figure('Name', "Nombre de percent moyen et minimum en fonction d'un seuil d'auc")
    plot(seuils, mins_percent_learn, 'r', 'LineWidth', 3)
    hold on
    plot(seuils, means_percent_learn, 'b', 'LineWidth', 3)
    legend('Taille minimale de la BA (en %)', 'Taille de BA moyen')
    xlabel("Seuil d'AUC")
    ylabel('Taille de la BA (en %)')
    
% figure()
%     plot(seuils, means_percent_learn)
%     hold on
%     plot(seuils, mins_percent_learn)


% figure()
%     plot(seuils, means_n_hidden, 'b')
%     hold on
%     plot(seuils, mins_n_hidden, 'r')