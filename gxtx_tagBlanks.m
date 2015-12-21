classdef gxtx_tagBlanks<hekaGUI
    properties
    end
    
    methods
        function hGUI=gxtx_tagBlanks(hekadat,params,fign)
          params=checkStructField(params,'PlotNow',1);
          hGUI@hekaGUI(hekadat,params,fign);
          Rows=size(hekadat.waveNames,1);
          colors=pmkmp(Rows,'CubicL');
          
          % info Table
          Selected=false(Rows,3);
          Selected(:,1)=hekadat.HEKAtagfind('ccc');
          Selected(:,2)=hekadat.HEKAtagfind('bad');
          Selected(params.PlotNow,3)=true;
          infoData=Selected;
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.21, .985];
          tableinput.FontSize=6;
          tableinput.ColumnWidth={50};
          tableinput.Data=infoData;
          tableinput.ColumnName={'ccc','bad','P'};
          tableinput.RowName=hGUI.waveTableNames();
          tableinput.headerWidth=63;
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
          dataplot=struct('Position',[.27 .08 .60 .43],'tag','dataPlot');
          dataplot.XLim=[min(hGUI.hekadat.tAxis) max(hGUI.hekadat.tAxis)];
          dataplot.YLim=[min(min(hGUI.hekadat.data)) max(max(hGUI.hekadat.data))];
          hGUI.makePlot(dataplot);
          hGUI.labelx(hGUI.figData.dataPlot,'Time (s)');
          hGUI.labely(hGUI.figData.dataPlot,'i (pA)');
          
        end
    end
    
    methods (Static=true)
         
    end
end