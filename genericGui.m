classdef genericGUI
    %Created Dec_2015 (angueyra@nih.gov)
    properties
        figH
        hObject
        params
        figData
        pos_l=.0001; %left position
        pos_w=.9999; %width
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
            set(hGUI.figH,'Position',[10 450 1111 800]);
            
            delete(get(hGUI.figH, 'Children'));
        end
        
        function disableGui(hObject)
            set(findobj('-property','Enable'),'Enable','off')
            drawnow
        end
        function enableGui(hObject)
            set(findobj('-property','Enable'),'Enable','on')
            drawnow
        end
    end
end