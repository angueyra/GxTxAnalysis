classdef HEKApopdata < handle
    %HEKAPOPDATA Collection of population data for figures
    %   Collection of population data for control, free and bound for all
    %   patches
    
    properties
        names
        n = struct('ccc',[],'ooo',[],'coc',[],'zzz',[],'total',[]);
        
        isingle
        popen
        hath
        hathi
        
        tactivation
        averagei
        actfx=@(b,t)( b(1) * (1 - exp(-t./b(2)) ).^b(3) );
        act_coeffs
        
        tflats
        tflat_coeffs
        
        odt1
        
        cdt1
        cdt2
        cdt3
        
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
            
            gauss=@(b,x)(b(3).*normalize(normpdf(x,b(1),b(2))));
            c0=[0 0.1 c_peak];
            c_coeffs=nlinfit(hs.hx(c_hw1:c_hw2),hs.hy(c_hw1:c_hw2),gauss,c0);
            fprintf('c_coeffs = %.03f \t%.03f \t%.03f\n',c_coeffs)
            
            o0=[hs.hx(o_i) 0.1 o_peak];
            o_coeffs=nlinfit(hs.hx(o_hw1:o_hw2),hs.hy(o_hw1:o_hw2),gauss,o0);
            fprintf('o_coeffs = %.03f\t%.03f\t%.03f\n',o_coeffs)
            
            popdata.isingle(idx)=o_coeffs(1)-c_coeffs(1);
            popdata.hath=((o_coeffs(1)-c_coeffs(1))/2)+c_coeffs(1);
            popdata.hathi=find(hs.hx>=popdata.hath,1,'first');
            popdata.popen(idx)=(trapz(hs.hx(popdata.hathi:end),hs.hy(popdata.hathi:end)))./...
                (trapz(hs.hx,hs.hy));
        end
        
        function popdata=HEKAtauact(popdata,t,single_ave,idx)
            % calculates mean current of single average after 100ms and
            % fits them to extract a time constant for activation
            averagei=mean(single_ave(t>.1)); %#ok<*PROPLC>
            i10=find(single_ave>=averagei*.1,1,'first');
            i90=find(single_ave<=averagei*.9,1,'last');

            a0=[1 1 1];
            a_coeffs=nlinfit(t(i10:i90),single_ave(i10:i90),popdata.actfx,a0);
            fprintf('a_coeffs = %.03f\t%.03f\t%.03f\n',a_coeffs)
            popdata.tactivation(idx)=a_coeffs(2);
            popdata.averagei(idx)=averagei;
            popdata.act_coeffs(idx,:)=a_coeffs;
        end
        
        function popdata=HEKAtauflat(popdata,flati,flatp,idx)
            % calculates mean current of single average after 100ms and
            % fits them to extract a time constant for activation
            i10=find(flatp>=.1,1,'first');
            i90=find(flatp<=.9,1,'last');

            a0=[1 1 1];
            a_coeffs=nlinfit(flati(i10:i90),flatp(i10:i90),popdata.actfx,a0);
            fprintf('a_coeffs = %.03f\t%.03f\t%.03f\n',a_coeffs)
            popdata.tflats(idx)=a_coeffs(2);
            popdata.tflat_coeffs(idx,:)=a_coeffs;

%             f1=getfigH(1);
%             lH=line(flati,flatp,'Parent',f1);
%             set(lH,'marker','o')
%             
%             lH=line(flati,popdata.actfx(a_coeffs,flati),'Parent',f1);
%             set(lH,'marker','none','linestyle','-','color','r')
        end
    end
    
    methods (Static = true)

    end
    
end

