function [ curr_id ] = find_neighbor_from_chip( grids, id_table, x, y )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%     curr_id_q = CQueue();
    temp = find(grids(x,:));
    if y==7
        temp = temp(:,find(temp >=3 & temp <=7 & temp~=y));
%             disp('here1');
%         disp(temp);
%             disp(id_table(grids(curr_x_2,temp),1));
    elseif y==8
        temp = temp(:,find(temp >=8 & temp <=12 & temp~=y));
%             disp('here2');
%         disp(temp);
    else
%             disp('here3');
        disp('error');
    end
    if isempty(temp)
        curr_id = -1;
        return;
    end
    
    curr_x_1 = x;
    curr_y_1 = temp;
    curr_id = grids(curr_x_1,temp);
    curr_type_id = id_table(curr_id,2);
%     if curr_type_id ~= 1
%         return;
%     end
    curr_x_2 = id_table(curr_id,6);
    curr_y_2 = id_table(curr_id,7);
    if (curr_y_2 == 14) || (curr_y_2 == 2)
%             curr_id_q.push('-');
        curr_id = '-';
    elseif (curr_y_2== 13) || (curr_y_2 == 1)
%             curr_id_q.push('+');
        curr_id = '+';
    elseif curr_type_id == 5 || curr_type_id == 6
%             curr_id_q.push('chip');
        curr_id = 'chip';
    end
end

