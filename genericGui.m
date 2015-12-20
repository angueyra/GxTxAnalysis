classdef genericGUI < handle
    %Created Dec_2015 (angueyra@nih.gov)
    properties
        figH
        params
        figData=struct;
    end
    
    properties (SetAccess = private)
        initalparseFlag = 0;
    end
    
    methods       
        function hGUI=genericGUI(fign)
            if isempty(fign)
                fign=10;
            end
            figure(fign);clf;
            hGUI.figH=gcf;
            set(hGUI.figH,'WindowStyle','normal');
            set(hGUI.figH,'Position',[250 450 1111 800]);            
            delete(get(hGUI.figH, 'Children')); %delete every ui object whithin figure
            set(hGUI.figH,'UserData',hGUI);            
            % set the base panel for ui interactions
            hGUI.figData.panel = uipanel('Parent', hGUI.figH, ...
                'Units', 'normalized', ...
                'UserData',[], ...
                'Position', [.0001 .0001 .9999 .9999],...
                'tag','panel');
        end
        
        function infoTable(hGUI,tableinput)
            if nargin == 0
                tableinput=struct;
            end
            % if previous infoTable exist, delete it
            delete(findobj('tag','infoTable'))
            % unchangeable parameters (overwrites if different)
            tableinput.Parent=hGUI.figH;
            tableinput.Units='normalized';
            tableinput.tag='infoTable';
            tableinput=checkStructField(tableinput,'Position',[0.01, .005, 0.185, .985]);
            tableinput=checkStructField(tableinput,'FontSize',10);
            tableinput=checkStructField(tableinput,'ColumnWidth',{20,20,20});
            tableinput=checkStructField(tableinput,'ColumnName',{'a','b','c'});
            tableinput=checkStructField(tableinput,'ColumnFormat',{});
            tableinput=checkStructField(tableinput,'RowName',{'1','2','3'});
            tableinput=checkStructField(tableinput,'ColumnEditable',true(1,3));
            tableinput=checkStructField(tableinput,'CellEditCallback',@hGUI.updateTable);
            tableinput=checkStructField(tableinput,'Data',false(3,3));
            tableinput=checkStructField(tableinput,'headerWidth',20);
              
            hGUI.figData.infoTable = uitable('Parent', tableinput.Parent, ...
                'Data', tableinput.Data, ...
                'Tag','infoTable',...
                'Units', tableinput.Units, ...
                'Position', tableinput.Position, ...
                'FontSize',tableinput.FontSize,...
                'ColumnWidth',tableinput.ColumnWidth,...
                'ColumnName',tableinput.ColumnName,...
                'ColumnFormat',tableinput.ColumnFormat,...
                'RowName', tableinput.RowName,...
                'ColumnEditable', tableinput.ColumnEditable,...
                'CellEditCallback',tableinput.CellEditCallback);
            modifyUITableHeaderWidth(hGUI.figData.infoTable,tableinput.headerWidth);
        end
        
        function updateTable(hGUI,~,~)
            hGUI.disableGui();
            hGUI.enableGui();
        end
        
    end
    
    methods (Static=true)
        
        function disableGui()
            set(findobj('-property','Enable'),'Enable','off')
            drawnow
        end
        function enableGui()
            set(findobj('-property','Enable'),'Enable','on')
            drawnow
        end
    end
end