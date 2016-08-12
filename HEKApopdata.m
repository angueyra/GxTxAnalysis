classdef HEKApopdata < handle
    %HEKAPOPDATA Collection of population data for figures
    %   Collection of population data for control, free and bound for all
    %   patches
    
    properties
        names
        n = struct('ccc',[],'ooo',[],'coc',[],'zzz',[],'total',[]);
        
        isingle
        popen
        
        tactivation
        averagei
        
        tflats
        
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
        
        
    end
    
    methods (Static = true)
        function isingle=histfit(histx,histy)
            
            tg=1.1/2; %threshold guess
%             tg=1.4/2; %threshold guess
            tg_ind=find(histx<tg,1,'last');
            c_peak=max(histy(1:tg_ind));
            c_i=find(histy==c_peak);
            c_hw1=find(histy(1:tg_ind)>c_peak/2,1,'first'); %half width
            c_hw2=find(histy(1:tg_ind)>c_peak/2,1,'last'); %half width
            o_peak=max(histy(tg_ind+1:end));
            o_i=find(histy==o_peak);
            o_hw1=find(histy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
            o_hw2=find(histy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width
            
            gauss=@(b,x)(b(3).*normalize(normpdf(x,b(1),b(2))));
            c0=[0 0.1 c_peak];
            c_coeffs=nlinfit(histx(c_hw1:c_hw2),histy(c_hw1:c_hw2),gauss,c0);
            fprintf('c_coeffs = %.2g \t%.2g \t%.2g\n',c_coeffs)
            
            o0=[histx(o_i) 0.1 o_peak];
            o_coeffs=nlinfit(histx(o_hw1:o_hw2),histy(o_hw1:o_hw2),gauss,o0);
            fprintf('o_coeffs = %.2g \t%.2g \t%.2g\n',o_coeffs)
            
            isingle=o_coeffs(1)-c_coeffs(1);
        end
    end
    
end

