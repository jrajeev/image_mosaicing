function [y x rmax] = anms(cimg, max_pts)
    %Adaptive Non-Maximal Suppression
    C=double(imregionalmax(cimg));
    cimg=C.*cimg;
    corners=find(cimg);
    [y x]=ind2sub(size(cimg),corners);
    dist=inf*ones(size(y,1),1);
    for i=1:size(y,1)
        for j=1:size(y,1)
            if (cimg(y(j),x(j))>cimg(y(i),x(i)))
                tmp=(y(i)-y(j))*(y(i)-y(j)) + (x(i)-x(j))*(x(i)-x(j));
                if (tmp<dist(i))
                    dist(i)=tmp;
                end
            end
        end
    end
    [abc idx]=sort(dist,'descend');
    y=y(idx);
    x=x(idx);
    y=y(1:max_pts);
    x=x(1:max_pts);
    rmax=sqrt(abc(max_pts));
end
