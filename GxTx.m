%% ANALYSIS OF KV2.1 SINGLE CHANNEL DATA
% Flow
%  1) hekadat=HEKAdat('2015_06_23_Juan') --> load data from Patchmaster into HEKAdat class
%  2) gxtx_tagBlanks(hekadat,p,10) -->  scroll through data and identify blanks and bad traces
%  3) gxtx_tagOpenings(hekadat,p,10) --> after baseline subtraction find 'ooo' and 'coc' epochs
%  4) hekadat.HEKAguessBaseline(); --> uses 'ccc' to correct for slow drifts
%  5) gxtx_correctBaseline((hekadat,p,10) --> use closed period to re-correct baseline in single epochs preloading guess
%           After Lock&Save all data histogram will be calculated
%  6) hekadat.HEKAsUpdate(); --> if changes are made to tags, updates baseline subtraction and correction
%  6) gxtx_refineBlanks(hekadat,p,10) --> use local correction for blanks (flanking blanks) when capacitance drifts
%  7) gxtx_fitHist(hekadat,p,10) --> fits amplitude histogram with 2 gaussians and idealizes data
%           Due to some issues during baseline correction, will assume
%           that channel is closed for the first 20 points of trace (~0.925ms)
%  8) iAnalysis=hekadat.iAnalyze --> compiles event list into a new object
%  9) gxtx_iAnalysisPlots(iA,p,10) --> allows to define thresholds between notx and gxtx for analysis
%           Fits open and closed dwell log histograms and cumulative
%           distributions of first latencies
%% Open all relevant code
edit gxtx_tagBlanks.m
edit gxtx_tagOpenings.m
edit gxtx_refineBlanks.m
edit gxtx_correctBaseline.m
edit gxtx_fitHist.m
edit gxtx_iAnalysisPlots.m
edit genericGUI.m
edit hekaGUI.m
edit iAnalysisGUI.m
edit iAnalysisGUI.m
edit HEKAdat.m
edit iAnalysisObj.m
edit iASubObj.m
edit GxTxFigs1.m
%%
%% Data loading
% Patchmaster mat file exports
% Need to find multichannels and isolate traces with singles if possible

clear; clear classes; clc;
% % Control cells (finished analysis)
% hekadat=HEKAdat('2011_06_22_E1_Stair200_02'); %Control cell but 200ms

% % Control cell (finished analysis)
% hekadat=HEKAdat('2015_06_23_Juan');

% % Control cell (finished analysis)
% hekadat=HEKAdat('2011_06_30_E2_Stair500'); % forgot TTX again. 

% Control cell (finished analysis)
% hekadat=HEKAdat('2016_06_17_E4_Control'); %

% % Control cell (finished analysis but not sure it should be included)
% % hekadat=HEKAdat('2016_06_17_E5_Control'); % not a great patch
%
% 
% % Control cell (2 channels)
% hekadat=HEKAdat('2016_06_16_E6_DoubleControl'); %


%GxTx cells:
% OK data but inconsistent stimulus with rest. (finished analysis)
% hekadat=HEKAdat('2011_06_17_E4_GxTx_Stairs75');
% Did not return to -100mV betwen steps and 200ms at +75mV.

% Good data here. Very consistent with 2011_06_29_E5GxTx. (finished analysis)
% hekadat=HEKAdat('2011_06_23_E4GxTx_Stair200'); % 200 ms and no TTX
% hekadat=HEKAdat('2011_06_23_E4GxTx_Stair500'); % Recorded 200ms steps before and no TTX

% Blah cell (finished analysis)
% hekadat=HEKAdat('2011_06_24_E4GxTx_Stair500');
% A lot of bad data (intrusive little friend).
% Conductance steadily decreases throughout recording. 
% Not such clear differences in closed dwell times. Especially, not huge rise in 3rd
% exponential component. First latency shift is really clear.

% Is it Kv2.1? (finished analysis)
% hekadat=HEKAdat('2011_06_29_E4GxTx');
% In this cell conductance changes between ooo and coc.
% Also not a lot of ccc and not big shift in first latencies. 

% Example cell (finished analysis)
% hekadat=HEKAdat('2011_06_29_E5GxTx');

% % Multiple channels patch
% hekadat=HEKAdat('2011_06_20_E1GxTx_Stair200');
% % Did not return to -100mV betwen steps and 200ms at +75mV.
% Will label multichannel trials as bad

p=struct;


% INSTRUCTIONS
% quickly scroll through blanks and bad data
% subtract blank average
% put blanks and bad data in separate struct and save them
%% find blanks (or ccc) and clearly bad sweeps
p.PlotNow=1;
hGUI=gxtx_tagBlanks(hekadat,p,10);
%% find ooo and coc (and the other ones)
p.PlotNow=1;
hGUI=gxtx_tagOpenings(hekadat,p,10);
%% subtract mean from ccc sweeps, then correct for drift using ccc sweeps and save
hekadat.HEKAinitialsubtraction;
hekadat.HEKAguessBaseline;
hekadat.HEKAsave;
%% manuelly recorrect baseline from closed periods
p.PlotNow=1;
% in ?????
hGUI=gxtx_correctBaseline(hekadat,p,10);
%% identify if subtraction of nose from flanking blanks is correct, then accept it (or don't)
% binary choice
hGUI=gxtx_refineBlanks(hekadat,p,10);
%% fit histogram with 2 gaussians and idealize traces
hGUI=gxtx_fitHist(hekadat,p,10);
%% calculate dwell times
iA=hekadat.HEKAiAnalysis;
iA.IAOsave;
%%
hGUI=gxtx_iAnalysisPlots(iA,p,10);

%%








