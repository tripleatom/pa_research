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
    tracks(delete_label)=[];
    velocity(delete_label) = [];
    save([result_path '/' current_proj], 'tracks', 'lastlabel', 'movobj','velocity', 'FrameRate','current_proj','velocity_threshold')
    clearvars tracks velocity
end