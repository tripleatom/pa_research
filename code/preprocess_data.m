clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/liq';
file = dir([mat_path '/*.mat']);
result_path = 'F:/2020at/pa_research/mat/11.2/clear';

%% delete empty tracks
for oo = 1:length(file)
    current_proj = file(oo).name(1:end -4);
    disp(current_proj)
    load([mat_path '/' file(oo).name]);
    empty_label = [];
    velocity(lastlabel).v = [];

    parfor i = 1:length(tracks)

        if isempty(velocity(i).v)
            empty_label = [empty_label, i];
        end

    end

    tracks(empty_label) = [];
    velocity(empty_label) = [];
    save([result_path '/' current_proj], 'tracks', 'lastlabel', 'movobj', 'velocity', 'FrameRate', 'current_proj')
    clearvars -except file mat_path result_path oo

end

%% plot clear path
file = dir([result_path '/*.mat']);
plt_path = 'F:/2020at/pa_research/result/track/';
pixels_per_micron = 1/5.3;

for oo = 1:length(file)
    current_proj = file(oo).name(1:end -4);
    load([result_path '/' file(oo).name]);
    colors = prism(lastlabel);
    hTrace = figure;
    hold on;
    daspect([1024 1280 1])

    for i = 1:length(velocity)

        if length(velocity(i).v) > 50
            plot(tracks(i).x * pixels_per_micron, tracks(i).y * pixels_per_micron, 'Color', colors(i, 1:3), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5);
            axis ij padded
        end

    end

    saveas(hTrace, [plt_path current_proj '.tif'])
    hold off
    clearvars -except oo file plt_path pixels_per_micron mat_path result_path
    close
end

%% delete the tracks which (track points length < 50)
% when reuse, rewrite load path and save path
mat_path = 'F:/2020at/pa_research/mat/11.2/clear';
file = dir([mat_path '/*.mat']);

length_threshold = 50;

for oo = 1:length(file)
    load([mat_path '/' file(oo).name]);
    current_proj = file(oo).name(1:end -4);
    disp(current_proj)
    delete_label = [];

    for i = 1:length(velocity)

        if length(velocity(i).v) < length_threshold
            delete_label = [delete_label, i];
        end

    end

    tracks(delete_label) = [];
    velocity(delete_label) = [];

    save([mat_path '/' current_proj], 'tracks', 'lastlabel', 'movobj', 'velocity', 'FrameRate', 'current_proj')
end

%% delete still worms
tic
clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/clear';
result_path = 'F:/2020at/pa_research/mat/11.2/delete_still';
file = dir([mat_path '/*.mat']);

velocity_threshold = 120; % um

for oo = 1:length(file)
    delete_label = [];
    load([mat_path '/' file(oo).name])
    current_proj = file(oo).name(1:end -4);

    for i = 1:length(tracks)

        if velocity(i).mean < velocity_threshold
            delete_label = [delete_label, i];
        end

    end

    tracks(delete_label) = [];
    velocity(delete_label) = [];
    save([result_path '/' current_proj], 'tracks', 'lastlabel', 'movobj', 'velocity', 'FrameRate', 'current_proj', 'velocity_threshold')
    clearvars tracks velocity
end
