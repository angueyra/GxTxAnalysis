%% ANALYSIS OF KV2.1 SINGLE CHANNEL DATA
% Steps (not stairs protocol)

%% Data loading
% Patchmaster mat file exports
clear; clear classes; clc;
hekadat=HEKAdat('2015_06_19_E3_IV'); %Control cell; 3 channels but ok for IV

%%
hGUI=gxtx_tagBlanks(hekadat,[],10);
%%
excludei=hekadat.HEKAtagfind('ccc')+hekadat.HEKAtagfind('bad');
newtags=hekadat.tags;
newtags(~excludei)={'ooo'};

hekadat.tags=newtags;
%% 0 mV
ccci=hekadat.HEKAtagfind('ccc');
s0.stname='e_3_1_1';
s0.endname='e_3_4_20';
s0.exname='e_3_2_10';
s0.sti=hekadat.HEKAnamefind(s0.stname);
s0.endi=hekadat.HEKAnamefind(s0.endname);
s0.exi=hekadat.HEKAnamefind(s0.exname);
s0.ccci=find(ccci(s0.sti:s0.endi));
s0.ex=hekadat.data(s0.exi,:);
s0.ccc=mean(hekadat.data(s0.ccci,:));
s0.sex=s0.ex-s0.ccc;
s0.tAxis=hekadat.tAxis;

f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s0.tAxis(2:end-2002),s0.ex(2004:end)-1.3,'Parent',f1);
set(lH,'Color','k','DisplayName','s0mV');
makeAxisStruct(f1,'IV0mV','GxTx/PoCNSciIV');
% lH=line([0 1],[0 0],'Parent',f1);
%% 25 mV
ccci=hekadat.HEKAtagfind('ccc');
s25.stname='e_3_5_1';
s25.endname='e_3_6_20';
s25.exname='e_3_5_2';
s25.sti=hekadat.HEKAnamefind(s25.stname);
s25.endi=hekadat.HEKAnamefind(s25.endname);
s25.exi=hekadat.HEKAnamefind(s25.exname);
s25.ccci=find(ccci(s25.sti:s25.endi));
s25.ex=hekadat.data(s25.exi,:);
s25.ccc=mean(hekadat.data(s25.ccci,:));
s25.sex=s25.ex-s25.ccc;
s25.tAxis=hekadat.tAxis;

f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s25.tAxis(2:end-2002),s25.ex(2004:end)-2.4,'Parent',f1);
set(lH,'Color','k','DisplayName','s25mV');
makeAxisStruct(f1,'IV25mV','GxTx/PoCNSciIV');
% lH=line([0 1],[0 0],'Parent',f1);
%% 50 mV
ccci=hekadat.HEKAtagfind('ccc');
s50.stname='e_3_7_1';
s50.endname='e_3_7_20';
s50.exname='e_3_7_1';
s50.sti=hekadat.HEKAnamefind(s50.stname);
s50.endi=hekadat.HEKAnamefind(s50.endname);
s50.exi=hekadat.HEKAnamefind(s50.exname);
s50.ccci=find(ccci(s50.sti:s50.endi));
s50.ex=hekadat.data(s50.exi,:);
s50.ccc=mean(hekadat.data(s50.ccci,:));
s50.sex=s50.ex-s50.ccc;
s50.tAxis=hekadat.tAxis;

f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s50.tAxis(2:end-2002),s50.ex(2004:end)-3.14,'Parent',f1);
set(lH,'Color','k','DisplayName','s50mV');
makeAxisStruct(f1,'IV50mV','GxTx/PoCNSciIV');
% lH=line([0 1],[0 0],'Parent',f1);
%% 75 mV
ccci=hekadat.HEKAtagfind('ccc');
s75.stname='e_3_8_1';
s75.endname='e_3_8_20';
s75.exname='e_3_8_1';
s75.sti=hekadat.HEKAnamefind(s75.stname);
s75.endi=hekadat.HEKAnamefind(s75.endname);
s75.exi=hekadat.HEKAnamefind(s75.exname);
s75.ccci=find(ccci(s75.sti:s75.endi));
s75.ex=hekadat.data(s75.exi,:);
s75.ccc=mean(hekadat.data(s75.ccci,:));
s75.sex=s75.ex-s75.ccc;
s75.tAxis=hekadat.tAxis;

f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s75.tAxis(2:end-2002),s75.ex(2004:end)-3.96,'Parent',f1);
set(lH,'Color','k','DisplayName','s75mV');
makeAxisStruct(f1,'IV75mV','GxTx/PoCNSciIV');
% lH=line([0 1],[0 0],'Parent',f1);
%% 100 mV
ccci=hekadat.HEKAtagfind('ccc');
s100.stname='e_3_9_1';
s100.endname='e_3_11_20';
s100.exname='e_3_9_14';
s100.sti=hekadat.HEKAnamefind(s100.stname);
s100.endi=hekadat.HEKAnamefind(s100.endname);
s100.exi=hekadat.HEKAnamefind(s100.exname);
s100.ccci=find(ccci(s100.sti:s100.endi));
s100.ex=hekadat.data(s100.exi,:);
s100.ccc=mean(hekadat.data(s100.ccci,:));
s100.sex=s100.ex-s100.ccc;
s100.tAxis=hekadat.tAxis;

f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s100.tAxis(2:end-2002),s100.ex(2004:end)-4.7,'Parent',f1);
set(lH,'Color','k','DisplayName','s100mV');
makeAxisStruct(f1,'IV100mV','GxTx/PoCNSciIV');
% lH=line([0 1],[0 0],'Parent',f1);