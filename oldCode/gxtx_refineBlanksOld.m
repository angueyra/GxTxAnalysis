function gxtx_refineBlanks(hekadat,params,fignumber)

if isfield(params,'PlotNow') && ~isempty(params.PlotNow)
    PlotNow=params.PlotNow;
else 
    PlotNow=1;
end

if isfield(params,'LockNow') && ~isempty(params.LockNow)
    LockNow=params.LockNow;
else 
    LockNow=0;
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
    bw=.065;
    bl=0.995-bw;
    bh=0.08;
    % only plot ccc, coc and ooo
    selWaves=logical(hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('ooo')+hekadat.HEKAtagfind('coc'));
    selWavesi=find(selWaves==1);
    Rows=size(hekadat.waveNames(selWaves),1);
    colors=pmkmp(Rows,'CubicL');
    tcolors=round(colors./1.2.*255);
    Selected=false(Rows,2);
    RowNames=cell(size(Rows));
    for i=1:Rows
        RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.waveNames{selWavesi(i)});
    end
    if PlotNow<Rows
        Selected(PlotNow,end)=true;
    else
        Selected(1,end)=true;
    end
    Selected(1,1)=true;
    infoData = [hekadat.tags(selWaves) num2cell(Selected)];
    figData.infoTable = uitable('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [0.01, .005, 0.185, .985], ...
        'FontSize',10,...
        'ColumnWidth',{40},...
        'Data', infoData, ...
        'ColumnName',{'tag','ccc','P'},...
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
        'Position', [bl .90 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','prev_push',...
        'string','<---',...
        'FontSize',10,...
        'UserData',params,...
        'callback',{@previous_callBack});
    figData.nextButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [bl .80 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','next_push',...
        'string','--->',...
        'FontSize',10,...
        'UserData',params,...
        'callback',{@next_callBack});
    figData.blankButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [bl .38 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','ccc',...
        'string','tag as blank',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.badButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [bl .28 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','bad',...
        'string','tag as bad',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@tag_callBack});
    figData.untagButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [bl .18 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','untag_push',...
        'string','untag',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@untag_callBack});
    figData.lockButton = uicontrol('Parent', figH, ...
        'Units', 'normalized', ...
        'Position', [bl .03 bw bh], ...
        'Style', 'pushbutton', ...
        'tag','lock_push',...
        'string','Lock&Save',...
        'FontSize',10,...
        'UserData',[],...
        'callback',{@lock_callBack});
    modifyUITableHeaderWidth(figData.infoTable,63);
    set(figH, 'UserData', figData)%, 'ResizeFcn',{@canvasResizeFcn,figData});
    
    
    %find current wave
    tst=hekadat.HEKAstairsprotocol();
    currWave=getRowName(figData.infoTable,PlotNow);
    currWavei=hekadat.HEKAnamefind(currWave);
    cccmean=hekadat.HEKAtagmean('ccc');
    
    %Data and blank
    sp2 = axes('Position',[.24 .55 .48 .43],'Parent', figData.panel,'tag','sp2');
    set(sp2,'XScale','linear','YScale','linear')
    set(get(sp2,'YLabel'),'string','i (pA)')
    set(get(sp2,'XLabel'),'string','Time (s)')
%     set(sp2,'YAxisLocation','left','XTickLabel',[])
    set(sp2,'XLim',[0 tst.delta])
    set(sp2,'XLim',[0 0.01])
    set(sp2,'YLim',[-3 2])

    % current trace
    lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','CurrentTrace')
    
    % nearest blank
    lH=line(hekadat.tAxis(1:tst.deltai),hekadat.data(currWavei,tst.sti:tst.endi)-cccmean(tst.sti:tst.endi),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','nearestBlank')
    
    % corrected trace
    lH=line(hekadat.tAxis(1:tst.deltai),NaN(size(hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','correctedTrace')
     
    currtag=text((hekadat.tAxis(tst.deltai))*.9,1.8,hekadat.tags(currWavei),'Parent',sp2);
    set(currtag,'tag','currtag','FontSize',24)
    
    
    % subtracted and curated plot
    sp = axes('Position',[.24 .08 .48 .43],'Parent', figData.panel,'tag','sp');
    set(sp,'XScale','linear','YScale','linear')
    set(get(sp,'XLabel'),'string','Time (s)')
    set(get(sp,'YLabel'),'string','i (pA)')
    set(sp,'YAxisLocation','left');
    set(sp,'XLim',[0 tst.delta])
%     set(sp,'XLim',[0 0.01])
    set(sp,'YLim',[-1 2])
    
    lH=line(hekadat.tAxis(1:tst.deltai),NaN(size(hekadat.data(currWavei,tst.sti:tst.endi))),'Parent',sp);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','subTrace')

    % Data and blank histograms
    sph2 = axes('Position',[.735 .55 .17 .43],'Parent', figData.panel,'tag','sph2');
    set(sph2,'YAxisLocation','right')
    set(sph2,'YLim',get(sp2,'YLim'))
    
    hnan=NaN(1,50);
    lH=line(hnan,hnan,'Parent',sph2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','currHist')
    
    lH=line(hnan,hnan,'Parent',sph2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','cccHist')
    
    % subtracted and curated histogram
    sph = axes('Position',[.735 .08 .17 .43],'Parent', figData.panel,'tag','sph');
    set(sph,'YAxisLocation','right')
    set(sph,'YLim',get(sp,'YLim'))
    
    lH=line(hnan,hnan,'Parent',sph);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','subHist')
    
    plotOne(figData.infoTable);
    
    if LockNow
       lock_callBack(figData.infoTable);
    end
end

function plotOne(hObject,eventdata)
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
figData.PlotNow=PlotNow;

% current wave
currWave=getRowName(figData.infoTable,PlotNow);
currWavei=hekadat.HEKAnamefind(currWave);

% find flanking ccc (left and right)
tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
if PlotNow==1 % no left
    cccLi=find(cellfun(tagfindfx('ccc'),hekadat.stags),1,'first');
    cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),hekadat.stags(PlotNow+1:end)),1,'first');
elseif PlotNow==size(Selected,1) % no right
    cccLi=find(cellfun(tagfindfx('ccc'),hekadat.stags(1:PlotNow)),1,'last');
    cccRi=find(cellfun(tagfindfx('ccc'),hekadat.stags),1,'last');
else
    cccLi=find(cellfun(tagfindfx('ccc'),hekadat.stags(1:PlotNow)),1,'last');
    cccRi=PlotNow+find(cellfun(tagfindfx('ccc'),hekadat.stags(PlotNow+1:end)),1,'first');
end
cccLWave=getRowName(figData.infoTable,cccLi);
cccLWavei=hekadat.HEKAnamefind(cccLWave);
cccRWave=getRowName(figData.infoTable,cccRi);
cccRWavei=hekadat.HEKAnamefind(cccRWave);

% update table
cccP=find(cell2mat(Selected(:,2)));
for i=1:length(cccP) 
    Selected{cccP(i),2}=false;
end
Selected{cccLi,2}=true;
Selected{cccRi,2}=true;
Rows=size(Selected,1);
colors=pmkmp(Rows,'CubicL');

cccmean=hekadat.HEKAtagmean('ccc');
tst=hekadat.HEKAstairsprotocol();
% current trace
currentTrace=hekadat.data(currWavei,tst.sti:tst.endi)-(cccmean(tst.sti:tst.endi));
lHNow=findobj('DisplayName','CurrentTrace');
set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
% flanking ccc
nearestLBlank=hekadat.data(cccLWavei,tst.sti:tst.endi);
nearestRBlank=hekadat.data(cccRWavei,tst.sti:tst.endi);
nearestBlank=((nearestLBlank+nearestRBlank)./2)-(cccmean(tst.sti:tst.endi));
lHNow=findobj('DisplayName','nearestBlank');
set(lHNow,'YData',nearestBlank,'Color',whithen(colors(PlotNow,:),.5))

% subtract nose and mean of flanking blanks
tlim=find(hekadat.tAxis<=0.003,1,'last');
subTrace=currentTrace;
subTrace(1:tlim)=subTrace(1:tlim)-nearestBlank(1:tlim);
subTrace(tlim+1:end)=subTrace(tlim+1:end)-mean(nearestBlank(2000:end),2);

lHNow=findobj('DisplayName','subTrace');
set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:))

lHNow=findobj('DisplayName','correctedTrace');
set(lHNow,'YData',subTrace,'Color',colors(PlotNow,:)/2)

currtag=findobj('tag','currtag');
set(currtag,'String',hekadat.tags(currWavei));
set(figData.infoTable,'Data',Selected)

% calculate histogram
hHNow=findobj('DisplayName','currHist');
nbins=100;

[currHistX,currHistY]=calculateHist(currentTrace,nbins,min(currentTrace),max(currentTrace));
set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))

hHNow=findobj('DisplayName','cccHist');
[cccHistX,cccHistY]=calculateHist(nearestBlank,nbins,min(currentTrace),max(currentTrace));
set(hHNow,'XData',cccHistY,'YData',cccHistX,'Color',whithen(colors(PlotNow,:),.5))


hHNow=findobj('DisplayName','subHist');
[subHistX,subHistY]=calculateHist(subTrace,nbins,-.5,2);
set(hHNow,'XData',subHistY,'YData',subHistX,'Color',colors(PlotNow,:))

end

function lock_callBack(hObject,eventdata)
disableGui();
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
tst=hekadat.HEKAstairsprotocol();
tlim=find(hekadat.tAxis<=0.003,1,'last');
% parsing by tags. May not correspond to waves in table unless reloaded
selWaves=logical(hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('ooo')+hekadat.HEKAtagfind('coc'));
        

hekadat.swaveNames=hekadat.waveNames(selWaves);
hekadat.stags=hekadat.tags(selWaves);
hekadat.stAxis=hekadat.tAxis(1:tst.deltai);

cccmean=hekadat.HEKAtagmean('ccc');
sdata=hekadat.data(selWaves,tst.sti:tst.endi)-repmat(cccmean(tst.sti:tst.endi),size(hekadat.swaveNames,1),1);


tagfindfx=@(tag)(@(taglist)(strcmp(tag,taglist)));
cccLi=NaN(size(hekadat.swaveNames,1),1);
cccLi(1)=find(cellfun(tagfindfx('ccc'),hekadat.stags),1,'first');
for i=2:size(hekadat.swaveNames,1)
    cccLi(i)=find(cellfun(tagfindfx('ccc'),hekadat.stags(1:i)),1,'last');
end
cccRi=NaN(size(hekadat.swaveNames,1),1);
for i=1:size(hekadat.swaveNames,1)-1
    cccRi(i)=i+find(cellfun(tagfindfx('ccc'),hekadat.stags(i+1:end)),1,'first');
end
cccRi(end)=find(cellfun(tagfindfx('ccc'),hekadat.stags),1,'last');

submat=zeros(size(sdata));
submat(:,1:tlim)=(sdata(cccLi,1:tlim)+sdata(cccRi,1:tlim))./2;
hekadat.sdata=sdata-submat;

hekadat.HEKAsave();
assignin('base','hekadat',hekadat);
fprintf('Saved  curated data to %s%s\n',hekadat.dirSave,hekadat.dirFile);
set(figData.panel,'UserData',hekadat);
enableGui();
end

function [hX,hY]=calculateHist(wave,nbins,edgemin,edgemax)
bins=linspace(edgemin*1.25,edgemax*1.25,nbins);
histcurr=histc(wave,bins)';
[hX,hY]=stairs(bins,histcurr);
end

function curr_RowName=getRowName(infoTable,index)
rowNames=get(infoTable,'RowName');
currWaveNamestart=regexp(rowNames{index},'e_');
currWaveNameend=regexp(rowNames{index},'</font')-1;
curr_RowName=rowNames{index}(currWaveNamestart:currWaveNameend);
end


function tag_callBack(hObject,eventdata)
disableGui();
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
enableGui();
end

function untag_callBack(hObject,eventdata)
disableGui();
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
enableGui();
end


function next_callBack(hObject,eventdata)
disableGui();
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
enableGui();
end

function previous_callBack(hObject,eventdata)
disableGui();
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
enableGui();
end


function table_callBack(hObject,eventdata)
disableGui();
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
enableGui();
end

function disableGui()
set(findobj('-property','Enable'),'Enable','off')
drawnow
end
function enableGui()
set(findobj('-property','Enable'),'Enable','on')
drawnow
end