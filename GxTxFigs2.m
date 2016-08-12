%% Figures for KV2.1 SINGLE CHANNEL DATA

%% Load data
clear; clear classes; clc; close all;
% % Control cell (finished analysis)
CtEx=HEKAdat('2015_06_23_Juan');
CtiA=CtEx.HEKAiAnalysis;
% % Example cell (finished analysis)
GxEx=HEKAdat('2011_06_29_E5GxTx');
GxiA=GxEx.HEKAiAnalysis;

plt.k=[0 0 0];
plt.g=whithen(plt.k,.5);
plt.ctcol=[.3 .3 .3];
plt.nocol=[0 0 1];
plt.gxcol=[1 0 0];
plt.nocolw=whithen(plt.nocol,.5);
plt.gxcolw=whithen(plt.gxcol,.5);
%% Stairs stimulus
f1=getfigH(1);
set(f1,'xlim',[0 0.84])
lH=line(CtEx.tAxis,CtEx.stim,'Parent',f1);
set(lH,'linewidth',2,'color',plt.k,'displayname','stim');
%% Raw data, subtracted/corrected data and idealized
f2=getfigH(2);
set(get(f2,'xlabel'),'string','Time (s)')
set(get(f2,'ylabel'),'string','i (pA)')
set(f2,'xlim',[0 0.84])
set(f2,'ylim',[-12 2])

tlims=struct;
tlims.delta=.025;
tlims.on=[0.1 0.22 0.74];
tlims.off=[0.2 0.72];
tlims.ion=cell2mat(arrayfun(@(x)find(CtEx.tAxis<=x,1,'last'),tlims.on,'UniformOutput',0));
tlims.ioff=cell2mat(arrayfun(@(x)find(CtEx.tAxis<=x,1,'last'),tlims.off,'UniformOutput',0));
tlims.iondelta=cell2mat(arrayfun(@(x)find(CtEx.tAxis<=x,1,'last'),tlims.on+tlims.delta,'UniformOutput',0));
tlims.ioffdelta=cell2mat(arrayfun(@(x)find(CtEx.tAxis<=x,1,'last'),tlims.off+tlims.delta,'UniformOutput',0));

cccsnuff=zeros(size(CtEx.tAxis));
cccsnuff(tlims.ion(1):tlims.iondelta(1))=1;
cccsnuff(tlims.ion(2):tlims.iondelta(2))=1;
cccsnuff(tlims.ion(3):tlims.iondelta(3))=1;

cccsnuff(tlims.ioff(1):tlims.ioffdelta(1))=1;
cccsnuff(tlims.ioff(2):tlims.ioffdelta(2))=1;


nCt.all=size(CtEx.sdata,1);
nCt.ooo=sum(CtEx.HEKAstagfind('ooo'));
nCt.coc=sum(CtEx.HEKAstagfind('coc'));
nCt.ccc=sum(CtEx.HEKAstagfind('ccc'));

Ct.fixio=[.25 .90 .50 .65 .80];
for i=1:length(Ct.fixio)
    Ct.ooosi(i)=find(cumsum(CtEx.HEKAstagfind('ooo'))>=floor(nCt.ooo*Ct.fixio(i)),1,'first');
    Ct.oooname{i}=CtEx.swaveNames{Ct.ooosi(i)};
    Ct.oooi(i)=CtEx.HEKAnamefind(Ct.oooname(i));
end


for i=1:length(Ct.fixio)
    bldata=CtEx.data(Ct.oooi(i),:)-CtEx.HEKAtagmean('ccc');
    [cccL,cccR]=CtEx.HEKAcccFlanks(Ct.oooi(i));
    cccflanks=mean(CtEx.data([cccL,cccR],:))-CtEx.HEKAtagmean('ccc');
    cccflanks=cccflanks.*cccsnuff;
    
    lH=line(CtEx.tAxis,(bldata-cccflanks)-(2.6*(i-1)),'parent',f2);
    set(lH,'linewidth',1,'color',plt.ctcol,'displayname',sprintf('ctooo_%g',i));
end
%%
f3=getfigH(3);
set(get(f3,'xlabel'),'string','Time (s)')
set(get(f3,'ylabel'),'string','i (pA)')
set(f3,'xlim',[0 0.84])
set(f3,'ylim',[-12 2])

nGx.all=size(GxEx.sdata,1);
nGx.ooo=sum(GxEx.HEKAstagfind('ooo'));
nGx.coc=sum(GxEx.HEKAstagfind('coc'));
nGx.ccc=sum(GxEx.HEKAstagfind('ccc'));

Gx.fixio=[.70 .99 .75 .60 .90];
for i=1:length(Gx.fixio)
    Gx.ooosi(i)=find(cumsum(GxEx.HEKAstagfind('ooo'))>=floor(nGx.ooo*Gx.fixio(i)),1,'first');
    Gx.oooname{i}=GxEx.swaveNames{Gx.ooosi(i)};
    Gx.oooi(i)=GxEx.HEKAnamefind(Gx.oooname(i));
end

for i=1:length(Gx.fixio)
    bldata=GxEx.data(Gx.oooi(i),:)-GxEx.HEKAtagmean('ccc');
    [cccL,cccR]=GxEx.HEKAcccFlanks(Gx.oooi(i));
    cccflanks=mean(GxEx.data([cccL,cccR],:))-GxEx.HEKAtagmean('ccc');
    cccflanks=cccflanks.*cccsnuff;
    
    lH=line(GxEx.tAxis,(bldata-cccflanks)-(2.6*(i-1)),'parent',f3);
    set(lH,'linewidth',1,'color',plt.nocol,'displayname',sprintf('rawooo_%g',i));
end
%%
f4=getfigH(4);
set(get(f4,'xlabel'),'string','Time (s)')
set(get(f4,'ylabel'),'string','i (pA)')
set(f4,'xlim',[0 0.84])
set(f4,'ylim',[-12 2])

Gx.fixic=[.68 .28 .60 .91 .80];
for i=1:length(Gx.fixic)
    Gx.cocsi(i)=find(cumsum(GxEx.HEKAstagfind('coc'))>=floor(nGx.coc*Gx.fixic(i)),1,'first');
    Gx.cocname{i}=GxEx.swaveNames{Gx.cocsi(i)};
    Gx.coci(i)=GxEx.HEKAnamefind(Gx.cocname(i));
end

for i=1:length(Gx.fixic)
    bldata=GxEx.data(Gx.coci(i),:)-GxEx.HEKAtagmean('ccc');
    [cccL,cccR]=GxEx.HEKAcccFlanks(Gx.coci(i));
    cccflanks=mean(GxEx.data([cccL,cccR],:))-GxEx.HEKAtagmean('ccc');
    cccflanks=cccflanks.*cccsnuff;
    
    lH=line(GxEx.tAxis,(bldata-cccflanks)-(2.6*(i-1)),'parent',f4);
    set(lH,'linewidth',1,'color',plt.gxcol,'displayname',sprintf('rawcoc_%g',i));
end
%%










%%
f3=getfigH(3);
set(get(f3,'xlabel'),'string','Time (s)')
set(get(f3,'ylabel'),'string','i (pA)')
set(f3,'ylim',[-2 5])
lH=line(hekadat.stAxis,hekadat.sdata(plt.coci(1),:),'parent',f3);
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

lH=line([0 nCt.ooo/nCt.all],[6 6],'parent',f7);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx1');
lH=line([0 nCt.ooo/nCt.all],[8 8],'parent',f7);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','notx2');

lH=line([0 nCt.coc/nCt.all],[3 3],'parent',f7);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx1');
lH=line([0 nCt.coc/nCt.all],[5 5],'parent',f7);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','gxtx2');

lH=line([0 nCt.ccc/nCt.all],[0 0],'parent',f7);
set(lH,'linewidth',2,'color',plt.k,'displayname','closed1');
lH=line([0 nCt.ccc/nCt.all],[2 2],'parent',f7);
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
