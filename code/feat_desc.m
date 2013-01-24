function [p] = feat_desc(im, y, x)
    %Descriptor Computation
    im=padarray(im,[20 20],'both');
    p=zeros(64,size(y,1));
    y=y+20;
    x=x+20;
    G=smooth(0.6);
    for i=1:size(y,1)
        p(:,i)=subsample(im((y(i)-20):(y(i)+19),(x(i)-20):(x(i)+19)),G);
    end
end