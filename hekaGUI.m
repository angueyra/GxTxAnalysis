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
           buttonstruct.Units='normalized';
           buttonstruct.callback=@hGUI.tagButtonCall;
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .675 0.10 .10]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string',sprintf('tag as %s',buttonstruct.tag));
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           %create button
           buttonName=sprintf('%sButton',buttonstruct.tag);
           hGUI.figData.(buttonName) = uicontrol(buttonstruct.Parent,buttonstruct);
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
           fprintf('tagged %s as %s\n',hekadat.waveNames{currWavei},tag);
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
       

   end
   
   methods (Static=true)
       function curr_RowName=getRowName(infoTable,index)
           rowNames=get(infoTable,'RowName');
           currWaveNamestart=regexp(rowNames{index},'e_');
           currWaveNameend=regexp(rowNames{index},'</font')-1;
           curr_RowName=rowNames{index}(currWaveNamestart:currWaveNameend);
       end
   end
end