clear;
clc;
addpath(genpath('./tinevez-matlab-tree-3d13d15/'));
addpath(genpath('./datastructure'));
load('elements.mat');
%% initialization grids and id_table
grids = zeros(35, 14);
id = 1;
id_table = zeros(10,35);

% 1 - wire, 2 - resistor1, 3 - resistor2, 
% 4 - inductor, 5 - chip8, 6 - chip16

% chip8
chip = [6,7;7,7;8,7;9,7;9,8;8,8;7,8;6,8];
id_table(id,1) = id;
id_table(id,2) = 5;
id_table(id,3) = 0;
id_table(id,4) = chip(1,1);
id_table(id,5) = chip(1,2);
id_table(id,6) = chip(2,1);
id_table(id,7) = chip(2,2);
id_table(id,8) = chip(3,1);
id_table(id,9) = chip(3,2);
id_table(id,10) = chip(4,1);
id_table(id,11) = chip(4,2);
id_table(id,12) = chip(5,1);
id_table(id,13) = chip(5,2);
id_table(id,14) = chip(6,1);
id_table(id,15) = chip(6,2);
id_table(id,16) = chip(7,1);
id_table(id,17) = chip(7,2);
id_table(id,18) = chip(8,1);
id_table(id,19) = chip(8,2);
grids = make_circuit(grids, chip, id, id_table);
id=id+1;

% % chip16
chip = [16,7; 17,7; 18,7; 19,7; 20,7; 21,7; 22,7;23,7;...
    23, 8; 22,8; 21,8; 20,8; 19,8; 18,8; 17,8; 16,8];
id_table(id,1) = id;
id_table(id,2) = 6;
id_table(id,3) = 0;
id_table(id,4) = chip(1,1);
id_table(id,5) = chip(1,2);
id_table(id,6) = chip(2,1);
id_table(id,7) = chip(2,2);
id_table(id,8) = chip(3,1);
id_table(id,9) = chip(3,2);
id_table(id,10) = chip(4,1);
id_table(id,11) = chip(4,2);
id_table(id,12) = chip(5,1);
id_table(id,13) = chip(5,2);
id_table(id,14) = chip(6,1);
id_table(id,15) = chip(6,2);
id_table(id,16) = chip(7,1);
id_table(id,17) = chip(7,2);
id_table(id,18) = chip(8,1);
id_table(id,19) = chip(8,2);
id_table(id,20) = chip(9,1);
id_table(id,21) = chip(9,2);
id_table(id,22) = chip(10,1);
id_table(id,23) = chip(10,2);
id_table(id,24) = chip(11,1);
id_table(id,25) = chip(11,2);
id_table(id,26) = chip(12,1);
id_table(id,27) = chip(12,2);
id_table(id,28) = chip(13,1);
id_table(id,29) = chip(13,2);
id_table(id,30) = chip(14,1);
id_table(id,31) = chip(14,2);
id_table(id,32) = chip(15,1);
id_table(id,33) = chip(15,2);
id_table(id,34) = chip(16,1);
id_table(id,35) = chip(16,2);
grids = make_circuit(grids, chip, id, id_table);
id=id+1;



% red wire pin 1
object = [1, 6, 5, 5, 1];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% resistor pin 3
object = [2, 8, 4, 11, 4];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% red wire pin 3
object = [1, 11, 3, 13, 1];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% resistor pin 4
object = [2, 9, 6, 12, 6];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% purple wire pin 4
object = [1, 12, 7, 16, 3];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% resistor pin 6
object = [2, 8, 11, 11, 11];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% wire pin 6
object = [1, 11, 9, 20, 9];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;

% black wire pin 8
object = [1, 6, 10, 7, 14];
id_table(id,1) = id;
id_table(id,2) = object(1);
id_table(id,3) = 0;
id_table(id,4) = object(2);
id_table(id,5) = object(3);
id_table(id,6) = object(4);
id_table(id,7) = object(5);
grids = make_circuit(grids, object, id, id_table);
id=id+1;


%% make tree from grids and id_table
% make_tree(grids, id_table);
    if isempty(find(grids(:,2))) && isempty(find(grids(:,14)))
        error('wrong circuit: no output');
    end
    if isempty(find(grids(:,1))) && isempty(find(grids(:,13)))
        error('wrong circuit: no input');
    end

    % find tree root nodes from chips
    chip_in = find(grids(:,7));
    chip_in = grids(chip_in,7);
    count = 0;
    curr_idd = chip_in(1,:);
    tree_list = CQueue();
    for each=1:size(chip_in,1)
        if chip_in(each,:)==curr_idd
            count=count+1;
%             disp(count);
        else
%             disp(count);
            if count==4 || count==8
                tree_list.push(chip_in(each-1,:));
%                 disp(tree_list.content());
            end
            curr_idd = chip_in(each,:);
            count = 1;
        end
    end
    % for final point
    if count==4 || count==8
        tree_list.push(chip_in(each-1,:));
%         disp(tree_list.content());
    end
    
    tree_num = tree_list.size();
    % for each root, create a tree
    for each=1:tree_num
        t(each) = tree(tree_list.front());
        tree_list.pop();
    end
%     disp(tree_list.content());

%     for each_tree=1:tree_num
    for each_tree=1:tree_num
        for erase = 1:size(id_table,1)
            id_table(erase,3)=0;
        end
        % find the tree
        curr_tree = t(each_tree); 
        
        curr_row = id_table(curr_tree.Node{1},:);
        if curr_row(2) == 5
            for j = 0:7
                curr_id_queue_pre(j+1,:) = curr_row(:,(4+2*j):(5+2*j));
            end
        elseif curr_row(2) == 6
            for j = 0:15
                curr_id_queue_pre(j+1,:) = curr_row(:,(4+2*j):(5+2*j));
            end
        end
        
        curr_id_queue = CQueue();
        
        for each_pin=1:size(curr_id_queue_pre,1)
            disp(['pin', num2str(each_pin)]);
            node_id = 1;
            curr_id_queue_temp = find_neighbor_from_chip(grids, id_table, curr_id_queue_pre(each_pin, 1), curr_id_queue_pre(each_pin, 2));
            for each_node=1:size(curr_id_queue_temp)
                curr_id_queue.push(curr_id_queue_temp(each_node));
            end
            while ~isempty(curr_id_queue)
                curr_id = curr_id_queue.front();
                curr_id_queue.pop();
                if curr_id == '-'
                    [curr_tree, node] = curr_tree.addnode(node_id, curr_id);
                    node_id = node_id+1;
                    disp(curr_tree.tostring());
                    break;
                elseif curr_id == '+'
                    [curr_tree, node] = curr_tree.addnode(node_id, curr_id);
                    node_id = node_id+1;
                    disp(curr_tree.tostring());
                    break;
                elseif curr_id == 'chip'
                    [curr_tree, node] = curr_tree.addnode(node_id, curr_id);
                    node_id = node_id+1;
                    disp(curr_tree.tostring());
                    break;
                elseif curr_id == -1
                    break;
                end
                
        %         if id_table(curr_id)
        %         tree_n_idx = node()
                % find first non wire item
                curr_id_queue_temp = find_non_wire(grids, id_table, curr_id, curr_id_queue_pre(each_pin, 1), curr_id_queue_pre(each_pin, 2));
                % when it reaches negative port
                if curr_id_queue_temp == -1
                    break;
                end
                
                for i = 1:size(curr_id_queue_temp,2)
                    if curr_id_queue_temp(i) == '-'
                        [curr_tree, node] = curr_tree.addnode(node_id, curr_id_queue_temp(i));
                        node_id = node_id+1;
                        disp(curr_tree.tostring());
                        break;
                    elseif curr_id_queue_temp(i) == '+'
                        [curr_tree, node] = curr_tree.addnode(node_id, curr_id_queue_temp(i));
                        node_id = node_id+1;
                        disp(curr_tree.tostring());
                        break;
                    elseif curr_id_queue_temp == 'chip'
                        [curr_tree, node] = curr_tree.addnode(node_id, curr_id_queue_temp(i));
                        node_id = node_id+1;
                        disp(curr_tree.tostring());
                        break;
                    end
                    % check if visited
                    if id_table(curr_id_queue_temp(i),3)~=1
                        id_table(curr_id_queue_temp(i),3) = 1;
                        curr_id_queue.push(curr_id_queue_temp(i));
                        disp(curr_id_queue.content());
                        [curr_tree, node(i)] = curr_tree.addnode(node_id, curr_id_queue_temp(i));
                        disp(curr_tree.tostring());
                        node_id = node(i);
                    end
                end
            end
        end
        disp(curr_tree.tostring);
        t(each_tree) = curr_tree;
    end
%                 
    %     disp(curr_id_queue_pre);
       
%         disp(curr_id_queue.content());
%         disp(curr_tree.tostring);
%                  
%% check if the two trees are the same
% t1 = t(1);
% t2 = t1;
% % t2 = tree('+');
% % removenode(t2, 2);
% % disp(t1.tostring());
% % t1 = t1.addnode(1, 9);
% % t1 = t1.removenode(9);
% disp(t1.tostring());
% disp(t2.tostring());
% try 
%     tf = strcmpi(t1,t2);
%     if tf.Node{1} == 1
%         warning('The two Trees are the same!');
%     else
%         warning('The two Trees are not the same');
%     end
% %     warning('The two Trees are the same!');
% catch 
%     warning('The two Trees are not the same');
% end
% 
% 
% disp(tf.tostring());


