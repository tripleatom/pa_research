function [A, D] = a_trous_dwt2D9P(I, N)
    g0 = [1, 8, 28, 56, 70, 56, 28, 8, 1] / 256;
    A = double(I);
    [r, c] = size(I);
    % approx=zeros(r,c);
    D = zeros(r, c, N);

    for level = 1:N
        l = 9 + 8 * (2^(level - 1) - 1);
        g = zeros(1, l);
        g(1:2^(level - 1):end) = g0;
        Aexpand = padarray(A, [l, l], 'symmetric', 'both');
        H = g' * g;
        approxtemp = conv2(Aexpand, H, 'same');
        Dtemp = Aexpand - approxtemp;
        D(:, :, level) = Dtemp(l + 1:r + l, l + 1:c + l);
        A = approxtemp(l + 1:r + l, l + 1:c + l);
        % approx(:,:,level)=A;
    end
