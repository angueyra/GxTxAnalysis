%% Figures for KV2.1 SINGLE CHANNEL DATA

%% Load data
clear; clear classes; clc; close all;
% % Control cell (finished analysis)
CtEx=HEKAdat('2015_06_23_Juan');
CtiA=CtEx.HEKAiAnalysis;
CtPop = HEKApopdata('Controls');
Ct = struct;
% % Example cell (finished analysis)
GxEx=HEKAdat('2011_06_29_E5GxTx');
GxiA=GxEx.HEKAiAnalysis;
NoPop = HEKApopdata('NoToxin');
GxPop = HEKApopdata('GxToxin');
No = struct;
Gx = struct;

plt.k=[0 0 0];
plt.g=whithen(plt.k,.5);
plt.ctcol=[.3 .3 .3];
plt.nocol=[0 0 1];
plt.gxcol=[1 0 0];
plt.ctcolw=whithen(plt.ctcol,.5);
plt.nocolw=whithen(plt.nocol,.5);
plt.gxcolw=whithen(plt.gxcol,.5);
%% Stairs stimulus
f1=getfigH(1);
set(f1,'xlim',[0 0.84])
lH=line(CtEx.tAxis,CtEx.stim,'Parent',f1);
set(lH,'linewidth',2,'color',plt.k,'displayname','stim');
%% Raw data, subtracted/corrected data
% Control
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
% Gx Free
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
% Gx Bound
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
%% Fraction of "bound" trials: f = P_bound / (Pbound + Pfree)

f5=getfigH(5);
set(get(f5,'ylabel'),'string','Fraction of bound trials')
set(f5,'XTick',[1 2],'XTickLabel',{'Control';'+GxTx'})
set(f5,'XLim',[0.5 2.5])

Ct.npop=size(CtPop.names,1);
Gx.npop=size(GxPop.names,1);
Ct.fbound=(CtPop.n.coc)./(CtPop.n.coc+CtPop.n.ooo);
Gx.fbound=(GxPop.n.coc)./(GxPop.n.coc+GxPop.n.ooo);
% Ct.fbound=(CtPop.n.coc)./(CtPop.n.total);
% Gx.fbound=(GxPop.n.coc)./(GxPop.n.total);

lH=line(ones(Ct.npop,1),Ct.fbound,'Parent',f5);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,Gx.fbound,'Parent',f5);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.25 +.25]+1,[mean(Ct.fbound) mean(Ct.fbound)],'Parent',f5);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.25 +.25]+2,[mean(Gx.fbound) mean(Gx.fbound)],'Parent',f5);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');


% %% Alternative: P_bound vs P_free
% f5=getfigH(5);
% 
% lH=line(CtPop.n.ooo./CtPop.n.total,CtPop.n.coc./CtPop.n.total,'Parent',f5);
% set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
% lH=line(GxPop.n.ooo./GxPop.n.total,GxPop.n.coc./GxPop.n.total,'Parent',f5);
% set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

%% Average from corrected waves + tau_activation and steady state i
% average i
f6=getfigH(6);
set(get(f6,'xlabel'),'string','Time (s)')
set(get(f6,'ylabel'),'string','i (pA)')
set(f6,'XLim',[0 .5])
set(f6,'YLim',[0 1.4])

lH=line(CtEx.itAxis,CtEx.HEKAstagmean('ooo')*CtEx.hath*2,'parent',f6);
set(lH,'linewidth',2,'color',plt.ctcol,'displayname','Ct');
lH=line(GxEx.itAxis,GxEx.HEKAstagmean('ooo')*GxEx.hath*2,'parent',f6);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','No');
lH=line(GxEx.itAxis,GxEx.HEKAstagmean('coc')*GxEx.hath*2,'parent',f6);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','Gx');


lH=line(CtEx.itAxis,CtPop.actfx([.9973 0.0076528 1.0154],CtEx.itAxis),'parent',f6);
set(lH,'linewidth',2,'color',plt.ctcolw,'displayname','CtFit');
lH=line(GxEx.itAxis,NoPop.actfx([1.2 0.0088 1.1047],GxEx.itAxis),'parent',f6);
set(lH,'linewidth',2,'color',plt.nocolw,'displayname','NoFit');
lH=line(GxEx.itAxis,GxPop.actfx([0.63 0.0124 3.0235],GxEx.itAxis),'parent',f6);
set(lH,'linewidth',2,'color',plt.gxcolw,'displayname','GxFit');


% Igor fits
% Ct
% 	A    	=0.9973 ± 0.00278
% 	tau  	=0.0076528 ± 0.000186
% 	sigma	=1.0154 ± 0.0262
% No
% 	A    	=1.2 ± 2.7e-18
% 	tau  	=0.0088 ± 1.59e-19
% 	sigma	=1.1047 ± 2.14e-17
% Gx
% 	A    	=0.63 ± 1.66e-18
% 	tau  	=0.0124 ± 1.76e-19
% 	sigma	=3.0235 ± 6.92e-17

%% tau_activation
f7=getfigH(7);
set(f7,'YScale','log')
set(get(f7,'ylabel'),'string','tau activation (ms)')
set(f7,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f7,'XLim',[0 4])


lH=line(ones(Ct.npop,1)*1,CtPop.tactivation,'Parent',f7);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.tactivation,'Parent',f7);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.tactivation,'Parent',f7);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[geomean(CtPop.tactivation) geomean(CtPop.tactivation)],'Parent',f7);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[geomean(NoPop.tactivation) geomean(NoPop.tactivation)],'Parent',f7);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[geomean(GxPop.tactivation) geomean(GxPop.tactivation)],'Parent',f7);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.tactivation(i) GxPop.tactivation(i)],'Parent',f7);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau%g',i));
end

% steady state current (>100 ms)
f8=getfigH(8);
set(f8,'YScale','linear')
set(get(f8,'ylabel'),'string','mean i 100 - 500 ms (pA)')
set(f8,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f8,'XLim',[0 4])
set(f8,'YLim',[0 1.5])


lH=line(ones(Ct.npop,1)*1,CtPop.averagei,'Parent',f8);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.averagei,'Parent',f8);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.averagei,'Parent',f8);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[mean(CtPop.averagei) mean(CtPop.averagei)],'Parent',f8);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[mean(NoPop.averagei) mean(NoPop.averagei)],'Parent',f8);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[mean(GxPop.averagei) mean(GxPop.averagei)],'Parent',f8);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.averagei(i) GxPop.averagei(i)],'Parent',f8);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('tau%g',i));
end

%% All points histograms
% Control
f9=getfigH(9);
set(get(f9,'xlabel'),'string','i (pA)')
set(get(f9,'ylabel'),'string','Frequency')

Ct.h=struct;
[Ct.h.hx,Ct.h.hy,Ct.h.sx,Ct.h.sy]=CtEx.HEKAhistbytag('ooo',400,-CtEx.hath*2,CtEx.hath*4);

lH=line(Ct.h.sx,Ct.h.sy,'parent',f9);
set(lH,'linewidth',2,'color',plt.ctcol,'displayname','Ct');
lH=line([CtEx.hath CtEx.hath], [0 .03],'parent',f9);
set(lH,'linestyle','--','linewidth',1,'color',plt.g,'displayname','Hath');
% lH=line(Ct.h.hx, CtPop.gaussfx(CtPop.hc_coeffs(1,:),Ct.h.hx),'parent',f9);
% set(lH,'linestyle','-','linewidth',2,'color',plt.ctcolw,'displayname','CtFit_c');
% lH=line(Ct.h.hx, CtPop.gaussfx(CtPop.ho_coeffs(1,:),Ct.h.hx),'parent',f9);
% set(lH,'linestyle','-','linewidth',2,'color',plt.ctcolw,'displayname','CtFit_o');

% Free
f10=getfigH(10);
set(get(f10,'xlabel'),'string','i (pA)')
set(get(f10,'ylabel'),'string','Frequency')

No.h=struct;
[No.h.hx,No.h.hy,No.h.sx,No.h.sy]=GxEx.HEKAhistbytag('ooo',400,-GxEx.hath*2,GxEx.hath*4);

lH=line(No.h.sx,No.h.sy,'parent',f10);
set(lH,'linewidth',2,'color',plt.nocol,'displayname','No');
lH=line([GxEx.hath GxEx.hath], [0 .03],'parent',f10);
set(lH,'linestyle','--','linewidth',1,'color',plt.g,'displayname','Hath');
% lH=line(No.h.hx, NoPop.gaussfx(NoPop.hc_coeffs(1,:),No.h.hx),'parent',f10);
% set(lH,'linestyle','-','linewidth',2,'color',plt.nocolw,'displayname','NoFit_c');
% lH=line(No.h.hx, NoPop.gaussfx(NoPop.ho_coeffs(1,:),No.h.hx),'parent',f10);
% set(lH,'linestyle','-','linewidth',2,'color',plt.nocolw,'displayname','NoFit_o');

% Bound
f11=getfigH(11);
set(get(f11,'xlabel'),'string','i (pA)')
set(get(f11,'ylabel'),'string','Frequency')

Gx.h=struct;
[Gx.h.hx,Gx.h.hy,Gx.h.sx,Gx.h.sy]=GxEx.HEKAhistbytag('coc',400,-GxEx.hath*2,GxEx.hath*4);

lH=line(Gx.h.sx,Gx.h.sy,'parent',f11);
set(lH,'linewidth',2,'color',plt.gxcol,'displayname','Gx');
lH=line([GxEx.hath GxEx.hath], [0 .03],'parent',f11);
set(lH,'linestyle','--','linewidth',1,'color',plt.g,'displayname','Hath');
% lH=line(Gx.h.hx, GxPop.gaussfx(GxPop.hc_coeffs(1,:),Gx.h.hx),'parent',f11);
% set(lH,'linestyle','-','linewidth',2,'color',plt.gxcolw,'displayname','GxFit_c');
% lH=line(Gx.h.hx, GxPop.gaussfx(GxPop.ho_coeffs(1,:),Gx.h.hx),'parent',f11);
% set(lH,'linestyle','-','linewidth',2,'color',plt.gxcolw,'displayname','GxFit_o');

%% single channel current and open probability
f12=getfigH(12);
set(get(f12,'ylabel'),'string','single channel current (pA)')
set(f12,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f12,'XLim',[0 4])
set(f12,'YLim',[0 1.6])


lH=line(ones(Ct.npop,1)*1,CtPop.isingle,'Parent',f12);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.isingle,'Parent',f12);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.isingle,'Parent',f12);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[mean(CtPop.isingle) mean(CtPop.isingle)],'Parent',f12);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[mean(NoPop.isingle) mean(NoPop.isingle)],'Parent',f12);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[mean(GxPop.isingle) mean(GxPop.isingle)],'Parent',f12);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.isingle(i) GxPop.isingle(i)],'Parent',f12);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('i%g',i));
end

% open probability
f13=getfigH(13);
set(get(f13,'ylabel'),'string','open probability')
set(f13,'XTick',[1 2 3],'XTickLabel',{'Control';'Free';'Bound'})
set(f13,'XLim',[0 4])
set(f13,'YLim',[0 1])


lH=line(ones(Ct.npop,1)*1,CtPop.popen,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.ctcol,'MarkerFaceColor',plt.ctcolw,'displayname','Ct');
lH=line(ones(Gx.npop,1)*2,NoPop.popen,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.nocol,'MarkerFaceColor',plt.nocolw,'displayname','No');
lH=line(ones(Gx.npop,1)*3,GxPop.popen,'Parent',f13);
set(lH,'Marker','o','Linestyle','none','color',plt.gxcol,'MarkerFaceColor',plt.gxcolw,'displayname','Gx');

lH=line([-.2 +.2]+1,[mean(CtPop.popen) mean(CtPop.popen)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.ctcol,'LineWidth',2,...
    'displayname','Ctmean');
lH=line([-.2 +.2]+2,[mean(NoPop.popen) mean(NoPop.popen)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.nocol,'LineWidth',2,...
    'displayname','Nomean');
lH=line([-.2 +.2]+3,[mean(GxPop.popen) mean(GxPop.popen)],'Parent',f13);
set(lH,'Marker','none','Linestyle','-','color',plt.gxcol,'LineWidth',2,...
    'displayname','Gxmean');

for i=1:Gx.npop
    lH=line([2 3],[NoPop.popen(i) GxPop.popen(i)],'Parent',f13);
    set(lH,'Marker','none','Linestyle','-','color',plt.g,...
        'displayname',sprintf('Po%g',i));
end
%%
h5root='GxTx/Fig2';

makeAxisStruct(f1, 'a_stim',h5root);
makeAxisStruct(f2, 'b1_rawCt',h5root);
makeAxisStruct(f3, 'b2_rawNo',h5root);
makeAxisStruct(f4, 'b3_rawGx',h5root);
makeAxisStruct(f5, 'c_fbound',h5root);
makeAxisStruct(f6, 'd1_averagei',h5root);
makeAxisStruct(f6, 'd2_averagei',h5root);
makeAxisStruct(f6, 'd3_averagei',h5root);
makeAxisStruct(f7, 'e_tactivation',h5root);
makeAxisStruct(f8, 'f_ssi',h5root);
makeAxisStruct(f9, 'g1_hCt',h5root);
makeAxisStruct(f10,'g2_hNo',h5root);
makeAxisStruct(f11,'g3_hGx',h5root);
makeAxisStruct(f12,'h_sci',h5root);
makeAxisStruct(f13,'i_popen',h5root);


%%
%% Calculation of statistical significance of changes
Stats=struct();

Stats.fnames={'fbound';'tactivation';'averagei';'isingle';'popen'};
Stats.n=size(Stats.fnames,1);
Stats.p=NaN(Stats.n,1);
Stats.h=NaN(Stats.n,1);
Stats.nno=NaN(Stats.n,1);
Stats.ngx=NaN(Stats.n,1);
Stats.stats=cell(Stats.n,1);


for i=1:Stats.n
    fname=Stats.fnames{i};
    if strcmp(fname,'fbound')
        [Stats.p(i),Stats.h(i),Stats.stats{i}]=ranksum(...
            Ct.(fname),Gx.(fname));
        Stats.nno(i)=size(Ct.(fname),1);
        Stats.ngx(i)=size(Gx.(fname),1);
    else
        [Stats.p(i),Stats.h(i),Stats.stats{i}]=ranksum(...
            [CtPop.(fname);NoPop.(fname)],GxPop.(fname));
        Stats.nno(i)=size([CtPop.(fname);NoPop.(fname)],1);
        Stats.ngx(i)=size(GxPop.(fname),1);
    end
end
