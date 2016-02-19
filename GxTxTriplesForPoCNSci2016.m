clear; clear classes; clc;
hekadat=HEKAdat('2015_06_28_E2_Triple'); %GxTx cell no TTX 

%%
it=1;
id=2;
is=6;

st=1;
bl=.8;
datat=(hekadat.data(it,st:end))-bl;
datad=(hekadat.data(id,st:end))-bl;
datas=(hekadat.data(is,st:end))-bl;
tAxis=hekadat.tAxis(1:end-st+1)-.1;

figure(1);clf;f1=gca;
set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','i (pA)')

set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','i (pA)')
xlim([tAxis(1) tAxis(end)])
% ylim([-.5 2])
lH=line(tAxis,datas,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',1,'Color',[0 0 0])
set(lH,'DisplayName',sprintf('single'))

lH=line(tAxis,datad,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',1,'Color',[0 0 1])
set(lH,'DisplayName',sprintf('double'))

lH=line(tAxis,datat,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',1,'Color',[.8 0 0])
set(lH,'DisplayName',sprintf('triple'))
makeAxisStruct(f1,'Single','GxTx/PoCNSci');
makeAxisStruct(f1,'Double','GxTx/PoCNSci');
makeAxisStruct(f1,'Triple','GxTx/PoCNSci');
makeAxisStruct(f1,'Overlay','GxTx/PoCNSci');

%%
stim=zeros(size(tAxis));
stim(tAxis>0)=1;
figure(2);clf;f2=gca;
lH=line(tAxis,stim,'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0 0])
set(lH,'DisplayName',sprintf('stim'))
makeAxisStruct(f2,'Stim','GxTx/PoCNSci');