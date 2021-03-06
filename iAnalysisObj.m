classdef iAnalysisObj < handle
    properties
        % idealized data
        n
        itags
        iwaveNames
        itAxis      % makes running analysis easier if this is at hand
        idata       % makes running analysis easier if this is at hand
        dt          % maybe I just need dt instead of itAxis
        flat        % time to first opening (first latency) in ms
        flati       % index to first opening (first latency) in idealized data
        odt         % open dwell times organized in cell array in ms
        cdt         % closed dwell times organized in cell array in ms
        
        notx
        gxtx
        
        % path
        dirSave='/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/';
        dirFile
    end
    
    properties (SetAccess = private)
    end
    
    methods
        function iA=iAnalysisObj(hekadat)
            iA.dirFile=sprintf('%s_iA',hekadat.dirFile);
            if exist(sprintf('%s%s.mat',iA.dirSave,iA.dirFile),'file')==2
                temp_iA=load(sprintf('%s%s',iA.dirSave,iA.dirFile));
                iA=temp_iA.iA;
                fprintf('Loaded saved version\n')
            else
                if ~isa(hekadat,'HEKAdat')
                    error('initial parsing/loading requires a HEKAdat object as input')
                end
                % transfer relevant information
                iA.dirFile=[hekadat.dirFile '_iA'];
                iA.n=size(hekadat.idata,1);
                iA.itags=hekadat.itags;
                iA.iwaveNames=hekadat.iwaveNames;
                iA.idata=hekadat.idata;
                iA.itAxis=hekadat.itAxis;
                iA.dt=hekadat.dt;
                iA.flat=NaN(size(iA.itags));
                iA.flati=NaN(size(iA.itags));
                iA.odt=cell(size(iA.itags,1),1);
                iA.cdt=cell(size(iA.itags,1),1);
                iA.notx=iASubObj;
                iA.gxtx=iASubObj;
                % run calculations
                fprintf('Starting dwell time calculations\n')
                iA.CALCflats;
                iA.CALCdts;
                
                fprintf('Ready!\n')
            end
        end
        
        function iA=CALCflats(iA)
            for i=1:size(iA.idata,1)
                if ~isempty(find(iA.idata(i,:),1,'first'))
                    iA.flati(i)=find(iA.idata(i,:),1,'first');
                    iA.flat(i)=iA.itAxis(iA.flati(i))*1e3;
                end
            end
        end
        
        function iA=CALCdts(iA)
           for i=1:size(iA.idata,1)
               [iA.odt{i},iA.cdt{i}]=iA.CALCdtsingle(iA.idata(i,:),iA.dt);
           end
        end
        
        function matches=IAOtagfind(iA,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matches=cellfun(tagfindfx(tag),iA.itags);
        end
        
        function matchindex=IAOnamefind(iA,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matchindex=find(cellfun(tagfindfx(tag),iA.iwaveNames));
        end
            
        function iA=IAOsave(iA)
           save(sprintf('%s%s',iA.dirSave,iA.dirFile),'iA')
           fprintf('Saved to %s%s\n',iA.dirSave,iA.dirFile);
        end
    end
    
    methods (Static=true)
        function dtarray=CALCdtarray(dtlist,ind)
            dtl=cellfun(@length,dtlist(ind));
            ndt=sum(dtl);
            dtarray=NaN(ndt,1);
            dtcnt=1;
            for i=1:length(ind)
                dtarray(dtcnt:sum(dtl(1:i)))=dtlist{ind(i)};
                dtcnt=sum(dtl(1:i))+1;
            end
        end
        
        function [odt,cdt]=CALCdtsingle(iWave,dt)
            fli=find(iWave,1,'first');
            now=1; %channel is open at first latency
            odt=[];
            cdt=[];
            if ~isnan(fli) %do not continue if there is no frist latency
                i(now)=fli;
                state(now)=logical(iWave(i(now)));
                while 1
                    now=now+1;
                    prev=now-1;
                    %look for change in current state
                    if isempty(find(iWave(i(prev):end)~=state(prev),1,'first'))
                        break %stop if there are no more changes in state
                    else
                        % get index of state change 
                        i(now)=i(prev)-1+find(iWave(i(prev):end)~=state(prev),1,'first');
                        % update current state
                        state(now)=logical(iWave(i(now)));
                    end
                end
                
                % collect indices of state changes
                oi=i(state);
                ci=i(~state);
                
                if state(end)
                    %wave ends in open state --> reject last open time
                    if ~isempty(ci)
                    odt=(ci-oi(1:end-1))*dt*1e3; %in ms
                    cdt=(oi(2:end)-ci)*dt*1e3; %in ms
                    else %there is only 1 opening and should be rejected
                       odt=[];
                       cdt=[];
                    end
                else
                    %wave ends in closed state --> reject last closed time
                    odt=(ci-oi)*dt*1e3; %in ms
                    cdt=(oi(2:end)-ci(1:end-1))*dt*1e3; %in ms
                end
            end
        end
    end
end