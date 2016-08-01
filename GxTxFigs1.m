%% Figures for KV2.1 SINGLE CHANNEL DATA

%% Load data
clear; clear classes; clc; close all;
% % Control cells (finished analysis)
% % hekadat=HEKAdat('2011_06_22_E1_Stair200_02'); %Control cell but 200ms

% % Control cell (finished analysis)
% % hekadat=HEKAdat('2015_06_23_Juan');

% % Control cell (finished analysis)
% % hekadat=HEKAdat('2011_06_30_E2_Stair500'); % forgot TTX again. 

%GxTx cells:
% % OK data but inconsistent stimulus with rest. (finished analysis)
% % hekadat=HEKAdat('2011_06_17_E4_GxTx_Stairs75');
% % Did not return to -100mV betwen steps and 200ms at +75mV.

% % Good data here. Very consistent with 2011_06_29_E5GxTx. (finished analysis)
% % hekadat=HEKAdat('2011_06_23_E4GxTx_Stair200'); % 200 ms and no TTX
% % hekadat=HEKAdat('2011_06_23_E4GxTx_Stair500'); % Recorded 200ms steps before and no TTX

% % Blah cell (finished analysis)
% % hekadat=HEKAdat('2011_06_24_E4GxTx_Stair500');
% % A lot of bad data (intrusive little friend).
% % Conductance steadily decreases throughout recording. 
% % Not such clear differences in closed dwell times. Especially, not huge rise in 3rd
% % exponential component. First latency shift is really clear.

% % Is it Kv2.1? (finished analysis)
% % hekadat=HEKAdat('2011_06_29_E4GxTx');
% % In this cell conductance changes between ooo and coc.
% % Also not a lot of ccc and not big shift in first latencies. 

% % Example cell (finished analysis)
% % hekadat=HEKAdat('2011_06_29_E5GxTx');

%GxTx cells:
% % Multiple channels patch
hekadat=HEKAdat('2011_06_20_E1GxTx_Stair200');
% % Did not return to -100mV betwen steps and 200ms at +75mV.

p=struct;
iA=hekadat.HEKAiAnalysis;
plt.k=[0 0 0];
plt.nocol=[0 0 1];
plt.gxcol=[1 0 0]; 
%%
%% Stairs stimulus
f1=getfigH(1);
lH=line(hekadat.tAxis,hekadat.stim,'Parent',f1);
set(lH,'linewidth',2,'color',plt.k,'displayname','stim');
%% Raw data, subtracted/corrected data and idealized
plt.k=[0 0 0];
plt.g=whithen(plt.k,.5);
plt.nocol=[0 0 1];
plt.nocolw=whithen(plt.nocol,.5);
plt.gxcol=[1 0 0]; 
plt.gxcolw=whithen(plt.gxcol,.5);

n.all=size(hekadat.sdata,1);
n.ooo=sum(hekadat.HEKAstagfind('ooo'));
n.coc=sum(hekadat.HEKAstagfind('coc'));
n.ccc=sum(hekadat.HEKAstagfind('ccc'));

% random
% plt.ooosi=find(cumsum(hekadat.HEKAstagfind('ooo'))>=floor(rand(1)*n.ooo),1,'first');
% plt.cocsi=find(cumsum(hekadat.HEKAstagfind('coc'))>=floor(rand(1)*n.coc),1,'first');
% fixed
if strcmpi(hekadat.dirFile,'2011_06_29_E5GxTx') %GxTx
    fixio=[.70 .50 .60 .91 .80];
    fixic=[.70 .50 .60 .91 .80];
elseif strcmpi(hekadat.dirFile,'2015_06_23_Juan') %Control
    fixio=[.25 .90 .50 .65 .80];
    fixic=[.1 1];
elseif strcmpi(hekadat.dirFile,'2011_06_22_E1_Stair200_02') %Control
    fixio=[.20 .50 .60 .70 .30];
    fixic=[1];
elseif strcmpi(hekadat.dirFile,'2011_06_30_E2_Stair500') %Control
    fixio=[.25 .90 .75 .60 .30];
    fixic=[.17 .334 .50 .67 1];
elseif strcmpi(hekadat.dirFile,'2011_06_23_E4GxTx_Stair200') %GxTx
    fixio=[.25 .90 .50 .65 .80];
    fixic=[.30 .40 .55 .65 .80];
elseif strcmpi(hekadat.dirFile,'2011_06_17_E4_GxTx_Stairs75') %GxTx
    fixio=[.55 .25 .15 .65 .80];
    fixic=[.18 .25 .50 .65 .55];
elseif strcmpi(hekadat.dirFile,'2011_06_24_E4GxTx_Stair500') %GxTx
    fixio=[.25 .90 .20 .65 .80];
    fixic=[.70 .40 .50 .52 .90];
elseif strcmpi(hekadat.dirFile,'2011_06_29_E4GxTx') %GxTx
    fixio=[.60 .90 .50 .65 .80];
    fixic=[.62 .90 .97 .85 .80];

else
    fixio=[.25 .90 .50 .65 .80];
    fixic=[.25 .90 .50 .65 .80];
end

for i=1:length(fixio)
    plt.ooosi(i)=find(cumsum(hekadat.HEKAstagfind('ooo'))>=floor(n.ooo*fixio(i)),1,'first');
    
    
    plt.oooname{i}=hekadat.swaveNames{plt.ooosi(i)};
    plt.oooi(i)=hekadat.HEKAnamefind(plt.oooname(i));
end
for i=1:length(fixic)
    plt.cocsi(i)=find(cumsum(hekadat.HEKAstagfind('coc'))>=floor(n.coc*fixic(i)),1,'first');
    plt.cocname{i}=hekadat.swaveNames{plt.cocsi(i)};
    plt.coci(i)=hekadat.HEKAnamefind(plt.cocname(i));
end

f2=getfigH(2);
set(get(f2,'xlabel'),'string','Time (s)')
set(get(f2,'ylabel'),'string','i (pA)')
set(f2,'ylim',[-2 5])
lH=line(hekadat.tAxis,hekadat.data(plt.oooi(1),:),'parent',f2);
set(lH,'linewidth',1,'color',plt.nocol,'displayname','raw_ooo');

f3=getfigH(3);
set(get(f3,'xlabel'),'string','Time (s)')
set(get(f3,'ylabel'),'string','i (pA)')
set(f3,'ylim',[-2 5])
lH=line(hekadat.tAxis,hekadat.data(plt.coci(1),:),'parent',f3);
set(lH,'linewidth',1,'color',plt.gxcol,'displayname','raw_coc');

f4=getfigH(4);
set(get(f4,'xlabel'),'string','Time (s)')
set(get(f4,'ylabel'),'string','i (pA)')

f5=getfigH(5);
set(get(f5,'xlabel'),'string','Time (s)')
set(get(f5,'ylabel'),'string','i (pA)')

for i=1:length(fixio)
    lH=line(hekadat.stAxis,hekadat.sdata(plt.ooosi(i),:)-(2.2*(i-1)),'parent',f4);
    set(lH,'linewidth',1,'color',plt.k,'displayname',sprintf('notx_%g',i));
    lH=line(hekadat.stAxis,(hekadat.idata(plt.ooosi(i),:)*hekadat.hath*2)-(2.2*(i-1)),'parent',f4);
    set(lH,'linewidth',1,'color',plt.nocol,'displayname',sprintf('notx_i%g',i));
end

% hekadat.idata(plt.cocsi(i),:)
for i=1:length(fixic)
    lH=line(hekadat.stAxis,hekadat.sdata(plt.cocsi(i),:)-(2.2*(i-1)),'parent',f5);
    set(lH,'linewidth',1,'color',plt.k,'displayname',sprintf('gxtx_%g',i));
    lH=line(hekadat.stAxis,(hekadat.idata(plt.cocsi(i),:)*hekadat.hath*2)-(2.2*(i-1)),'parent',f5);
    set(lH,'linewidth',1,'color',plt.gxcol,'displayname',sprintf('gxtx_i%g',i));
end

%% All points histogram dibiding ooo and coc
noh=struct;
[noh.hx,noh.hy,noh.sx,noh.sy]=hekadat.HEKAhistbytag('ooo',400,-hekadat.hath*2,hekadat.hath*4);
gxh=struct;
[gxh.hx,gxh.hy,gxh.sx,gxh.sy]=hekadat.HEKAhistbytag('coc',400,-hekadat.hath*2,hekadat.hath*4);

f6=getfigH(6);
set(get(f6,'xlabel'),'string','i (pA)')
set(get(f6,'ylabel'),'string','Frequency')

lH=line(noh.sx,noh.sy,'parent',f6);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx_hist');

lH=line(gxh.sx,gxh.sy,'parent',f6);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx_hist');

% lH=line([hekadat.hath hekadat.hath], [0 1.1*max([max(noh.hy) max(gxh.hy)])],'parent',f6);
lH=line([hekadat.hath hekadat.hath], [0 .05],'parent',f6);
set(lH,'linestyle','--','linewidth',1,'color',plt.g,'displayname','hath');
%% Bar graph for fraction of data according to states (closed/bound/unbound)
f7=getfigH(7);
set(get(f7,'xlabel'),'string','Fraction of trials')
set(f7,'xaxislocation','bottom')
set(f7,'YTick',[1 4 7],'YTickLabel',{'Closed';'Bound';'Unbound'})

lH=line([0 n.ooo/n.all],[6 6],'parent',f7);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx1');
lH=line([0 n.ooo/n.all],[8 8],'parent',f7);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx2');

lH=line([0 n.coc/n.all],[3 3],'parent',f7);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx1');
lH=line([0 n.coc/n.all],[5 5],'parent',f7);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx2');

lH=line([0 n.ccc/n.all],[0 0],'parent',f7);
set(lH,'linewidth',2,'color',plt.k,'displayname','closed1');
lH=line([0 n.ccc/n.all],[2 2],'parent',f7);
set(lH,'linewidth',2,'color',plt.k,'displayname','closed2');
%% Average from idealized waves
f8=getfigH(8);
set(get(f8,'xlabel'),'string','Time (s)')
set(get(f8,'ylabel'),'string','i (pA)')

lH=line(hekadat.itAxis,hekadat.HEKAitagmean('ooo')*hekadat.hath*2,'parent',f8);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx');

lH=line(hekadat.itAxis,hekadat.HEKAitagmean('coc')*hekadat.hath*2,'parent',f8);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx');

%% First latencies
f9=getfigH(9);
set(get(f9,'xlabel'),'string','Latency to first opening (ms)')
set(get(f9,'ylabel'),'string','Cumulative probability')

lH=line(iA.notx.flat,iA.notx.flatp,'parent',f9);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx');

lH=line(iA.gxtx.flat,iA.gxtx.flatp,'parent',f9);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx');

f18=getfigH(18);
set(get(f18,'ylabel'),'string','Median latency (ms)')
set(f18,'xaxislocation','bottom')
set(f18,'XTick',[1 2],'XTickLabel',{'Unbound';'Bound'})
set(f18,'XLim',[0.5 2.5])

lH=line(1,median(iA.notx.flat),'parent',f18);
set(lH,'Marker','o','linewidth',1,'color',plt.nocol,'displayname','notx_midflat');

lH=line(2,median(iA.gxtx.flat),'parent',f18);
set(lH,'Marker','o','linewidth',1,'color',plt.gxcol,'displayname','gxtx_midflat');

lH=line([1 2],[median(iA.notx.flat) median(iA.gxtx.flat)],'parent',f18);
set(lH,'Marker','none','linewidth',1,'color',plt.g,'displayname','line_medianflat');

%% Open dwell times
f10=getfigH(10);
set(get(f10,'xlabel'),'string','Open dwell times (ms)')
set(get(f10,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f10,'xtick',log10(xt))
set(f10,'xticklabel',xt)

lH=line(iA.notx.osx,iA.notx.osy,'parent',f10);
set(lH,'linewidth',1,'color',plt.k,'displayname','notx_odt');
lH=line(iA.notx.ohx,iA.notx.ofit,'parent',f10);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx_odtfit');
lH=line([-.5 iA.notx.ocoeffs(2)],[iA.notx.ocoeffs(1) iA.notx.ocoeffs(1)],'parent',f10);
set(lH,'linestyle','--','linewidth',2,'color',plt.nocolw,'displayname','notx_odtcoeff1');
lH=line([iA.notx.ocoeffs(2) iA.notx.ocoeffs(2)],[0 iA.notx.ocoeffs(1)],'parent',f10);
set(lH,'linestyle','--','linewidth',2,'color',plt.nocolw,'displayname','notx_odtcoeff2');

f11=getfigH(11);
set(get(f11,'xlabel'),'string','Open dwell times (ms)')
set(get(f11,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f11,'xtick',log10(xt))
set(f11,'xticklabel',xt)

lH=line(iA.gxtx.osx,iA.gxtx.osy,'parent',f11);
set(lH,'linewidth',1,'color',plt.k,'displayname','gxtx_odt');
lH=line(iA.gxtx.ohx,iA.gxtx.ofit,'parent',f11);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx_odtfit');
lH=line([-.5 iA.gxtx.ocoeffs(2)],[iA.gxtx.ocoeffs(1) iA.gxtx.ocoeffs(1)],'parent',f11);
set(lH,'linestyle','--','linewidth',2,'color',plt.gxcolw,'displayname','gxtx_ot');
lH=line([iA.gxtx.ocoeffs(2) iA.gxtx.ocoeffs(2)],[0 iA.gxtx.ocoeffs(1)],'parent',f11);
set(lH,'linestyle','--','linewidth',2,'color',plt.gxcolw,'displayname','gxtx_oh');

% ODT bar plots for population data
f12=getfigH(12);
set(get(f12,'ylabel'),'string','Tau open (ms)')
set(f12,'xaxislocation','bottom')
set(f12,'XTick',[1 2],'XTickLabel',{'Unbound';'Bound'})
set(f12,'XLim',[0.5 2.5])%,'YLim',[0 14])

lH=line(1,10^iA.notx.ocoeffs(2),'parent',f12);
set(lH,'Marker','o','linewidth',1,'color',plt.nocol,'displayname','notx_tau');

lH=line(2,10^iA.gxtx.ocoeffs(2),'parent',f12);
set(lH,'Marker','o','linewidth',1,'color',plt.gxcol,'displayname','gxtx_tau');

lH=line([1 2],[10^iA.notx.ocoeffs(2) 10^iA.gxtx.ocoeffs(2)],'parent',f12);
set(lH,'linewidth',1,'color',plt.g,'displayname','line_tau');


%% Closed dwell times

notx_cfits1=sqrt( (10.^iA.notx.chx) .* iA.notx.logexp(iA.notx.ccoeffs(1:2),iA.notx.chx));
notx_cfits2=sqrt( (10.^iA.notx.chx) .* iA.notx.logexp(iA.notx.ccoeffs(3:4),iA.notx.chx));

f13=getfigH(13);
set(get(f13,'xlabel'),'string','Closed dwell times (ms)')
set(get(f13,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f13,'xtick',log10(xt))
set(f13,'xticklabel',xt)

lH=line(iA.notx.csx,iA.notx.csy,'parent',f13);
set(lH,'linewidth',1,'color',plt.k,'displayname','notx_cdt');

lH=line(iA.notx.chx,iA.notx.cfit,'parent',f13);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx_cdtfit');

lH=line(iA.notx.chx,notx_cfits1,'parent',f13);
set(lH,'linewidth',1,'color',plt.nocolw,'displayname','notx_cdtfit1');
lH=line(iA.notx.chx,notx_cfits2,'parent',f13);
set(lH,'linewidth',1,'color',plt.nocolw,'displayname','notx_cdtfit2');

lH=line([-.5 iA.notx.ccoeffs(2)],[iA.notx.ccoeffs(1) iA.notx.ccoeffs(1)],'parent',f13);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','notx_ct1');
lH=line([iA.notx.ccoeffs(2) iA.notx.ccoeffs(2)],[0 iA.notx.ccoeffs(1)],'parent',f13);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','notx_ch1');

lH=line([-.5 iA.notx.ccoeffs(4)],[iA.notx.ccoeffs(3) iA.notx.ccoeffs(3)],'parent',f13);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','notx_ct2');
lH=line([iA.notx.ccoeffs(4) iA.notx.ccoeffs(4)],[0 iA.notx.ccoeffs(3)],'parent',f13);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','notx_ch2');

gxtx_cfits1=sqrt( (10.^iA.gxtx.chx) .* iA.gxtx.logexp(iA.gxtx.ccoeffs(1:2),iA.gxtx.chx));
gxtx_cfits2=sqrt( (10.^iA.gxtx.chx) .* iA.gxtx.logexp(iA.gxtx.ccoeffs(3:4),iA.gxtx.chx));
gxtx_cfits3=sqrt( (10.^iA.gxtx.chx) .* iA.gxtx.logexp(iA.gxtx.ccoeffs(5:6),iA.gxtx.chx));

f14=getfigH(14);
set(get(f14,'xlabel'),'string','Closed dwell time (ms)')
set(get(f14,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f14,'xtick',log10(xt))
set(f14,'xticklabel',xt)

lH=line(iA.gxtx.csx,iA.gxtx.csy,'parent',f14);
set(lH,'linewidth',1,'color',plt.k,'displayname','gxtx_cdt');
lH=line(iA.gxtx.chx,iA.gxtx.cfit,'parent',f14);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx_cdtfit');

lH=line(iA.gxtx.chx,gxtx_cfits1,'parent',f14);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','gxtx_cdtfit1');
lH=line(iA.gxtx.chx,gxtx_cfits2,'parent',f14);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','gxtx_cdtfit2');
lH=line(iA.gxtx.chx,gxtx_cfits3,'parent',f14);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','gxtx_cdtfit3');

lH=line([-.5 iA.gxtx.ccoeffs(2)],[iA.gxtx.ccoeffs(1) iA.gxtx.ccoeffs(1)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ct1');
lH=line([iA.gxtx.ccoeffs(2) iA.gxtx.ccoeffs(2)],[0 iA.gxtx.ccoeffs(1)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ch1');

lH=line([-.5 iA.gxtx.ccoeffs(4)],[iA.gxtx.ccoeffs(3) iA.gxtx.ccoeffs(3)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ct2');
lH=line([iA.gxtx.ccoeffs(4) iA.gxtx.ccoeffs(4)],[0 iA.gxtx.ccoeffs(3)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ch2');

lH=line([-.5 iA.gxtx.ccoeffs(6)],[iA.gxtx.ccoeffs(5) iA.gxtx.ccoeffs(5)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ct3');
lH=line([iA.gxtx.ccoeffs(6) iA.gxtx.ccoeffs(6)],[0 iA.gxtx.ccoeffs(5)],'parent',f14);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','gxtx_ch3');

% CDT bar plots for population data
f15=getfigH(15);
set(get(f15,'ylabel'),'string','1st Tau closed (ms)')
set(f15,'xaxislocation','bottom')
set(f15,'XTick',[1 2],'XTickLabel',{'Unbound';'Bound'})
set(f15,'XLim',[0.5 2.5],'YLim',[0 1.5])

lH=line(1,10^iA.notx.ccoeffs(2),'parent',f15);
set(lH,'Marker','o','linewidth',1,'color',plt.nocol,'displayname','notx_tau1');

lH=line(2,10^iA.gxtx.ccoeffs(2),'parent',f15);
set(lH,'Marker','o','linewidth',1,'color',plt.gxcol,'displayname','gxtx_tau1');

lH=line([1 2],[10^iA.notx.ccoeffs(2) 10^iA.gxtx.ccoeffs(2)],'parent',f15);
set(lH,'linewidth',1,'color',plt.g,'displayname','line_tau1');

f16=getfigH(16);
set(get(f16,'ylabel'),'string','2nd Tau closed (ms)')
set(f16,'xaxislocation','bottom')
set(f16,'XTick',[1 2],'XTickLabel',{'Unbound';'Bound'})
set(f16,'XLim',[0.5 2.5],'YLim',[0 10])

lH=line(1,10^iA.notx.ccoeffs(4),'parent',f16);
set(lH,'Marker','o','linewidth',1,'color',plt.nocol,'displayname','notx_tau2');

lH=line(2,10^iA.gxtx.ccoeffs(4),'parent',f16);
set(lH,'Marker','o','linewidth',1,'color',plt.gxcol,'displayname','gxtx_tau2');

lH=line([1 2],[10^iA.notx.ccoeffs(4) 10^iA.gxtx.ccoeffs(4)],'parent',f16);
set(lH,'linewidth',1,'color',plt.g,'displayname','line_tau2');


f17=getfigH(17);
set(get(f17,'ylabel'),'string','3rd Tau closed (ms)')
set(f17,'xaxislocation','bottom')
set(f17,'XTick',[1 2],'XTickLabel',{'Unbound';'Bound'})
set(f17,'XLim',[0.5 2.5],'YLim',[0 40])

% lH=line(7,10^iA.notx.ccoeffs(6),'parent',f15);
% set(lH,'Marker','o','linewidth',1,'color',plt.nocol,'displayname','notx_tau3');

lH=line(2,10^iA.gxtx.ccoeffs(6),'parent',f17);
set(lH,'Marker','o','linewidth',1,'color',plt.gxcol,'displayname','gxtx_tau3');

% lH=line([7 8],[10^iA.notx.ccoeffs(6) 10^iA.gxtx.ccoeffs(6)],'parent',f15);
% set(lH,'linewidth',1,'color',plt.g,'displayname','line_tau3');
%%
% check if directory already exists
if ~isdir(sprintf('/Users/angueyraaristjm/hdf5/GxTx/SummaryFigures/%s',hekadat.dirFile))
    mkdir('/Users/angueyraaristjm/hdf5/GxTx/SummaryFigures/',hekadat.dirFile)
end

makeAxisStruct(f1,'a_stim',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f2,'b_rawno',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f3,'c_rawgx',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f4,'d_singlesno',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f5,'e_singlesgx',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f6,'f_ihist',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f7,'g_statefrac',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f8,'h_imean',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f9,'i_flats',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f10,'j_odtno',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f11,'k_odtgx',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f12,'l_odttau',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f13,'m_cdtno',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f14,'n_cdtgx',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f15,'o_cdttau1',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f16,'p_cdttau2',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f17,'q_cdttau3',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
makeAxisStruct(f18,'i2_midflat',sprintf('GxTx/SummaryFigures/%s',hekadat.dirFile));
