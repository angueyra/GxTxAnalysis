function GxTxForPoCNSci2016()
%% No Toxin 
%% Data loading
% Patchmaster mat file exports
close all
clear; clear classes; clc;
hekadat=HEKAdat('2015_06_23_Juan'); %Control cell
load('/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/2015_06_23_Juan_iA.mat');
NoTxExamples=[4,6,7,11,12,14,18,21,22,27,29];
p=struct('PlotNow',[]);
%% Stimulus
if isempty(hekadat.stim)
    hekadat.HEKAgetstim;
    hekadat.HEKAsave;
end
figure(1);clf;f1=gca;
set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','Vcmd (mV)')
tnil=hekadat.HEKAstairsprotocol;
tnil=tnil.st;
lH=line(hekadat.tAxis-tnil,hekadat.stim*1000,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0 0])
set(lH,'DisplayName','stim')
%%%makeAxisStruct(f1,sprintf('aStim'),'GxTx/PoCNSci');
%% Raw data examples
for i=1:length(NoTxExamples)
    %Raw Data
    p.PlotNow=hekadat.HEKAnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_tagBlanks(hekadat,p,10);
    %%%makeAxisStruct(hGUI.figData.plotCurr,sprintf('bNoTxRaw%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    %Blank subtracted
    p.PlotNow=hekadat.HEKAnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_tagOpenings(hekadat,p,10);
    %%%makeAxisStruct(hGUI.figData.plotCurr,sprintf('cNoTxSub%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    %Subtracted, nose corrected, clipped data + Histogram
    p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_refineBlanks(hekadat,p,10);
    %%%makeAxisStruct(hGUI.figData.plotSub,sprintf('dNoTxSub%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    %%%makeAxisStruct(hGUI.figData.plotHist2,sprintf('eNoTxHist%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
end
%% Fitted all data histogram
i=4;
p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
hGUI=gxtx_fitHist(hekadat,p,10);
%%%makeAxisStruct(hGUI.figData.plotHist,sprintf('fNoTxHistFit%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
%% Idealized data
for i=1:length(NoTxExamples)
    p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_fitHist(hekadat,p,10);
    %%%makeAxisStruct(hGUI.figData.plotSub,sprintf('gNoTxIdeal%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
end
BIPBIP;
%% idealized analysis
p=struct('norm',0);
hGUI=gxtx_iAnalysisPlots(iA,p,10);
%run fits
%%
%%%makeAxisStruct(hGUI.figData.plotEvolution,'gNoTxiA_Evo','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotEvolution2,'gNoTxiA_Evo2','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotFlats,'gNoTxiA_Flats','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotOdt,'gNoTxiA_Odt','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotCdt,'gNoTxiA_Cdt','GxTx/PoCNSci');
%%
p=struct('norm',1);
hGUI=gxtx_iAnalysisPlots(iA,p,10);
%run fits
%%
%%%makeAxisStruct(hGUI.figData.plotOdt,'gNoTxiA_OdtNorm','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotCdt,'gNoTxiA_CdtNorm','GxTx/PoCNSci');
%% Ensemble average
f1=getfigH(1);
% ens_mean=mean(hekadat.sdata(hekadat.HEKAstagfind('ooo'),:))/(hekadat.hist_o(1)-hekadat.hist_c(1));
ens_mean=mean(hekadat.idata(hekadat.HEKAstagfind('ooo'),:));
% ens_mean(1:)=0;
lH=line(hekadat.stAxis,ens_mean,'Parent',f1);
set(lH,'Color','k','DisplayName','notx_ensmean')
xlim([0 .5])
ylim([0 1])
xlabel('Time (ms)')
ylabel('i (pA)')
%%%makeAxisStruct(f1,'hNoTxEnsMean','GxTx/PoCNSci');
%%
%% Recreating linear histogram
figure(1);clf;f1=gca;
% set(f1,'xscale','log')
set(get(f1,'xlabel'),'string','Open duration (ms)')
set(get(f1,'ylabel'),'string','n')
set(f1,'xlim',[0 100])
set(f1,'ylim',[0 150])
bw=10.^iA.notx.ohx;
lH=line(10.^iA.notx.ohx,(iA.notx.ohy)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[0 0 0])
set(lH,'DisplayName','notx_odt')

lH=line(10.^iA.notx.ohx,(iA.notx.ofit)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_odtfit')

otau=10^(iA.notx.ocoeffs(2));
otaui=find(iA.notx.ohx<iA.notx.ocoeffs(2),1,'last');
otauy=(iA.notx.ohy(otaui))./(bw(otaui+1)-bw(otaui));

lH=line([0 otau],[otauy otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_otauh')

lH=line([otau otau],[0 otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_otauv')

%%
%%%makeAxisStruct(f1,'gNoTxiA_LinOdt','GxTx/PoCNSci');
%%
%%
%% Guangxi Toxin 
%% Data loading
% Patchmaster mat file exports
close all
clear; clear classes; clc;
hekadat=HEKAdat('2011_06_29_E5GxTx'); %Control cell
% corrfactor=1.2383/1.094;
% hekadat.sdata=hekadat.sdata./corrfactor;
load('/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/2011_06_29_E5GxTx_iA.mat');
%% Already corrected data examples
GxTxExamples={...
    'e_5_51_5';...
%     'e_5_54_8';...
%     'e_5_56_5';...
%     'e_5_57_8';...
%     'e_5_47_4';...
%     'e_5_49_1';...
%     'e_5_55_5';...
%     'e_5_55_9';...
%     'e_5_55_10';...
%     'e_5_56_2';...
%     'e_5_56_3';...
%     'e_5_49_2';...
%     'e_5_49_3';...
%     'e_5_49_8';...
    };
p=struct('PlotNow',[]);
for i=1:length(GxTxExamples)
    %Subtracted, nose corrected, clipped data + Histogram
    p.PlotNow=hekadat.HEKAsnamefind(GxTxExamples(i));
    hGUI=gxtx_refineBlanks(hekadat,p,10);
%     %%%makeAxisStruct(hGUI.figData.plotSub,sprintf('dGxTxSub%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
%     %%%makeAxisStruct(hGUI.figData.plotHist2,sprintf('eGxTxHist%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
end
%% Fitted all data histogram
p.PlotNow=hekadat.HEKAsnamefind('e_5_49_1');
hGUI=gxtx_fitHist(hekadat,p,10);
% %%%makeAxisStruct(hGUI.figData.plotHist,sprintf('gxfGxTxHistFit%s','491'),'GxTx/PoCNSci');
%% Idealized data



%% idealized analysis
hGUI=gxtx_iAnalysisPlots(iA,[],10);
%run fits
%%
%%%makeAxisStruct(hGUI.figData.plotEvolution,'gxgGxTxiA_Evo','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotEvolution2,'gxgGxTxiA_Evo2','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotFlats,'gxgGxTxiA_Flats','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotOdt,'gxgGxTxiA_Odt','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotCdt,'gxgGxTxiA_Cdt','GxTx/PoCNSci');
%%
p=struct('norm',1);
hGUI=gxtx_iAnalysisPlots(iA,p,10);
%run fits
%%
%%%makeAxisStruct(hGUI.figData.plotOdt,'gGxTxiA_OdtNorm','GxTx/PoCNSci');
%%%makeAxisStruct(hGUI.figData.plotCdt,'gGxTxiA_CdtNorm','GxTx/PoCNSci');

%% Ensemble average
f1=getfigH(1);
% oooens_mean=mean(hekadat.sdata(hekadat.HEKAstagfind('ooo'),:))/(hekadat.hist_o(1)-hekadat.hist_c(1));
oooens_mean=mean(hekadat.idata(hekadat.HEKAstagfind('ooo'),:));
lH=line(hekadat.stAxis,oooens_mean,'Parent',f1);
set(lH,'Color','k','DisplayName','ooo_ensmean')

% cocens_mean=mean(hekadat.sdata(hekadat.HEKAstagfind('coc'),:))/(hekadat.hist_o(1)-hekadat.hist_c(1));
cocens_mean=mean(hekadat.idata(hekadat.HEKAstagfind('coc'),:));
lH=line(hekadat.stAxis,cocens_mean,'Parent',f1);
set(lH,'Color','r','DisplayName','coc_ensmean')

xlim([0 .5])
ylim([0 1])
xlabel('Time (ms)')
ylabel('i (pA)')
%%%makeAxisStruct(f1,'gxhGxTxEnsMean','GxTx/PoCNSci');
%%
%% Recreating linear histogram 
%% OPEN
figure(1);clf;f1=gca;
% set(f1,'xscale','log')
set(get(f1,'xlabel'),'string','Open duration (ms)')
set(get(f1,'ylabel'),'string','n')
set(f1,'xlim',[0 20])
set(f1,'ylim',[0 400])
bw=10.^iA.notx.ohx;

lH=line(10.^iA.notx.ohx,(iA.notx.ohy)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[0 0 0])
set(lH,'DisplayName','notx_odt')

lH=line(10.^iA.notx.ohx,(iA.notx.ofit)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_odtfit')


lH=line(10.^iA.gxtx.ohx,(iA.gxtx.ohy)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_odt')

lH=line(10.^iA.gxtx.ohx,(iA.gxtx.ofit)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_odtfit')

otau=10^(iA.notx.ocoeffs(2));
otaui=find(iA.notx.ohx<iA.notx.ocoeffs(2),1,'last');
otauy=(iA.notx.ohy(otaui))./(bw(otaui+1)-bw(otaui));

lH=line([0 otau],[otauy otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_otauh')

lH=line([otau otau],[0 otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_otauv')


otau=10^(iA.gxtx.ocoeffs(2));
otaui=find(iA.gxtx.ohx<iA.gxtx.ocoeffs(2),1,'last');
otauy=(iA.gxtx.ohy(otaui))./(bw(otaui+1)-bw(otaui));

lH=line([0 otau],[otauy otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_otauh')

lH=line([otau otau],[0 otauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_otauv')
%%
%%%makeAxisStruct(f1,'gGxTxiA_LinOdt','GxTx/PoCNSci');

%% CLOSED
figure(1);clf;f1=gca;
% set(f1,'xscale','log')
set(get(f1,'xlabel'),'string','Closed duration (ms)')
set(get(f1,'ylabel'),'string','n')
set(f1,'xlim',[0 10])
set(f1,'ylim',[0 600])
bw=10.^iA.notx.chx;

lH=line(10.^iA.notx.chx,(iA.notx.chy)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[0 0 0])
set(lH,'DisplayName','notx_cdt')

lH=line(10.^iA.notx.chx,(iA.notx.cfit)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_cdtfit')


lH=line(10.^iA.gxtx.chx,(iA.gxtx.chy)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','.','LineStyle','none','LineWidth',1,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_cdt')

lH=line(10.^iA.gxtx.chx,(iA.gxtx.cfit)./[diff(bw);bw(end)],'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_cdtfit')

ctau=10^(iA.notx.ccoeffs(2));
ctaui=find(iA.notx.chx<iA.notx.ccoeffs(2),1,'last');
ctauy=(iA.notx.chy(ctaui))./(bw(ctaui+1)-bw(ctaui));

lH=line([0 ctau],[ctauy ctauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_ctauh')

lH=line([ctau ctau],[0 ctauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[0 0.2 0.8])
set(lH,'DisplayName','notx_ctauv')


ctau=10^(iA.gxtx.ccoeffs(2));
ctaui=find(iA.gxtx.chx<iA.gxtx.ccoeffs(2),1,'last');
ctauy=(iA.gxtx.ohy(ctaui))./(bw(ctaui+1)-bw(ctaui));

lH=line([0 ctau],[ctauy ctauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_ctauh')

lH=line([ctau ctau],[0 ctauy],'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',2,'Color',[1 0 0])
set(lH,'DisplayName','gxtx_ctauv')
%%
%%%makeAxisStruct(f1,'gGxTxiA_LinCdt','GxTx/PoCNSci');
end
