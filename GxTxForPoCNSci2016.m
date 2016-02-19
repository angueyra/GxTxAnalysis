function GxTxForPoCNSci2016()
%% No Toxin 
%% Data loading
% Patchmaster mat file exports
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
makeAxisStruct(f1,sprintf('aStim'),'GxTx/PoCNSci');
%% Raw data examples
for i=1:length(NoTxExamples)
    %Raw Data
    p.PlotNow=hekadat.HEKAnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_tagBlanks(hekadat,p,10);
    makeAxisStruct(hGUI.figData.plotCurr,sprintf('bNoTxRaw%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    %Blank subtracted
    p.PlotNow=hekadat.HEKAnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_tagOpenings(hekadat,p,10);
    makeAxisStruct(hGUI.figData.plotCurr,sprintf('cNoTxSub%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    %Subtracted, nose corrected, clipped data + Histogram
    p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_refineBlanks(hekadat,p,10);
    makeAxisStruct(hGUI.figData.plotSub,sprintf('dNoTxSub%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
    makeAxisStruct(hGUI.figData.plotHist2,sprintf('eNoTxHist%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
end
%% Fitted all data histogram
i=4;
p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
hGUI=gxtx_fitHist(hekadat,p,10);
makeAxisStruct(hGUI.figData.plotHist,sprintf('fNoTxHistFit%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
%% Idealized data
for i=1:length(NoTxExamples)
    p.PlotNow=hekadat.HEKAsnamefind(sprintf('e_1_2_%g',NoTxExamples(i)));
    hGUI=gxtx_fitHist(hekadat,p,10);
    makeAxisStruct(hGUI.figData.plotSub,sprintf('gNoTxIdeal%s',sprintf('2%g',NoTxExamples(i))),'GxTx/PoCNSci');
end
BIPBIP;
%% idealized analysis
hGUI=gxtx_iAnalysisPlots(iA,[],10);
%run fits
%%
makeAxisStruct(hGUI.figData.plotEvolution,'gNoTxiA_Evo','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotEvolution2,'gNoTxiA_Evo2','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotFlats,'gNoTxiA_Flats','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotOdt,'gNoTxiA_Odt','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotCdt,'gNoTxiA_Cdt','GxTx/PoCNSci');
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
makeAxisStruct(f1,'hNoTxEnsMean','GxTx/PoCNSci');
%%
%%
%%
%% Guangxi Toxin 
%% Data loading
% Patchmaster mat file exports
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
%     makeAxisStruct(hGUI.figData.plotSub,sprintf('dGxTxSub%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
%     makeAxisStruct(hGUI.figData.plotHist2,sprintf('eGxTxHist%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
end
%% Fitted all data histogram
p.PlotNow=hekadat.HEKAsnamefind('e_5_49_1');
hGUI=gxtx_fitHist(hekadat,p,10);
% makeAxisStruct(hGUI.figData.plotHist,sprintf('gxfGxTxHistFit%s','491'),'GxTx/PoCNSci');
%% Idealized data



%% idealized analysis
hGUI=gxtx_iAnalysisPlots(iA,[],10);
%run fits
%%
makeAxisStruct(hGUI.figData.plotEvolution,'gxgGxTxiA_Evo','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotEvolution2,'gxgGxTxiA_Evo2','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotFlats,'gxgGxTxiA_Flats','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotOdt,'gxgGxTxiA_Odt','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotCdt,'gxgGxTxiA_Cdt','GxTx/PoCNSci');
%% Recreating linear histogram
figure(1);clf;f1=gca;
set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','i (pA)')
bw=10.^iA.notx.ohx;
plot(10.^iA.notx.ohx,(iA.notx.ohy)./[diff(bw);bw(end)],'.-')

% lH=line(hekadat.tAxis(1:length(osingle)),osingle,'Parent',f1);
% set(lH,'Marker','none','LineStyle','-','LineWidth',1,'Color',[0 0 0])
% set(lH,'DisplayName','wci')





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
makeAxisStruct(f1,'gxhGxTxEnsMean','GxTx/PoCNSci');

end