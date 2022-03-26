function [title_text, output_filename] = creat_title(surf_or_liquid, mean_or_v, thres_or_not)
    %CREAT_TITLE Summary of this function goes here
    %   Detailed explanation goes here

    if strcmp(mean_or_v, 'mean')
        title_text = 'mean';
    else
        title_text = 'instant';
    end

    if thres_or_not == true
        title_text = [title_text ' thres filter'];
    else
        title_text = [title_text ' all'];
    end

    if strcmp(surf_or_liquid, 'surf')
        title_text = ['Surface ' title_text];
    else
        title_text = ['Liquid ' title_text];
    end

    expression = '\x20';
    replace = '_';
    output_filename = regexprep(title_text, expression, replace);
end
