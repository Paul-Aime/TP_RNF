function [ log_NET ] = selectPoints( log_NET, fields, fields_values )
%SELECTPOINTS Select points from LOG_NET, given FIELDS_VALUES condition for
%FIELDS of LOG_NET

for idx_fix = 1 : size(fields, 2)
    curr_fix_name = fields{idx_fix};
    curr_field_values = {log_NET.(curr_fix_name)};
    
    idxs_to_keep = [];
    
    if iscell(fields_values{idx_fix}) % i.e. it's the fixed field with multiple values allowed, for multiple plots
        
        for idx_fix_value = 1 : size(fields_values{idx_fix}, 2)
            curr_fix_value = fields_values{idx_fix}{idx_fix_value};
            
            if isa(curr_fix_value, 'char')
                idxs_to_keep = [idxs_to_keep find(strcmp(curr_field_values, 'logistic'));];
            elseif isa(curr_fix_value, 'double')
                idxs_to_keep = [idxs_to_keep find([curr_field_values{:}] == curr_fix_value)];
            else
                error("fields' values must be either double or char")
                return
            end
        end
        idxs_to_keep = unique(idxs_to_keep);
        
    else
        curr_fix_value = fields_values{idx_fix};
        if isa(curr_fix_value, 'char')
            idxs_to_keep = [idxs_to_keep find(strcmp(curr_field_values, curr_fix_value));];
        elseif isa(curr_fix_value, 'double')
            idxs_to_keep = [idxs_to_keep find([curr_field_values{:}] == curr_fix_value)];
        else
            error("fields' values must be either double or char")
            return
        end
    end
    
    log_NET = log_NET(idxs_to_keep);
end % end on testing point interest


end

