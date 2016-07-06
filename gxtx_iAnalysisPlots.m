classdef gxtx_iAnalysisPlots<iAnalysisGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_iAnalysisPlots(iA,params,fign)
            params=checkStructField(params,'norm',0);
            params=checkStructField(params,'notx_start',1);
            params=checkStructField(params,'notx_end',iA.n);
            params=checkStructField(params,'gxtx_start',1);
            params=checkStructField(params,'gxtx_end',iA.n);
            
            params=checkStructField(params,'nbins',140);
            params=checkStructField(params,'omin',-.5);
            params=checkStructField(params,'omax',2.5);
            params=checkStructField(params,'cmin',-.5);
            params=checkStructField(params,'cmax',3);

            hGUI@iAnalysisGUI(iA,params,fign);
            
            pleft=.05;
            pwidth=.35;
            pheight=.35;
            ptop=.98-pheight;
            
            bw=.065;
            bh=0.08;
            btop=ptop-pheight+.15;
            % Save Button
            lockBt=struct('Position', [pleft+pwidth-bw btop bw+.02 bh],'String','Lock&Save');
            hGUI.lockButton(lockBt);
            
            % Sliders
            lSlide=struct('tag','leftSlider','Position',[pleft-.015 ptop-pheight/2+.075 pwidth+.03 .05]);
            lSlide.Min=1;
            lSlide.Max=iA.n;
            lSlide.Value=params.notx_start;
            lSlide.SliderStep=[1/iA.n 20/iA.n];
            lSlide.Callback=@hGUI.lSlideCall;
            hGUI.createSlider(lSlide);
            
            rSlide=struct('tag','rightSlider','Position',[pleft-.015 ptop-pheight/2+.045 pwidth+.03 .05]);
            rSlide.Min=1;
            rSlide.Max=iA.n;
            rSlide.Value=params.notx_end;
            rSlide.SliderStep=[1/iA.n 20/iA.n];
            rSlide.Callback=@hGUI.lSlideCall;
            hGUI.createSlider(rSlide);
            
            % Accept Restriction button
            restrictBt=struct('tag','Restrict','Position',[pleft btop .065 .08]);
            restrictBt.Callback=@hGUI.restrictCall;
            hGUI.createButton(restrictBt);
            
            % odt Fit button
            odtfitBt=struct('tag','odtFit','Position',[pleft+bw*1.1 btop .065 .08]);
            odtfitBt.Callback=@hGUI.odtfitCall;
            hGUI.createButton(odtfitBt);
            
            % cdt Fit button
            cdtfitBt=struct('tag','cdtFit','Position',[pleft+bw*2.2 btop .065 .08]);
            cdtfitBt.Callback=@hGUI.cdtfitCall;
            hGUI.createButton(cdtfitBt);
            
            % State evolution (as cumulative probablity)
            plotEvolution=struct('Position',[pleft ptop pwidth pheight],'tag','plotEvolution');
            plotEvolution.YLim=[0 1.05];
            plotEvolution.XLim=[1 iA.n];
            hGUI.makePlot(plotEvolution);
            hGUI.labelx(hGUI.figData.plotEvolution,'n');
            hGUI.labely(hGUI.figData.plotEvolution,'Cum. Prob.');
            
            %left line
            lH=line([lSlide.Value lSlide.Value],plotEvolution.YLim,'Parent',hGUI.figData.plotEvolution);
            set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .75 .75])
            set(lH,'DisplayName','leftLine')
            %right line
            lH=line([rSlide.Value rSlide.Value],plotEvolution.YLim,'Parent',hGUI.figData.plotEvolution);
            set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 1])
            set(lH,'DisplayName','rightLine')
            
            %State Evolution
            ooo=iA.IAOtagfind('ooo');
            coc=iA.IAOtagfind('coc');
            ccc=iA.IAOtagfind('ccc');
            nwaves=(1:iA.n)';
            % ooo cum prob
            oooH=line(nwaves,cumsum(ooo)./(nwaves),'Parent',hGUI.figData.plotEvolution);
            set(oooH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(oooH,'DisplayName','ooo')
            % coc cum prob
            cocH=line(nwaves,cumsum(coc)./(nwaves),'Parent',hGUI.figData.plotEvolution);
            set(cocH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(cocH,'DisplayName','coc')
            % ccc cum prob
            cccH=line(nwaves,cumsum(ccc)./(nwaves),'Parent',hGUI.figData.plotEvolution);
            set(cccH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[.5 .5 .5])
            set(cccH,'DisplayName','ccc')
            
            % State evolution (as cumulative counts)
            plotEvolution2=struct('Position',[pleft 0.05 pwidth pheight],'tag','plotEvolution2');
            plotEvolution2.YLim=[0 1.1*max([sum(ooo) sum(ccc) sum(coc)]./iA.n)];
            plotEvolution2.XLim=[1 iA.n];
            hGUI.makePlot(plotEvolution2);
            hGUI.labelx(hGUI.figData.plotEvolution2,'n');
            hGUI.labely(hGUI.figData.plotEvolution2,'Cum. Fraction');
            
            %left line
            lH=line([lSlide.Value lSlide.Value],plotEvolution2.YLim,'Parent',hGUI.figData.plotEvolution2);
            set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .75 .75])
            set(lH,'DisplayName','leftLine')
            %right line
            lH=line([rSlide.Value rSlide.Value],plotEvolution2.YLim,'Parent',hGUI.figData.plotEvolution2);
            set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 1])
            set(lH,'DisplayName','rightLine')
            
            % ooo cum prob
            oooH=line(nwaves,cumsum(ooo)./(iA.n),'Parent',hGUI.figData.plotEvolution2);
            set(oooH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(oooH,'DisplayName','ooo')
            % coc cum prob
            cocH=line(nwaves,cumsum(coc)./(iA.n),'Parent',hGUI.figData.plotEvolution2);
            set(cocH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(cocH,'DisplayName','coc')
            % ccc cum prob
            cccH=line(nwaves,cumsum(ccc)./(iA.n),'Parent',hGUI.figData.plotEvolution2);
            set(cccH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[.5 .5 .5])
            set(cccH,'DisplayName','ccc')
            
            pwidth2=.5;
            pheight2=.27;
            ptop2=0.98-pheight2;
            
            % First latencies (as cumulative counts)
            plotFlats=struct('Position',[pleft+pwidth+.1 ptop2 .95-pwidth2 pheight2],'tag','plotFlats');
            plotFlats.YLim=[0 1.05];
            plotFlats.XLim=[1 max(hGUI.iA.flat)*1.1];
            hGUI.makePlot(plotFlats);
            hGUI.labelx(hGUI.figData.plotFlats,'Time to first opening (ms)');
            hGUI.labely(hGUI.figData.plotFlats,'Cum. Prob.');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(lH,'DisplayName','notx_flat')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(lH,'DisplayName','gxtx_flat')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color',whithen([0 0 1],0.5))
            set(lH,'DisplayName','notx_imean')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color',whithen([1 0 0],0.5))
            set(lH,'DisplayName','gxtx_imean')
            
            % Open dwell times log hist
            plotOdt=struct('Position',[pleft+pwidth+.1 ptop2-pheight2-.05 .95-pwidth2 pheight2],'tag','plotOdt');
            %           plotOdt.YLim=[0 1.05];
            %           plotOdt.XLim=[1 iA.n];
            hGUI.makePlot(plotOdt);
            hGUI.labelx(hGUI.figData.plotOdt,'Open dwell time (ms)');
            hGUI.labelylatex(hGUI.figData.plotOdt,'$\sqrt(log(n))$');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','b')
            set(lH,'DisplayName','notx_odt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_odtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_otauh')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_otauv')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')
            set(lH,'DisplayName','gxtx_odt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_odtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_otauh')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_otauv')
            
            % Closed dwell times log hist
            plotCdt=struct('Position',[pleft+pwidth+.1 ptop2-pheight2*2-.1 .95-pwidth2 pheight2],'tag','plotCdt');
            %           plotCdt.YLim=[0 1.05];
            %           plotCdt.XLim=[1 iA.n];
            hGUI.makePlot(plotCdt);
            hGUI.labelx(hGUI.figData.plotCdt,'Closed dwell time (ms)');
            hGUI.labelylatex(hGUI.figData.plotCdt,'$\sqrt(log(n))$');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','b')
            set(lH,'DisplayName','notx_cdt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_cdtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_cdtfits1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_cdtfits2')
                        
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_ctauh1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_ctauv1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_ctauh2')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_ctauv2')
            
            
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')
            set(lH,'DisplayName','gxtx_cdt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_cdtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_cdtfits1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_cdtfits2')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_cdtfits3')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauh1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauv1')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauh2')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauv2')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauh3')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_ctauv3')
            
            
            hGUI.updatePlots();
        end
        
        function [notx,gxtx]=calculateHISTs(hGUI,~,~)
            hGUI.disableGui;
            iA=hGUI.iA;
            params=hGUI.params;
            
            % NO TOXIN
            notx=iASubObj;
            notx.istart=hGUI.params.notx_start;
            notx.iend=hGUI.params.notx_end;
            notx.nbins=params.nbins;
            notx.omin=params.omin;
            notx.omax=params.omax;
            notx.cmin=params.cmin;
            notx.cmax=params.cmax;
            % Get indices using restrictions
            notx.index=hGUI.iA.IAOtagfind('ooo');
            notx.index=find(notx.index(notx.istart:notx.iend));
            % first latencies
            notx.flat=iA.flat(notx.index);
            notx.IAOunmixflats;
            % open dwell times
            notx.odt=iA.CALCdtarray(iA.odt,notx.index);
            notx.IAOologhist;
            % closed dwell times
            notx.cdt=iA.CALCdtarray(iA.cdt,notx.index);
            notx.IAOcloghist;
            
            % GX TOXIN
            gxtx=iASubObj;
            gxtx.istart=hGUI.params.gxtx_start;
            gxtx.iend=hGUI.params.gxtx_end;
            gxtx.nbins=params.nbins;
            gxtx.omin=params.omin;
            gxtx.omax=params.omax;
            gxtx.cmin=params.cmin;
            gxtx.cmax=params.cmax;
            % Get indices using restrictions
            gxtx.index=hGUI.iA.IAOtagfind('coc');
            gxtx.index=find(gxtx.index(gxtx.istart:gxtx.iend));
            % first latencies
            gxtx.flat=iA.flat(gxtx.index);
            gxtx.IAOunmixflats;
            % open dwell times
            gxtx.odt=iA.CALCdtarray(iA.odt,gxtx.index);
            gxtx.IAOologhist;
            % closed dwell times
            gxtx.cdt=iA.CALCdtarray(iA.cdt,gxtx.index);
            gxtx.IAOcloghist;
            
        end
        
        function updatePlots(hGUI,~,~)
            hGUI.disableGui;
            
            if isempty(hGUI.iA.notx.ocoeffs)&&isempty(hGUI.iA.gxtx.ocoeffs)
                %first time running this
                [notx,gxtx]=calculateHISTs(hGUI);
                hGUI.params.notx=notx;
                hGUI.params.gxtx=gxtx;
            else
                %already saved version
                notx=hGUI.iA.notx;
                gxtx=hGUI.iA.gxtx;
                hGUI.params.notx=notx;
                hGUI.params.gxtx=gxtx;
                try
                hGUI.odtfitPlot;
                end
                try
                hGUI.cdtfitPlot;
                end
            end
            % NO TOXIN
            % first latencies
            notxflH=findobj('DisplayName','notx_flat');
            set(notxflH,'XData',notx.flat,'YData',notx.flatp)
%             notxflH=findobj('DisplayName','notx_imean');
%             set(notxflH,'XData',hGUI.iA.itAxis*1000,'YData',mean(hGUI.iA.idata(hGUI.iA.IAOtagfind('ooo'),:)))
            % open dwell times
            notxoH=findobj('DisplayName','notx_odt');
            set(notxoH,'XData',notx.osx,'YData',notx.osy)
            % closed dwell times
            notxoH=findobj('DisplayName','notx_cdt');
            set(notxoH,'XData',notx.csx,'YData',notx.csy)
            % GX TOXIN
            % first latencies
            gxtxflH=findobj('DisplayName','gxtx_flat');
            set(gxtxflH,'XData',gxtx.flat,'YData',gxtx.flatp)
%             gxaverage=mean(hGUI.iA.idata(hGUI.iA.IAOtagfind('coc'),:));
%             gxaverage=gxaverage./(1.1.*mean(gxaverage(round(length(gxaverage)/4):end)));
%             gxtxflH=findobj('DisplayName','gxtx_imean');
%             set(gxtxflH,'XData',hGUI.iA.itAxis*1000,'YData',gxaverage)
            % open dwell times
            gxtxoH=findobj('DisplayName','gxtx_odt');
            set(gxtxoH,'XData',gxtx.osx,'YData',gxtx.osy)
            % closed dwell times
            gxtxoH=findobj('DisplayName','gxtx_cdt');
            set(gxtxoH,'XData',gxtx.csx,'YData',gxtx.csy)
            
            hGUI.enableGui;
        end
        
        function odtfitCall(hGUI,~,~)
            hGUI.disableGui;
            fprintf('NO TOXIN\n')
            hGUI.params.notx.IAOohistfit([]);
            
            fprintf('GX TOXIN\n')
            hGUI.params.gxtx.IAOohistfit([]);
            
            hGUI.odtfitPlot;
            hGUI.enableGui;
        end
        
        function odtfitPlot(hGUI,~,~)
            % No Toxin
            nooc=hGUI.params.notx.ocoeffs;
            
            if ~hGUI.params.norm
                notxoH=findobj('DisplayName','notx_odtfit');
                set(notxoH,'XData',hGUI.params.notx.ohx,'YData',hGUI.params.notx.ofit)
                
                tauH=findobj('DisplayName','notx_otauh');
                set(tauH,'XData',[-.5 nooc(2)],'YData',[nooc(1) nooc(1)])
                
                tauH=findobj('DisplayName','notx_otauv');
                set(tauH,'XData',[nooc(2) nooc(2)],'YData',[0 nooc(1)])
            else
                notxoH=findobj('DisplayName','notx_odtfit');
                set(notxoH,'XData',hGUI.params.notx.ohx,'YData',hGUI.params.notx.ofit./nooc(1))
                
                tauH=findobj('DisplayName','notx_otauh');
                set(tauH,'XData',[-.5 nooc(2)],'YData',[nooc(1) nooc(1)]./nooc(1))
                
                tauH=findobj('DisplayName','notx_otauv');
                set(tauH,'XData',[nooc(2) nooc(2)],'YData',[0 nooc(1)]./nooc(1))
                % open dwell times
                notxoH=findobj('DisplayName','notx_odt');
                set(notxoH,'XData',hGUI.params.notx.osx,'YData',hGUI.params.notx.osy./nooc(1))
                
            end
            
            %Gx Toxin
            gxoc=hGUI.params.gxtx.ocoeffs;
            
            if ~hGUI.params.norm
                gxtxoH=findobj('DisplayName','gxtx_odtfit');
                set(gxtxoH,'XData',hGUI.params.gxtx.ohx,'YData',hGUI.params.gxtx.ofit)
                
                tauH=findobj('DisplayName','gxtx_otauh');
                set(tauH,'XData',[-.5 gxoc(2)],'YData',[gxoc(1) gxoc(1)])
                
                tauH=findobj('DisplayName','gxtx_otauv');
                set(tauH,'XData',[gxoc(2) gxoc(2)],'YData',[0 gxoc(1)])
            else
                gxtxoH=findobj('DisplayName','gxtx_odtfit');
                set(gxtxoH,'XData',hGUI.params.gxtx.ohx,'YData',hGUI.params.gxtx.ofit./gxoc(1))
                
                tauH=findobj('DisplayName','gxtx_otauh');
                set(tauH,'XData',[-.5 gxoc(2)],'YData',[gxoc(1) gxoc(1)]./gxoc(1))
                
                tauH=findobj('DisplayName','gxtx_otauv');
                set(tauH,'XData',[gxoc(2) gxoc(2)],'YData',[0 gxoc(1)]./gxoc(1))
                % normalized open dwell times
                gxtxoH=findobj('DisplayName','gxtx_odt');
                set(gxtxoH,'XData',hGUI.params.gxtx.osx,'YData',hGUI.params.gxtx.osy./gxoc(1))
            end
        end
        
        function cdtfitCall(hGUI,~,~)
            hGUI.disableGui;
            fprintf('NO TOXIN\n')
            hGUI.params.notx.IAOchistfit([]);
            
            fprintf('GX TOXIN\n')
            % hGUI.params.gxtx.IAOchistfit([]);  % double exponential
            hGUI.params.gxtx.IAOchistfit3([]); % triple exponential
            hGUI.cdtfitPlot;
            hGUI.enableGui;
        end
        
        function cdtfitPlot(hGUI,~,~)
            % No Toxin
            nocc=hGUI.params.notx.ccoeffs;
            notx_cfits1=sqrt( (10.^hGUI.params.notx.chx) .* hGUI.params.notx.logexp(nocc(1:2),hGUI.params.notx.chx));
            notx_cfits2=sqrt( (10.^hGUI.params.notx.chx) .* hGUI.params.notx.logexp(nocc(3:4),hGUI.params.notx.chx));
            
            if ~hGUI.params.norm
                notxoH=findobj('DisplayName','notx_cdtfit');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',hGUI.params.notx.cfit)
                
                notxoH=findobj('DisplayName','notx_cdtfits1');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',notx_cfits1)
                
                notxoH=findobj('DisplayName','notx_cdtfits2');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',notx_cfits2)
                
                tauH=findobj('DisplayName','notx_ctauh1');
                set(tauH,'XData',[-.5  nocc(2)],'YData',[nocc(1) nocc(1)])
                tauH=findobj('DisplayName','notx_ctauv1');
                set(tauH,'XData',[ nocc(2)  nocc(2)],'YData',[0 nocc(1)])
                
                tauH=findobj('DisplayName','notx_ctauh2');
                set(tauH,'XData',[-.5 nocc(4)],'YData',[nocc(3) nocc(3)])
                tauH=findobj('DisplayName','notx_ctauv2');
                set(tauH,'XData',[nocc(4) nocc(4)],'YData',[0 nocc(3)])
            else
                notxoH=findobj('DisplayName','notx_cdtfit');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',hGUI.params.notx.cfit./nocc(1))
                
                notxoH=findobj('DisplayName','notx_cdtfits1');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',notx_cfits1./nocc(1))
                
                notxoH=findobj('DisplayName','notx_cdtfits2');
                set(notxoH,'XData',hGUI.params.notx.chx,'YData',notx_cfits2./nocc(1))
                
                tauH=findobj('DisplayName','notx_ctauh1');
                set(tauH,'XData',[-.5  nocc(2)],'YData',[nocc(1) nocc(1)]./nocc(1))
                tauH=findobj('DisplayName','notx_ctauv1');
                set(tauH,'XData',[ nocc(2)  nocc(2)],'YData',[0 nocc(1)]./nocc(1))
                
                tauH=findobj('DisplayName','notx_ctauh2');
                set(tauH,'XData',[-.5 nocc(4)],'YData',[nocc(3) nocc(3)]./nocc(1))
                tauH=findobj('DisplayName','notx_ctauv2');
                set(tauH,'XData',[nocc(4) nocc(4)],'YData',[0 nocc(3)]./nocc(1))
                % normalized closed dwell times
                notxoH=findobj('DisplayName','notx_cdt');
                set(notxoH,'XData',hGUI.params.notx.csx,'YData',hGUI.params.notx.csy./nocc(1))
            end
            
            %Gx Toxin
            gxcc=hGUI.params.gxtx.ccoeffs;
            gxtx_cfits1=sqrt( (10.^hGUI.params.gxtx.chx) .* hGUI.params.gxtx.logexp(gxcc(1:2),hGUI.params.gxtx.chx));
            gxtx_cfits2=sqrt( (10.^hGUI.params.gxtx.chx) .* hGUI.params.gxtx.logexp(gxcc(3:4),hGUI.params.gxtx.chx));
            gxtx_cfits3=sqrt( (10.^hGUI.params.gxtx.chx) .* hGUI.params.gxtx.logexp(gxcc(5:6),hGUI.params.gxtx.chx));
            if ~hGUI.params.norm
                gxtxoH=findobj('DisplayName','gxtx_cdtfit');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',hGUI.params.gxtx.cfit)
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits1');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits1)
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits2');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits2)
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits3');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits3)
                
                tauH=findobj('DisplayName','gxtx_ctauh1');
                set(tauH,'XData',[-.5  gxcc(2)],'YData',[gxcc(1) gxcc(1)])
                tauH=findobj('DisplayName','gxtx_ctauv1');
                set(tauH,'XData',[ gxcc(2)  gxcc(2)],'YData',[0 gxcc(1)])
                
                tauH=findobj('DisplayName','gxtx_ctauh2');
                set(tauH,'XData',[-.5 gxcc(4)],'YData',[gxcc(3) gxcc(3)])
                tauH=findobj('DisplayName','gxtx_ctauv2');
                set(tauH,'XData',[gxcc(4) gxcc(4)],'YData',[0 gxcc(3)])
                
                tauH=findobj('DisplayName','gxtx_ctauh3');
                set(tauH,'XData',[-.5 gxcc(6)],'YData',[gxcc(5) gxcc(5)])
                tauH=findobj('DisplayName','gxtx_ctauv3');
                set(tauH,'XData',[gxcc(6) gxcc(6)],'YData',[0 gxcc(5)])
            else
                gxtxoH=findobj('DisplayName','gxtx_cdtfit');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',hGUI.params.gxtx.cfit./gxcc(1))
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits1');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits1./gxcc(1))
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits2');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits2./gxcc(1))
                
                gxtxoH=findobj('DisplayName','gxtx_cdtfits3');
                set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',gxtx_cfits3./gxcc(1))
                
                tauH=findobj('DisplayName','gxtx_ctauh1');
                set(tauH,'XData',[-.5  gxcc(2)],'YData',[gxcc(1) gxcc(1)]./gxcc(1))
                tauH=findobj('DisplayName','gxtx_ctauv1');
                set(tauH,'XData',[ gxcc(2)  gxcc(2)],'YData',[0 gxcc(1)]./gxcc(1))
                
                tauH=findobj('DisplayName','gxtx_ctauh2');
                set(tauH,'XData',[-.5 gxcc(4)],'YData',[gxcc(3) gxcc(3)]./gxcc(1))
                tauH=findobj('DisplayName','gxtx_ctauv2');
                set(tauH,'XData',[gxcc(4) gxcc(4)],'YData',[0 gxcc(3)]./gxcc(1))
                
                tauH=findobj('DisplayName','gxtx_ctauh3');
                set(tauH,'XData',[-.5 gxcc(6)],'YData',[gxcc(5) gxcc(5)]./gxcc(1))
                tauH=findobj('DisplayName','gxtx_ctauv3');
                set(tauH,'XData',[gxcc(6) gxcc(6)],'YData',[0 gxcc(5)]./gxcc(1))
                % normalized closed dwell times
                gxtxoH=findobj('DisplayName','gxtx_cdt');
                set(gxtxoH,'XData',hGUI.params.gxtx.csx,'YData',hGUI.params.gxtx.csy./gxcc(1))
            end
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            hGUI.iA.notx=hGUI.params.notx;
            hGUI.iA.gxtx=hGUI.params.gxtx;
            hGUI.iA.IAOsave;
            hGUI.enableGui;
        end
        
        function restrictCall(hGUI,~,~)
            hGUI.disableGui;
            
            hGUI.enableGui;
        end
        
        function lSlideCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Value');
            rValue=get(hGUI.figData.rightSlider,'Value');
            
            lH=findobj('DisplayName','leftLine');
            set(lH,'XData',[lValue lValue])
            rH=findobj('DisplayName','rightLine');
            set(rH,'XData',[rValue rValue])
            hGUI.enableGui;
        end
        
        function wSlideCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.wleftSlider,'Value');
            rValue=get(hGUI.figData.wrightSlider,'Value');
            lTime=hGUI.hekadat.stAxis(ceil(lValue));
            rTime=hGUI.hekadat.stAxis(floor(rValue));
            
            lH=findobj('DisplayName','wleftLine');
            set(lH,'XData',[lTime lTime])
            rH=findobj('DisplayName','wrightLine');
            set(rH,'XData',[rTime rTime])
            hGUI.enableGui;
        end
        
        
    end
    
    methods (Static=true)
         
    end
end
