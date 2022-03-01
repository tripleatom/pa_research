%set sgv to 0&1
tic

sgf = []; %velocity
lastj = [];
rever = []; %represent reverse time
a0 = 1;
count = 0;

for i = 1:lastlabel

    if length(velocity(i).v) > 60 && mean(velocity(i).v) > 150
        %plot(velocity(i).v);
        sgf(i, 1:length(velocity(i).v)) = velocity(i).v;
        %plot(sgf,'Color',colors(i,1:3));
    end

end

all(sgf == 0, 2);
sgf(all(sgf == 0, 2), :) = []; %delete rows of 0 in sgf

lasti = size(sgf, 1);

for i = 1:lasti

    for m = 1:size(sgf, 2)

        if sgf(i, m) ~= 0
            m = m + 1;
            lastj(i) = m - 1;
        end

    end

end

for i = 1:lasti

    for j = 2:lastj(i) - 1

        if sgf(i, j) < sgf(i, j - 1) && sgf(i, j) < sgf(i, j + 1) %find velocity minimum
            b = j;

            for m = 1:b - 2

                for M = 1:lastj - b - 1

                    if sgf(i, b - m) > sgf(i, b - m - 1) && sgf(i, b - m) > sgf(i, b - m + 1) && sgf(i, b + M) > sgf(i, b + M - 1) && sgf(i, b + M) > sgf(i, b + M + 1) && sgf(i, b - m) - sgf(i, b) > 0.8 * (mean(sgf(i, 1:lastj(i)))) && sgf(i, b + M) - sgf(i, b) > 0.8 * (mean(sgf(i, 1:lastj(i)))) %find velocity maximum nearist to b
                        rever(i, j) = m + M;
                        break
                    end

                end

            end

            %            for m=1:b-2
            %                for M=1:lastj-b-1
            %                    if sgf(i,b-m)>sgf(i,b-m-1)&&sgf(i,b-m)>sgf(i,b-m+1)&&sgf(i,b+M)>sgf(i,b+M-1)&&sgf(i,b+M)>sgf(i,b+M+1) %find velocity maximum nearist to b
            %                       a0=b-m;
            %                       c=b+M;
            %                       if sgf(i,a0)-sgf(i,b)>0.8*(mean(sgf(i,1:lastj(i))))&&sgf(i,c)-sgf(i,b)>0.8*(mean(sgf(i,1:lastj(i))))
            %                           rever(i,j)=c-a0;
            %                           flag=1;
            %                           break
            %                       end
            % %                       if flag==1
            % %                           break
            % %                      end
            %
            %                    end
            %
            %                end
            %
            %            end

            %            if sgf(i,a0)-sgf(i,b)>0.8*(mean(sgf(i,1:lastj(i))))&&sgf(i,c)-sgf(i,b)>0.8*(mean(sgf(i,1:lastj(i))))
            %             rever(i,j)=c-a0;
            %            end

        end

    end

end

toc
