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
