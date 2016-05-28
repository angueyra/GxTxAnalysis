classdef gxtx_refineBlanks<hekaGUI
    % uses 1 or 2 flanking ccc epochs to subtract remaining capacitive transient
    % from all hekadat.sdata
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_refineBlanks(hekadat,params,fign)
            if hekadat.baselinecorrectionFlag
                warning('This function has already been run and results saved')
            end
          params=checkStructField(params,'PlotNow',1);
          params=checkStructField(params,'LockNow',0);
          params=checkStructField(params,'nbins',200);
          params=checkStructField(params,'tlim',0.025);
          tlimi=find(hekadat.stAxis>=params.tlim,1,'first');
          hGUI@hekaGUI(hekadat,params,fign);
          
          Rows=size(hekadat.swaveNames,1);
          colors=pmkmp(Rows,'CubicL');
          tcolors=round(colors./1.2.*255);
          
          RowNames=cell(size(Rows));
          for i=1:Rows
              RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.swaveNames{i});
          end
          
          % info Table
          Selected=false(Rows,2);         
          Selected(params.PlotNow,end)=true;
          infoData=[hGUI.hekadat.stags num2cell(Selected)];
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.185, .985];
          tableinput.FontSize=10;
          tableinput.ColumnWidth={40};
          tableinput.Data=infoData;
          tableinput.ColumnName={'tag','ccc','P'};
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
          currWave=hGUI.getRowNamebyIndex(hGUI,params.PlotNow);
          currWavei=hGUI.hekadat.HEKAsnamefind(currWave);
          cccmean=hGUI.hekadat.HEKAtagmean('ccc');
          
          pleft=.235;
          pwidth=.48;
          pheight=.43;
          ptop=.555;
          ptop2=.08;
          
          % Current and Nearest Blank traces
          plotCurr=struct('Position',[pleft ptop pwidth pheight],'tag','plotCurr');
%           plotCurr.XLim=[0 tst.delta];
          plotCurr.XLim=[0 0.1];
          plotCurr.YLim=[-5 3];
          hGUI.makePlot(plotCurr);
          hGUI.labelx(hGUI.figData.plotCurr,'Time (s)');
          hGUI.labely(hGUI.figData.plotCurr,'i (pA)');
          

          %zero line
          lH=line(hGUI.hekadat.stAxis,zeros(size(hGUI.hekadat.sdata(currWavei,:))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLine')
          
          %correction limit line
          lH=line([hGUI.hekadat.stAxis(tlimi) hGUI.hekadat.stAxis(tlimi)],plotCurr.YLim,'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','correctionLine')
          
          % current trace
          lH=line(hGUI.hekadat.stAxis,hGUI.hekadat.sdata(currWavei,:)-hekadat.sBaseline(currWavei),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          
          % nearest blank
          lH=line(hGUI.hekadat.stAxis,hGUI.hekadat.sdata(currWavei,:)-hekadat.sBaseline(currWavei),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','nearestBlank')
          
          % corrected trace
          lH=line(hGUI.hekadat.stAxis,NaN(size(hGUI.hekadat.sdata(currWavei,:))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','+','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','correctedWave')
          
          
          currtag=text(0.09,-1.8,hGUI.hekadat.stags(currWavei),'Parent',hGUI.figData.plotCurr);
          set(currtag,'tag','currtag','FontSize',24)                  
                    
          % Local Subtraction
          plotSub=struct('Position',[pleft ptop2 pwidth pheight],'tag','plotSub');
          plotSub.XLim=[0 hekadat.stAxis(end)];
%           plotSub.XLim=[0 0.01];
          plotSub.YLim=[-1 3];
          hGUI.makePlot(plotSub);
          hGUI.labelx(hGUI.figData.plotSub,'Time (s)');
          hGUI.labely(hGUI.figData.plotSub,'i (pA)');
          
          % refined trace
          lH=line(hGUI.hekadat.stAxis,NaN(size(hGUI.hekadat.sdata(currWavei,:))),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subTrace')
          
          %zero line
          lH=line(hGUI.hekadat.stAxis,zeros(size(hGUI.hekadat.sdata(currWavei,:))),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineSub')
          
          
          %correction limit line
          lH=line([hGUI.hekadat.stAxis(tlimi) hGUI.hekadat.stAxis(tlimi)],plotSub.YLim,'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLine')
          
          hleft=.735;
          hwidth=.17;
          
          % Data and blank histograms
          plotHist=struct('Position',[hleft ptop hwidth pheight],'tag','plotHist');
          plotHist.YAxisLocation='right';
          plotHist.XLim=[0 0.1];
          plotHist.YLim=plotCurr.YLim;
          hGUI.makePlot(plotHist);
          
          %zero line
          lH=line([0 1],[0 0],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineHist')

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
          plotHist2.XLim=[0 0.1];
          plotHist2.YLim=plotSub.YLim;
          hGUI.makePlot(plotHist2);
         
          % All data histogram
          if ~isempty(hekadat.histx)
              lH=line(hekadat.stairy,hekadat.stairx,'Parent',hGUI.figData.plotHist2);
              set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
              set(lH,'DisplayName','subHistAll')
          end
          
          %zero line
          lH=line([0 1],[0 0],'Parent',hGUI.figData.plotHist2);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineHist2')
          
          % Curated hist
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist2);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','subHist')

          hGUI.updatePlots();
%           if params.LockNow
%               hGUI.lockButtonCall();
%           end          
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            hGUI.params.PlotNow=PlotNow;
            % figData.PlotNow=PlotNow;
            
            % current wave
            currWave=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAsnamefind(currWave);

            % find flanking ccc (left and right)
            tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));

            stags=Selected(:,1);
            firstL=find(cellfun(tagfindfx('ccc'),stags),1,'first');
            if PlotNow<=firstL % no left
                cccLi=find(cellfun(tagfindfx('ccc'),stags),1,'first');
                cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),stags(PlotNow+1:end)),1,'first');
            elseif PlotNow==size(Selected,1) % no right
                cccLi=find(cellfun(tagfindfx('ccc'),stags(1:PlotNow)),1,'last');
                cccRi=find(cellfun(tagfindfx('ccc'),stags),1,'last');
            else
                cccLi=find(cellfun(tagfindfx('ccc'),stags(1:PlotNow)),1,'last');
                cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),stags(PlotNow+1:end)),1,'first');
            end
            
            
            cccLWave=hGUI.getRowNamebyIndex(hGUI,cccLi);
            cccLWavei=hGUI.hekadat.HEKAsnamefind(cccLWave);
            cccRWave=hGUI.getRowNamebyIndex(hGUI,cccRi);
            cccRWavei=hGUI.hekadat.HEKAsnamefind(cccRWave);
            
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
            if ~hGUI.hekadat.baselinecorrectionFlag
                % current trace
                currentTrace=hGUI.hekadat.sdata(currWavei,:)-hGUI.hekadat.sBaseline(currWavei);
                lHNow=findobj('DisplayName','currWave');
                set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
                % flanking ccc
                nearestLBlank=hGUI.hekadat.sdata(cccLWavei,:)-hGUI.hekadat.sBaseline(cccLWavei);
                nearestRBlank=hGUI.hekadat.sdata(cccRWavei,:)-hGUI.hekadat.sBaseline(cccRWavei);
                nearestBlank=((nearestLBlank+nearestRBlank)./2);
                lHNow=findobj('DisplayName','nearestBlank');
                set(lHNow,'YData',nearestBlank,'Color',whithen(colors(PlotNow,:),.5))
            else
            % current trace
            currentTrace=hGUI.hekadat.sdata(currWavei,:);%-hGUI.hekadat.sBaseline(currWavei);
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
            % flanking ccc
            nearestLBlank=hGUI.hekadat.sdata(cccLWavei,:);%-hGUI.hekadat.sBaseline(cccLWavei);
            nearestRBlank=hGUI.hekadat.sdata(cccRWavei,:);%-hGUI.hekadat.sBaseline(cccRWavei);
            nearestBlank=((nearestLBlank+nearestRBlank)./2);
            lHNow=findobj('DisplayName','nearestBlank');
            set(lHNow,'YData',nearestBlank,'Color',whithen(colors(PlotNow,:),.5))
            end
            
            % subtract nose and mean of flanking blanks
            tlimi=find(hGUI.hekadat.stAxis<=hGUI.params.tlim,1,'last');
            subTrace=currentTrace;
            subTrace(1:tlimi)=subTrace(1:tlimi)-nearestBlank(1:tlimi);
            subTrace(tlimi+1:end)=subTrace(tlimi+1:end)-mean(nearestBlank(2000:end),2);
            
            lHNow=findobj('DisplayName','subTrace');
            set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:))
            
            lHNow=findobj('DisplayName','correctedWave');
            set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:)/2)
            
            currtag=findobj('tag','currtag');
            set(currtag,'String',hGUI.hekadat.stags(currWavei));
            set(hGUI.figData.infoTable,'Data',Selected)
            
            % calculate histograms and reset xlims
            [currHistX,currHistY]=hGUI.calculateHist(currentTrace,hGUI.params.nbins,min(currentTrace),max(currentTrace));
            hHNow=findobj('DisplayName','currHist');
            set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))
            
            [cccHistX,cccHistY]=hGUI.calculateHist(nearestBlank,hGUI.params.nbins,min(currentTrace),max(currentTrace));
            hHNow=findobj('DisplayName','cccHist');
            set(hHNow,'XData',cccHistY,'YData',cccHistX,'Color',whithen(colors(PlotNow,:),.5))
            
            [subHistX,subHistY]=hGUI.calculateHist(subTrace,hGUI.params.nbins,-.5,2);
            hHNow=findobj('DisplayName','subHist');
            set(hHNow,'XData',subHistY,'YData',subHistX,'Color',colors(PlotNow,:))
            
            maxlim=max([max(currHistY) max(cccHistY)]);
            set(hGUI.figData.plotHist,'XLim',[0 maxlim*1.05])
            set(hGUI.figData.plotHist2,'XLim',[0 max(subHistY)*1.05])
            
            hGUI.refocusTable(PlotNow);
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            if hGUI.hekadat.baselinecorrectionFlag
                warning('Correction already saved\n')
            else    
                tlimi=find(hGUI.hekadat.stAxis>=hGUI.params.tlim,1,'first');
                
                tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
                cccFirst=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags),1,'first');
                cccLi=NaN(size(hGUI.hekadat.swaveNames,1),1);
                cccLi(1:cccFirst)=cccFirst;
                for i=cccFirst+1:size(hGUI.hekadat.swaveNames,1)
                    cccLi(i)=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(1:i)),1,'last');
                end
                cccRi=NaN(size(hGUI.hekadat.swaveNames,1),1);
                for i=1:size(hGUI.hekadat.swaveNames,1)-1
                    cccRi(i)=i+find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags(i+1:end)),1,'first');
                end
                cccRi(end)=find(cellfun(tagfindfx('ccc'),hGUI.hekadat.stags),1,'last');
                
                sdata=hGUI.hekadat.HEKAbldata; %including baseline subtraction
                submat=zeros(size(hGUI.hekadat.sdata));
                submat(:,1:tlimi)=(sdata(cccLi,1:tlimi)+sdata(cccRi,1:tlimi))./2;
                hGUI.hekadat.sdata=sdata-submat; %makes baseline subtraction and capacitive transient removal permanent
                
                % recalculating all data histogram
                alldata=reshape(hGUI.hekadat.sdata,1,numel(hGUI.hekadat.sdata));
                [hGUI.hekadat.stairx,hGUI.hekadat.stairy]=hGUI.calculateHist(alldata,hGUI.params.nbins,-1,2);
                deltax=(hGUI.hekadat.stairx(2)-hGUI.hekadat.stairx(1))/2;
                hGUI.hekadat.histx=hGUI.hekadat.stairx(1:2:end)+deltax;
                hGUI.hekadat.histy=hGUI.hekadat.stairy(1:2:end);
                
                hGUI.hekadat.stCorrection=hGUI.params.tlim;
                hGUI.hekadat.changeBLCFlag(1);
                hGUI.hekadat.HEKAsave();
                fprintf('sdata should be ready for idealization: go to gxtx_fitHist to determine threshold\n')
            end
            hGUI.enableGui;
        end
        
        function updateTable(hGUI,~,eventdata)
           hGUI.disableGui;
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
           hGUI.enableGui;
        end
       
        function nextButtonCall(hGUI,~,~)
           hGUI.disableGui;
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
           hGUI.enableGui;
       end
       
       function prevButtonCall(hGUI,~,~)
           hGUI.disableGui;
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
           hGUI.enableGui;
       end
    end
    
    methods (Static=true)
         
    end
end