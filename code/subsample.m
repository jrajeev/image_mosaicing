function p=subsample(im,G)
    im=conv2(double(im),G,'same');
    p=reshape(im(1:5:size(im,1),1:5:size(im,2)),[64,1]);
    p=(p-mean(p))/std(p,1,1);
end