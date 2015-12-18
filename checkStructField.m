function inputstruct=checkStructField(inputstruct,nameoffield,defaultvalue)
% function inputstruct=checkStructField(inputstruct,nameoffield,defaultvalue)
% Created Dec_2015 (angueyra@nih.gov)
if ~isfield(inputstruct,nameoffield) || isempty(inputstruct.(nameoffield))
    inputstruct.(nameoffield)=defaultvalue;
end
end