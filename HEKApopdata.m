classdef HEKApopdata < handle
    %HEKAPOPDATA Collection of population data for figures
    %   Collection of population data for control, free and bound for all
    %   patches
    
    properties
        names           % patch/cell identifiers
                        % number of trials for each tag
        n = struct('ccc',[],'ooo',[],'coc',[],'zzz',[],'total',[]);
        
        isingle         % single-channel current 
        popen           % open probability
        hath            % half-amplitude threshold
        hathi           % index of hath
                        % gaussian function for hist fits
        gaussfx=@(b,x)(b(3).*normalize(normpdf(x,b(1),b(2))));
        hc_coeffs   % fit coefficients for closed peak
        ho_coeffs   % fit coefficients for open peak
        
        averagei        % steady state current (>100 ms) of singles average current
        tactivation     % activation tau fit to 10%-90% rise of singles average current
                        % activation equation
        actfx=@(b,t)( b(1) * (1 - exp(-t./b(2)) ).^b(3) );
        act_coeffs      % fit coefficients to extract activation tau
        
                        % activation equation
        taufx=@(b,t)((1 - exp(-t./b(1)) ).^b(2) );
        tflats          % tau of first latencies 
        tflat_coeffs    % fit coefficients to extract tau of first latencies (using same activation equation)
        
        popen_afo       % mean open probability after first opening
        popen_afosd     % s.d. open probability after first opening
        popen_afon      % n trials with openings
        
        odt1            % tau of closing
        
        cdt1            % 1st tau of opening
        cdt2            % 2nd tau of opening
        cdt3            % 3rd tau of opening
        
        cdtlong         % fraction of closed dwell times > 100 ms
        cdtnlong        % number of closed dwell times > 100ms
        cdtntotal       % number of closed dwell times
        
        % path
        dirSave='/Users/angueyraaristjm/Documents/DataGxTx/HEKApopdata/';
        dirFile
    end
    
    methods
        function popdata=HEKApopdata(filename)
            popdata.dirFile=sprintf('%s',filename);
            if exist(sprintf('%s%s.mat',popdata.dirSave,popdata.dirFile),'file')==2
                temp_pd=load(sprintf('%s%s',popdata.dirSave,popdata.dirFile));
                popdata=temp_pd.popdata;
                fprintf('Loaded pop data saved version\n')
            else
                if ~isa(filename,'char')
                    error('initial parsing/loading requires a valid filename as input')
                end
            end
        end
        
        function popdata=HEKAsave(popdata)
           save(sprintf('%s%s',popdata.dirSave,popdata.dirFile),'popdata')
           fprintf('Saved to %s%s\n',popdata.dirSave,popdata.dirFile);
        end
        
        function popdata=HEKApafo(popdata,iA,idx,tag)
            % calculates the open probability after the first opening
            tagi=find(iA.IAOtagfind(tag));
            popen=NaN(1,sum(~isnan(iA.flati(tagi))));
            popen_afo=NaN(1,sum(~isnan(iA.flati(tagi))));
            cnt=0;
            for p=1:size(tagi,1)
                i=tagi(p);
                if ~isnan(iA.flati(i))
                    cnt=cnt+1;
                    popen(cnt)=sum(iA.idata(i,1:end))/size(iA.idata(i,1:end),2);
                    popen_afo(cnt)=sum(iA.idata(i,iA.flati(i):end))/size(iA.idata(i,iA.flati(i):end),2);
                end
            end

            popdata.popen_afo(idx)=mean(popen_afo);
            popdata.popen_afosd(idx)=std(popen_afo);
            popdata.popen_afon(idx)=sum(~isnan(iA.flati(tagi)));
            
            f3=getfigH(3);
            lH=line(popen,popen_afo,'Parent',f3);
            set(lH,'Marker','o','LineStyle','none');
            
            lH=line([0 1],[0 1],'Parent',f3);
            set(lH,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
        end
        
        function popdata=HEKAhistfit(popdata,hs,idx)
            % calculates single channel current and open probability based
            % on histogram structure derived from hekadat.HEKAhistbytag and
            % stores results on idx index
            
            tg=1.1/2; %threshold guess
%             tg=1.4/2; %threshold guess
            tg_ind=find(hs.hx<tg,1,'last');
            c_peak=max(hs.hy(1:tg_ind));
            c_i=find(hs.hy==c_peak);
            c_hw1=find(hs.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
            c_hw2=find(hs.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
            o_peak=max(hs.hy(tg_ind+1:end));
            o_i=find(hs.hy==o_peak);
            o_hw1=find(hs.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
            o_hw2=find(hs.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width
            
            gauss=popdata.gaussfx;
            c0=[0 0.1 c_peak];
            c_coeffs=nlinfit(hs.hx(c_hw1:c_hw2),hs.hy(c_hw1:c_hw2),gauss,c0);
            fprintf('c_coeffs = %.03f \t%.03f \t%.03f\n',c_coeffs)
            
            o0=[hs.hx(o_i) 0.1 o_peak];
            o_coeffs=nlinfit(hs.hx(o_hw1:o_hw2),hs.hy(o_hw1:o_hw2),gauss,o0);
            fprintf('o_coeffs = %.03f\t%.03f\t%.03f\n',o_coeffs)
            
            popdata.isingle(idx)=o_coeffs(1)-c_coeffs(1);
            popdata.hath(idx)=((o_coeffs(1)-c_coeffs(1))/2)+c_coeffs(1);
            popdata.hathi(idx)=find(hs.hx>=popdata.hath(idx),1,'first');
            popdata.popen(idx)=(trapz(hs.hx(popdata.hathi(idx):end),hs.hy(popdata.hathi(idx):end)))./...
                (trapz(hs.hx,hs.hy));
            popdata.hc_coeffs(idx,:)=c_coeffs;
            popdata.ho_coeffs(idx,:)=o_coeffs;
        end
        
        function popdata=HEKAtauact(popdata,t,single_ave,idx)
            % calculates mean current of single average after 100ms and
            % fits them to extract a time constant for activation
            averagei=mean(single_ave(t>.1)); %#ok<*PROPLC>
            i10=find(single_ave>=averagei*.1,1,'first');
            i90=find(single_ave<=averagei*.9,1,'last');

            a0=[averagei .004 1];
            a_coeffs=nlinfit(t(i10:i90),single_ave(i10:i90),popdata.actfx,a0);
            fprintf('a_coeffs = %.03f\t%.03f\t%.03f\n',a_coeffs)
            popdata.tactivation(idx)=a_coeffs(2)*1000;
            popdata.averagei(idx)=averagei;
            popdata.act_coeffs(idx,:)=a_coeffs;
            
            f1=getfigH(1);
            lH=line(t,single_ave,'Parent',f1);
            set(lH,'marker','o','linewidth',2)
            
            lH=line(t,popdata.actfx(a_coeffs,t),'Parent',f1);
            set(lH,'marker','none','linestyle','-','color','r','linewidth',2)
        end
        
        function popdata=HEKAtauflat2(popdata,flati,flatp,idx)
            % calculates mean current of single average after 100ms and
            % fits them to extract a time constant for activation
            i10=find(flatp>=0,1,'first');
            i90=find(flatp<=.90,1,'last');

            a0=[10 1];
            a_coeffs=nlinfit(flati(i10:i90),flatp(i10:i90),popdata.taufx,a0);
            fprintf('a_coeffs = %.03f\t%.03f\n',a_coeffs)
            popdata.tflats(idx)=a_coeffs(1);
            popdata.tflat_coeffs(idx,:)=a_coeffs;

            f2=getfigH(2);
            lH=line(flati,flatp,'Parent',f2);
            set(lH,'marker','o','linewidth',2)
            
            lH=line(flati,popdata.taufx(a_coeffs,flati),'Parent',f2);
            set(lH,'marker','none','linestyle','-','color','r','linewidth',2)
        end
        
        function popdata=HEKAtauflat(popdata,flati,flatp,idx)
            % calculates mean current of single average after 100ms and
            % fits them to extract a time constant for activation
            i10=find(flatp>=0,1,'first');
            i90=find(flatp<=1,1,'last');

            a0=[1 6 1];
            a_coeffs=nlinfit(flati(i10:i90),flatp(i10:i90),popdata.actfx,a0);
            fprintf('a_coeffs = %.03f\t%.03f\t%.03f\n',a_coeffs)
            popdata.tflats(idx)=a_coeffs(2);
            popdata.tflat_coeffs(idx,:)=a_coeffs;

            f2=getfigH(2);
            lH=line(flati,flatp,'Parent',f2);
            set(lH,'marker','o','linewidth',2)
            
            lH=line(flati,popdata.actfx(a_coeffs,flati),'Parent',f2);
            set(lH,'marker','none','linestyle','-','color','r','linewidth',2)
        end
    end
    
    methods (Static = true)

    end
    
end

