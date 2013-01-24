function [H,inlier_ind] = ransac_est_homography(y1, x1, y2, x2, thresh)
    %RANSAC-based Homography Fitting
    sz=-1;
    %szzzzz=size(x1)
    for i=1:1000
        r=rand(size(y1,1),1);
        [abc idx]=sort(r);
        idx=idx(1:4);
        H=est_homography(x1(idx),y1(idx),x2(idx),y2(idx));
        [xn2 yn2]=apply_homography(H,x2,y2);
        %[xn2(idx) x2(idx) x1(idx)]
        %[yn2(idx) y2(idx) y1(idx)]
        %xdiff=xn1-x2
        %ydiff=yn1-y2
        dist=(xn2-x1).^2 + (yn2-y1).^2;
        tmp=find(dist<=(thresh^2));
        tsz=numel(tmp);
        if (tsz>sz)
            sz=tsz;
            inlier_ind=tmp;
        end
    end
    H=est_homography(x1(inlier_ind),y1(inlier_ind),x2(inlier_ind),y2(inlier_ind));
end