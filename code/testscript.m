%%
I1=imread('museum1.jpg');
I2=imread('museum2.jpg');
I1=II;
I2=I3;
Ig1=rgb2gray(I1);
Ig2=rgb2gray(I2);
Cb1=cornermetric(Ig1);
Cb2=cornermetric(Ig2);

%%
%mid=zeros(size(I1,1),30,3);
%combo=[I1 mid I2];
[y1 x1 rmax1]=anms(Cb1,50);
[y2 x2 rmax2]=anms(Cb2,50);
%xn2=x2+30+size(I1,2);
%finy=[y1;y2];
%finx=[x1;xn2];
%imagesc(combo);
%hold all
%plot(finx,finy,'or','MarkerSize',2,'MarkerFaceColor','r');
imagesc(I1);
hold all
plot(x1,y1,'or','MarkerSize',2,'MarkerFaceColor','r');
figure,imagesc(I2);
hold all
plot(x2,y2,'or','MarkerSize',2,'MarkerFaceColor','r');

%%
p1=feat_desc(Ig1,y1,x1);
p2=feat_desc(Ig2,y2,x2);

%%
m=feat_match(p1,p2);
m1=[1:size(p1,1)]';
m1=m1(m~=-1);
m2=m(m~=-1);
xfin2=xn2(m2);
yfin2=y2(m2);
xfin1=x1(m1);
yfin1=y1(m1);
for i=1:size(m1,1)
    hold all
    line([xfin2(i);xfin1(i)],[yfin2(i); yfin1(i)],'LineWidth',1,'Color','g');
end

%%
thresh=1;
[H inliers_idx]=ransac_est_homography(yfin1,xfin1,yfin2,x2(m2),thresh);
xx2=xfin2(inliers_idx);
yy2=yfin2(inliers_idx);
xx1=xfin1(inliers_idx);
yy1=yfin1(inliers_idx);

for i=1:numel(inliers_idx)
    hold all
    line([xx2(i);xx1(i)],[yy2(i); yy1(i)],'LineWidth',2,'Color','y');
end
%%
Ylen=size(Ig2,1);
Xlen=size(Ig1,2);
%Y=repmat([1:Ylen]',Xlen,1);
%X=repmat([1:Xlen],Ylen,1);
%X=reshape(X,Xlen*Ylen,1);
X=[1;Xlen;1;Xlen];
Y=[1;1;Ylen;Ylen];
[tx ty]=apply_homography(H,X,Y);
Hinv=H^-1;
mintx=round(min(tx));
maxtx=round(max(tx));
minty=round(min(ty));
maxty=round(max(ty));
Xarr=[mintx:maxtx];
Yarr=[minty:maxty]';
Xlen=numel(Xarr);
Ylen=numel(Yarr);
Yarr=repmat(Yarr,Xlen,1);
Xarr=repmat(Xarr,Ylen,1);
Xarr=reshape(Xarr,Xlen*Ylen,1);
%rtx=uint16(round(tx));
%rty=round(ty);
%rty=uint16(rty-min(rty)+1);
[ntx nty]=apply_homography(Hinv,Xarr,Yarr);
I=zeros(maxty-minty+1,maxtx,3);
acbcbc='Hello';
ntx=round(ntx);
nty=round(nty);
idx=ntx>=1 & nty>=1 & ntx<=size(Ig2,2) & nty<=size(Ig2,1);
Yarr=Yarr(idx);
Xarr=Xarr(idx);
ntx=ntx(idx);
nty=nty(idx);
Yarr=Yarr-minty+1;
Xarr=Xarr;
for i=1:numel(ntx)
    I(Yarr(i),Xarr(i),:)=I2(nty(i),ntx(i),:);
end
I(1-minty:size(I1,1)-minty,1:size(I1,2),:)=I1;
figure,imagesc(uint8(I));

