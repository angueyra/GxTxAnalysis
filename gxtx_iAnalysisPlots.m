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
            hGUI@iAnalysisGUI(iA,params,fign);
            
          
            
            pleft=.05;
            pwidth=.35;
            pheight=.35;
            ptop=.98-pheight;
            
            bw=.065;
            bh=0.08;
            %           bl=0.995-bw;
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
            %           plotFlats.YLim=[0 1.05];
            %           plotFlats.XLim=[1 iA.n];
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
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(lH,'DisplayName','notx_odt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotOdt);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(lH,'DisplayName','gxtx_odt')
            
            % Closed dwell times log hist
            plotCdt=struct('Position',[pleft+pwidth+.1 ptop2-pheight2*2-.1 .95-pwidth2 pheight2],'tag','plotCdt');
            %           plotCdt.YLim=[0 1.05];
            %           plotCdt.XLim=[1 iA.n];
            hGUI.makePlot(plotCdt);
            hGUI.labelx(hGUI.figData.plotCdt,'Closed dwell time (ms)');
            hGUI.labely(hGUI.figData.plotCdt,'sqrt(log(n))');
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','b')
            set(lH,'DisplayName','notx_cdt')
            
            lH=line(NaN,NaN,'Parent',hGUI.figData.plotCdt);
            set(lH,'Marker','.','LineStyle','-','LineWidth',1,'Color','r')
            set(lH,'DisplayName','gxtx_cdt')
            
            hGUI.updatePlots();
        end
        
        function updatePlots(hGUI,~,~)
            hGUI.disableGui;
            notx_start=hGUI.params.notx_start;
            notx_end=hGUI.params.notx_end;
            gxtx_start=hGUI.params.gxtx_start;
            gxtx_end=hGUI.params.gxtx_end;
            
            notx=hGUI.iA.IAOtagfind('ooo');
            gxtx=hGUI.iA.IAOtagfind('coc');
            
            notx_flats=normalize(sort(hGUI.iA.flat(notx(notx_start:notx_end))));
            gxtx_flats=normalize(sort(hGUI.iA.flat(gxtx(gxtx_start:gxtx_end))));
            
            notxflH=findobj('DisplayName','notx_flat');
            set(notxflH,'XData',(1:size(notx_flats,1)),'YData',notx_flats)
            
            gxtxflH=findobj('DisplayName','gxtx_flat');
            set(gxtxflH,'XData',(1:size(gxtx_flats,1)),'YData',gxtx_flats)
            
            hGUI.enableGui;
        end
        
        function fittingCall(hGUI,~,~)
            hGUI.disableGui;
            
            hGUI.enableGui;
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            
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