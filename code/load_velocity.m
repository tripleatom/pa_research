function whole_v = load_velocity(mat_path, surf_or_liquid, mean_or_v, thres_or_not)
    %LOAD_VELOCITY load mean or instant velocity from mat file
    %   Return array with all velocity (without order)

    if thres_or_not == true
        mat_path = [mat_path 'delete_still'];
    else
        mat_path = [mat_path 'clear'];
    end

    file = dir([mat_path '/' surf_or_liquid '*.mat']);

    whole_v = [];

    for i = 1:length(file)
        disp(i)
        load([mat_path '/' file(i).name], 'velocity');
        v = extractfield(velocity, mean_or_v);
        whole_v = [whole_v, v];
    end

end
