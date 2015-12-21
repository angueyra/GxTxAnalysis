classdef hekaGUI < genericGUI
   properties
       hekadat
   end
   
   methods
       function hGUI=hekaGUI(hekadat,params,fign)
          if nargin == 0
            fign=10;
          end
          hGUI@genericGUI(fign);
          hGUI.hekadat=hekadat;
          hGUI.params=params;
       end
       
       % Object creation
       function makePlot(hGUI,plotstruct,varargin)
           if nargin < 2
               plotstruct=struct;
               plotstruct.tag='mainPlot';
           else
               plotstruct=checkStructField(plotstruct,'tag','mainPlot');
           end
           % if same exists, delete it
           delete(findobj('tag',plotstruct.tag))
           % plot properties
           plotstruct.Parent=hGUI.figData.panel;
           plotstruct=checkStructField(plotstruct,'Position',[.27 .55 .60 .43]);
           hGUI.figData.(plotstruct.tag)=axes(plotstruct);
       end
       
       function tagButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag='tag';
           else
               buttonstruct=checkStructField(buttonstruct,'tag','tag');
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % button definition
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.callback=@hGUI.tagButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .675 0.10 .10]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string',sprintf('tag as %s',buttonstruct.tag));
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,'Units','normalized',buttonstruct);
       end
       
       function untagButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag='untag';
           else
               buttonstruct=checkStructField(buttonstruct,'tag','untag');
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % button definition
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.callback=@hGUI.untagButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.89 .39 0.10 .10]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string','untag');
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,'Units','normalized',buttonstruct);
       end
       
       function nextButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag='next';
           else
               buttonstruct=checkStructField(buttonstruct,'tag','next');
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % button definition
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.Units='normalized';
           buttonstruct.callback=@hGUI.nextButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .825 0.10 .08]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string','-->');
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,buttonstruct);
       end
       
       function prevButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag='prev';
           else
               buttonstruct=checkStructField(buttonstruct,'tag','prev');
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % button definition
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.Units='normalized';
           buttonstruct.callback=@hGUI.prevButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .91 0.10 .08]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string','<--');
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,buttonstruct);
       end
       
       function lockButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag='lock';
           else
               buttonstruct=checkStructField(buttonstruct,'tag','lock');
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % button definition
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.Units='normalized';
           buttonstruct.callback=@hGUI.lockButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .09 0.10 .10]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string','Lock&Save');
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,buttonstruct);
       end
       
       % Callback functions
       function tagButtonCall(hGUI,hObject,~)
           hGUI.disableGui();
           disp('tag')
           Selected=get(hGUI.figData.infoTable,'Data');
           tag=get(hObject,'tag');
           Plotted=find(cell2mat(Selected(:,end)));
           Selected{Plotted,1}=tag;
           
           currWave=getRowName(hGUI.figData.infoTable,Plotted);
           currWavei=hGUI.hekadat.HEKAnamefind(currWave);
           
           hGUI.hekadat.tags{currWavei}=tag;
           fprintf('tagged %s as %s\n',hGUI.hekadat.waveNames{currWavei},tag);
           set(hGUI.figData.infoTable,'Data',Selected)
           hGUI.nextButtonCall();
           hGUI.enableGui();
       end
       
       function untagButtonCall(hGUI,~,~)
           hGUI.disableGui();
           disp('untag')
           Selected=get(hGUI.figData.infoTable,'Data');
           tag='';
           Plotted=find(cell2mat(Selected(:,end)));
           Selected{Plotted,1}=tag;
           
           currWave=getRowName(hGUI.figData.infoTable,Plotted);
           currWavei=hGUI.hekadat.HEKAnamefind(currWave);
           
           hGUI.hekadat.tags{currWavei}=tag;
           fprintf('untagged %s\n',hGUI.hekadat.waveNames{currWavei});
           set(hGUI.figData.infoTable,'Data',Selected)
           hGUI.nextButtonCall();
           hGUI.enableGui();
       end
       
       function nextButtonCall(hGUI,~,~)
           hGUI.disableGui();
           disp('next')
           Selected=get(hGUI.figData.infoTable,'Data');
           Plotted=find(Selected(:,end));
           PlotNext=Plotted+1;
           if PlotNext>size(Selected,1)
               PlotNext=1;
           end
           Selected(Plotted,end)=false;
           Selected(PlotNext,end)=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=pmkmp(Rows,'CubicL');
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Plotted});
           set(curt,'Color',colors(Plotted,:),'LineWidth',1)
           
%            plotOne(hObject);

           hGUI.enableGui();
       end
       
       function prevButtonCall(hGUI,~,~)
           hGUI.disableGui();
           disp('prev')
           Selected=get(hGUI.figData.infoTable,'Data');
           Plotted=find(Selected(:,end));
           PlotNext=Plotted-1;
           if PlotNext<1
               PlotNext=size(Selected,1);
           end
           Selected(Plotted,end)=false;
           Selected(PlotNext,end)=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=pmkmp(Rows,'CubicL');
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Plotted});
           set(curt,'Color',colors(Plotted,:),'LineWidth',1)
%            plotOne(hObject);
           
           hGUI.enableGui();
       end
       
       function lockButtonCall(hGUI,~,~)
           hGUI.disableGui();
           hGUI.hekadat.HEKAsave();
           hGUI.enableGui();
       end
       
       function RowNames=waveTableNames(hGUI)
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=pmkmp(Rows,'CubicL');
           tcolors=round(colors./1.2.*255);
           RowNames=cell(size(Rows));
           for i=1:Rows
               RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hGUI.hekadat.waveNames{i});
           end
       end
   end
   
   methods (Static=true)
       function curr_RowName=getRowName(infoTable,index)
           rowNames=get(infoTable,'RowName');
           currWaveNamestart=regexp(rowNames{index},'e_');
           currWaveNameend=regexp(rowNames{index},'</font')-1;
           curr_RowName=rowNames{index}(currWaveNamestart:currWaveNameend);
       end
       
       function labelx(plothandle,xlabel)
          set(get(plothandle,'XLabel'),'string',xlabel) 
       end
       
       function labely(plothandle,ylabel)
          set(get(plothandle,'YLabel'),'string',ylabel) 
       end
       
   end
end