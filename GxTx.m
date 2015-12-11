%% Data loading
% Pathcmaster mat file exports
hekadat=HEKAdat('2015_06_23_Juan');

% quickly scroll through blanks and bad data
% subtract blank average
% put blanks and bad data in separate struct and save them
%%
gxtx_screenBlanks(hekadat,[],1);