% detect reverse by method proposed in Masson et.al. 2012

clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/with_angle/';
result_path = 'F:/2020at/pa_research/result/11.2/distribution/';

surf_or_liquid = 'surf';
file = dir([mat_path surf_or_liquid '*.mat']);
lens_magnification = 40;

%% tumble mode duration

tumble = []; % unit is s

for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    disp(current_proj)

    for i = 1:length(angle_velocity)
        temp_v = velocity(i).v / lens_magnification;
        temp_angle = angle_velocity(i).v; % radius

        tumble_marker = zeros(length(temp_angle), 1);

        %% for velocity
        minprominence = 1;
        [TF1, ~] = islocalmin(temp_v, 'MinProminence', minprominence); % local min
        [TF2, ~] = islocalmin(-temp_v, 'MinProminence', minprominence); % local max

        n_max = sum(TF2);
        min_index = find(TF1);
        max_index = find(TF2);

        if ~isempty(min_index) && ~isempty(max_index)

            if min_index(1) < max_index(1)
                TF1(min_index(1)) = ~TF1(min_index(1));
            end

        end

        min_index = find(TF1);

        for j = 1:n_max - 1
            left = temp_v(max_index(j));
            right = temp_v(max_index(j + 1));
            vmin = temp_v(min_index(j));
            delta_v = max(left - vmin, right - vmin);

            if delta_v / vmin > .7

                for k = max_index(j):max_index(j + 1)

                    if temp_v(k) < vmin + .2 * delta_v
                        tumble_marker(k) = 1;
                    end

                end

            end

        end

        %% for angular
        minprominence = 1;
        [TF1, ~] = islocalmin(temp_angle, 'MinProminence', minprominence); % local min
        [TF2, ~] = islocalmin(-temp_angle, 'MinProminence', minprominence); % local max

        n_min = sum(TF1);
        min_index = find(TF1);
        max_index = find(TF2);

        if ~isempty(min_index) && ~isempty(max_index)

            if max_index(1) < min_index(1)
                TF1(max_index(1)) = ~TF1(max_index(1));
            end

        end

        max_index = find(TF1);
        D = .1; %rad^2/s
        beta = 2;

        for j = 1:n_min - 1
            left = temp_angle(min_index(j));
            right = temp_angle(min_index(j + 1));
            thetamax = temp_angle(max_index(j));
            delta_theta = max(thetamax - left, thetamax - right);

            delta_time = (min_index(j + 1) - min_index(j)) / FrameRate;
            sum_theta = sum(temp_angle(min_index(j):min_index(j + 1)));

            if sum_theta >= beta * sqrt(2 * D * delta_time)

                for k = max_index(j):max_index(j + 1)

                    if abs(thetamax - temp_angle(k)) < .2 * delta_theta
                        tumble_marker(k) = 1;
                    end

                end

            end

        end

        % use marker to calculate distribution
        left = 0;
        tumble_flag = false;
        for j = 1:length(tumble_marker)
            if tumble_marker(j) == 1 && tumble_flag == false
                tumble_flag = true;
                left = j;
            elseif tumble_marker(j) == 0 && tumble_flag == true
                tumble_flag = false;
                temp_time = (j  - left) / FrameRate;
                
                tumble = [tumble, temp_time];
                left = 0;
            end
        end

    end

end
%% fit slope and plot

% tumble_filtered = tumble(tumble>.3);
[counts, edges, bin] = histcounts(tumble);

% indexes = counts < 10 | counts > 1e3; % Remove unwanted data
% counts(indexes) = 0; % Set those bins to zero.

[~, index, v] = find(counts); % find non-zero frequence
counts = counts(index);
edges = edges(index);

f = fit(edges', counts', 'exp1'); % fit exponential function
% plot(f, 'b--')
hold on
set(gca, 'YScale', 'log')

g = gca;
sigma_text = ['slope = ' num2str(f.b, '%.3f')];
text(g.XLim(2) * .7, g.YLim(2)^.8, sigma_text)

b = bar(edges, counts, 'EdgeAlpha', .2);
b.FaceColor = 'none';
xlabel('Time (s)')
ylabel('Counts')
legend('fitted curve')

current_time = datestr(now, 'mmdd-HH');
title_text = [surf_or_liquid ' tumble duration'];
title(title_text)

%% save
fname = [result_path 'tumble_dur_' surf_or_liquid '_' current_time '_1'];
saveas(gca, fname, 'png')
