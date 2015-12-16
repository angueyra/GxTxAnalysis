function gxtx_refineBaseline(hekadat,params,fignumber)

if isfield(params,'PlotNow') && ~isempty(params.PlotNow)
    PlotNow=params.PlotNow;
else 
    PlotNow=1;
end

if isempty(hekadat.sdata)
    error('First run gxtx_refineBlanks and save curation')
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
%     selWaves=logical(hekadat.HEKAstagfind('ccc')+hekadat.HEKAstagfind('ooo')+hekadat.HEKAstagfind('coc'));
    selWaves=logical(hekadat.HEKAstagfind('ccc'));
    selWavesi=find(selWaves==1);
    Rows=size(hekadat.swaveNames(selWaves),1);
    colors=pmkmp(Rows,'CubicL');
    tcolors=round(colors./1.2.*255);
    Selected=false(Rows,2);
    RowNames=cell(size(Rows));
    for i=1:Rows
        RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.swaveNames{selWavesi(i)});
    end
    if PlotNow<Rows
        Selected(PlotNow,end)=true;
    else
        Selected(1,end)=true;
    end
    Selected(1,1)=true;
    infoData = [hekadat.stags(selWaves) num2cell(Selected)];
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
    
    % plot positions
    pp=struct;
    pp.l=.24;
    pp.tlim=[min(hekadat.stAxis) max(round(hekadat.stAxis*10)/10)];
    pp.dlim=[-1.1 2.2];
    
    % all data
    sp = axes('Position',[pp.l .78 .65 .20],'Parent', figData.panel,'tag','sp');
    set(sp,'XScale','linear','YScale','linear')
    set(get(sp,'XLabel'),'string','Time (s)')
    set(get(sp,'YLabel'),'string','i (pA)')
    set(sp,'YAxisLocation','left');
    set(sp,'XLim',pp.tlim)
    set(sp,'YLim',pp.dlim)
    
    for i=1:Rows
        lH=line(hekadat.stAxis,hekadat.sdata(selWavesi(i),:),'Parent',sp);
        set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(i,:))
        set(lH,'DisplayName',hekadat.swaveNames{i})
    end
    lH=line(hekadat.stAxis,NaN(size(hekadat.sdata(selWavesi,:))),'Parent',sp);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(i,:))
    set(lH,'DisplayName','currTraceAll')
    
    sph = axes('Position',[pp.l .33 .65 .40],'Parent', figData.panel,'tag','sph');
    set(sph,'XScale','linear','YScale','linear')
    set(get(sph,'XLabel'),'string','i (pA)')
    set(get(sph,'YLabel'),'string','Frequency')
    set(sph,'YAxisLocation','left');
    set(sph,'XLim',pp.dlim)
    hH=line(1:100,NaN(1,100),'Parent',sph);
    set(hH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
    set(hH,'DisplayName','allHist')
    
    hH=line(1:100,NaN(1,100),'Parent',sph);
    set(hH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
    set(hH,'DisplayName','currHist')
    
    
    sp2 = axes('Position',[pp.l .07 .65 .20],'Parent', figData.panel,'tag','sp2');
    set(sp2,'XScale','linear','YScale','linear')
    set(get(sp2,'XLabel'),'string','Time (s)')
    set(get(sp2,'YLabel'),'string','i (pA)')
    set(sp2,'YAxisLocation','left');
    set(sp2,'XLim',pp.tlim)
    set(sp2,'YLim',pp.dlim)
      
    lH=line(hekadat.stAxis,hekadat.sdata(PlotNow,:),'Parent',sp2);
    set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(PlotNow,:))
    set(lH,'DisplayName','currTrace')
    
    plotOne(figData.infoTable);
    
end

function plotOne(hObject,eventdata)
figData=get(get(hObject,'Parent'),'UserData');
hekadat=get(figData.panel,'UserData');
Selected=get(figData.infoTable,'Data');
PlotNow=find(cell2mat(Selected(:,end)));
figData.PlotNow=PlotNow;
Rows=size(Selected,1);
colors=pmkmp(Rows,'CubicL');

selWaves=logical(hekadat.HEKAstagfind('ccc'));
currData=hekadat.sdata(selWaves,:);

% current wave
curt=findobj('DisplayName','currTraceAll');
set(curt,'YData',currData(PlotNow,:))
if PlotNow==1
    set(curt,'Color',[0,.7,0],'LineWidth',1)
elseif PlotNow==Rows
    set(curt,'Color',[.7,0,0],'LineWidth',1)
else
    set(curt,'Color',[0,0,0],'LineWidth',1)
end
uistack(curt,'top');

currTrace=currData(PlotNow,:);
currTraceH=findobj('DisplayName','currTrace');
set(currTraceH,'YData',currTrace,'Color',colors(PlotNow,:))

% calculate histogram
nbins=300;

[currHistX,currHistY]=calculateHist(currTrace,nbins,-1.1,2.2);
currHistY_norm=currHistY./size(currTrace,2);
hHNow=findobj('DisplayName','currHist');
set(hHNow,'XData',currHistX,'YData',currHistY_norm,'Color',colors(PlotNow,:))

alldata=reshape(currData,1,numel(currData));
[allHistX,allHistY]=calculateHist(alldata,nbins,-1.1,2.2);
allHistY_norm=allHistY./size(alldata,2);
hHNow=findobj('DisplayName','allHist');
set(hHNow,'XData',allHistX,'YData',allHistY_norm,'Color',[0 0 0])


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