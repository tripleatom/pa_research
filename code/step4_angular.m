% calculate velocity and angle change by 4th order central difference

clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/v_thres/';
out_path = 'F:/2020at/pa_research/mat/11.2/with_angle/';

surf_or_liquid = 'liq';
file = dir([mat_path surf_or_liquid '*.mat']);

%% calculate instantaneous velocity and direction of motion
for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    disp(current_proj)

    for i = 1:length(tracks)

        % smooth the tracks
        [X, ~] = a_trous_dwt1D(tracks(i).x, 1);
        [Y, ~] = a_trous_dwt1D(tracks(i).y, 1);

        dx = X(2:end) - X(1:end - 1);
        dy = Y(2:end) - Y(1:end - 1);

        % direction
        direction(i).x = dx;
        direction(i).y = dy;

        % save the motion directions into a structure
        for k = 1:length(dx)
            temp_dir(k).x = dx(k);
            temp_dir(k).y = dy(k);
        end

        % absolute value for angular deviation
        angle_velocity(i).v = arrayfun(@(a, b) atan2(abs(det([a.x, a.y; b.x, b.y])), dot([a.x, a.y], [b.x, b.y])), temp_dir(1:end - 1), temp_dir(2:end));
        angle_velocity(i).mean = mean(angle_velocity(i).v);
        
        clear temp_dir

    end

    save([out_path '/' file(oo).name(1:end -4)], 'tracks', 'movobj', 'velocity', 'FrameRate', 'direction', 'angle_velocity', 'current_proj')
    clearvars -except file mat_path out_path oo
end
