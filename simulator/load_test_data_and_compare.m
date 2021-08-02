function [ ] = load_test_data_and_compare( src, dest, test_data_path, no_of_tile, offset )

[ lambda_tile_test, test_data_size ] = readLambdaFromSavedDataRandomSourceSink( test_data_path );

[ average_latency_test, sd_test ] = read_latency_and_sd( test_data_path );

cd ..

% coeff_struct = load('coefficients/ring with 6 tile/num_sum_prod_den_prod/x_tile_3_3.mat');
coeff_struct_new = load('x_tile.mat');

x_tile_new = coeff_struct_new.x_tile;

% predicted_latency_tile_3_3_new = latency_calculation( test_data_size, offset, lambda_tile_test, x_tile_3_3_new, no_of_tile )
predicted_latency_tile_new = latency_calculation_with_recursion( src, dest, test_data_size, offset, lambda_tile_test, x_tile_new, no_of_tile );

% coeff_struct_old = load('x_tile_3_3_sd.mat');
% 
% x_tile_3_3_old = coeff_struct_old.x_tile_3_3;
% 
% predicted_latency_tile_3_3_old = latency_calculation( test_data_size, offset, lambda_tile_test, x_tile_3_3_old, no_of_tile )

average_latency_tile_test = average_latency_test(:,dest,src);

j = 1;

% lambda_tile_test(:,dest,src) = [0.025:0.025:0.35, 0.36 0.37 0.38];

for i = 1:length(average_latency_tile_test)
    if (average_latency_tile_test(i) < 20*offset)
        average_latency_tile_test_thresh(j) = average_latency_tile_test(i);
        predicted_latency_tile_thresh_new(j) = predicted_latency_tile_new(i);
%         predicted_latency_tile_3_3_thresh_old(j) = predicted_latency_tile_3_3_old(i);
        lambda_tile_plot(j) = lambda_tile_test(i,dest,src);
        j = j+1;
    end
end



% mean_error_tile_ = abs(mean((predicted_latency_tile_3_3_thresh_new - average_latency_tile3_3_core_test_thresh)./average_latency_tile3_3_core_test_thresh))*100

f1 = plot(lambda_tile_plot, average_latency_tile_test_thresh, '*-.r');
xlabel('injection rate(packets/cycle)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Latency(cycles)', 'FontSize', 14, 'FontWeight', 'bold');
title('Latency vs Injection Rate', 'FontSize', 14, 'FontWeight', 'bold');
set(f1,'LineWidth', 1.4, 'MarkerSize', 11);
hold on;

f2 = plot(lambda_tile_plot, predicted_latency_tile_thresh_new, '^--b');
set(f2,'LineWidth', 1.4, 'MarkerSize', 11);

% f2 = plot(lambda_tile_plot, predicted_latency_tile_3_3_thresh_old, 'o:k');
% set(f2,'LineWidth', 1.4, 'MarkerSize', 11);

hold off;

legend('Simulation model', 'Predicted model new');

legend('Location', 'northwest');

legend('show');

grid on;

end

