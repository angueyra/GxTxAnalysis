classdef HEKAdat
    properties
        data
        tAxis
        waveNames
        dirData='/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabExports/';
        dirSave='/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/';
        dirFile
        tags
%             bad %bad data
%             ccc %blanks
%             ooo %normal
%             coc %toxin bound
%             coo %toxin left
%             cco %toxin left too
%             occ %inactivation?
%             ooc %inactivation?
%             oco %weird one
    end
    
    properties (SetAccess = private)
        initalparseFlag = 0;
    end
    
    methods
        function obj=HEKAdat(dirFile)
            if ~ischar(dirFile)
                error('dirFile must be a string (e.g. ''2015_06_23.mat'')')
            else
                if exist(sprintf('%s%s.mat',obj.dirSave,dirFile),'file')==2
                    temp_obj=load(sprintf('%s%s',obj.dirSave,dirFile));
                    obj=temp_obj.hekadat;
                else
                    if exist(sprintf('%s%s.mat',obj.dirData,dirFile),'file')==2
                        obj.dirFile=dirFile;
                        obj=HEKAparse(obj);
                    else
                        error('file <%s.mat> does not exist in <%s>',dirFile,obj.dirData)
                    end
                end
            end
        end 
        
        function obj=HEKAparse(obj)
            HEKAexport=load(sprintf('%s/%s.mat',obj.dirData,obj.dirFile));
            fnames=fieldnames(HEKAexport);
            
            obj.waveNames=regexprep(regexprep(fnames,'Trace','e'),'_1$','');
            obj.tAxis=HEKAexport.(fnames{1})(:,1)';
            obj.data=NaN(size(fnames,1),size(obj.tAxis,2));
            for i=1:size(fnames,1)
                obj.data(i,:)=HEKAexport.(fnames{i})(:,2)*1e12; %transform into pA
            end
            obj.initalparseFlag=1;
            obj.tags=cell(size(obj.waveNames));
        end
        
        function hekadat=HEKAsave(hekadat)
           save(sprintf('%s%s',hekadat.dirSave,hekadat.dirFile),'hekadat') 
        end
        
        function matches=HEKAtagfind(obj,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matches=cellfun(tagfindfx(tag),obj.tags);
        end
    end
end