classdef HEKAdat < handle
    % with classdef HEKAdat<handle, all modificaitons of hekadat objects immediately apply to it
    % it no longer works as a workspace variable
    properties
        % raw data
        data
        tAxis
        dt
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
        % distributions
        histx
        histy
        histfx %gaussian
        hist_c % fit coefficients for closed
        hist_o % fit coefficients for open
        hath %half-amplitude threshold
        stairx
        stairy
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
            hekadat.dt=hekadat.tAxis(2)-hekadat.tAxis(1);
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
        
        function matches=HEKAitagfind(hekadat,tag)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            matches=cellfun(tagfindfx(tag),hekadat.itags);
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
        
        
        function HEKAinitialsubtraction(hekadat)
            if isempty(hekadat.sdata)
                tst=hekadat.HEKAstairsprotocol();
                selWaves=logical(hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('ooo')+hekadat.HEKAtagfind('coc'));
                hekadat.swaveNames=hekadat.waveNames(selWaves);
                hekadat.stags=hekadat.tags(selWaves);
                hekadat.stAxis=hekadat.tAxis(1:tst.deltai);
                cccmean=hekadat.HEKAtagmean('ccc');
                hekadat.sdata=hekadat.data(selWaves,tst.sti:tst.endi)-repmat(cccmean(tst.sti:tst.endi),size(hekadat.swaveNames,1),1);
                hekadat.sBaseline=zeros(size(hekadat.sdata,1),1);
            end
        end
        
        function HEKAguessBaseline(hekadat)
            % trying to guess baseline subtraction for already
            % ccc-subtracted date from ccc themselves
            if isempty(hekadat.sBaseline)
                error('First run hekadat.HEKAinitialsubtraction();')
            else
                fprintf('Only replacing empty values in sBaseline...')
                Flanks_ind=NaN(size(hekadat.sBaseline,1),2);
                guessBaseline=NaN(size(hekadat.sBaseline,1),1);
                
                cccs=hekadat.HEKAstagfind('ccc')';
                
                currL=find(cccs,1,'first');
                currR=find(cccs,1,'first');
                
                Flanks_ind(1:currL,1)=currL;
                Flanks_ind(1:currL,2)=currR;
                
                for i=currL+1:length(cccs)
                    if cccs(i)
                        currL=currR;
                        currR=i;
                    end
                    Flanks_ind(i,1)=currL;
                    Flanks_ind(i,2)=currR;
                    
                    guessBaseline(i)=(mean(hekadat.sdata(currL,floor(end/2):end))+mean(hekadat.sdata(currR,floor(end/2):end)))/2;
                end
                hekadat.sBaseline(hekadat.sBaseline==0)=guessBaseline(hekadat.sBaseline==0);
                hekadat.HEKAsave;
                fprintf('...Done!\n')
            end
        end
        
        
        function HEKAsUpdate(hekadat)
            % use if went back to change tags because discovered errors
            % after baseline subtraction and correction
            % works by finding difference between sWaveNames (saved) and
            % uWaveNames (updated)
            if isempty(hekadat.sdata)
                error('Nothing to update. Run hekadat.HEKAinitialsubtraction first\n')
            else
                strfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
                
                uwaves=logical(hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('ooo')+hekadat.HEKAtagfind('coc'));
                uwaveNames=hekadat.waveNames(uwaves);
                utags=hekadat.tags(uwaves);

                umatch=NaN(size(uwaveNames));
                uBaseline=NaN(size(uwaveNames));
                for i=1:size(uwaveNames)
                    umatch(i)=find(cellfun(strfindfx(uwaveNames{i}),hekadat.swaveNames));
                    if ~isnan(umatch(i))
                        % epochs that are still ccc ooo or coc remain,
                        % epochs that got swapped to bad, zzz or untagged will not match
                        uBaseline(i)=hekadat.sBaseline(umatch(i));
                    else
                        %new epoch was added. Can still run HEKAguessBaseline to adjust these epochs
                        uBaseline(i)=0;
                    end
                end

                tst=hekadat.HEKAstairsprotocol();
                hekadat.swaveNames=uwaveNames;
                hekadat.stags=utags;
                cccmean=hekadat.HEKAtagmean('ccc');
                hekadat.sdata=hekadat.data(uwaves,tst.sti:tst.endi)-repmat(cccmean(tst.sti:tst.endi),size(hekadat.swaveNames,1),1);
                hekadat.sBaseline=uBaseline;
                fprintf('Check results then HEKAsave\n')

            end
        end
        
        
        function blData=HEKAbldata(hekadat,varargin)
            %baseline corrected data
            if isempty(hekadat.sBaseline)
                error('Run refineBlanks and refineBaseline first\n')
            else
                if nargin==1 %spit out entire data matrix 
                    blData=hekadat.sdata-repmat(hekadat.sBaseline,1,size(hekadat.sdata,2));
                elseif nargin==2
                    i=varargin{1};
                    blData=hekadat.sdata(i,:)-hekadat.sBaseline(i);
                end
            end
        end
        
        function iA=HEKAianalyze(hekadat)
            %analyze idealized waves
            if isempty(hekadat.idata)
                error('Idealize data first\n')
            end
            iA=struct;
            iA.firstlatsi=hekadat.HEKAfirstlatsi;
            iA.firstlats=hekadat.HEKAfirstlats; %in ms
            iA.cumfirstlats=sort(iA.firstlats)./length(iA.firstlats); %in ms
            [iA.odt,iA.cdt]=hekadat.HEKAdwelltimes; %in ms
        end
        
        function firstlats=HEKAfirstlats(hekadat)
            %first latencies
            firstlats=NaN(size(hekadat.idata,1),1);
            for i=1:size(hekadat.idata,1)
                if ~isempty(find(hekadat.idata(i,:),1,'first'))
                    firstlats(i)=hekadat.itAxis(find(hekadat.idata(i,:),1,'first'))*1e3;
                end
            end
        end
        
        function firstlatsi=HEKAfirstlatsi(hekadat)
            %first latencies indices
            firstlatsi=NaN(size(hekadat.idata,1),1);
            for i=1:size(hekadat.idata,1)
                if ~isempty(find(hekadat.idata(i,:),1,'first'))
                    firstlatsi(i)=find(hekadat.idata(i,:),1,'first');
                end
            end
        end
        
        function [odt,cdt]=HEKAdwelltimes(hekadat)
            if isempty(hekadat.idata)
                error('Please idealize data first\n')
            else
                odt=[];
                cdt=[];
                for i=1:size(hekadat.idata,1)
                    [curr_odt,curr_cdt]=HEKAdwelltime_single(hekadat,i);
                    odt=[odt curr_odt];
                    cdt=[cdt curr_cdt];
                end
            end
        end
        
        function [odt,cdt]=HEKAdwelltime_single(hekadat,index)
            ideData=hekadat.idata(index,:);
            fli=hekadat.HEKAfirstlatsi;
            fli=fli(index);
            
            now=1;
            odt=[];
            cdt=[];
            
            if ~isnan(fli)
                i(now)=fli;
                state(now)=logical(ideData(i(now)));
                
                while 1
                    now=now+1;
                    prev=now-1;
                    if isempty(find(ideData(i(prev):end)~=state(prev),1,'first'))
                        break
                    else
                        i(now)=i(prev)-1+find(ideData(i(prev):end)~=state(prev),1,'first');
                        state(now)=logical(ideData(i(now)));
                    end
                    
                end
                
                oi=i(state);
                ci=i(~state);
                
                if state(end)
                    %wave ends in open state
                    odt=(ci-oi(1:end-1))*hekadat.dt*1e3; %in ms
                    cdt=(oi(2:end)-ci)*hekadat.dt*1e3; %in ms
                else
                    %wave ends in open state
                    odt=(ci-oi)*hekadat.dt*1e3; %in ms
                    cdt=(oi(2:end)-ci(1:end-1))*hekadat.dt*1e3; %in ms
                end
            end
        end
    end
    
    methods (Static=true)
        function idata=HEKAidealize(data,hath)
            idata=zeros(size(data));
            idata(data>hath)=1;
        end
        
        function [hx,hy,sx,sy]=HEKAhist(wave,nbins,edgemin,edgemax)
            bins=linspace(edgemin,edgemax,nbins);
            hy=histc(wave,bins);
            d=diff(bins)/2;
            hx= [bins(1:end-1)+d, bins(end)];
            if nargout>2 && nargout==4
                [sx,sy]=stairs(bins,hy);
            end
        end
        
        function [hx_log,hy_log,sx_log,sy_log]=HEKAloghist(wave,nbins,edgemin,edgemax)
            wave_log=log10(wave);
            logbins=linspace(edgemin,edgemax,nbins);
            d=diff(logbins)/2;
            hx_log= [logbins(1:end-1)+d, logbins(end)];                   
            hy_log=sqrt(histc(wave_log,logbins));                      
            if nargout>2 && nargout==4
                [sx_log,sy_log]=stairs(logbins,hy_log);
            end
        end
        
    end
end