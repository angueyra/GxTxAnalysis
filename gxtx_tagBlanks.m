classdef gxtx_tagBlanks<hekaGUI
    properties
    end
    
    methods
        function hGUI=gxtx_tagBlanks(hekadat,params,fign)
          params=checkStructField(params,'PlotNow',1);
          hGUI@hekaGUI(hekadat,params,fign);
          Rows=size(hekadat.waveNames,1);
          colors=pmkmp(Rows,'CubicL');
          tcolors=round(colors./1.2.*255);
          Selected=false(Rows,3);
          Selected(:,1)=hekadat.HEKAtagfind('ccc');
          Selected(:,2)=hekadat.HEKAtagfind('bad');
          RowNames=cell(size(Rows));
          for i=1:Rows
              RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.waveNames{i});
          end
          Selected(params.PlotNow,3)=true;
          infoData=Selected;
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.21, .985];
          tableinput.FontSize=6;
          tableinput.ColumnWidth={50};
          tableinput.Data=infoData;
          tableinput.ColumnName={'ccc','bad','P'};
          tableinput.RowName=RowNames;
          tableinput.headerWidth=63;
          hGUI.infoTable(tableinput);
          hGUI.nextButton();
          hGUI.prevButton();
          
          cccBt=struct;
          cccBt.tag='ccc';
          hGUI.tagButton(cccBt);
        end
    end
end