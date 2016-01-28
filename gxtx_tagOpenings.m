classdef gxtx_tagOpenings<hekaGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_tagOpenings(hekadat,params,fign) 
          params=checkStructField(params,'PlotNow',1);
          hGUI@hekaGUI(hekadat,params,fign);
          Rows=size(hekadat.waveNames,1);
          colors=pmkmp(Rows,'CubicL');
          
          tnil=hGUI.hekadat.HEKAstairsprotocol;
          tnil=tnil.st;
          
          % info Table
          Selected=false(Rows,1);         
          Selected(params.PlotNow,end)=true;
          infoData=[hGUI.hekadat.tags num2cell(Selected)];
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.18, .985];
          tableinput.FontSize=10;
          tableinput.ColumnWidth={50};
          tableinput.Data=infoData;
          tableinput.ColumnName={'tag','P'};
          tableinput.RowName=hGUI.waveTableNames();
          tableinput.headerWidth=63;
          hGUI.infoTable(tableinput);
          
          % buttons
          hGUI.nextButton();
          hGUI.prevButton();
          hGUI.lockButton();
          oooBt=struct('tag','ooo','Position',[.895 .67 0.10 .10]);
          hGUI.tagButton(oooBt);
          cocBt=struct('tag','coc','Position',[.895 .57 0.10 .10]);
          hGUI.tagButton(cocBt);
          zzzBt=struct('tag','zzz','Position',[.895 .47 0.10 .10]);
          hGUI.tagButton(zzzBt);
          cccBt=struct('tag','ccc','Position',[.895 .34 0.10 .10]);
          hGUI.tagButton(cccBt);
          badBt=struct('tag','bad','Position',[.895 .24 0.10 .10]);
          hGUI.tagButton(badBt);
          untagBt=struct('tag','untag','Position',[.895 .14 0.10 .10]);
          hGUI.untagButton(untagBt);
          
          cccmean=hGUI.hekadat.HEKAtagmean('ccc');
          
          plotCurr=struct('Position',[.255 .555 .60 .43],'tag','plotCurr');
          plotCurr.XLim=[min(hGUI.hekadat.tAxis) max(hGUI.hekadat.tAxis)]-tnil;
          plotCurr.YLim=[min(min(hGUI.hekadat.data-repmat(cccmean,Rows,1))) max(max(hGUI.hekadat.data-repmat(cccmean,Rows,1)))];
          hGUI.makePlot(plotCurr);
          hGUI.labelx(hGUI.figData.plotCurr,'Time (s)');
          hGUI.labely(hGUI.figData.plotCurr,'i (pA)');
          
          % tag label
%           currTag=text((hGUI.hekadat.tAxis(end))*.9,max(max(hGUI.hekadat.data-repmat(cccmean,Rows,1)))*.9,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          currTag=text((hGUI.hekadat.tAxis(end)-tnil)*.9,3,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          set(currTag,'tag','currTag','FontSize',24)
          % index label
%           currTag=text((hGUI.hekadat.tAxis(end))*.9,max(max(hGUI.hekadat.data))*.9,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          currIndex=text(0.01-tnil,3,num2str(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          set(currIndex,'tag','currIndex','FontSize',24)
          
          % current trace
          lH=line(hGUI.hekadat.tAxis-tnil,NaN(size(hGUI.hekadat.data(params.PlotNow,:))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          
          hGUI.updatePlots();
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            colors=pmkmp(size(hGUI.hekadat.waveNames,1),'CubicL');
            
            cccmean=hGUI.hekadat.HEKAtagmean('ccc');
            %current trace
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',hGUI.hekadat.data(PlotNow,:)-cccmean,'Color',colors(PlotNow,:))
            % move current trace to top of all traces
            curt=findobj('DisplayName',hGUI.hekadat.waveNames{PlotNow});
            if PlotNow==1
                set(curt,'Color',[0,.7,0],'LineWidth',1)
            elseif PlotNow==size(hGUI.hekadat.waveNames,1)
                set(curt,'Color',[.7,0,0],'LineWidth',1)
            else
                set(curt,'Color',[0,0,0],'LineWidth',1)
            end
            uistack(curt,'top')
            
            currtag=findobj('tag','currTag');
            set(currtag,'String',hGUI.hekadat.tags(PlotNow));
            curri=findobj('tag','currIndex');
            set(curri,'String',num2str(PlotNow));
            
            hGUI.refocusTable(PlotNow);
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