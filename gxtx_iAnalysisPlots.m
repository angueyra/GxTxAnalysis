classdef gxtx_iAnalysisPlots<iAnalysisGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_iAnalysisPlots(iA,params,fign) 
            params=checkStructField(params,'notx_start',1);
            params=checkStructField(params,'notx_end',iA.n);
            params=checkStructField(params,'gxtx_start',1);
            params=checkStructField(params,'gxtx_end',iA.n);
            
            params=checkStructField(params,'nbins',140);
            params=checkStructField(params,'omin',-1);
            params=checkStructField(params,'omax',2.5);
            params=checkStructField(params,'cmin',-1);
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
            set(cocH,'DisplayName','ooo')
            % ccc cum prob
            cccH=line(nwaves,cumsum(ccc)./(nwaves),'Parent',hGUI.figData.plotEvolution);
            set(cccH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[.5 .5 .5])
            set(cccH,'DisplayName','ooo')
            
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
            set(cocH,'DisplayName','ooo')
            % ccc cum prob
            cccH=line(nwaves,cumsum(ccc)./(iA.n),'Parent',hGUI.figData.plotEvolution2);
            set(cccH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[.5 .5 .5])
            set(cccH,'DisplayName','ooo')
            
            pwidth2=.5;
            pheight2=.27;
            ptop2=0.98-pheight2;
            
            % First latencies (as cumulative counts)
            plotFlats=struct('Position',[pleft+pwidth+.1 ptop2 .95-pwidth2 pheight2],'tag','plotFlats');
            plotFlats.YLim=[0 1.05];
%             plotFlats.XLim=[1 iA.n];
            hGUI.makePlot(plotFlats);
            hGUI.labelx(hGUI.figData.plotFlats,'Time to first opening (ms)');
            hGUI.labely(hGUI.figData.plotFlats,'Cum. Prob.');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(lH,'DisplayName','notx_flat')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotFlats);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(lH,'DisplayName','gxtx_flat')
            
            % Open dwell times log hist
            plotOdt=struct('Position',[pleft+pwidth+.1 ptop2-pheight2-.05 .95-pwidth2 pheight2],'tag','plotOdt');
            %           plotOdt.YLim=[0 1.05];
            %           plotOdt.XLim=[1 iA.n];
            hGUI.makePlot(plotOdt);
            hGUI.labelx(hGUI.figData.plotOdt,'Open dwell time (ms)');
            hGUI.labely(hGUI.figData.plotOdt,'sqrt(log(n))');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','b')
            set(lH,'DisplayName','notx_odt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_odtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')
            set(lH,'DisplayName','gxtx_odt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_odtfit')
            
            % Closed dwell times log hist
            plotCdt=struct('Position',[pleft+pwidth+.1 ptop2-pheight2*2-.1 .95-pwidth2 pheight2],'tag','plotCdt');
            %           plotCdt.YLim=[0 1.05];
            %           plotCdt.XLim=[1 iA.n];
            hGUI.makePlot(plotCdt);
            hGUI.labelx(hGUI.figData.plotCdt,'Closed dwell time (ms)');
            hGUI.labely(hGUI.figData.plotCdt,'sqrt(log(n))');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','b')
            set(lH,'DisplayName','notx_cdt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([0,0,1],.5))
            set(lH,'DisplayName','notx_cdtfit')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')
            set(lH,'DisplayName','gxtx_cdt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',whithen([1,0,0],.5))
            set(lH,'DisplayName','gxtx_cdtfit')
            
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
            
            [notx,gxtx]=calculateHISTs(hGUI);
            % NO TOXIN
            % first latencies
            notxflH=findobj('DisplayName','notx_flat');
            set(notxflH,'XData',notx.flat,'YData',notx.flatp)
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
            % open dwell times
            gxtxoH=findobj('DisplayName','gxtx_odt');
            set(gxtxoH,'XData',gxtx.osx,'YData',gxtx.osy)
            % closed dwell times
            gxtxoH=findobj('DisplayName','gxtx_cdt');
            set(gxtxoH,'XData',gxtx.csx,'YData',gxtx.csy)
            
            hGUI.params.notx=notx;
            hGUI.params.gxtx=gxtx;
            
            hGUI.enableGui;
        end
        
        function odtfitCall(hGUI,~,~)
            hGUI.disableGui;
            fprintf('NO TOXIN\n')
            hGUI.params.notx.IAOohistfit([]);
            notxoH=findobj('DisplayName','notx_odtfit');
            set(notxoH,'XData',hGUI.params.notx.ohx,'YData',hGUI.params.notx.ofit)
            
            fprintf('GX TOXIN\n')
            hGUI.params.gxtx.IAOohistfit([]);
            gxtxoH=findobj('DisplayName','gxtx_odtfit');
            set(gxtxoH,'XData',hGUI.params.gxtx.ohx,'YData',hGUI.params.gxtx.ofit)
            hGUI.enableGui;
        end
        
        function cdtfitCall(hGUI,~,~)
            hGUI.disableGui;
            fprintf('NO TOXIN\n')
            hGUI.params.notx.IAOchistfit([]);
            notxoH=findobj('DisplayName','notx_cdtfit');
            set(notxoH,'XData',hGUI.params.notx.chx,'YData',hGUI.params.notx.cfit)
            
            fprintf('GX TOXIN\n')
            hGUI.params.gxtx.IAOchistfit([]);
            gxtxoH=findobj('DisplayName','gxtx_cdtfit');
            set(gxtxoH,'XData',hGUI.params.gxtx.chx,'YData',hGUI.params.gxtx.cfit)
            hGUI.enableGui;
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