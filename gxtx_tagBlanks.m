function gxtx_tagBlanks(hekadat,params,fignumber)

if isfield(params,'PlotNow') && ~isempty(params.PlotNow)
    PlotNow=params.PlotNow;
else 
    PlotNow=1;
end

figure(fignumber)
clf
figH=gcf;
set(gcf,'WindowStyle','normal');
set(gcf,'Position',[10 450 1111 800]);

 % create new panel slider, info table
    delete(get(figH, 'Children'));
    figData.currentFunction = mfilename;
    figData.PlotNow=PlotNow;
    l = .0001; %left position
    w = .9999; %width
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
    Selected(PlotNow,3)=true;
    infoData = Selected;
    figData.infoTable = uitable('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [0.01, .005, 0.21, .985], ...
        'FontSize',6,...
        'ColumnWidth',{50},...
        'Data', infoData, ...
        'ColumnName',{'Blnk','Bad','P'},...
        'RowName', RowNames,...
        'ColumnEditable', true(1,Rows),...
        'CellEditCallback',{@table_callBack});
    figData.panel = uipanel('Parent', figH, ...
        'Units', 'normalized', ...
        'UserData',hekadat, ...
        'Position', [l 0.00001 w 1],...
        'tag','panel');
    figData.previousButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .90 0.10 .08], ...
        'Style', 'pushbutton', ...
        'tag','prev_push',...
        'string','<---',...
        'FontSize',10,...
        'UserData',params,...
        'callback',{@previous_callBack});
    figData.nextButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .80 0.10 .08], ...
        'Style', 'pushbutton', ...
        'tag','next_push',...
        'string','--->',...
        'FontSize',10,...
        'UserData',params,...
        'callback',{@next_callBack});
    figData.blankButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .68 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','blank_push',...
        'string','tag as Blank',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@blank_callBack});
    figData.badButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .50 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','bad_push',...
        'string','tag as Bad Data',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@bad_callBack});
    figData.untagButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .39 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','untag_push',...
        'string','untag',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@untag_callBack});
    figData.lockButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .09 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','lock_push',...
        'string','Lock&Save',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@lock_callBack});
    modifyUITableHeaderWidth(figData.infoTable,63);
    set(figH, 'UserData', figData)%, 'ResizeFcn',{@canvasResizeFcn,figData});
    
    % Data plot
    sp = axes('Position',[.27 .08 .60 .43],'Parent', figData.panel,'tag','sp');
    set(sp,'XScale','linear','YScale','linear')
    set(get(sp,'XLabel'),'string','Time (s)')
    set(get(sp,'YLabel'),'string','i (pA)')
    set(sp,'YAxisLocation','left');
    set(sp,'XLim',[min(hekadat.tAxis) max(hekadat.tAxis)])
    set(sp,'YLim',[min(min(hekadat.data)) max(max(hekadat.data))])
    
    for i=1:Rows
        lH=line(hekadat.tAxis,hekadat.data(i,:),'Parent',sp);
        set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(i,:))
        set(lH,'DisplayName',hekadat.waveNames{i})
    end
    
    sp2 = axes('Position',[.27 .55 .60 .43],'Parent', figData.panel,'tag','sp2');
    set(sp2,'XScale','linear','YScale','linear')
    set(get(sp2,'YLabel'),'string','i (pA)')
    set(sp2,'YAxisLocation','left','XTickLabel',[])
    set(sp2,'XLim',[min(hekadat.tAxis) max(hekadat.tAxis)])
    set(sp2,'YLim',[min(min(hekadat.data)) max(max(hekadat.data))])
    
    % blanks mean
    lH=line(hekadat.tAxis,NaN(size(hekadat.data(PlotNow,:))),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[.5 .5 .5])
    set(lH,'DisplayName','CurrentMean')
    
    % current trace
    lH=line(hekadat.tAxis,hekadat.data(PlotNow,:),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','CurrentTrace')
    
    
    
    plotOne(figData.infoTable);
end

function plotOne(hObject,eventdata)
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
figData.PlotNow=PlotNow;
Rows=size(hekadat.waveNames,1);
colors=pmkmp(Rows,'CubicL');

% blank mean
if sum(Selected(:,1))>0
    lHMean=findobj('DisplayName','CurrentMean');
    set(lHMean,'YData',hekadat.HEKAtagmean('ccc'));
end

%current trace
lHNow=findobj('DisplayName','CurrentTrace');
set(lHNow,'YData',hekadat.data(PlotNow,:),'Color',colors(PlotNow,:))


% move current trace to top of all traces
curt=findobj('DisplayName',hekadat.waveNames{PlotNow});
if PlotNow==1
    set(curt,'Color',[0,.7,0],'LineWidth',2)
elseif PlotNow==Rows
    set(curt,'Color',[0,0,0],'LineWidth',2)
else
    set(curt,'Color',[.7,0,0],'LineWidth',2)
end
    
uistack(curt,'top')
end

function blank_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
Selected(PlotNow,1)=true;
hekadat.tags{PlotNow}='ccc';
assignin('base','hekadat',hekadat);
set(figData.infoTable,'Data',Selected)
next_callBack(figData.infoTable)
set(figData.panel,'UserData',hekadat);
fprintf('%s = ''ccc''\n',hekadat.waveNames{PlotNow})
enableGui(hObject);
end

function bad_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
Selected(PlotNow,2)=true;
hekadat.tags{PlotNow}='bad';
assignin('base','hekadat',hekadat);
set(figData.infoTable,'Data',Selected)
next_callBack(figData.infoTable)
set(figData.panel,'UserData',hekadat);
enableGui(hObject);
end

function untag_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
Selected(PlotNow,2)=true;
hekadat.tags{PlotNow}='';
assignin('base','hekadat',hekadat);
set(figData.infoTable,'Data',Selected)
set(figData.panel,'UserData',hekadat);
enableGui(hObject);
end

function lock_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
hekadat.HEKAsave();
assignin('base','hekadat',hekadat);
fprtinf('Saved to %s%s',hekadat.dirSave,hekadat.dirFile);
set(figData.panel,'UserData',hekadat);
enableGui(hObject);
end


function next_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
PlotNext=PlotNow+1;
if PlotNext>size(Selected,1)
    PlotNext=1;
end
Selected(PlotNow,end)=false;
Selected(PlotNext,end)=true;
set(figData.infoTable,'Data',Selected)

Rows=size(hekadat.waveNames,1);
colors=pmkmp(Rows,'CubicL');
curt=findobj('DisplayName',hekadat.waveNames{PlotNow});
set(curt,'Color',colors(PlotNow,:),'LineWidth',1)

set(figData.panel,'UserData',hekadat);
plotOne(hObject);
enableGui(hObject);
end

function previous_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(Selected(:,end));
PlotNext=PlotNow-1;
if PlotNext<1
    PlotNext=size(Selected,1);
end
Selected(PlotNow,end)=false;
Selected(PlotNext,end)=true;
set(figData.infoTable,'Data',Selected)

Rows=size(hekadat.waveNames,1);
colors=pmkmp(Rows,'CubicL');
curt=findobj('DisplayName',hekadat.waveNames{PlotNow});
set(curt,'Color',colors(PlotNow,:),'LineWidth',1)

set(figData.panel,'UserData',hekadat);
plotOne(hObject);
enableGui(hObject);
end


function table_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
Plotted=find(Selected(:,end));
Plotted=Plotted(~ismember(find(Selected(:,end)),eventdata.Indices(1)));

Selected(Plotted,end)=false;
set(figData.infoTable,'Data',Selected)

Rows=size(hekadat.waveNames,1);
colors=pmkmp(Rows,'CubicL');
curt=findobj('DisplayName',hekadat.waveNames{Plotted});
set(curt,'Color',colors(Plotted,:),'LineWidth',1)

set(figData.panel,'UserData',hekadat);
plotOne(hObject);
enableGui(hObject);
end

function disableGui(hObject)
set(findobj('-property','Enable'),'Enable','off')
drawnow
end
function enableGui(hObject)
set(findobj('-property','Enable'),'Enable','on')
drawnow
end