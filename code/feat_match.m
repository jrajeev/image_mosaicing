function [m] = feat_match(p1,p2)
    %Descriptor Matching
    thresh=0.75;
    m=-1*ones(size(p1,2),1);
    for i=1:size(p1,2)
        tmp=bsxfun(@minus,p1(:,i),p2);
        tmp=sum(tmp.*tmp);
        [abc idx]=sort(tmp,2);
        if (abc(1)/abc(2)<thresh)
            m(i)=idx(1);
        else
            m(i)=-1;
        end
    end
    %mmm=sum(m~=-1)
end