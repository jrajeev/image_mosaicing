function G=smooth(a)
    gx=[(0.25-a/2) 0.25 a 0.25 (0.25-a/2)];
    gy=gx';
    G=conv2(gx,gy);
end