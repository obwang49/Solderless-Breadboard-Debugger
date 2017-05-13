function [ grids ] = make_circuit( grids, obj, id, id_table)
% make_circuit Summary of this function goes here
%   Detailed explanation goes here
    if id_table(id,2) == 5
        for i = 0:2:15
%             disp(i);
            grids(id_table(id, 4+i), id_table(id, 5+i)) = id;
        end
    elseif id_table(id,2) == 6
        for i = 0:2:31
%             disp(i);
            grids(id_table(id, 4+i), id_table(id, 5+i)) = id;
        end
    else
        grids(obj(:,2),obj(:,3)) = id;
        grids(obj(:,4),obj(:,5)) = id;
    end
end