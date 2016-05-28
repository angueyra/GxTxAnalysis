classdef gxtx_tagBlanks<hekaGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_tagBlanks(hekadat,params,fign) 
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
          tableinput.headerWidth=77;
          hGUI.infoTable(tableinput);
          
          % buttons
          hGUI.nextButton();
          hGUI.prevButton();
          hGUI.lockButton();
          cccBt=struct('tag','ccc');
          hGUI.tagButton(cccBt);
          badBt=struct('tag','bad','Position',[.895 .50 0.10 .10]);
          hGUI.tagButton(badBt);
          untagBt=struct('tag','untag','Position',[.895 .39 0.10 .10]);
          hGUI.untagButton(untagBt);
          
          % plots
          plotAll=struct('Position',[.255 .08 .60 .43],'tag','plotAll');
          plotAll.XLim=[min(hGUI.hekadat.tAxis) max(hGUI.hekadat.tAxis)]-tnil;
          plotAll.YLim=[min(min(hGUI.hekadat.data)) max(max(hGUI.hekadat.data))];
          plotAll.YLim=[-10 15];
          hGUI.makePlot(plotAll);
          hGUI.labelx(hGUI.figData.plotAll,'Time (s)');
          hGUI.labely(hGUI.figData.plotAll,'i (pA)');
          
          for i=1:Rows
              lH=line(hGUI.hekadat.tAxis-tnil,hGUI.hekadat.data(i,:),'Parent',hGUI.figData.plotAll);
              set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',whithen(colors(i,:),.6))
              set(lH,'DisplayName',hGUI.hekadat.waveNames{i})
          end
          
          plotCurr=struct('Position',[.255 .555 .60 .43],'tag','plotCurr');
          plotCurr.XLim=[min(hGUI.hekadat.tAxis) max(hGUI.hekadat.tAxis)]-tnil;
          plotCurr.YLim=[min(min(hGUI.hekadat.data)) max(max(hGUI.hekadat.data))];
          plotCurr.YLim=[-10 15];
          hGUI.makePlot(plotCurr);
          hGUI.labelx(hGUI.figData.plotCurr,'Time (s)');
          hGUI.labely(hGUI.figData.plotCurr,'i (pA)');
          
          % blanks mean
          lH=line(hGUI.hekadat.tAxis-tnil,NaN(size(hGUI.hekadat.data(params.PlotNow,:))),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[.5 .5 .5])
          set(lH,'DisplayName','cccMean')
          
          % current trace
          lH=line(hGUI.hekadat.tAxis-tnil,hGUI.hekadat.data(params.PlotNow,:),'Parent',hGUI.figData.plotCurr);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          
          % tag label
%           currTag=text((hGUI.hekadat.tAxis(end))*.9,max(max(hGUI.hekadat.data))*.9,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          currTag=text((hGUI.hekadat.tAxis(end)-tnil)*.9,8,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          set(currTag,'tag','currTag','FontSize',24)
          
          % index label
%           currTag=text((hGUI.hekadat.tAxis(end))*.9,max(max(hGUI.hekadat.data))*.9,hGUI.hekadat.tags(params.PlotNow),'Parent',hGUI.figData.plotCurr);
          currStr=sprintf('%g',params.PlotNow);
          currIndex=text(0.01-tnil,8,currStr,'Parent',hGUI.figData.plotCurr);
          set(currIndex,'tag','currIndex','FontSize',24)
          
          totStr=sprintf('   of\n%g',size(hGUI.hekadat.data,1));
          totIndex=text(0.01-tnil,6,totStr,'Parent',hGUI.figData.plotCurr);
          set(totIndex,'tag','totStr','FontSize',10)
          
          hGUI.updatePlots();
        end
        
        function keyPress = detectKey(hGUI, ~, handles)
            % determine the key that was pressed
            keyPress = handles.Key;
            if strcmp(keyPress,'rightarrow')&&~isempty(hGUI.figData.nextButton)
                hGUI.nextButtonCall;
            elseif strcmp(keyPress,'leftarrow')&&~isempty(hGUI.figData.prevButton)
                hGUI.prevButtonCall;
            elseif strcmp(keyPress,'c')&&~isempty(hGUI.figData.prevButton)
                hGUI.tagButtonCall(hGUI.figData.cccButton)
            elseif strcmp(keyPress,'b')&&~isempty(hGUI.figData.prevButton)
                hGUI.tagButtonCall(hGUI.figData.badButton)
            elseif strcmp(keyPress,'u')&&~isempty(hGUI.figData.prevButton)
                hGUI.tagButtonCall(hGUI.figData.untagButton)
            end
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            colors=pmkmp(size(hGUI.hekadat.waveNames,1),'CubicL');
            
            % blank mean
            lHMean=findobj('DisplayName','cccMean');
            set(lHMean,'YData',hGUI.hekadat.HEKAtagmean('ccc'));
            
            %current trace
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',hGUI.hekadat.data(PlotNow,:),'Color',colors(PlotNow,:))
            
            % move current trace to top of all traces
            curt=findobj('DisplayName',hGUI.hekadat.waveNames{PlotNow});
            if PlotNow==1
                set(curt,'Color',[0,.7,0],'LineWidth',1)
            elseif PlotNow==size(hGUI.hekadat.waveNames,1)
                set(curt,'Color',[.7,0,0],'LineWidth',1)
            else
                set(curt,'Color',[0,0,0],'LineWidth',1)
            end
%             uistack(curt,'top')
            
            currtag=findobj('tag','currTag');
            set(currtag,'String',hGUI.hekadat.tags(PlotNow));
            
            curri=findobj('tag','currIndex');
            set(curri,'String',num2str(PlotNow));
            
%             hGUI.refocusTable(PlotNow);
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