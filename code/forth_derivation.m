function deriv = forth_derivation(X)
    % myFun - Description
    %
    % Syntax: deriv = forth_derivation(X)
    % X: input time series, 1-d
    % Long description:
    % [8(x_i+1-x_i-1)-(x_i+2-x_i-2)]/12

    Xb2 = X(1:end - 4);
    Xb1 = X(2:end - 3);
    Xf1 = X(4:end - 1);
    Xf2 = X(5:end);
    deriv = (8 * (Xf1 - Xb1) - (Xf2 - Xb2)) / 12;

end
