function [ t ] = make_tree( grids, id_table )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if isempty(find(grids(:,2))) && isempty(find(grids(:,14)))
        error('wrong circuit: no output');
    end
    if isempty(find(grids(:,1))) && isempty(find(grids(:,13)))
        error('wrong circuit: no input');
    end

    t = tree('+');

    % find the + in, assume there is only one
    curr_x_1 = find(grids(:,1));
    curr_y_1 = 1;
    curr_id_queue_pre = grids(curr_x_1,curr_y_1);
    curr_id_queue = CQueue();
    for each=1:size(curr_id_queue_pre)
    end
    while ~isempty(curr_id_queue)
        
        % find first non wire item
        curr_id_queue = find_non_wire(grids, id_table, curr_id_queue);

        % build tree and mark visited
        for i =1:size(curr_id_queue,2)
            [t, node(i)] = t.addnode(1, curr_id_queue(i));
            % mark visited
            id_table(curr_id_queue(i),7) = 1;
        end
    end
    % for i = 1:size
    % end

    disp(t.tostring);
end

