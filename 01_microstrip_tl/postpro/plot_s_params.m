% 1. Read Raw CSV Data Safely
raw_structure = importdata('port-S.csv', ',');
if isstruct(raw_structure)
    data = raw_structure.data;
else
    data = raw_structure;
end

if isempty(data)
    error('ERROR: port-S.csv could not be read or is empty!');
end


freq_ghz = data(:, 1);       % No division needed, already in GHz!
s11_db = data(:, 2);         % Column 2: S11 (dB) Return Loss
s21_db = data(:, 4);         % Column 4: S21 (dB) Insertion Loss

% 3. Initialize Figure
figure('Position', [100, 100, 800, 500]);
hold on;

% Plot S-Parameters
h1 = plot(freq_ghz, s11_db, 'r-o', 'LineWidth', 2, 'MarkerSize', 4);
h2 = plot(freq_ghz, s21_db, 'b--s', 'LineWidth', 2, 'MarkerSize', 4);

% Plot -10 dB Impedance Bandwidth Threshold
h3 = plot([min(freq_ghz); max(freq_ghz)], [-10; -10], 'k--', 'LineWidth', 1.5);

% 4. Dynamic Y-Axis Scaling
all_y = [s11_db; s21_db; -10];
min_y = min(all_y);
max_y = max(all_y);
y_range = max_y - min_y;
if y_range == 0
    y_range = 1.0;
end

ylim([min_y - 5, max_y + 5]);
xlim([min(freq_ghz), max(freq_ghz)]);

% 5. Labels and Styling
title('Palace FEM - S-Parameter Characterization', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Frequency (GHz)', 'FontSize', 10);
ylabel('Magnitude (dB)', 'FontSize', 10);
grid on;
grid minor;

legend([h1, h2], {'S_{11} (Return Loss)', 'S_{21} (Insertion Loss)'}, 'Location', 'northeastoutside');
hold off;

% Save Output Image
print('s_parameters_octave.png', '-dpng', '-r300');
disp('>>> Success: "s_parameters_octave.png" has been generated with correct units.');
