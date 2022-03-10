% Velocity threshold
clear;
close all;

mat_path = 'F:/2020at/pa_research/mat/11.2';
% mat_path = 'F:/2020at/pa_research/mat/11.2/surface';
result_path = 'F:/2020at/pa_research/result/11.2';
% result_path = 'F:/2020at/pa_research/result/11.2/surface';

% mean_v_flag = 1;
track_threshold = 50;

file = dir([mat_path '/*.mat']);

%% file by file
for oo = 1:length(file)
    disp(oo)
    load([mat_path '/' file(oo).name]);
    FrameRate = movobj.FrameRate;
    colors = prism(lastlabel); clf;

    for i = 1:lastlabel

        % calculate velocity
        if length(tracks(i).x) > track_threshold && length(tracks(i).y) > track_threshold
            [X, ~] = a_trous_dwt1D(tracks(i).x, 1);
            [Y, ~] = a_trous_dwt1D(tracks(i).y, 1);
            dx = X(2:end) - X(1:end - 1);
            dy = Y(2:end) - Y(1:end - 1);
            dr = sqrt(dx.^2 + dy.^2);
            velocity(i).v = dr * FrameRate; % um/s
            velocity(i).mean = mean(velocity(i).v);
        end

        plot(tracks(i).x, tracks(i).y, 'Color', colors(i, 1:3));
    end

    velocity(i).v = []; % make sure the size of track and velocity is the same
    velocity(i).v = velocity(i).v/40; % 40x magnification
    %find two peaks
    [counts,centers] = hist(velocity(2).v,50);
    [m,p1]=max(counts(1:20));
    [n,p2]=max(counts(21:50));
    velocity(i).peak1=centers(p1);
    velocity(i).peak2=centers(p2);
    velocity(i).threshold  = 0.5*(velocity(i).peak1+velocity(i).peak2);

    save([mat_path '/' file(oo).name(1:end -4)], 'tracks', 'lastlabel', 'movobj', 'velocity', 'FrameRate', 'track_threshold')
    clearvars -except file mat_path oo mean_v_flag result_path track_threshold mean_v

end