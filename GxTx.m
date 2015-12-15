%% Data loading
% Patchmaster mat file exports
hekadat=HEKAdat('2015_06_23_Juan');

% quickly scroll through blanks and bad data
% subtract blank average
% put blanks and bad data in separate struct and save them
%%
gxtx_tagBlanks(hekadat,[],1);
%%
gxtx_tagOpenings(hekadat,[],1);
%% Idealization of ooo and coc traces only

cccmean=hekadat.HEKAtagmean('ccc');
plot(hekadat.tAxis,hekadat.data(8,:)-cccmean,'.');
xlim([0.22 0.72])
%%
gxtx_refineBlanks(hekadat,[],10);
%%
gxtx_idealizeTraces(hekadat,[],10);

%%