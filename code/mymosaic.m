function img_mosaic = mymosaic(img_input)
    %Overall Mosaicing Function
    num=numel(img_input);
    st=ceil(num/2);
    img_mosaic=img_input{st};
    %figure,imagesc(uint8(img_mosaic));
    for i=st+1:num
        img_mosaic=works(img_mosaic,img_input{i});
        %figure,imagesc(uint8(img_mosaic));
    end
    for i=st-1:-1:1
        img_mosaic=works(img_mosaic,img_input{i});
    end
    figure,imagesc(uint8(img_mosaic));
end