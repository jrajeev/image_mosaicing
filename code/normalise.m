function z=normalise(p)
    z=(p-mean(p))/std(p,1,1);
end