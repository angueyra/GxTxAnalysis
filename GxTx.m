%% Data loading
% Pathcmaster mat file exports
hekadat=HEKAdat('2015_06_23_Juan');

% quickly scroll through blanks and bad data
% subtract blank average
% put blanks and bad data in separate struct and save them
%%
gxtx_screenBlanks(hekadat,[],1);
%%
gxtx_screenOpenings(hekadat,[],1);
%% Idealization of ooo and coc traces only

cccmean=hekadat.HEKAtagmean('ccc');
plot(hekadat.tAxis,hekadat.data(8,:)-cccmean,'.');
xlim([0.22 0.72])
%%
gxtx_idealizeTraces(hekadat,[],10);

%%
tst=hekadat.HEKAstairsprotocol();
blanks=hekadat.data(hekadat.HEKAtagfind('ccc'),tst.sti:tst.endi);
f1=getfigH(1);
lH=line(1:size(blanks,1),mean(blanks(:,2000:end),2),'Parent',f1)
set(lH,'linestyle','none','marker','.');

%%
plot(blanks(74,:))
hold all
plot(blanks(73,:))
plot(blanks(72,:))
plot(mean(blanks),'k')
hold off
