original = [1.6329 1.7926 1.9893 2.2613 2.6263 3.0845 3.6679 4.8199 6.8235 12.1196];
predicted_lin = [1.6195 1.7602 1.9281 2.1321 2.3852 2.7074 3.1317 3.7156 4.5702 5.9404];
predicted_new = [1.6812 1.9038 2.1819 2.5359 2.9968 3.6131 4.4642 5.6893 7.5504 10.5971];

lambda_tile_tot = 0.025:0.025:0.25;

f10 = plot(lambda_tile_tot, original, '*-r');
xlabel('injection rate(packets/cycle) from tile 3', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Latency(cycles)', 'FontSize', 14, 'FontWeight', 'bold');
title('Latency vs Injection Rate for Tile 3 to 3', 'FontSize', 14, 'FontWeight', 'bold');
set(f10,'LineWidth', 1.4, 'MarkerSize', 11);
hold on;

f11 = plot(lambda_tile_tot, predicted_lin, '^-g');
set(f11,'LineWidth', 1.4, 'MarkerSize', 11);

f12 = plot(lambda_tile_tot, predicted_new, '^-b');
set(f12,'LineWidth', 1.4, 'MarkerSize', 11);

hold off;

legend('Simulation model', 'Degree 1 prediction', 'Degree n prediction');

legend('Location', 'northwest');

legend('show');

grid on;