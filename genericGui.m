classdef genericGui
    %Created Dec_2015 (angueyra@nih.gov)
    properties
        fignumber
        hObject
        params
        inputdata
    end
    
    properties (SetAccess = private)
        initalparseFlag = 0;
    end
    
    methods
        function
            
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