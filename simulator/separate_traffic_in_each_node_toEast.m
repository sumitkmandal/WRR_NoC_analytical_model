function [classes_arbitration_0, classes_arbitration_1 ] = separate_traffic_in_each_node_toEast(node_idx, num_node)

classes_arbitration_0 = 0;
arbitration_0_idx = 0;

classes_arbitration_1 = 0;
arbitration_1_idx = 0;

for idx = node_idx:num_node
    
    %self traffic
    if (idx == node_idx)
        if (rem(node_idx, 2) == 1)
            arbitration_0_idx = arbitration_0_idx + 1;
            classes_arbitration_0(arbitration_0_idx) = node_idx;
        end
    else
        abs_dist = abs(idx-node_idx);
        if (rem(abs_dist,2) == 0)
            arbitration_0_idx = arbitration_0_idx + 1;
            classes_arbitration_0(arbitration_0_idx) = idx;
        else
            arbitration_1_idx = arbitration_1_idx + 1;
            classes_arbitration_1(arbitration_1_idx) = idx;
        end
    end    
end

end

