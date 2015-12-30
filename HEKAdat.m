classdef HEKAdat < handle
    % with classdef HEKAdat<handle, all modificaitons of hekadat objects immediately apply to it
    % it no longer works as a workspace variable
    properties
        % raw data
        data
        tAxis
        stim
        waveNames
        tags
%             bad %bad data
%             ccc %blanks
%             ooo %normal
%             coc %toxin bound
%             zzz %all others
%               coo %toxin left
%               cco %toxin left too
%               occ %inactivation?
%               ooc %inactivation?
%               oco %weird one

        % curated data
        sdata
        stAxis
        swaveNames
        stags
        sBaseline
        histx
        histy
        histfx
        histfitcoeffs
        
        % idealized data
        idata
        itAxis
        itags
        iwaveNames
        
        % path
        dirData='/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabExports/';
        dirSave='/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/';
        dirFile
        
        
    end
    
    properties (SetAccess = private)
        initalparseFlag = 0;
    end
    
    methods
        function hekadat=HEKAdat(dirFile)
            if ~ischar(dirFile)
                error('dirFile must be a string (e.g. ''2015_06_23.mat'')')
            else
                if exist(sprintf('%s%s.mat',hekadat.dirSave,dirFile),'file')==2
                    temp_hekadat=load(sprintf('%s%s',hekadat.dirSave,dirFile));
                    hekadat=temp_hekadat.hekadat;
                else
                    if exist(sprintf('%s%s.mat',hekadat.dirData,dirFile),'file')==2
                        hekadat.dirFile=dirFile;
                        hekadat=HEKAparse(hekadat);
                    else
                        error('file <%s.mat> does not exist in <%s>',dirFile,hekadat.dirData)
                    end
                end
            end
        end 
        
        function hekadat=HEKAparse(hekadat)
            HEKAexport=load(sprintf('%s/%s.mat',hekadat.dirData,hekadat.dirFile));
            fnames=fieldnames(HEKAexport);
            
            hekadat.waveNames=regexprep(regexprep(fnames,'Trace','e'),'_1$','');
            hekadat.tAxis=HEKAexport.(fnames{1})(:,1)';
            hekadat.data=NaN(size(fnames,1),size(hekadat.tAxis,2));
            for i=1:size(fnames,1)
                hekadat.data(i,:)=HEKAexport.(fnames{i})(:,2)*1e12; %transform into pA
            end
            hekadat.initalparseFlag=1;
            hekadat.tags=cell(size(hekadat.waveNames));
        end
        
        function hekadat=HEKAsave(hekadat)
           save(sprintf('%s%s',hekadat.dirSave,hekadat.dirFile),'hekadat')
           fprintf('Saved to %s%s\n',hekadat.dirSave,hekadat.dirFile);
        end
        
        function matches=HEKAtagfind(hekadat,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matches=cellfun(tagfindfx(tag),hekadat.tags);
        end
        
        function matches=HEKAstagfind(hekadat,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matches=cellfun(tagfindfx(tag),hekadat.stags);
        end
        
        function matchindex=HEKAnamefind(hekadat,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matchindex=find(cellfun(tagfindfx(tag),hekadat.waveNames));
        end
        
        function matchindex=HEKAsnamefind(hekadat,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matchindex=find(cellfun(tagfindfx(tag),hekadat.swaveNames));
        end
        
        function tagmean=HEKAtagmean(hekadat,tag)
            tagmean=mean(hekadat.data(hekadat.HEKAtagfind(tag),:));
        end
        
        function t_stairs=HEKAstairsprotocol(hekadat)
            t_stairs=struct;
            t_stairs.st=0.22;
            t_stairs.end=0.72;
            t_stairs.delta=t_stairs.end-t_stairs.st;
            t_stairs.sti=find(hekadat.tAxis<=t_stairs.st,1,'last');
            t_stairs.endi=find(hekadat.tAxis<=t_stairs.end,1,'last');
            t_stairs.deltai=find(hekadat.tAxis<=t_stairs.delta,1,'last');
        end
    end
end