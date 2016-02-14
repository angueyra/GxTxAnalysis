%% ANALYSIS OF KV2.1 SINGLE CHANNEL DATA
% Steps (not stairs protocol)

%% Data loading
% Patchmaster mat file exports
clear; clear classes; clc;
hekadat=HEKAdat('2015_06_19_E3_IV'); %Control cell; 3 channels but ok for IV
edgemin=-1;edgemax=2;nbins=200;
gauss=@(b,x)(b(3).*normalize(normpdf(x,b(1),b(2))));
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

s0.ex=s0.ex(2004:end)-1.3;
s0.tAxis=s0.tAxis(2:end-2002);



[s0.hx,s0.hy,s0.sx,s0.sy]=hekadat.HEKAhist(s0.ex,nbins,edgemin,edgemax);

tg=0.5/2; %threshold guess
tg_ind=find(s0.hx<tg,1,'last');
c_peak=max(s0.hy(1:tg_ind));
c_i=find(s0.hy==c_peak);
c_hw1=find(s0.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
c_hw2=find(s0.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
o_peak=max(s0.hy(tg_ind+1:end));
o_i=find(s0.hy==o_peak);
o_hw1=find(s0.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
o_hw2=find(s0.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width


c0=[0 0.1 c_peak];
s0.c_coeffs=nlinfit(s0.hx(c_hw1:c_hw2),s0.hy(c_hw1:c_hw2),gauss,c0);
s0.cfit=gauss(s0.c_coeffs,s0.hx);
o0=[0.5 0.1 o_peak];
s0.o_coeffs=nlinfit(s0.hx(o_hw1:o_hw2),s0.hy(o_hw1:o_hw2),gauss,o0);
s0.ofit=gauss(s0.o_coeffs,s0.hx);
s0.i=s0.o_coeffs(1)-s0.c_coeffs(1);


f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s0.tAxis,s0.ex,'Parent',f1);
set(lH,'Color','k','DisplayName','s0mV');
lH=line([0 1],[0 0],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','ic');
lH=line([0 1],[s0.i s0.i],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','io');
makeAxisStruct(f1,'IV0mV','GxTx/PoCNSciIV');


f2=getfigH(2);
% set(f1,'ylim',[-0.5 3])
lH=line(s0.sx,s0.sy,'Parent',f2);
set(lH,'Color','k','DisplayName','h0mV');
lH=line(s0.hx,s0.ofit,'Parent',f2);
set(lH,'Color','r','DisplayName','hofit');
lH=line(s0.hx,s0.cfit,'Parent',f2);
set(lH,'Color','b','DisplayName','hcfit');
makeAxisStruct(f2,'h0mV','GxTx/PoCNSciIV');

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


s25.ex=(s25.ex(2004:end)-2.4)*.8;
s25.tAxis=s25.tAxis(2:end-2002);



[s25.hx,s25.hy,s25.sx,s25.sy]=hekadat.HEKAhist(s25.ex,nbins,edgemin,edgemax);

tg=.64/2; %threshold guess
tg_ind=find(s25.hx<tg,1,'last');
c_peak=max(s25.hy(1:tg_ind));
c_i=find(s25.hy==c_peak);
c_hw1=find(s25.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
c_hw2=find(s25.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
o_peak=max(s25.hy(tg_ind+1:end));
o_i=find(s25.hy==o_peak);
o_hw1=find(s25.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
o_hw2=find(s25.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width


c0=[0 0.1 c_peak];
s25.c_coeffs=nlinfit(s25.hx(c_hw1:c_hw2),s25.hy(c_hw1:c_hw2),gauss,c0);
s25.cfit=gauss(s25.c_coeffs,s25.hx);
o0=[0.64 0.1 o_peak];
s25.o_coeffs=nlinfit(s25.hx(o_hw1:o_hw2),s25.hy(o_hw1:o_hw2),gauss,o0);
s25.ofit=gauss(s25.o_coeffs,s25.hx);
s25.i=s25.o_coeffs(1)-s25.c_coeffs(1);
disp(s25.i)


f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s25.tAxis,s25.ex,'Parent',f1);
set(lH,'Color','k','DisplayName','s25mV');
lH=line([0 1],[0 0],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','ic');
lH=line([0 1],[s25.i s25.i],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','io');
makeAxisStruct(f1,'IV25mV','GxTx/PoCNSciIV');


f2=getfigH(2);
% set(f1,'ylim',[-0.5 3])
lH=line(s25.sx,s25.sy,'Parent',f2);
set(lH,'Color','k','DisplayName','h0mV');
lH=line(s25.hx,s25.ofit,'Parent',f2);
set(lH,'Color','r','DisplayName','hofit');
lH=line(s25.hx,s25.cfit,'Parent',f2);
set(lH,'Color','b','DisplayName','hcfit');
makeAxisStruct(f2,'h25mV','GxTx/PoCNSciIV');

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

s50.ex=(s50.ex(2004:end)-3.14)*.75;
s50.tAxis=s50.tAxis(2:end-2002);



[s50.hx,s50.hy,s50.sx,s50.sy]=hekadat.HEKAhist(s50.ex,nbins,edgemin,edgemax);

tg=.75/2; %threshold guess
tg_ind=find(s50.hx<tg,1,'last');
c_peak=max(s50.hy(1:tg_ind));
c_i=find(s50.hy==c_peak);
c_hw1=find(s50.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
c_hw2=find(s50.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
o_peak=max(s50.hy(tg_ind+1:end));
o_i=find(s50.hy==o_peak);
o_hw1=find(s50.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
o_hw2=find(s50.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width


c0=[0.2 0.1 c_peak];
s50.c_coeffs=nlinfit(s50.hx(c_hw1:c_hw2),s50.hy(c_hw1:c_hw2),gauss,c0);
s50.cfit=gauss(s50.c_coeffs,s50.hx);
o0=[.8 0.1 o_peak];
s50.o_coeffs=nlinfit(s50.hx(o_hw1:o_hw2),s50.hy(o_hw1:o_hw2),gauss,o0);
s50.ofit=gauss(s50.o_coeffs,s50.hx);
s50.i=s50.o_coeffs(1);%-s50.c_coeffs(1);
disp(s50.i)


f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s50.tAxis,s50.ex,'Parent',f1);
set(lH,'Color','k','DisplayName','s50mV');
lH=line([0 1],[0 0],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','ic');
lH=line([0 1],[s50.i s50.i],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','io');
makeAxisStruct(f1,'IV50mV','GxTx/PoCNSciIV');


f2=getfigH(2);
% set(f1,'ylim',[-0.5 3])
lH=line(s50.sx,s50.sy,'Parent',f2);
set(lH,'Color','k','DisplayName','h0mV');
lH=line(s50.hx,s50.ofit,'Parent',f2);
set(lH,'Color','r','DisplayName','hofit');
lH=line(s50.hx,s50.cfit,'Parent',f2);
set(lH,'Color','b','DisplayName','hcfit');
makeAxisStruct(f2,'h50mV','GxTx/PoCNSciIV');


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

s75.ex=(s75.ex(2004:end)-3.96)*.75;
s75.tAxis=s75.tAxis(2:end-2002);



[s75.hx,s75.hy,s75.sx,s75.sy]=hekadat.HEKAhist(s75.ex,nbins,edgemin,edgemax);

tg=1.12/2; %threshold guess
tg_ind=find(s75.hx<tg,1,'last');
c_peak=max(s75.hy(1:tg_ind));
c_i=find(s75.hy==c_peak);
c_hw1=find(s75.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
c_hw2=find(s75.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
o_peak=max(s75.hy(tg_ind+1:end));
o_i=find(s75.hy==o_peak);
o_hw1=find(s75.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
o_hw2=find(s75.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width


c0=[0 0.1 c_peak];
s75.c_coeffs=nlinfit(s75.hx(c_hw1:c_hw2),s75.hy(c_hw1:c_hw2),gauss,c0);
s75.cfit=gauss(s75.c_coeffs,s75.hx);
o0=[1.12 0.1 o_peak];
s75.o_coeffs=nlinfit(s75.hx(o_hw1:o_hw2),s75.hy(o_hw1:o_hw2),gauss,o0);
s75.ofit=gauss(s75.o_coeffs,s75.hx);
s75.i=s75.o_coeffs(1)-s75.c_coeffs(1);
disp(s75.i)


f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s75.tAxis,s75.ex,'Parent',f1);
set(lH,'Color','k','DisplayName','s75mV');
lH=line([0 1],[0 0],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','ic');
lH=line([0 1],[s75.i s75.i],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','io');
makeAxisStruct(f1,'IV75mV','GxTx/PoCNSciIV');


f2=getfigH(2);
% set(f1,'ylim',[-0.5 3])
lH=line(s75.sx,s75.sy,'Parent',f2);
set(lH,'Color','k','DisplayName','h0mV');
lH=line(s75.hx,s75.ofit,'Parent',f2);
set(lH,'Color','r','DisplayName','hofit');
lH=line(s75.hx,s75.cfit,'Parent',f2);
set(lH,'Color','b','DisplayName','hcfit');
makeAxisStruct(f2,'h75mV','GxTx/PoCNSciIV');
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

s100.ex=(s100.ex(2004:end)-4.7)*.75;
s100.tAxis=s100.tAxis(2:end-2002);



[s100.hx,s100.hy,s100.sx,s100.sy]=hekadat.HEKAhist(s100.ex,nbins,edgemin,edgemax);

tg=1.31/2; %threshold guess
tg_ind=find(s100.hx<tg,1,'last');
c_peak=max(s100.hy(1:tg_ind));
c_i=find(s100.hy==c_peak);
c_hw1=find(s100.hy(1:tg_ind)>c_peak/2,1,'first'); %half width
c_hw2=find(s100.hy(1:tg_ind)>c_peak/2,1,'last'); %half width
o_peak=max(s100.hy(tg_ind+1:end));
o_i=find(s100.hy==o_peak);
o_hw1=find(s100.hy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
o_hw2=find(s100.hy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width


c0=[0 0.1 c_peak];
s100.c_coeffs=nlinfit(s100.hx(c_hw1:c_hw2),s100.hy(c_hw1:c_hw2),gauss,c0);
s100.cfit=gauss(s100.c_coeffs,s100.hx);
o0=[1.31 0.1 o_peak];
s100.o_coeffs=nlinfit(s100.hx(o_hw1:o_hw2),s100.hy(o_hw1:o_hw2),gauss,o0);
s100.ofit=gauss(s100.o_coeffs,s100.hx);
s100.i=s100.o_coeffs(1)-s100.c_coeffs(1);
disp(s100.i)


f1=getfigH(1);
set(f1,'ylim',[-0.5 3])
lH=line(s100.tAxis,s100.ex,'Parent',f1);
set(lH,'Color','k','DisplayName','s100mV');
lH=line([0 1],[0 0],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','ic');
lH=line([0 1],[s100.i s100.i],'Parent',f1);
set(lH,'Color',[.5 .5 .5],'DisplayName','io');
makeAxisStruct(f1,'IV100mV','GxTx/PoCNSciIV');


f2=getfigH(2);
% set(f1,'ylim',[-0.5 3])
lH=line(s100.sx,s100.sy,'Parent',f2);
set(lH,'Color','k','DisplayName','h0mV');
lH=line(s100.hx,s100.ofit,'Parent',f2);
set(lH,'Color','r','DisplayName','hofit');
lH=line(s100.hx,s100.cfit,'Parent',f2);
set(lH,'Color','b','DisplayName','hcfit');
makeAxisStruct(f2,'h100mV','GxTx/PoCNSciIV');

%% full IV
IV=struct;

IV.v=[0 25 50 75 100];
IV.i=[s0.i s25.i s50.i s75.i s100.i];

linef=@(b,x)( (b(1)*x) + b(2) );
l0=[2 -50];
IV.coeffs=nlinfit(IV.v,IV.i,linef,l0);
IV.fitx=-100:10:100;
IV.fity=linef(IV.coeffs,IV.fitx);

f3=getfigH(3);
lH=line(IV.v,IV.i,'Parent',f3);
set(lH,'Marker','.','LineStyle','none','Color','k','DisplayName','IV');

lH=line(IV.fitx,IV.fity,'Parent',f3);
set(lH,'Marker','none','LineStyle','--','Color','k','DisplayName','IVfit');

lH=line([-100 100],[0 0],'Parent',f3);
set(lH,'Marker','none','LineStyle','--','Color','k','DisplayName','zeroi');
makeAxisStruct(f3,'IV','GxTx/PoCNSciIV');
