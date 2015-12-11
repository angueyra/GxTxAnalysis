function newstruct=clipWaveNames(oldstruct)
% function newstruct=clipWaveNames(oldstruct)
%Created Dec_2015 (angueyra@nih.gov)


fnames=fieldnames(oldstruct);
for i=1:size(fnames,1)
    f=char(fnames(i));
    strposition=regexp(f,'Trace','end');
    if ~isempty(strposition)
       newstruct.(f(regexp(f,'Trace','end'):end-2))=oldstruct.(f)(:,2)*1e12; %transform to pA
    else
        newstruct.(f)=oldstruct.(f);
    end
end
newstruct.tAxis=oldstruct.(f)(:,1);

end