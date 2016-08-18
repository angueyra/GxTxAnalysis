%% Figures for KV2.1 SINGLE CHANNEL DATA

%% Load data
clear; clear classes; clc; close all;
% % Control cell (finished analysis)
CtEx=HEKAdat('2015_06_23_Juan');
CtEx.idata=CtEx.idata*CtEx.hath*2;
CtiA=CtEx.HEKAiAnalysis;
CtPop = HEKApopdata('Controls');
Ct = struct;
% % Example cell (finished analysis)
GxEx=HEKAdat('2011_06_29_E5GxTx');
GxEx.idata=GxEx.idata*GxEx.hath*2;
GxiA=GxEx.HEKAiAnalysis;
NoPop = HEKApopdata('NoToxin');
GxPop = HEKApopdata('GxToxin');
No = struct;
Gx = struct;

Ct.npop=size(CtPop.names,1);
Gx.npop=size(GxPop.names,1);

plt.k=[0 0 0];
plt.g=whithen(plt.k,.5);
plt.ctcol=[.3 .3 .3];
plt.nocol=[0 0 1];
plt.gxcol=[1 0 0];
plt.ctcolw=whithen(plt.ctcol,.5);
plt.nocolw=whithen(plt.nocol,.5);
plt.gxcolw=whithen(plt.gxcol,.5);
%% Idealized + raw
% Control
f1=getfigH(1);
set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','i (pA)')
set(f1,'xlim',[0 0.5])
set(f1,'ylim',[-12 2])

nCt.all=size(CtEx.sdata,1);
nCt.ooo=sum(CtEx.HEKAstagfind('ooo'));
nCt.coc=sum(CtEx.HEKAstagfind('coc'));
nCt.ccc=sum(CtEx.HEKAstagfind('ccc'));

Ct.fixio=[.25 .90 .50 .65 .80];
for i=1:length(Ct.fixio)
    Ct.ooosi(i)=find(cumsum(CtEx.HEKAstagfind('ooo'))>=floor(nCt.ooo*Ct.fixio(i)),1,'first');
    Ct.oooname{i}=CtEx.swaveNames{Ct.ooosi(i)};
    Ct.oooi(i)=CtEx.HEKAsnamefind(Ct.oooname(i));
end

for i=1:length(Ct.fixio)  
    lH=line(CtEx.stAxis,CtEx.sdata(Ct.oooi(i),:)-(2.6*(i-1)),'parent',f1);
    set(lH,'linewidth',1,'color',plt.k,'displayname',sprintf('ct_%g',i));
    
    lH=line(CtEx.stAxis,CtEx.idata(Ct.oooi(i),:)-(2.6*(i-1)),'parent',f1);
    set(lH,'linewidth',2,'color',plt.ctcol,'displayname',sprintf('cti_%g',i));
end
% Gx Free
f2=getfigH(2);
set(get(f2,'xlabel'),'string','Time (s)')
set(get(f2,'ylabel'),'string','i (pA)')
set(f2,'xlim',[0 0.5])
set(f2,'ylim',[-12 2])

nGx.all=size(GxEx.sdata,1);
nGx.ooo=sum(GxEx.HEKAstagfind('ooo'));
nGx.coc=sum(GxEx.HEKAstagfind('coc'));
nGx.ccc=sum(GxEx.HEKAstagfind('ccc'));

Gx.fixio=[.70 .99 .75 .60 .90];
for i=1:length(Gx.fixio)
    Gx.ooosi(i)=find(cumsum(GxEx.HEKAstagfind('ooo'))>=floor(nGx.ooo*Gx.fixio(i)),1,'first');
    Gx.oooname{i}=GxEx.swaveNames{Gx.ooosi(i)};
    Gx.oooi(i)=GxEx.HEKAsnamefind(Gx.oooname(i));
end

for i=1:length(Gx.fixio)  
    lH=line(GxEx.stAxis,GxEx.sdata(Gx.oooi(i),:)-(2.6*(i-1)),'parent',f2);
    set(lH,'linewidth',1,'color',plt.k,'displayname',sprintf('no_%g',i));
    
    lH=line(GxEx.stAxis,GxEx.idata(Gx.oooi(i),:)-(2.6*(i-1)),'parent',f2);
    set(lH,'linewidth',2,'color',plt.nocol,'displayname',sprintf('noi_%g',i));
end
% Gx Bound
f3=getfigH(3);
set(get(f3,'xlabel'),'string','Time (s)')
set(get(f3,'ylabel'),'string','i (pA)')
set(f3,'xlim',[0 0.5])
set(f3,'ylim',[-12 2])

Gx.fixic=[.68 .28 .60 .91 .80];
for i=1:length(Gx.fixic)
    Gx.cocsi(i)=find(cumsum(GxEx.HEKAstagfind('coc'))>=floor(nGx.coc*Gx.fixic(i)),1,'first');
    Gx.cocname{i}=GxEx.swaveNames{Gx.cocsi(i)};
    Gx.coci(i)=GxEx.HEKAsnamefind(Gx.cocname(i));
end

for i=1:length(Gx.fixic)
    lH=line(GxEx.stAxis,GxEx.sdata(Gx.coci(i),:)-(2.6*(i-1)),'parent',f3);
    set(lH,'linewidth',1,'color',plt.k,'displayname',sprintf('gx_%g',i));
    
    lH=line(GxEx.stAxis,GxEx.idata(Gx.coci(i),:)-(2.6*(i-1)),'parent',f3);
    set(lH,'linewidth',2,'color',plt.gxcol,'displayname',sprintf('gxi_%g',i));
end

%% First latencies
f4=getfigH(4);
set(get(f4,'xlabel'),'string','Latency to first opening (ms)')
set(get(f4,'ylabel'),'string','Cum. Prob.')
set(f4,'XLim',[0 400])
set(f4,'YLim',[0 1.0])

lH=line(CtiA.notx.flat,CtiA.notx.flatp,'parent',f4);
set(lH,'Marker','o','LineStyle','none','color',plt.ctcol,'displayname','Ct');
lH=line(GxiA.notx.flat,GxiA.notx.flatp,'parent',f4);
set(lH,'Marker','o','LineStyle','none','color',plt.nocol,'displayname','No');
lH=line(GxiA.gxtx.flat,GxiA.gxtx.flatp,'parent',f4);
set(lH,'Marker','o','LineStyle','none','color',plt.gxcol,'displayname','Gx');

% lH=line(CtiA.notx.flat,CtPop.actfx(CtPop.tflat_coeffs(1,:),CtiA.notx.flat),'parent',f4);
lH=line(CtiA.notx.flat,CtPop.actfx([.902 4.6666 1.6474],CtiA.notx.flat),'parent',f4);
set(lH,'LineWidth',2,'color',plt.ctcolw,'displayname','CtFit');
% lH=line(GxiA.notx.flat,NoPop.actfx(GxPop.tflat_coeffs(1,:),GxiA.notx.flat),'parent',f4);
lH=line(GxiA.notx.flat,NoPop.actfx([.9278 9.2242 1.3011],GxiA.notx.flat),'parent',f4);
set(lH,'LineWidth',2,'color',plt.nocolw,'displayname','NoFit');
% lH=line(GxiA.gxtx.flat,GxPop.actfx(GxPop.tflat_coeffs(1,:),GxiA.gxtx.flat),'parent',f4);
lH=line(GxiA.gxtx.flat,GxPop.actfx([.9407 29.3180 1.7183],GxiA.gxtx.flat),'parent',f4);
set(lH,'LineWidth',2,'color',plt.gxcolw,'displayname','GxFit');

%% tau_flats
f5=getfigH(5);
set(f5,'YScale','log')
set(get(f5,'ylabel'),'string','tau latency (ms)')
set(f5,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f5,'XLim',[0 4])

% not good fit
lH=line(ones(1,1)*1,CtPop.tflats(end),'Parent',f5);
set(lH,'Marker','*','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','CtExcluded');
% the rest
lH=line(ones(Ct.npop-1,1)*1,CtPop.tflats(1:end-1),'Parent',f5);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.tflats,'Parent',f5);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.tflats,'Parent',f5);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[geomean(CtPop.tflats(1:end-1)) geomean(CtPop.tflats(1:end-1))],'Parent',f5);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[geomean(NoPop.tflats) geomean(NoPop.tflats)],'Parent',f5);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[geomean(GxPop.tflats) geomean(GxPop.tflats)],'Parent',f5);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.tflats(i) GxPop.tflats(i)],'Parent',f5);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau%g',i));
end
%% Open dwell times
% Control
f6=getfigH(6);
set(get(f6,'xlabel'),'string','Open dwell times (ms)')
set(get(f6,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f6,'xtick',log10(xt))
set(f6,'xticklabel',xt)

lH=line(CtiA.notx.osx,CtiA.notx.osy,'parent',f6);
set(lH,'linewidth',1,'color',plt.k,'displayname','Ct');
lH=line(CtiA.notx.ohx,CtiA.notx.ofit,'parent',f6);
set(lH,'linewidth',2,'color',plt.ctcol,'displayname','Ct_fit');
lH=line([CtiA.notx.ocoeffs(2) CtiA.notx.ocoeffs(2)],[0 CtiA.notx.ocoeffs(1)],'parent',f6);
set(lH,'linestyle','--','linewidth',2,'color',plt.ctcolw,'displayname','Ct_line');

% Free
f7=getfigH(7);
set(get(f7,'xlabel'),'string','Open dwell times (ms)')
set(get(f7,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f7,'xtick',log10(xt))
set(f7,'xticklabel',xt)

lH=line(GxiA.notx.osx,GxiA.notx.osy,'parent',f7);
set(lH,'linewidth',1,'color',plt.k,'displayname','No');
lH=line(GxiA.notx.ohx,GxiA.notx.ofit,'parent',f7);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','No_fit');
lH=line([GxiA.notx.ocoeffs(2) GxiA.notx.ocoeffs(2)],[0 GxiA.notx.ocoeffs(1)],'parent',f7);
set(lH,'linestyle','--','linewidth',2,'color',plt.nocolw,'displayname','No_line');

% Bound
f8=getfigH(8);
set(get(f8,'xlabel'),'string','Open dwell times (ms)')
set(get(f8,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f8,'xtick',log10(xt))
set(f8,'xticklabel',xt)

lH=line(GxiA.gxtx.osx,GxiA.gxtx.osy,'parent',f8);
set(lH,'linewidth',1,'color',plt.k,'displayname','Gx');
lH=line(GxiA.gxtx.ohx,GxiA.gxtx.ofit,'parent',f8);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','Gx_fit');
lH=line([GxiA.gxtx.ocoeffs(2) GxiA.gxtx.ocoeffs(2)],[0 GxiA.gxtx.ocoeffs(1)],'parent',f8);
set(lH,'linestyle','--','linewidth',2,'color',plt.gxcolw,'displayname','Gx_line');
%% odt_taus
f9=getfigH(9);
set(f9,'YScale','log')
set(get(f9,'ylabel'),'string','tau closing (ms)')
set(f9,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f9,'XLim',[0 4])


lH=line(ones(Ct.npop,1)*1,CtPop.odt1(1:end),'Parent',f9);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.odt1,'Parent',f9);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.odt1,'Parent',f9);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[geomean(CtPop.odt1(1:end)) geomean(CtPop.odt1(1:end))],'Parent',f9);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[geomean(NoPop.odt1) geomean(NoPop.odt1)],'Parent',f9);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[geomean(GxPop.odt1) geomean(GxPop.odt1)],'Parent',f9);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.odt1(i) GxPop.odt1(i)],'Parent',f9);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau%g',i));
end
%% Closed dwell times
f10=getfigH(10);
set(get(f10,'xlabel'),'string','Closed dwell time (ms)')
set(get(f10,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f10,'xtick',log10(xt))
set(f10,'xticklabel',xt)

ct_cfits1=sqrt( (10.^CtiA.notx.chx) .* CtiA.notx.logexp(CtiA.notx.ccoeffs(1:2),CtiA.notx.chx));
ct_cfits2=sqrt( (10.^CtiA.notx.chx) .* CtiA.notx.logexp(CtiA.notx.ccoeffs(3:4),CtiA.notx.chx));

lH=line(CtiA.notx.csx,CtiA.notx.csy,'parent',f10);
set(lH,'linewidth',1,'color',plt.k,'displayname','No');
lH=line(CtiA.notx.chx,CtiA.notx.cfit,'parent',f10);
set(lH,'linewidth',2,'color',plt.ctcol,'displayname','NoFit');

lH=line(CtiA.notx.chx,ct_cfits1,'parent',f10);
set(lH,'linewidth',1,'color',plt.ctcolw,'displayname','NoFit1');
lH=line(CtiA.notx.chx,ct_cfits2,'parent',f10);
set(lH,'linewidth',1,'color',plt.ctcolw,'displayname','NoFit2');

lH=line([CtiA.notx.ccoeffs(2) CtiA.notx.ccoeffs(2)],[0 CtiA.notx.ccoeffs(1)],'parent',f10);
set(lH,'linestyle','--','linewidth',1,'color',plt.ctcolw,'displayname','NoLine1');
lH=line([CtiA.notx.ccoeffs(4) CtiA.notx.ccoeffs(4)],[0 CtiA.notx.ccoeffs(3)],'parent',f10);
set(lH,'linestyle','--','linewidth',1,'color',plt.ctcolw,'displayname','NoLine2');

f11=getfigH(11);
set(get(f11,'xlabel'),'string','Closed dwell time (ms)')
set(get(f11,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f11,'xtick',log10(xt))
set(f11,'xticklabel',xt)

notx_cfits1=sqrt( (10.^GxiA.notx.chx) .* GxiA.notx.logexp(GxiA.notx.ccoeffs(1:2),GxiA.notx.chx));
notx_cfits2=sqrt( (10.^GxiA.notx.chx) .* GxiA.notx.logexp(GxiA.notx.ccoeffs(3:4),GxiA.notx.chx));

lH=line(GxiA.notx.csx,GxiA.notx.csy,'parent',f11);
set(lH,'linewidth',1,'color',plt.k,'displayname','No');
lH=line(GxiA.notx.chx,GxiA.notx.cfit,'parent',f11);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','NoFit');

lH=line(GxiA.notx.chx,notx_cfits1,'parent',f11);
set(lH,'linewidth',1,'color',plt.nocolw,'displayname','NoFit1');
lH=line(GxiA.notx.chx,notx_cfits2,'parent',f11);
set(lH,'linewidth',1,'color',plt.nocolw,'displayname','NoFit2');

lH=line([GxiA.notx.ccoeffs(2) GxiA.notx.ccoeffs(2)],[0 GxiA.notx.ccoeffs(1)],'parent',f11);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','NoLine1');
lH=line([GxiA.notx.ccoeffs(4) GxiA.notx.ccoeffs(4)],[0 GxiA.notx.ccoeffs(3)],'parent',f11);
set(lH,'linestyle','--','linewidth',1,'color',plt.nocolw,'displayname','NoLine2');

f12=getfigH(12);
set(get(f12,'xlabel'),'string','Closed dwell time (ms)')
set(get(f12,'ylabel'),'string','sqrt(log(n))')
xt=[.1 .2 .5 1 2 5 10 20 50 100 200 500 1000];
set(f12,'xtick',log10(xt))
set(f12,'xticklabel',xt)

gxtx_cfits1=sqrt( (10.^GxiA.gxtx.chx) .* GxiA.gxtx.logexp(GxiA.gxtx.ccoeffs(1:2),GxiA.gxtx.chx));
gxtx_cfits2=sqrt( (10.^GxiA.gxtx.chx) .* GxiA.gxtx.logexp(GxiA.gxtx.ccoeffs(3:4),GxiA.gxtx.chx));
gxtx_cfits3=sqrt( (10.^GxiA.gxtx.chx) .* GxiA.gxtx.logexp(GxiA.gxtx.ccoeffs(5:6),GxiA.gxtx.chx));

lH=line(GxiA.gxtx.csx,GxiA.gxtx.csy,'parent',f12);
set(lH,'linewidth',1,'color',plt.k,'displayname','Gx');
lH=line(GxiA.gxtx.chx,GxiA.gxtx.cfit,'parent',f12);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','GxFit');

lH=line(GxiA.gxtx.chx,gxtx_cfits1,'parent',f12);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','GxFit1');
lH=line(GxiA.gxtx.chx,gxtx_cfits2,'parent',f12);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','GxFit2');
lH=line(GxiA.gxtx.chx,gxtx_cfits3,'parent',f12);
set(lH,'linewidth',1,'color',plt.gxcolw,'displayname','GxFit3');

lH=line([GxiA.gxtx.ccoeffs(2) GxiA.gxtx.ccoeffs(2)],[0 GxiA.gxtx.ccoeffs(1)],'parent',f12);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','GxLine1');
lH=line([GxiA.gxtx.ccoeffs(4) GxiA.gxtx.ccoeffs(4)],[0 GxiA.gxtx.ccoeffs(3)],'parent',f12);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','GxLine2');
lH=line([GxiA.gxtx.ccoeffs(6) GxiA.gxtx.ccoeffs(6)],[0 GxiA.gxtx.ccoeffs(5)],'parent',f12);
set(lH,'linestyle','--','linewidth',1,'color',plt.gxcolw,'displayname','GxLine3');

%% cdt_taus
f13=getfigH(13);
set(f13,'YScale','log')
set(get(f13,'ylabel'),'string','tau opening (ms)')
set(f13,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f13,'XLim',[0 4])


lH=line(ones(Ct.npop,1)*1,CtPop.cdt1(1:end),'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct1');
lH=line(ones(Gx.npop,1)*2,NoPop.cdt1,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No1');
lH=line(ones(Gx.npop,1)*3,GxPop.cdt1,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx1');

lH=line([-.2 +.2]+1,[geomean(CtPop.cdt1(1:end)) geomean(CtPop.cdt1(1:end))],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ct1mean');
lH=line([-.2 +.2]+2,[geomean(NoPop.cdt1) geomean(NoPop.cdt1)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','No1mean');
lH=line([-.2 +.2]+3,[geomean(GxPop.cdt1) geomean(GxPop.cdt1)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gx1mean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.cdt1(i) GxPop.cdt1(i)],'Parent',f13);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau1%g',i));
end

lH=line(ones(Ct.npop,1)*1,CtPop.cdt2(1:end),'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct2');
lH=line(ones(Gx.npop,1)*2,NoPop.cdt2,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No2');
lH=line(ones(Gx.npop,1)*3,GxPop.cdt2,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx2');

lH=line([-.2 +.2]+1,[geomean(CtPop.cdt2(1:end)) geomean(CtPop.cdt2(1:end))],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ct2mean');
lH=line([-.2 +.2]+2,[geomean(NoPop.cdt2) geomean(NoPop.cdt2)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','No2mean');
lH=line([-.2 +.2]+3,[geomean(GxPop.cdt2) geomean(GxPop.cdt2)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gx2mean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.cdt2(i) GxPop.cdt2(i)],'Parent',f13);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau2%g',i));
end


lH=line(ones(Gx.npop,1)*3,GxPop.cdt3,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx3');

lH=line([-.2 +.2]+3,[geomean(GxPop.cdt3) geomean(GxPop.cdt3)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gx3mean');

%% long cdts (>50ms)
f14=getfigH(14);
set(get(f14,'ylabel'),'string','prob. closed times > 50 ms')
set(f14,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f14,'XLim',[0 4])
set(f14,'YLim',[0 .4])


lH=line(ones(Ct.npop,1)*1,CtPop.cdtlong(1:end),'Parent',f14);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.cdtlong,'Parent',f14);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.cdtlong,'Parent',f14);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[mean(CtPop.cdtlong(1:end)) mean(CtPop.cdtlong(1:end))],'Parent',f14);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[mean(NoPop.cdtlong) mean(NoPop.cdtlong)],'Parent',f14);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[mean(GxPop.cdtlong) mean(GxPop.cdtlong)],'Parent',f14);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.cdtlong(i) GxPop.cdtlong(i)],'Parent',f14);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau%g',i));
end



%%

h5root='GxTx/Fig3';

makeAxisStruct(f1, 'a1_ict',h5root);
makeAxisStruct(f2, 'a2_ino',h5root);
makeAxisStruct(f3, 'a3_igx',h5root);
makeAxisStruct(f4, 'b1_flat',h5root);
makeAxisStruct(f4, 'b2_flat',h5root);
makeAxisStruct(f4, 'b3_flat',h5root);
makeAxisStruct(f5, 'c_tflat',h5root);
makeAxisStruct(f6, 'd1_odtct',h5root);
makeAxisStruct(f7, 'd2_odtno',h5root);
makeAxisStruct(f8, 'd3_odtgx',h5root);
makeAxisStruct(f9, 'e_todt',h5root);
makeAxisStruct(f10,'f1_cdtct',h5root);
makeAxisStruct(f11,'f2_cdtno',h5root);
makeAxisStruct(f12,'f3_cdtgx',h5root);
makeAxisStruct(f13,'g_tcdt',h5root);
makeAxisStruct(f14,'h_longcdt',h5root);
