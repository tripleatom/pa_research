function [Approx, D] = a_trous_dwt1D(S, N)
    g0 = [1/16, 1/4, 3/8, 1/4, 1/16];
    A = S;

    if ~iscolumn(A)
        A = A';
    end

    len = length(S);
    % approx=zeros(len,1);
    D = zeros(len, N);
    Approx = zeros(len, N);

    for level = 1:N
        l = 5 + 4 * (2^(level - 1) - 1);
        %     approxtemp=zeros(len+2*l,1);
        %     Dtemp=zeros(len+2*l,1);
        g = zeros(1, l);
        g(1:2^(level - 1):end) = g0;
        foward = flipud(A(1:l));
        backward = flipud(A(len - l + 1:len));
        Aexpand = [foward; A; backward];
        %     H=g'*g;
        approxtemp = conv(Aexpand, g, 'same');
        Dtemp = Aexpand - approxtemp;
        D(:, level) = Dtemp(l + 1:len + l);
        %     C=approx(:,:,level);
        A = approxtemp(l + 1:len + l);
        Approx(:, level) = A;
    end
