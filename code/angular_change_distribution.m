clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/with_angle/';
result_path = 'F:/2020at/pa_research/result/11.2/distribution/';

surf_or_liquid = 'surf';
mode_choosen = 'pause';
% pause or worm

file = dir([mat_path surf_or_liquid '*.mat']);

%% during of one mode
angle = []; % unit is s

worm_thres = .25;

for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    disp(current_proj)

    for i = 1:length(velocity)

        temp_v = velocity(i).v;
        temp_direction = direction(i); % struct: temp_direction.x, temp_direction.y
        thres = velocity(i).threshold;

        ind = (temp_v <= thres);

        left = 0;
        mode_flag = false;

        for j = 1:length(temp_v)

            if ind(j) == 1 && mode_flag == false
                mode_flag = true;
                left = j;
            elseif ind(j) == 0 && mode_flag == true
                mode_flag = false;
                temp_time = (j - left) / FrameRate;

                if j > length(temp_direction.x)
                    j = j - 1;
                end

                begin_angle.x = temp_direction.x(left);
                begin_angle.y = temp_direction.y(left);
                end_angle.x = temp_direction.x(j);
                end_angle.y = temp_direction.y(j);
                % calcuate angle change
                temp_angle = arrayfun(@(a, b) atan2(abs(det([a.x, a.y; b.x, b.y])), dot([a.x, a.y], [b.x, b.y])), begin_angle, end_angle);

                if strcmp(mode_choosen, 'pause')

                    if temp_time <= worm_thres
                        angle = [angle, temp_angle];
                    end

                elseif strcmp(mode_choosen, 'worm')

                    if temp_time > worm_thres
                        angle = [angle, temp_angle];
                    end

                end

                left = 0;
            end

        end

    end

end

angle = rad2deg(angle);
%% plot histogram
[counts, edges, bin] = histcounts(angle);

indexes = counts < 10 ;%| counts > 1e3; % Remove unwanted data
counts(indexes) = 0; % Set those bins to zero.

[~, index, v] = find(counts); % find non-zero frequence
counts = counts(index);
edges = edges(index);

hold on
set(gca, 'YScale', 'log')
xlim([min(edges) 180])
% xlim([min(edges) .25]) % for worm
% ylim([10 1e3])

b = bar(edges, counts, 'EdgeAlpha', .5);
% b.FaceColor = 'none';
xlabel('Turn angle (\circ)')
ylabel('Counts')

current_time = datestr(now, 'mmdd-HH');
title_text = [surf_or_liquid ' ' mode_choosen ' turn angle'];
title(title_text)

%% save
fname = [result_path 'angle_' mode_choosen '_' surf_or_liquid '_' current_time];
saveas(gca, fname, 'png')
