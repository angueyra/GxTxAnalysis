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

%%
%%
%%
%% Guangxi Toxin 
%% Data loading
% Patchmaster mat file exports
clear; clear classes; clc;
hekadat=HEKAdat('2011_06_29_E5GxTx'); %Control cell
load('/Users/angueyraaristjm/Documents/DataGxTx/HEKAmatlabParsed/2011_06_29_E5GxTx_iA.mat');
%% Already corrected data examples
GxTxExamples={...
%     'e_5_51_5';...
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
    'e_5_49_2';...
    'e_5_49_3';...
    'e_5_49_8';...
    };
p=struct('PlotNow',[]);
for i=1:length(GxTxExamples)
    %Subtracted, nose corrected, clipped data + Histogram
    p.PlotNow=hekadat.HEKAsnamefind(GxTxExamples(i));
    hGUI=gxtx_refineBlanks(hekadat,p,10);
    makeAxisStruct(hGUI.figData.plotSub,sprintf('dGxTxSub%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
    makeAxisStruct(hGUI.figData.plotHist2,sprintf('eGxTxHist%s',strrep(GxTxExamples{i}(4:end),'_','')),'GxTx/PoCNSci');
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
makeAxisStruct(hGUI.figData.plotEvolution,'gxgNoTxiA_Evo','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotEvolution2,'gxgNoTxiA_Evo2','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotFlats,'gxgNoTxiA_Flats','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotOdt,'gxgNoTxiA_Odt','GxTx/PoCNSci');
makeAxisStruct(hGUI.figData.plotCdt,'gxgNoTxiA_Cdt','GxTx/PoCNSci');



end