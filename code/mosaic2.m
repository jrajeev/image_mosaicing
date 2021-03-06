function I=mosaic2(I1,I2)
    Ig1=rgb2gray(I1);
    Ig2=rgb2gray(I2);
    Cb1=cornermetric(Ig1);
    Cb2=cornermetric(Ig2);
    
    [y1 x1 rmax1]=anms(Cb1,100);
    [y2 x2 rmax2]=anms(Cb2,100);
    ymm=max(size(I1,1),size(I2,1));
    z1=zeros(ymm-size(I1,1),size(I1,2),3);
    z2=zeros(ymm-size(I2,1),size(I2,2),3);
    zmid=zeros(ymm,30,3);
    img=[[I1;z1] zmid [I2;z2]];
    imagesc(uint8(img));
    hold all
    x2s=x2+30+size(I1,2);
    x12=[x1;x2s];
    y12=[y1;y2];
    plot(x12,y12,'or','MarkerSize',2,'MarkerFaceColor','r');
    
    p1=feat_desc(Ig1,y1,x1);
    p2=feat_desc(Ig2,y2,x2);
    
    m=feat_match(p1,p2);
    m1=[1:size(p1,2)]';
    m1=m1(m~=-1);
    m2=m(m~=-1);
    xfin2=x2(m2);
    yfin2=y2(m2);
    xfin1=x1(m1);
    yfin1=y1(m1);
    
    for i=1:size(m1,1)
        hold all
        line([x1(m1(i));x2s(m2(i))],[y1(m1(i)); y2(m2(i))],'LineWidth',1,'Color','g');
    end

    thresh=9;
    [H inliers_idx]=ransac_est_homography(yfin1,xfin1,yfin2,xfin2,thresh);
    
    Ylen=size(Ig2,1);
    Xlen=size(Ig1,2);
    X=[1;Xlen;1;Xlen];
    Y=[1;1;Ylen;Ylen];
    [tx ty]=apply_homography(H,X,Y);
    Hinv=H^-1;
    mintx=round(min(tx));
    maxtx=round(max(tx));
    minty=round(min(ty));
    maxty=round(max(ty));
    [Xarr Yarr]=meshgrid(mintx:maxtx,minty:maxty);
    Xarr=reshape(Xarr,[size(Xarr,1)*size(Xarr,2),1]);
    Yarr=reshape(Yarr,[size(Yarr,1)*size(Yarr,2),1]);
    [ntx nty]=apply_homography(Hinv,Xarr,Yarr);
    minx=min(mintx,1);
    miny=min(minty,1);
    maxx=max(maxtx,size(I1,2));
    maxy=max(maxty,size(I1,1));
    I=zeros(maxy-miny+1,maxx-minx+1,3);
    %imagesc(I);
    if (minx>=1)
        stx=1;
    else
        stx=1-minx;
    end
    if (miny>=1)
        sty=1;
    else
        sty=1-miny;
    end
    I(sty:sty+size(I1,1)-1,stx:stx+size(I1,2)-1,:)=I1(:,:,:);
    %figure,imagesc(uint8(I));
    if (mintx<1)
       offx=1-mintx; 
    else
        offx=0;
    end
    if (minty<1)
       offy=1-minty; 
    else
        offy=0;
    end
    ntx=round(ntx);
    nty=round(nty);
    idx=ntx>=1 & ntx<=size(I2,2) & nty>=1 & nty<=size(I2,1);
    ntx=ntx(idx);
    nty=nty(idx);
    Yarr=Yarr(idx);
    Xarr=Xarr(idx);
    %inliers_idx
    for i=1:size(Xarr,1)
        %[Yarr(i)+offy Xarr(i)+offx nty(i) ntx(i)] 
        I(Yarr(i)+offy,Xarr(i)+offx,:)=I2(nty(i),ntx(i),:);
    end
    I=uint8(I);
end