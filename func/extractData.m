function [ X, Y, Y_std, n_points_averaged ] = extractData( log_NET, ...
                                                           fields_to_fix, fixed_fields_values, ...
                                                           field_to_multi_plot, multi_plotted_field_values, ...
                                                           fields_to_average, averaged_fields_values, ...
                                                           field_to_study_x, field_to_study_y )
%EXTRACTDATA Extract interesting data from LOG_NET, and return it to be
%plotted
% 

% _-_-_-_-_-_ TODO _-_-_-_-_-_
%
% Pour pouvoir juger fix field optimizer, il faut regarder aussi en
% particulier si quand c'est 'costfunc', est-ce que on a le même 'outfunc',
% puisque la costfunc dépend de la outfunc.
%
% Si je concatene des log_NET issus de plusieurs mlp300, alors verifier
% qu'il y ai pas de doublon (tout critères sauf les err, le net etc. qui peuvent être
% aléa)
% Annoncer sur quelles fields on été fait la moyenne, car il se peut 
% qu'elle se fasse sur n_iter_max sans qu'on le veuille par exemple
%
% En plus de la variance, donner également les valeurs min et max de
% chaque points

log_NET = selectPoints(log_NET, fields_to_fix, fixed_fields_values);
log_NET = selectPoints(log_NET, fields_to_average, averaged_fields_values);
log_NET = selectPoints(log_NET, field_to_multi_plot, multi_plotted_field_values);

if ~isempty(field_to_multi_plot)
    X = cell(1, size(multi_plotted_field_values{1}, 2));
    Y = cell(1, size(multi_plotted_field_values{1}, 2));
    Y_std = cell(1, size(multi_plotted_field_values{1}, 2));
    n_points_averaged = cell(1, size(multi_plotted_field_values{1}, 2));
end

X_all = unique([log_NET.(field_to_study_x)]);
x_field_values = {log_NET.(field_to_study_x)};

for x = X_all   
    if isa(x, 'char')
        idxs_to_keep_x = find(strcmp(x_field_values, x));
    elseif isa(x, 'double')
        idxs_to_keep_x = find([x_field_values{:}] == x);
    else
        error("fields' values must be either double or char")
        return
    end
    
    field_to_multi_plot_values = {log_NET.(field_to_multi_plot{1})};
    
    for idx_multi_plot = 1 : size(multi_plotted_field_values{1}, 2)
        plot_field_value = multi_plotted_field_values{1}{idx_multi_plot};
        
        if isa(plot_field_value, 'char')
            idxs_to_keep_multi = find(strcmp(field_to_multi_plot_values, plot_field_value));
        elseif isa(plot_field_value, 'double')
            idxs_to_keep_multi = find([field_to_multi_plot_values{:}] == plot_field_value);
        else
            error("fields' values must be either double or char")
            return
        end
        
        idxs_to_keep = intersect(idxs_to_keep_x, idxs_to_keep_multi);
        
        if ~ isempty(idxs_to_keep)
            X{idx_multi_plot} = [X{idx_multi_plot} ; x];        
        
            y = [log_NET(idxs_to_keep).(field_to_study_y)];
            y_std = std(y, 1, 2);

            Y{idx_multi_plot} = [Y{idx_multi_plot} ; mean(y, 2)];        
            Y_std{idx_multi_plot} = [Y_std{idx_multi_plot} ; y_std];
            n_points_averaged{idx_multi_plot} = [n_points_averaged{idx_multi_plot} ; size(y, 2)];
        end
    end   
end


end

