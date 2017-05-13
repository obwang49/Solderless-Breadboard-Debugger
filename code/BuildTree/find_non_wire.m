function [ curr_id ] = find_non_wire( grids, id_table, curr_id, pin_x, pin_y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    if pin_x == id_table(curr_id,4)
        flag = 1;
    else
        flag = 0;
    end
    if id_table(curr_id,3)==1
        if flag
            curr_x_1 = id_table(curr_id, 4);
            curr_y_1 = id_table(curr_id, 5);
            curr_x_2 = id_table(curr_id,6);
            curr_y_2 = id_table(curr_id,7);
        else
            curr_x_2 = id_table(curr_id, 4);
            curr_y_2 = id_table(curr_id, 5);
            curr_x_1 = id_table(curr_id,6);
            curr_y_1 = id_table(curr_id,7);
        end
        curr_type_id = id_table(curr_id, 2);
        if (curr_y_2 == 14) || (curr_y_2 == 2)
            curr_id = '-';
            return;
        elseif (curr_y_2== 13) || (curr_y_2 == 1)
            curr_id = '+';
            return;
        elseif curr_type_id == 5 || curr_type_id == 6
            curr_id = 'chip';
            return;
        end
        temp = find(grids(curr_x_2,:));
        if curr_y_2>=3 && curr_y_2<=7
            temp = temp(:,find(temp >=3 & temp <=7 & temp~=curr_y_1 & temp~=curr_y_2));
%             disp(id_table(grids(curr_x_2,temp),1));
        elseif curr_y_2>=8 && curr_y_2<=12
            temp = temp(:,find(temp >=8 & temp <=12 & temp~=curr_y_1 & temp~=curr_y_2));
        else
            disp('error');
            return;
        end
        curr_x_1 = curr_x_2;
        curr_y_1 = temp;
        curr_id = grids(curr_x_2,temp);
    else
        if flag
            curr_x_1 = id_table(curr_id, 4);
            curr_y_1 = id_table(curr_id, 5);
        else
            curr_x_1 = id_table(curr_id, 6);
            curr_y_1 = id_table(curr_id, 7);
        end
    end
    while 1
        if flag
            curr_x_2 = id_table(curr_id,6);
            curr_y_2 = id_table(curr_id,7);
        else
            curr_x_2 = id_table(curr_id,4);
            curr_y_2 = id_table(curr_id,5);
        end
        curr_type_id = id_table(grids(curr_x_2,curr_y_2),2);
        if (curr_y_2 == 14) || (curr_y_2 == 2)
            curr_id = '-';
            break;
        elseif (curr_y_2== 13) || (curr_y_2 == 1)
            curr_id = '+';
            break;
        elseif curr_type_id == 5 || curr_type_id == 6
            curr_id = 'chip';
            break;
        end
        if curr_type_id~=1
            break;
        end
        
        temp = find(grids(curr_x_2,:));
        if curr_y_2>=3 && curr_y_2<=7
%             temp = temp(:,find(temp >=3 & temp <=7 & temp~=curr_y_1 & temp~=curr_y_2));
            temp = temp(:,find(temp >=3 & temp <=7 & temp~=curr_y_2));
%             disp(id_table(grids(curr_x_2,temp),1));
        elseif curr_y_2>=8 && curr_y_2<=12
%             temp = temp(:,find(temp >=8 & temp <=12 & temp~=curr_y_1 & temp~=curr_y_2));
            temp = temp(:,find(temp >=8 & temp <=12 & temp~=curr_y_2));
        else
            disp('error');
            break;
        end
        curr_x_1 = curr_x_2;
        curr_y_1 = temp;
        curr_id = grids(curr_x_2,temp);
        curr_type_id = id_table(curr_id,2);
    end
end

