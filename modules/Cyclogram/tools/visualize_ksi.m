function [] = visualize_ksi(ksi_rx, time_rx, ksi_lost, time_lost, color, title_str)

figure()
plot(time_rx, ksi_rx, 'o') % received
hold on
plot(time_lost, ksi_lost, 'o', 'Color', color, 'LineWidth', 2) % lost
grid on
title(title_str)
ylim([-0.2 1.2])
xlabel('t, s')