classdef gxtx_correctBaseline<hekaGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_correctBaseline(hekadat,params,fign)
            if hekadat.baselinecorrectionFlag
%                 error('Baseline subtraction has already been corrected and included in sdata')
            end
          params=checkStructField(params,'PlotNow',1);
          params=checkStructField(params,'LockNow',0);
          params=checkStructField(params,'nbins',400);
          hGUI@hekaGUI(hekadat,params,fign);
          
          % only plot ccc, coc and ooo
          Rows=size(hekadat.swaveNames,1);
          colors=pmkmp(Rows,'CubicL');
          tcolors=round(colors./1.2.*255);
          
          RowNames=cell(size(Rows));
          for i=1:Rows
              RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.swaveNames{i});
          end
          
          % info Table
          Selected=false(Rows,1);         
          Selected(params.PlotNow,end)=true;
          infoData=[hGUI.hekadat.stags num2cell(hekadat.sBaseline) num2cell(Selected)];
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.185, .985];
          tableinput.FontSize=10;
          tableinput.ColumnWidth={40};
          tableinput.Data=infoData;
          tableinput.ColumnName={'tag','bline','P'};
          tableinput.RowName=RowNames;
          tableinput.headerWidth=63;
          hGUI.infoTable(tableinput);
          
          bw=.065;
          bh=0.08;
          bl=0.995-bw;
          
          pleft=.235;
          pwidth=.48;
          pheight=.43;
          ptop=.555;
          ptop2=.08;
          hleft=.735;
          hwidth=.17;
          
          % Next and Previous Buttons
          nextBt=struct('Position',[bl pheight bw bh]);
          hGUI.nextButton(nextBt);
          prevBt=struct('Position',[bl pheight+.1 bw bh]);
          hGUI.prevButton(prevBt);
          
          lockBt=struct('Position', [bl .03 bw bh]);
          hGUI.lockButton(lockBt);
          
         
          
          % Sliders
          lSlide=struct('tag','leftSlider','Position',[pleft-.015 .45 pwidth+.03 .05]);
          lSlide.Min=1;
          lSlide.Max=size(hekadat.sdata,2);
          lSlide.Value=floor(lSlide.Min)+1;
          lSlide.SliderStep=[1/10000 1/100];
          lSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(lSlide);
          
          rSlide=struct('tag','rightSlider','Position',[pleft-.015 .42 pwidth+.03 .05]);
          rSlide.Min=1;
          rSlide.Max=size(hekadat.sdata,2);
          rSlide.Value=floor(rSlide.Max);
          rSlide.SliderStep=[1/10000 1/100];
          rSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(rSlide);
          
          % Zoom button
          zBt=struct('tag','Zoom','Position',[pleft+pwidth+0.02 pheight .065 .08]);
          zBt.Callback=@hGUI.zoomCall;
          hGUI.createButton(zBt);
          
          % Unzoom button
          uzBt=struct('tag','Unzoom','Position',[pleft+pwidth+0.15 pheight .065 .08]);
          uzBt.Callback=@hGUI.unzoomCall;
          hGUI.createButton(uzBt);
          
          % Baseline button
          blBt=struct('tag','Baseline','Position',[pleft+pwidth+0.085 pheight .065 .08]);
          blBt.Callback=@hGUI.baselineCall;
          hGUI.createButton(blBt);
          
          % lock Baseline button
          lblBt=struct('tag','lockBline','Position',[bl pheight-.2 bw bh]);
          lblBt.Callback=@hGUI.lockbblineCall;
          hGUI.createButton(lblBt);
          
           
          % current wave (after subtraction)
          plotCurr=struct('Position',[pleft ptop pwidth pheight],'tag','plotCurr');
          plotCurr.XLim=[0 hekadat.stAxis(end)];
          plotCurr.YLim=[-1 3];
          hGUI.makePlot(plotCurr);
          hGUI.labelx(hGUI.figData.plotCurr,'Time (s)');
          hGUI.labely(hGUI.figData.plotCurr,'i (pA)');

          % refined trace
          lH=line(hGUI.hekadat.stAxis,NaN(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','+','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          
          %left line
          lH=line([hGUI.hekadat.stAxis(lSlide.Value) hGUI.hekadat.stAxis(lSlide.Value)],plotCurr.YLim,'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .75 .75])
          set(lH,'DisplayName','leftLine')
          %right line
          lH=line([hGUI.hekadat.stAxis(rSlide.Value) hGUI.hekadat.stAxis(rSlide.Value)],plotCurr.YLim,'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 1])
          set(lH,'DisplayName','rightLine')
          %zero line
          lH=line(hGUI.hekadat.stAxis,zeros(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLine')
          
          % Data and blank histograms
          plotHist=struct('Position',[hleft ptop hwidth pheight],'tag','plotHist');
          plotHist.YAxisLocation='right';
          plotHist.XLim=[0 0.15];
          plotHist.YLim=plotCurr.YLim;
          hGUI.makePlot(plotHist);
          hGUI.labelx(hGUI.figData.plotHist,'Freq');
          
          hnan=NaN(1,50);
          
          %zero line
          lH=line([0 1],[0 0],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineHist')
          
          % Curated hist
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currHist')
          
          % All data histogram
          if ~isempty(hekadat.sdata)
              alldata=reshape(hekadat.sdata,1,numel(hekadat.sdata));
              [allHistX,allHistY]=hGUI.calculateHist(alldata,params.nbins,-1,2);
              lH=line(allHistY,allHistX,'Parent',hGUI.figData.plotHist);
              set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
              set(lH,'DisplayName','allHist')
          end
          

          plotSub=struct('Position',[pleft ptop2 pwidth pheight-.11],'tag','plotSub');
          plotSub.XLim=[0 hekadat.stAxis(end)];
          plotSub.YLim=[-1 2];
          hGUI.makePlot(plotSub);
          hGUI.labelx(hGUI.figData.plotSub,'Time (s)');
          hGUI.labely(hGUI.figData.plotSub,'i (pA)');
          
          % refined trace
          lH=line(hGUI.hekadat.stAxis,NaN(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subWave')
          
          %zero line
          lH=line(hGUI.hekadat.stAxis,zeros(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineSub')
          
          % Data and blank histograms
          plotHist2=struct('Position',[hleft ptop2 hwidth pheight-.11],'tag','plotHist2');
          plotHist2.YAxisLocation='right';
          plotHist2.XLim=[0 0.3];
          plotHist2.YLim=plotSub.YLim;
          hGUI.makePlot(plotHist2);
          hGUI.labelx(hGUI.figData.plotHist2,'Freq');
          
          %zero line
          lH=line([0 1],[0 0],'Parent',hGUI.figData.plotHist2);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineHist2')
          
          % corrected Hist
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist2);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subHist')
          
          % All data Hist2ogram
          if ~isempty(hekadat.sdata)
              alldatab=hekadat.sdata-repmat(hekadat.sBaseline,1,size(hekadat.sdata,2));
              alldatab=reshape(alldatab,1,numel(alldatab));
              [allHist2X,allHist2Y]=hGUI.calculateHist(alldatab,params.nbins,-1,2);
              lH=line(allHist2Y,allHist2X,'Parent',hGUI.figData.plotHist2);
              set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
              set(lH,'DisplayName','allHist2')
          end
          
          % index label
          % currTag=text((hGUI.hekadat.tAxis(end))*.9,max(max(hGUI.hekadat.data))*.9,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          currIndex=text(0.01,2.5,num2str(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          set(currIndex,'tag','currIndex','FontSize',24)
          
          hGUI.updatePlots();
%           if params.LockNow
%               hGUI.lockButtonCall();
%           end
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            hGUI.params.PlotNow=PlotNow;
            Rows=size(Selected,1);
            colors=pmkmp(Rows,'CubicL');
            % current wave
            currWave=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAsnamefind(currWave);
            % current trace
            currentTrace=hGUI.hekadat.sdata(currWavei,:);
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
            % current histograms
            [currHistX,currHistY]=hGUI.calculateHist(currentTrace,hGUI.params.nbins,-1,2);
            hHNow=findobj('DisplayName','currHist');
            set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))
            % after baseline correction
            baseline=Selected{PlotNow,2};
            lHNow=findobj('DisplayName','subWave');
            set(lHNow,'YData',currentTrace-baseline,'Color',colors(PlotNow,:))
            
            [currHistX,currHistY]=hGUI.calculateHist(currentTrace-baseline,hGUI.params.nbins,-1,2);
            hHNow=findobj('DisplayName','subHist');
            set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))
            
            curri=findobj('tag','currIndex');
            set(curri,'String',num2str(PlotNow));
            
            hGUI.refocusTable(PlotNow);
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            Selected=get(hGUI.figData.infoTable,'Data');
            hGUI.hekadat.sBaseline=cell2mat(Selected(:,2));
            alldata=hGUI.hekadat.HEKAbldata;
            alldata=reshape(alldata,1,numel(alldata));
            [hGUI.hekadat.stairx,hGUI.hekadat.stairy]=hGUI.calculateHist(alldata,hGUI.params.nbins,-1,2);
            deltax=(hGUI.hekadat.stairx(2)-hGUI.hekadat.stairx(1))/2;
            hGUI.hekadat.histx=hGUI.hekadat.stairx(1:2:end)+deltax;
            hGUI.hekadat.histy=hGUI.hekadat.stairy(1:2:end);
            hGUI.hekadat.HEKAsave();
            hGUI.enableGui;
        end
        
        function lockbblineCall(hGUI,~,~)
            hGUI.disableGui;
            Selected=get(hGUI.figData.infoTable,'Data');
            hGUI.hekadat.sBaseline=cell2mat(Selected(:,2));
            hGUI.hekadat.HEKAsave();
            hGUI.enableGui;
        end
        
        function baselineCall(hGUI,~,~)
%             hGUI.disableGui;
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            % take care of sliders
            lValue=floor(get(hGUI.figData.leftSlider,'Value'));
            rValue=ceil(get(hGUI.figData.rightSlider,'Value'));
            if lValue>rValue
                tempValue=lValue;
                lValue=rValue;
                rValue=tempValue;
            end
            %calculate baseline between lines and update table
            currWave=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAsnamefind(currWave);
            currentTrace=hGUI.hekadat.sdata(currWavei,:);
            baseline=mean(currentTrace(lValue:rValue));
            Selected{PlotNow,2}=baseline; %#ok<*FNDSB>
            set(hGUI.figData.infoTable,'Data',Selected)
            hGUI.updatePlots();
%             hGUI.enableGui;
        end
        
        function lSlideCall(hGUI,~,~)
%             hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Value');
            rValue=get(hGUI.figData.rightSlider,'Value');
            lTime=hGUI.hekadat.stAxis(ceil(lValue));
            rTime=hGUI.hekadat.stAxis(floor(rValue));
            
            lH=findobj('DisplayName','leftLine');
            set(lH,'XData',[lTime lTime])
            rH=findobj('DisplayName','rightLine');
            set(rH,'XData',[rTime rTime])
%             hGUI.enableGui;
        end
        
        function zoomCall(hGUI,~,~)
%             hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Value');
            rValue=get(hGUI.figData.rightSlider,'Value');
            if lValue<rValue
                lTime=hGUI.hekadat.stAxis(ceil(lValue));
                rTime=hGUI.hekadat.stAxis(floor(rValue));
            else
                set(hGUI.figData.leftSlider,'Value',rValue);
                set(hGUI.figData.rightSlider,'Value',lValue);
                lTime=hGUI.hekadat.stAxis(ceil(rValue));
                rTime=hGUI.hekadat.stAxis(floor(lValue));
                lH=findobj('DisplayName','leftLine');
                set(lH,'XData',[lTime lTime])
                rH=findobj('DisplayName','rightLine');
                set(rH,'XData',[rTime rTime])
            end
            set(hGUI.figData.plotCurr,'XLim',[lTime rTime])
%             hGUI.enableGui;
        end
        
        function unzoomCall(hGUI,~,~)
%             hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Min');
            lTime=hGUI.hekadat.stAxis(ceil(lValue));
            set(hGUI.figData.leftSlider,'Value',lValue);
            rValue=get(hGUI.figData.rightSlider,'Max');
            rTime=hGUI.hekadat.stAxis(floor(rValue));
            set(hGUI.figData.rightSlider,'Value',rValue);
            lH=findobj('DisplayName','leftLine');
            set(lH,'XData',[lTime lTime])
            rH=findobj('DisplayName','rightLine');
            set(rH,'XData',[rTime rTime])
            set(hGUI.figData.plotCurr,'XLim',[lTime rTime])
%             hGUI.enableGui;
        end
        
        function updateTable(hGUI,~,eventdata)
%            hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Plotted=find(cell2mat(Selected(:,end)));
           Previous=Plotted(Plotted~=eventdata.Indices(1));
           Plotted=Plotted(Plotted==eventdata.Indices(1));
           
           Selected{Previous,end}=false;
           Selected{Plotted,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.5);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Previous});
           set(curt,'Color',colors(Previous,:),'LineWidth',1)
           
           updatePlots(hGUI);
%            hGUI.enableGui;
        end
       
        function nextButtonCall(hGUI,~,~)
%            hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Current=find(cell2mat(Selected(:,end)));
           PlotNext=Current+1;
           if PlotNext>size(Selected,1)
               PlotNext=1;
           end
           Selected{Current,end}=false;
           Selected{PlotNext,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.6);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Current});
           set(curt,'Color',colors(Current,:),'LineWidth',1)
           hGUI.updatePlots();
           hGUI.unzoomCall();
%            hGUI.enableGui;
       end
       
       function prevButtonCall(hGUI,~,~)
%            hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Previous=find(cell2mat(Selected(:,end)));
           PlotNext=Previous-1;
           if PlotNext<1
               PlotNext=size(Selected,1);
           end
           Selected{Previous,end}=false;
           Selected{PlotNext,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.6);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Previous});
           set(curt,'Color',colors(Previous,:),'LineWidth',1)
           hGUI.updatePlots();
           hGUI.unzoomCall();
%            hGUI.enableGui;
       end
    end
    
    methods (Static=true)
         
    end
end
