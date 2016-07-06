classdef iASubObj < handle
    properties
        % analysis restrictions
        istart
        iend
        index
        nbins
        % sorted first latencies
        flat
        flatp
        % open dwell times histogram and fit
        odt
        omin
        omax
        ohx
        ohy
        osx
        osy
        ofx
        ofxname
        ocoeffs
        ofit
        % closed dwell times histogram and fit
        cdt
        cmin
        cmax
        chx
        chy
        csx
        csy
        cfx
        cfxname
        ccoeffs
        cfit
    end
    
    properties (SetAccess = private)
    end
    
    methods
        function iASO=iASubObj()
        end
        
        function iASO=IAOunmixflats(iASO)
            iASO.flat=sort(iASO.flat(~isnan(iASO.flat)));
            iASO.flatp=(0:1/length(iASO.flat):1-1/length(iASO.flat))';
        end
        function iASO=IAOologhist(iASO)
            if isempty(iASO.odt)
                error('No open dwell time array provided\n')
            end
            logodt=log10(iASO.odt);
            logbins=linspace(iASO.omin,iASO.omax,iASO.nbins);
            d=diff(logbins)/2;
            iASO.ohx= [logbins(1:end-1)+d, logbins(end)]';               
            iASO.ohy=sqrt(histc(logodt,logbins));                      
            [iASO.osx,iASO.osy]=stairs(logbins,iASO.ohy);
        end
        
        function iASO=IAOcloghist(iASO)
            if isempty(iASO.cdt)
                error('No closed dwell time array provided\n')
            end
            logcdt=log10(iASO.cdt);
            logbins=linspace(iASO.cmin,iASO.cmax,iASO.nbins);
            d=diff(logbins)/2;
            iASO.chx= [logbins(1:end-1)+d, logbins(end)]';               
            iASO.chy=sqrt(histc(logcdt,logbins));                      
            [iASO.csx,iASO.csy]=stairs(logbins,iASO.chy);
        end
        
        function iASO=IAOohistfit(iASO,varargin)
            if nargin==2
                oguess=varargin{1};
            end
            if isempty(oguess)
                oguess=[20 log10(10)];
            end
            logexp=@(q,x)(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
            logbinexp=@(q,x)sqrt( (10.^x) .* (  logexp(q,x)  ) );
            
            iASO.ocoeffs=nlinfit(iASO.ohx,iASO.ohy,logbinexp,oguess);
            iASO.ofit=logbinexp(iASO.ocoeffs,iASO.ohx);
            iASO.ofx=logbinexp;
            iASO.ofxname='logbinexp';
            fprintf('_________________________________________\n')
            fprintf('Fit of open dwell times:\n')
            fprintf('\ttau = %g ms\n\talpha = %g\n',round(10^(iASO.ocoeffs(2))*1000)/1000,round((iASO.ocoeffs(1))*1000)/1000)
            fprintf('-----------------------------------------\n')
        end
        
        function iASO=IAOchistfit(iASO,varargin)
            if nargin==2
                cguess=varargin{1};
            end
            if isempty(cguess)
                cguess=[ 10 -0.1 4 0.9];
            end
            logexp=@(q,x)(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
            dblogbinexp=@(q,x)sqrt( (10.^x) .* (  logexp([q(1) q(2)],x) + logexp([q(3) q(4)],x)  ) );
            
            iASO.ccoeffs=nlinfit(iASO.chx,iASO.chy,dblogbinexp,cguess);
            iASO.cfit=dblogbinexp(iASO.ccoeffs,iASO.chx);
            iASO.cfx=dblogbinexp;
            iASO.cfxname='dblogbinexp';
            fprintf('_________________________________________\n')
            fprintf('Fit of closed dwell times:\n')
            fprintf('   First exponential\tSecond exponential\n')
            fprintf('     tau1 = %g ms\t   tau2 = %g ms\n',round(10^(iASO.ccoeffs(2))*1000)/1000,round(10^(iASO.ccoeffs(4))*1000)/1000)
            fprintf('     alpha1 = %g\t   alpha2 = %g ms\n\n',round((iASO.ccoeffs(1))*1000)/1000,round((iASO.ccoeffs(3))*1000)/1000)
            fprintf('-----------------------------------------\n')
        end
        
        function iASO=IAOchistfit3(iASO,varargin)
            if nargin==2
                cguess=varargin{1};
            end
            if isempty(cguess)
                cguess=[13 1 9 1.5 4 2.1];
                
            end
            logexp=@(q,x)(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
            tlogbinexp=@(q,x)sqrt( (10.^x) .* (  logexp([q(1) q(2)],x) + logexp([q(3) q(4)],x) + logexp([q(5) q(6)],x)  ) );
            
            try
                iASO.ccoeffs=nlinfit(iASO.chx,iASO.chy,tlogbinexp,cguess);
            catch ME
                if strcmp(ME.identifier,'stats:nlinfit:NonFiniteFunOutput')
                    iASO.ccoeffs=(cguess./cguess)*1e-3;
                    fprintf('ERROR: nlinfit failed, all coeffs will be 1e-3\n')
                end
            end
            
            
            iASO.cfit=tlogbinexp(iASO.ccoeffs,iASO.chx);
            iASO.cfx=tlogbinexp;
            iASO.cfxname='tlogbinexp';
            fprintf('_________________________________________\n')
            fprintf('Fit of closed dwell times:\n')
            fprintf('   First exponential\tSecond exponential\n')
            fprintf('     tau1 = %g ms\t   tau2 = %g ms\t   tau3 = %g ms\n',round(10^(iASO.ccoeffs(2))*1000)/1000,round(10^(iASO.ccoeffs(4))*1000)/1000,round(10^(iASO.ccoeffs(6))*1000)/1000)
            fprintf('     alpha1 = %g\t   alpha2 = %g \t   alpha3 = %g \n\n',round((iASO.ccoeffs(1))*1000)/1000,round((iASO.ccoeffs(3))*1000)/1000,round((iASO.ccoeffs(5))*1000)/1000)
            fprintf('-----------------------------------------\n')
        end
    end
    
    methods (Static=true)
        function y=logexp(q,x)
            y=(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
        end
    end
end
