% Collecting population data for GxTx experiments

%% Controls patches
clear; clear classes; clc;
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
CtPop.hath = NaN(size(CtPop.names));
CtPop.hathi = NaN(size(CtPop.names));
CtPop.act_coeffs = NaN(size(CtPop.names,1),3);
CtPop.tactivation = NaN(size(CtPop.names));
CtPop.averagei = NaN(size(CtPop.names));
CtPop.tflats = NaN(size(CtPop.names));
CtPop.tflat_coeffs = NaN(size(CtPop.names,1),3);
CtPop.odt1 = NaN(size(CtPop.names));
CtPop.cdt1 = NaN(size(CtPop.names));
CtPop.cdt2 = NaN(size(CtPop.names));
CtPop.cdt3 = NaN(size(CtPop.names));
CtPop.cdtlong = NaN(size(CtPop.names));
CtPop.cdtnlong = NaN(size(CtPop.names));
CtPop.cdtntotal = NaN(size(CtPop.names));
%
for i=1:size(CtPop.names,1)
    % %% n trials by tag
    hekadat=HEKAdat(char(CtPop.names(i)));
    iA=hekadat.HEKAiAnalysis;
    CtPop.n.ccc(i)=sum(hekadat.HEKAtagfind('ccc'));
    CtPop.n.ooo(i)=sum(hekadat.HEKAtagfind('ooo'));
    CtPop.n.coc(i)=sum(hekadat.HEKAtagfind('coc'));
    CtPop.n.zzz(i)=sum(hekadat.HEKAtagfind('zzz'));
    CtPop.n.total(i)=CtPop.n.ccc(i)+CtPop.n.ooo(i)+CtPop.n.coc(i)+CtPop.n.zzz(i);
    % %% single channel current and popen
    % Calculate histogram
    noh=struct;
    [noh.hx,noh.hy,noh.sx,noh.sy]=...
        hekadat.HEKAhistbytag('ooo',400,-hekadat.hath*2,hekadat.hath*4);
    % Fit histogram with gaussian to get single channel current and integrate
    % to get popen
    CtPop.HEKAhistfit(noh,i);
    % %% mean from singles: tau activation and mean i
    % Calculate mean from non-idealized single traces
    single_ave=hekadat.HEKAstagmean('ooo');
    CtPop.HEKAtauact(hekadat.stAxis,single_ave,i);
    
    % %% tau first latencies
    CtPop.HEKAtauflat(iA.notx.flat,iA.notx.flatp,i);
    % %% dwell time taus
    CtPop.odt1(i)=10^iA.notx.ocoeffs(2);
    CtPop.cdt1(i)=10^iA.notx.ccoeffs(2);
    CtPop.cdt2(i)=10^iA.notx.ccoeffs(4);
    
    CtPop.cdtnlong(i)=sum(iA.notx.cdt>log10(50));
    CtPop.cdtntotal(i)=size(iA.notx.cdt,1);
    CtPop.cdtlong(i)=CtPop.cdtnlong(i)/CtPop.cdtntotal(i);
end

% for i=1:size(CtPop.names,1)
%     fprintf('\n%s:\n\ttauact = %0.02f ms\n\ttauflats = %0.02f ms\n',...
%         CtPop.names{i},CtPop.tactivation(i),CtPop.tflats(i))
% end

CtPop.HEKAsave;
%%
% f3=getfigH(3);
% 
% lH=line(iA.notx.flat,iA.notx.flatp,'Parent',f3);
% set(lH,'Marker','o','linewidth',2)
% 
% lH=line(iA.notx.flat,.95*CtPop.taufx([7 1.2],iA.notx.flat),'Parent',f3)
% set(lH,'linewidth',2,'color','r')

%% GxTx patches Free
NoPop = HEKApopdata('NoToxin');

NoPop.names = {...
    '2011_06_29_E5GxTx';...
    '2011_06_23_E4GxTx_Stair500';...
    '2011_06_24_E4GxTx_Stair500';...
    };
NoPop.names=cellstr(NoPop.names);
NoPop.n=struct;
NoPop.n.ccc = NaN(size(NoPop.names));
NoPop.n.ooo = NaN(size(NoPop.names));
NoPop.n.coc = NaN(size(NoPop.names));
NoPop.n.zzz = NaN(size(NoPop.names));
NoPop.n.total = NaN(size(NoPop.names));
NoPop.isingle = NaN(size(NoPop.names));
NoPop.popen = NaN(size(NoPop.names));
NoPop.hath = NaN(size(NoPop.names));
NoPop.hathi = NaN(size(NoPop.names));
NoPop.act_coeffs = NaN(size(NoPop.names,1),3);
NoPop.tactivation = NaN(size(NoPop.names));
NoPop.averagei = NaN(size(NoPop.names));
NoPop.tflats = NaN(size(NoPop.names));
NoPop.tflat_coeffs = NaN(size(NoPop.names,1),3);
NoPop.odt1 = NaN(size(NoPop.names));
NoPop.cdt1 = NaN(size(NoPop.names));
NoPop.cdt2 = NaN(size(NoPop.names));
NoPop.cdt3 = NaN(size(NoPop.names));
NoPop.cdtlong = NaN(size(NoPop.names));
NoPop.cdtnlong = NaN(size(NoPop.names));
NoPop.cdtntotal = NaN(size(NoPop.names));
%
for i=1:size(NoPop.names,1)
    % %% n trials by tag
    hekadat=HEKAdat(char(NoPop.names(i)));
    iA=hekadat.HEKAiAnalysis;
    NoPop.n.ccc(i)=sum(hekadat.HEKAtagfind('ccc'));
    NoPop.n.ooo(i)=sum(hekadat.HEKAtagfind('ooo'));
    NoPop.n.coc(i)=sum(hekadat.HEKAtagfind('coc'));
    NoPop.n.zzz(i)=sum(hekadat.HEKAtagfind('zzz'));
    NoPop.n.total(i)=NoPop.n.ccc(i)+NoPop.n.ooo(i)+NoPop.n.coc(i)+NoPop.n.zzz(i);
    % %% single channel current and popen
    % Calculate histogram
    noh=struct;
    [noh.hx,noh.hy,noh.sx,noh.sy]=...
        hekadat.HEKAhistbytag('ooo',400,-hekadat.hath*2,hekadat.hath*4);
    % Fit histogram with gaussian to get single channel current and integrate
    % to get popen
    NoPop.HEKAhistfit(noh,i);
    % %% mean from singles: tau activation and mean i
    % Calculate mean from non-idealized single traces
    single_ave=hekadat.HEKAstagmean('ooo');
    NoPop.HEKAtauact(hekadat.stAxis,single_ave,i);
    
    % %% tau first latencies
    NoPop.HEKAtauflat(iA.notx.flat,iA.notx.flatp,i);
    drawnow
    % %% dwell time taus
    NoPop.odt1(i)=10^iA.notx.ocoeffs(2);
    NoPop.cdt1(i)=10^iA.notx.ccoeffs(2);
    NoPop.cdt2(i)=10^iA.notx.ccoeffs(4);
    
    NoPop.cdtnlong(i)=sum(iA.notx.cdt>log10(50));
    NoPop.cdtntotal(i)=size(iA.notx.cdt,1);
    NoPop.cdtlong(i)=NoPop.cdtnlong(i)/NoPop.cdtntotal(i);
end

for i=1:size(NoPop.names,1)
    fprintf('\n%s:\n\ttauact = %0.02f ms\n\ttauflats = %0.02f ms\n',...
        NoPop.names{i},NoPop.tactivation(i),NoPop.tflats(i))
end

NoPop.HEKAsave;
%%

%% GxTx patches Bound
GxPop = HEKApopdata('GxToxin');

GxPop.names = {...
    '2011_06_29_E5GxTx';...
    '2011_06_23_E4GxTx_Stair500';...
    '2011_06_24_E4GxTx_Stair500';...
    };
GxPop.names=cellstr(GxPop.names);
GxPop.n=struct;
GxPop.n.ccc = NaN(size(GxPop.names));
GxPop.n.ooo = NaN(size(GxPop.names));
GxPop.n.coc = NaN(size(GxPop.names));
GxPop.n.zzz = NaN(size(GxPop.names));
GxPop.n.total = NaN(size(GxPop.names));
GxPop.isingle = NaN(size(GxPop.names));
GxPop.popen = NaN(size(GxPop.names));
GxPop.hath = NaN(size(GxPop.names));
GxPop.hathi = NaN(size(GxPop.names));
GxPop.act_coeffs = NaN(size(GxPop.names,1),3);
GxPop.tactivation = NaN(size(GxPop.names));
GxPop.averagei = NaN(size(GxPop.names));
GxPop.tflats = NaN(size(GxPop.names));
GxPop.tflat_coeffs = NaN(size(GxPop.names,1),3);
GxPop.odt1 = NaN(size(GxPop.names));
GxPop.cdt1 = NaN(size(GxPop.names));
GxPop.cdt2 = NaN(size(GxPop.names));
GxPop.cdt3 = NaN(size(GxPop.names));
GxPop.cdtlong = NaN(size(GxPop.names));
GxPop.cdtnlong = NaN(size(GxPop.names));
GxPop.cdtntotal = NaN(size(GxPop.names));
%
for i=1:size(GxPop.names,1)
    % %% n trials by tag
    hekadat=HEKAdat(char(GxPop.names(i)));
    iA=hekadat.HEKAiAnalysis;
    GxPop.n.ccc(i)=sum(hekadat.HEKAtagfind('ccc'));
    GxPop.n.ooo(i)=sum(hekadat.HEKAtagfind('ooo'));
    GxPop.n.coc(i)=sum(hekadat.HEKAtagfind('coc'));
    GxPop.n.zzz(i)=sum(hekadat.HEKAtagfind('zzz'));
    GxPop.n.total(i)=GxPop.n.ccc(i)+GxPop.n.ooo(i)+GxPop.n.coc(i)+GxPop.n.zzz(i);
    % %% single channel current and popen
    % Calculate histogram
    gxh=struct;
    [gxh.hx,gxh.hy,gxh.sx,gxh.sy]=...
        hekadat.HEKAhistbytag('coc',400,-hekadat.hath*2,hekadat.hath*4);
    % Fit histogram with gaussian to get single channel current and integrate
    % to get popen
    GxPop.HEKAhistfit(gxh,i);
    % %% mean from singles: tau activation and mean i
    % Calculate mean from non-idealized single traces
    single_ave=hekadat.HEKAstagmean('coc');
    GxPop.HEKAtauact(hekadat.stAxis,single_ave,i);
    
    % %% tau first latencies
    GxPop.HEKAtauflat(iA.gxtx.flat,iA.gxtx.flatp,i);
    drawnow
    % %% dwell time taus
    GxPop.odt1(i)=10^iA.gxtx.ocoeffs(2);
    GxPop.cdt1(i)=10^iA.gxtx.ccoeffs(2);
    GxPop.cdt2(i)=10^iA.gxtx.ccoeffs(4);
    GxPop.cdt3(i)=10^iA.gxtx.ccoeffs(6);
    
    GxPop.cdtnlong(i)=sum(iA.gxtx.cdt>log10(50));
    GxPop.cdtntotal(i)=size(iA.gxtx.cdt,1);
    GxPop.cdtlong(i)=GxPop.cdtnlong(i)/GxPop.cdtntotal(i);
end

for i=1:size(GxPop.names,1)
    fprintf('\n%s:\n\ttauact = %0.02f ms\n\ttauflats = %0.02f ms\n',...
        GxPop.names{i},GxPop.tactivation(i),GxPop.tflats(i))
end

GxPop.HEKAsave;
