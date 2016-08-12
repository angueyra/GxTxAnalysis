% Collecting population data for GxTx experiments

%% Controls patches
CtPop = HEKApopdata('Controls');

CtPop.names = {...
    '2015_06_23_Juan';...
    '2011_06_30_E2_Stair500';...
    '2016_06_17_E4_Control';...
    '2016_06_17_E5_Control'};
CtPop.names=cellstr(CtPop.names);
CtPop.n=struct;
CtPop.n.ccc = NaN(size(CtPop.names));
CtPop.n.ooo = NaN(size(CtPop.names));
CtPop.n.coc = NaN(size(CtPop.names));
CtPop.n.zzz = NaN(size(CtPop.names));
CtPop.n.total = NaN(size(CtPop.names));
CtPop.isingle = NaN(size(CtPop.names));
CtPop.popen = NaN(size(CtPop.names));
CtPop.tactivation = NaN(size(CtPop.names));
CtPop.averagei = NaN(size(CtPop.names));
CtPop.tflats = NaN(size(CtPop.names));
CtPop.odt1 = NaN(size(CtPop.names));
CtPop.cdt1 = NaN(size(CtPop.names));
CtPop.cdt2 = NaN(size(CtPop.names));
CtPop.cdt3 = NaN(size(CtPop.names));
%
i=1;

%% n trials by tag
hekadat=HEKAdat(char(CtPop.names(i)));
iA=hekadat.HEKAiAnalysis;
CtPop.n.ccc(i)=sum(hekadat.HEKAtagfind('ccc'));
CtPop.n.ooo(i)=sum(hekadat.HEKAtagfind('ooo'));
CtPop.n.coc(i)=sum(hekadat.HEKAtagfind('coc'));
CtPop.n.zzz(i)=sum(hekadat.HEKAtagfind('zzz'));
CtPop.n.total(i)=CtPop.n.ccc(i)+CtPop.n.ooo(i)+CtPop.n.coc(i)+CtPop.n.zzz(i);

%% single channel current and popen
% Calculate histogram
noh=struct;
[noh.hx,noh.hy,noh.sx,noh.sy]=...
    hekadat.HEKAhistbytag('ooo',400,-hekadat.hath*2,hekadat.hath*4);
% Fit histogram with gaussian to get single channel current and integrate
% to get popen
CtPop.HEKAhistfit(noh,i);
%% mean from singles: tau activation and mean i
% Calculate mean from non-idealized single traces
single_ave=hekadat.HEKAstagmean('ooo');
CtPop.HEKAtauact(hekadat.stAxis,single_ave,i);

%% tau first latencies
CtPop.HEKAtauflat(iA.notx.flat,iA.notx.flatp,i);
%% dwell time taus
CtPop.odt1(i)=10^iA.notx.ocoeffs(2);
CtPop.cdt1(i)=10^iA.notx.ccoeffs(2);
CtPop.cdt2(i)=10^iA.notx.ccoeffs(4);