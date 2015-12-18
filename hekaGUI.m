classdef hekaGUI < genericGUI
   properties
       hekadat
   end
   
   methods
       function hGUI=hekaGUI(hekadat,fign)
          if nargin == 0
            fign=10;
          end
          hGUI@genericGUI(fign);
          hGUI.hekadat=hekadat;
          tags=cellstr(['ooo';'ooo';'ooo']);
          Selected=false(3,2);
          Selected(1,1)=true;
          tableinput=struct;
          tableinput=checkStructField(tableinput,'Data',[tags num2cell(Selected)]);
          tableinput=checkStructField(tableinput,'headerWidth',40);
          hGUI.infoTable(tableinput);
          hGUI.tagButton();
       end
         
       function tagButton(hGUI,buttonstruct)
           if nargin < 2
               buttonstruct=struct;
               buttonstruct.tag=sprintf('%gButton','tag');
           else
               buttonstruct=checkStructField(buttonstruct,'tag',sprintf('%gButton','tag'));
           end
           % if same exists, delete it
           delete(findobj('tag',buttonstruct.tag))
           % unchangeable parameters (overwrites if different)
           buttonstruct.Parent=hGUI.figH;
           buttonstruct.Units='normalized';
           
           buttonstruct=checkStructField(buttonstruct,'Position',[.895 .895 0.10 .10]);
           buttonstruct=checkStructField(buttonstruct,'Style','pushbutton');
           buttonstruct=checkStructField(buttonstruct,'string','tag as tag');
           buttonstruct=checkStructField(buttonstruct,'FontSize',10);
           buttonstruct=checkStructField(buttonstruct,'UserData',[]);
           
           hGUI.figData.tagButton = uicontrol('Parent', buttonstruct.Parent, ...
               'Units', buttonstruct.Units, ...
               'Position', buttonstruct.Position, ...
               'Style', buttonstruct.Style, ...
               'tag',buttonstruct.tag,...
               'string',buttonstruct.string,...
               'FontSize',buttonstruct.FontSize,...
               'UserData',buttonstruct.UserData,...
               'callback',{@hGUI.tagButtonCall});
       end
%        function hGUI=scrollButton(hGUI)
%                 figData.nextButton = uicontrol('Parent', figH, ...
%         'Units', 'normalized', ...
%         'Position', [.89 .80 0.10 .08], ...
%         'Style', 'pushbutton', ...
%         'tag','next_push',...
%         'string','--->',...
%         'FontSize',10,...
%         'UserData',params,...
%         'callback',{@next_callBack});
%        end
       
       function tagButtonCall(hGUI,~,~)
           hGUI.disableGui();
           
           disp('tag')
%            figData=get(get(hObject,'Parent'),'UserData');
%            hekadat=get(figData.panel,'UserData');
%            Selected=get(figData.infoTable,'Data');
%            tag=get(hObject,'tag');
%            tag=tag(1:3);
%            PlotNow=find(cell2mat(Selected(:,end)));
%            Selected{PlotNow,1}=tag;
%            
%            currWave=getRowName(figData.infoTable);
%            currWavei=hekadat.HEKAnamefind(currWave);
%            
%            hekadat.tags{currWavei}=tag;
%            assignin('base','hekadat',hekadat);
%            fprintf('tagged %s as %s\n',hekadat.waveNames{currWavei},tag);
%            set(figData.infoTable,'Data',Selected)
%            set(figData.panel,'UserData',hekadat);
%            next_callBack(figData.infoTable)
           hGUI.enableGui();
       end

   end
end