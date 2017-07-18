close all; clear; clear classes; clc;
hekadat=HEKAdat('2011_06_23_E4GxTx_Stair500'); %GxTx cell no TTX 
hekadat.HEKAstairs;
stairs=hekadat.stim;
% tagged 'ccc' until trace #100
cccmean=hekadat.HEKAtagmean('ccc');
%%
ttx_epochs=[7,54,57,59,77,80,11,72,74,78,82];

ttxdata=hekadat.data(ttx_epochs,:);
ttxdata=ttxdata-(repmat(cccmean,length(ttx_epochs),1));
tlim=find(hekadat.tAxis<0.22,1,'last');
ttxdata=ttxdata(:,1:tlim);
tAxis=hekadat.tAxis(1:tlim);
stairs=hekadat.stim;
stairs=stairs(1:tlim);

figure(2);clf;f2=gca;
set(get(f2,'xlabel'),'string','Time (s)')
set(get(f2,'ylabel'),'string','VCMD (mV)')
xlim([0 0.22])

lH=line(tAxis,stairs,'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color',[0 0 0])
set(lH,'DisplayName','Stim')

%%%makeAxisStruct(f2,sprintf('ttxStim'),'GxTx/PoCNSci');

figure(1);clf;f1=gca;
set(get(f1,'xlabel'),'string','Time (s)')
set(get(f1,'ylabel'),'string','i (pA)')
xlim([0 0.22])

for i=1:length(ttx_epochs)
    figure(1);clf;f1=gca;
    set(get(f1,'xlabel'),'string','Time (s)')
    set(get(f1,'ylabel'),'string','i (pA)')
    xlim([0 0.22])
    lH=line(tAxis,ttxdata(i,:),'Parent',f1);
    set(lH,'Marker','none','LineStyle','-','LineWidth',1,'Color',[0 0 0])
    set(lH,'DisplayName',sprintf('ttxdata%g',i))
    drawnow
    %%%makeAxisStruct(f1,sprintf('ttx%g',i),'GxTx/PoCNSci');
end



