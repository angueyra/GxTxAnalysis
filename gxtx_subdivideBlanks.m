function gxtx_subdivideBlanks(hekadat,params,fignumber)

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
    % only plot ccc, coc and ooo
    selWaves=logical(hekadat.HEKAtagfind('ccc'));
    selWavesi=find(selWaves==1);
    Rows=size(hekadat.waveNames(selWaves),1);
    colors=pmkmp(Rows,'CubicL');
    tcolors=round(colors./1.2.*255);
    Selected=false(Rows,1);
    RowNames=cell(size(Rows));
    for i=1:Rows
        RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.waveNames{selWavesi(i)});
    end
    Selected(PlotNow,1)=true;
    infoData = [hekadat.tags(selWaves) num2cell(Selected)];
    figData.infoTable = uitable('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [0.01, .005, 0.21, .985], ...
        'FontSize',10,...
        'ColumnWidth',{40},...
        'Data', infoData, ...
        'ColumnName',{'tag','P'},...
        'ColumnFormat',{'char','logical'},...
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
    figData.oooButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .68 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','ooo',...
        'string','tag as O O O',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.cocButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .58 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','coc',...
        'string','tag as C O C',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.zzzButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .48 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','zzz',...
        'string','tag as Z Z Z',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.blankButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .38 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','ccc',...
        'string','tag as blank',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.badButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .28 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','bad',...
        'string','tag as Bad Data',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.untagButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .18 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','untag_push',...
        'string','untag',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@untag_callBack});
    figData.lockButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [.89 .03 0.10 .10], ...
        'Style', 'pushbutton', ...
        'tag','lock_push',...
        'string','Lock&Save',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@lock_callBack});
    modifyUITableHeaderWidth(figData.infoTable,63);
    set(figH, 'UserData', figData)%, 'ResizeFcn',{@canvasResizeFcn,figData});
    
    
    tst=hekadat.HEKAstairsprotocol();
    currWave=getRowName(figData.infoTable);
    currWavei=hekadat.HEKAnamefind(currWave);
    
    % Data plot
    sp = axes('Position',[.27 .08 .60 .43],'Parent', figData.panel,'tag','sp');
    set(sp,'XScale','linear','YScale','linear')
    set(get(sp,'XLabel'),'string','Time (s)')
    set(get(sp,'YLabel'),'string','i (pA)')
    set(sp,'YAxisLocation','left');
    set(sp,'XLim',[0 tst.delta])
    set(sp,'XLim',[0 0.0050])
%     set(sp,'YLim',[-2 2])
    
    cccmean=hekadat.HEKAtagmean('ccc');
    lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(currWavei,tst.sti:tst.endi),'Parent',sp);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','CurrentTraceNoSub')
    lH=line(hekadat.tAxis(1:tst.deltai),cccmean(tst.sti:tst.endi),'Parent',sp);
    set(lH,'LineStyle','-','Marker','.','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
    set(lH,'DisplayName','cccmean')
    
%     for i=1:Rows
%         lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(selWavesi(i),tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',sp);
%         set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(i,:))
%         set(lH,'DisplayName',hekadat.waveNames{i})
%     end

    
    sp2 = axes('Position',[.27 .55 .60 .43],'Parent', figData.panel,'tag','sp2');
    set(sp2,'XScale','linear','YScale','linear')
    set(get(sp2,'YLabel'),'string','i (pA)')
    set(get(sp2,'XLabel'),'string','Time (s)')
%     set(sp2,'YAxisLocation','left','XTickLabel',[])
    set(sp2,'XLim',[0 tst.delta])
    set(sp2,'XLim',[0 0.0050])
    set(sp2,'YLim',[-2 2])

    % current trace
    lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','CurrentTrace')
    
    % current trace
    lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','correctedTrace')
     
    currtag=text((hekadat.tAxis(tst.deltai))*.9,1.8,hekadat.tags(currWavei),'Parent',sp2);
    set(currtag,'tag','currtag','FontSize',24)

end

function plotOne(hObject,eventdata)
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
figData.PlotNow=PlotNow;

% only plot ccc, coc and ooo
selWaves=logical(hekadat.HEKAtagfind('ccc'));
currWave=getRowName(figData.infoTable);
currWavei=hekadat.HEKAnamefind(currWave);
Rows=size(Selected,1);
colors=pmkmp(Rows,'CubicL');
cccmean=hekadat.HEKAtagmean('ccc');
tst=hekadat.HEKAstairsprotocol();
subcorr=mean(hekadat.data(currWavei,tst.sti+2000:tst.endi))-mean(cccmean(tst.sti+2000:tst.endi));
%current trace
lHNow=findobj('DisplayName','CurrentTrace');
set(lHNow,'YData',hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Color',colors(PlotNow,:))

lHNow=findobj('DisplayName','correctedTrace');
set(lHNow,'YData',hekadat.data(currWavei,tst.sti:tst.endi)-(cccmean(tst.sti:tst.endi)+subcorr),'Color',whithen(colors(PlotNow,:),.5))

lHNow=findobj('DisplayName','CurrentTraceNoSub');
set(lHNow,'YData',hekadat.data(currWavei,tst.sti:tst.endi),'Color',colors(PlotNow,:))
currtag=findobj('tag','currtag');
set(currtag,'String',hekadat.tags(currWavei));
end

function curr_RowName=getRowName(infoTable)
Selected=get(infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
rowNames=get(infoTable,'RowName');
currWaveNamestart=regexp(rowNames{PlotNow},'e_');
currWaveNameend=regexp(rowNames{PlotNow},'</font')-1;
curr_RowName=rowNames{PlotNow}(currWaveNamestart:currWaveNameend);
end

function tag_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
tag=get(hObject,'tag');
PlotNow=find(cell2mat(Selected(:,end)));
Selected{PlotNow,1}=tag;

currWave=getRowName(figData.infoTable);
currWavei=hekadat.HEKAnamefind(currWave);

hekadat.tags{currWavei}=tag;
assignin('base','hekadat',hekadat);
fprintf('tagged %s as %s\n',hekadat.waveNames{currWavei},tag);
set(figData.infoTable,'Data',Selected)
set(figData.panel,'UserData',hekadat);
next_callBack(figData.infoTable)
enableGui(hObject);
end

function untag_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
Selected{PlotNow,1}='';

currWave=getRowName(figData.infoTable);
currWavei=hekadat.HEKAnamefind(currWave);

hekadat.tags{currWavei}='';
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
fprintf('Saved to %s%s\n',hekadat.dirSave,hekadat.dirFile);
set(figData.panel,'UserData',hekadat);
enableGui(hObject);
end


function next_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
PlotNext=PlotNow+1;
if PlotNext>size(Selected,1)
    PlotNext=1;
end
PlotNext;
Selected{PlotNow,end}=false;
Selected{PlotNext,end}=true;
set(figData.infoTable,'Data',Selected)

set(figData.panel,'UserData',hekadat);
plotOne(hObject);
enableGui(hObject);
end

function previous_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
PlotNext=PlotNow-1;
if PlotNext<1
    PlotNext=size(Selected,1);
end
Selected{PlotNow,end}=false;
Selected{PlotNext,end}=true;
set(figData.infoTable,'Data',Selected)

set(figData.panel,'UserData',hekadat);
plotOne(hObject);
enableGui(hObject);
end


function table_callBack(hObject,eventdata)
disableGui(hObject);
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
Plotted=find(cell2mat(Selected(:,end)));
Plotted=Plotted(~ismember(find(cell2mat(Selected(:,end))),eventdata.Indices(1)));

Selected{Plotted,end}=false;
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