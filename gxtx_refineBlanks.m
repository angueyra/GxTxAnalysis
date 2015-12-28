classdef gxtx_refineBlanks<hekaGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_refineBlanks(hekadat,params,fign) 
          params=checkStructField(params,'PlotNow',1);
          params=checkStructField(params,'LockNow',0);
          params=checkStructField(params,'nbins',100);
          hGUI@hekaGUI(hekadat,params,fign);
          
          % only plot ccc, coc and ooo
          selWaves=logical(hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('ooo')+hekadat.HEKAtagfind('coc'));
          selWavesi=find(selWaves==1);
          Rows=size(hekadat.waveNames(selWaves),1);
          colors=pmkmp(Rows,'CubicL');
          tcolors=round(colors./1.2.*255);
          
          RowNames=cell(size(Rows));
          for i=1:Rows
              RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.waveNames{selWavesi(i)});
          end
          
          % info Table
          Selected=false(Rows,2);         
          Selected(params.PlotNow,end)=true;
          infoData=[hGUI.hekadat.tags(selWaves) num2cell(Selected)];
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.185, .985];
          tableinput.FontSize=10;
          tableinput.ColumnWidth={40};
          tableinput.Data=infoData;
          tableinput.ColumnName={'tag','ccc','P'};
%           tableinput.RowName=hGUI.waveTableNames();
          tableinput.RowName=RowNames;
          tableinput.headerWidth=63;
          hGUI.infoTable(tableinput);
          
          bw=.065;
          bh=0.08;
          bl=0.995-bw;
          % buttons
          nextBt=struct('Position',[bl .80 bw bh]);
          hGUI.nextButton(nextBt);
          prevBt=struct('Position',[bl .90 bw bh]);
          hGUI.prevButton(prevBt);
          
          cccBt=struct('tag','ccc','Position',[bl .38 bw bh]);
          hGUI.tagButton(cccBt);
          badBt=struct('tag','bad','Position',[bl .28 bw bh]);
          hGUI.tagButton(badBt);
          untagBt=struct('tag','untag','Position',[bl .18 bw bh]);
          hGUI.untagButton(untagBt);
          lockBt=struct('Position', [bl .03 bw bh]);
          hGUI.lockButton(lockBt);
          
          %find current wave
          tst=hGUI.hekadat.HEKAstairsprotocol();
          currWave=hGUI.getRowNamebyIndex(hGUI,params.PlotNow);
          currWavei=hGUI.hekadat.HEKAnamefind(currWave);
          cccmean=hGUI.hekadat.HEKAtagmean('ccc');
          
          pleft=.235;
          pwidth=.48;
          pheight=.43;
          ptop=.555;
          ptop2=.08;
          
          % Current and Nearest Blank traces
          plotCurr=struct('Position',[pleft ptop pwidth pheight],'tag','plotCurr');
          plotCurr.XLim=[0 tst.delta];
          plotCurr.XLim=[0 0.01];
          plotCurr.YLim=[-3 2];
          hGUI.makePlot(plotCurr);
          hGUI.labelx(hGUI.figData.plotCurr,'Time (s)');
          hGUI.labely(hGUI.figData.plotCurr,'i (pA)');

          %zero line
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),zeros(size(hGUI.hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLine')
          
          % current trace
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),hGUI.hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currentWave')
          
          % nearest blank
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),hGUI.hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','nearestBlank')
          
          % corrected trace
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),NaN(size(hGUI.hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','+','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','correctedTrace')
          
          
          currtag=text((hGUI.hekadat.tAxis(tst.deltai))*.9,1.8,hGUI.hekadat.tags(currWavei),'Parent',hGUI.figData.plotCurr);
          set(currtag,'tag','currtag','FontSize',24)
          
          % Local Subtraction
          plotSub=struct('Position',[pleft ptop2 pwidth pheight],'tag','plotSub');
          plotSub.XLim=[0 tst.delta];
%           plotSub.XLim=[0 0.01];
          plotSub.YLim=[-1 2];
          hGUI.makePlot(plotSub);
          hGUI.labelx(hGUI.figData.plotSub,'Time (s)');
          hGUI.labely(hGUI.figData.plotSub,'i (pA)');
          
          % refined trace
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),NaN(size(hGUI.hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subTrace')
          
          %zero line
          lH=line(hGUI.hekadat.tAxis(1:tst.deltai),zeros(size(hGUI.hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineSub')
          
          hleft=.735;
          hwidth=.17;
          
          % Data and blank histograms
          plotHist=struct('Position',[hleft ptop hwidth pheight],'tag','plotHist');
          plotHist.YAxisLocation='right';
          plotHist.YLim=plotCurr.YLim;
          hGUI.makePlot(plotHist);

          hnan=NaN(1,50);
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currHist')

          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','cccHist')
          
          % Locally-subtracted histogram
          plotHist2=struct('Position',[hleft ptop2 hwidth pheight],'tag','plotHist2');
          plotHist2.YAxisLocation='right';
          plotHist2.YLim=plotSub.YLim;
          hGUI.makePlot(plotHist2);
          
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist2);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subHist')

%     
%     if LockNow
%        lock_callBack(figData.infoTable);
%     end
%           
          hGUI.updatePlots();
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            hGUI.params.PlotNow=PlotNow;
            % figData.PlotNow=PlotNow;
            
            % current wave
            currWave=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAnamefind(currWave);
            
            % find flanking ccc (left and right)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
            if PlotNow==1 % no left
                cccLi=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags),1,'first');
                cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(PlotNow+1:end)),1,'first');
            elseif PlotNow==size(Selected,1) % no right
                cccLi=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(1:PlotNow)),1,'last');
                cccRi=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags),1,'last');
            else
                cccLi=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(1:PlotNow)),1,'last');
                cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(PlotNow+1:end)),1,'first');
            end
            cccLWave=hGUI.getRowNamebyIndex(hGUI,cccLi);
            cccLWavei=hGUI.hekadat.HEKAnamefind(cccLWave);
            cccRWave=hGUI.getRowNamebyIndex(hGUI,cccRi);
            cccRWavei=hGUI.hekadat.HEKAnamefind(cccRWave);
            
            % update table
            cccP=find(cell2mat(Selected(:,2)));
            for i=1:length(cccP)
                Selected{cccP(i),2}=false;
            end
            Selected{cccLi,2}=true;
            Selected{cccRi,2}=true;
            Rows=size(Selected,1);
            colors=pmkmp(Rows,'CubicL');
            
            cccmean=hGUI.hekadat.HEKAtagmean('ccc');
            tst=hGUI.hekadat.HEKAstairsprotocol();
            % current trace
            currentTrace=hGUI.hekadat.data(currWavei,tst.sti:tst.endi)-(cccmean(tst.sti:tst.endi));
            lHNow=findobj('DisplayName','currentWave');
            set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
            % flanking ccc
            nearestLBlank=hGUI.hekadat.data(cccLWavei,tst.sti:tst.endi);
            nearestRBlank=hGUI.hekadat.data(cccRWavei,tst.sti:tst.endi);
            nearestBlank=((nearestLBlank+nearestRBlank)./2)-(cccmean(tst.sti:tst.endi));
            lHNow=findobj('DisplayName','nearestBlank');
            set(lHNow,'YData',nearestBlank,'Color',whithen(colors(PlotNow,:),.5))
            
            % subtract nose and mean of flanking blanks
            tlim=find(hGUI.hekadat.tAxis<=0.003,1,'last');
            subTrace=currentTrace;
            subTrace(1:tlim)=subTrace(1:tlim)-nearestBlank(1:tlim);
            subTrace(tlim+1:end)=subTrace(tlim+1:end)-mean(nearestBlank(2000:end),2);
            
            lHNow=findobj('DisplayName','subTrace');
            set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:))
            
            lHNow=findobj('DisplayName','correctedTrace');
            set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:)/2)
            
            currtag=findobj('tag','currtag');
            set(currtag,'String',hGUI.hekadat.tags(currWavei));
            set(hGUI.figData.infoTable,'Data',Selected)
            
            % calculate histogram
            [currHistX,currHistY]=hGUI.calculateHist(currentTrace,hGUI.params.nbins,min(currentTrace),max(currentTrace));
            hHNow=findobj('DisplayName','currHist');
            set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))
            
            [cccHistX,cccHistY]=hGUI.calculateHist(nearestBlank,hGUI.params.nbins,min(currentTrace),max(currentTrace));
            hHNow=findobj('DisplayName','cccHist');
            set(hHNow,'XData',cccHistY,'YData',cccHistX,'Color',whithen(colors(PlotNow,:),.5))
            
            [subHistX,subHistY]=hGUI.calculateHist(subTrace,hGUI.params.nbins,-.5,2);
            hHNow=findobj('DisplayName','subHist');
            set(hHNow,'XData',subHistY,'YData',subHistX,'Color',colors(PlotNow,:))
        end
        
        function updateTable(hGUI,~,eventdata)
           hGUI.disableGui();
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
           hGUI.enableGui();
        end
       
        function nextButtonCall(hGUI,~,~)
           hGUI.disableGui();
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
           hGUI.enableGui();
       end
       
       function prevButtonCall(hGUI,~,~)
           hGUI.disableGui();
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
           hGUI.enableGui();
       end
    end
    
    methods (Static=true)
         
    end
end