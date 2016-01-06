%% Data loading
% Patchmaster mat file exports
clear; clear classes; clc;
hekadat=HEKAdat('2015_06_23_Juan');

% quickly scroll through blanks and bad data
% subtract blank average
% put blanks and bad data in separate struct and save them
%%
hGUI=gxtx_tagBlanks(hekadat,[],10);
%%
gxtx_tagOpenings(hekadat,[],10);
%% Idealization of ooo and coc traces only

cccmean=hekadat.HEKAtagmean('ccc');
plot(hekadat.tAxis,hekadat.data(8,:)-cccmean,'.');
xlim([0.22 0.72])
%%
p=struct;
p.LockNow=0;
gxtx_refineBlanks(hekadat,p,10);
%%
gxtx_idealizeTraces(hekadat,[],10);

%%

clear; clear classes; clc;hekadat=HEKAdat('2015_06_23_Juan');hGUI=gxtx_tagBlanks(hekadat,[],10);
%%
hekadat=HEKAdat('2015_06_23_Juan');
[odt,cdt]=hekadat.HEKAdwelltimes;
%%
[hx,hy]=hekadat.HEKAloghist(odt,100,1,200);
plot(hx,hy,'k-','LineWidth',2)
xlim([0 50])
%%
[hx,hy]=hekadat.HEKAhist(odt,100,0,80);
plot(hx,hy,'k-','LineWidth',2)
xlim([0 25])
%%
dtmin=1;
dtmax=100;
nbins=50;
spacing=logspace(log10(dtmin),log10(dtmax),nbins);

% function [ logtime logdata ] = LogBinData( time, data, bins )
% spacing=logspace(log10(1),log10(length(time)+1),bins);
% [~, binidx] = histc(1:length(time),spacing);
% timemeans = accumarray(binidx.', time', [], @mean);
% if time(1)==0,
%     logtime=[0; timemeans(timemeans~=0)];
% else
%     logtime=timemeans(timemeans~=0);
% end
% datameans = accumarray(binidx.', data', [], @mean);
% logdata=datameans(datameans~=0);
% end