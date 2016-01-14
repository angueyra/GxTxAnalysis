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
%% openDwellTimes log-binned histogram and fitting
nbins=80;
ologmin=-1;
ologmax=2.2;
[ohx_log,ohy_log,osx_log,osy_log]=hekadat.HEKAloghist(odt,nbins,ologmin,ologmax);


logexp=@(q,x)(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
logbinexp=@(q,x)sqrt( (10.^x) .* (  logexp(q,x)  ) );
og=[10 1];
ogy_log=logbinexp(og,ohx_log);

ofc_log=nlinfit(ohx_log,ohy_log,logbinexp,og);
ofy_log=logbinexp(ofc_log,ohx_log);
fprintf('_________________________________________\n')
fprintf('Fit of open dwell times:\n')
fprintf('\ttau = %g ms\n\talpha = %g\n',round(10^(ofc_log(2))*1000)/1000,round((ofc_log(1))*1000)/1000)
fprintf('-----------------------------------------\n')

f1=getfigH(1);
set(f1,'xscale','linear')
lH=line(ohx_log,ohy_log,'Parent',f1);
set(lH,'Marker','.','LineStyle','none','Color','k')
lH=line(osx_log,osy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','k')
lH=line(ohx_log,ogy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',1,'Color',[.5 .5 .5])
lH=line(ohx_log,ofy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')

% replotting in linear time
[ohx,ohy,osx,osy]=hekadat.HEKAhist(odt,nbins,10^ologmin,10^ologmax);
expdecayfixedtau=@(q,x)((q(1)*exp(-(x)/10^(ofc_log(2)))));
ofc=nlinfit(ohx(2:end),ohy(2:end),expdecayfixedtau,400);
ofy=expdecayfixedtau(ofc,ohx);

f2=getfigH(2);
set(f2,'xscale','linear')
lH=line(ohx,ohy,'Parent',f2);
set(lH,'Marker','.','LineStyle','none','Color','k')
lH=line(osx,osy,'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','k')
lH=line(ohx,ofy,'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')

%% closedDwellTimes log-binned histogram and fitting
nbins=80;
clogmin=-1;
clogmax=2.5;
[chx_log,chy_log,csx_log,csy_log]=hekadat.HEKAloghist(cdt,nbins,clogmin,clogmax);

logexp=@(q,x)(q(1)^2 .* exp(  (1-( 10.^x ./ 10^q(2) ))) ./ (10^q(2)));
dblogbinexp=@(q,x)sqrt( (10.^x) .* (  logexp([q(1) q(2)],x) + logexp([q(3) q(4)],x)  ) );
g=[10 -0.1 4 0.9];
gy_log=dblogbinexp(g,chx_log);

cfc_log=nlinfit(chx_log,chy_log,dblogbinexp,g);
fy_log=dblogbinexp(cfc_log,chx_log);
fprintf('_________________________________________\n')
fprintf('Fit of closed dwell times:\n')
fprintf('   First exponential\tSecond exponential\n')
fprintf('     tau1 = %g ms\t   tau2 = %g ms\n',round(10^(cfc_log(2))*1000)/1000,round(10^(cfc_log(4))*1000)/1000)
fprintf('     alpha1 = %g\t   alpha2 = %g ms\n\n',round((cfc_log(1))*1000)/1000,round((cfc_log(3))*1000)/1000)
fprintf('-----------------------------------------\n')

f1=getfigH(1);
set(f1,'xscale','linear')
lH=line(chx_log,chy_log,'Parent',f1);
set(lH,'Marker','.','LineStyle','none','Color','k')
lH=line(csx_log,csy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','k')
% lH=line(hx_log,hyy_log,'Parent',f1);
% set(lH,'Marker','o','LineStyle','none','Color','b')
lH=line(chx_log,gy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','--','LineWidth',1,'Color',[.5 .5 .5])
lH=line(chx_log,fy_log,'Parent',f1);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')

% replotting in linear time
[chx,chy,csx,csy]=hekadat.HEKAhist(cdt,nbins,10^clogmin,10^clogmax);
doubleexpdecayfixedtau=@(q,x)((q(1)*exp(-(x)/10^(cfc_log(2)))))+((q(2)*exp(-(x)/10^(cfc_log(4)))));
cfc=nlinfit(chx(2:end),chy(2:end),doubleexpdecayfixedtau,[1000 157]);
cfy=doubleexpdecayfixedtau(cfc,chx);

f2=getfigH(2);
set(f2,'yscale','linear')
lH=line(chx,chy,'Parent',f2);
set(lH,'Marker','.','LineStyle','none','Color','k')
lH=line(csx,csy,'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','k')
lH=line(chx(2:end),cfy(2:end),'Parent',f2);
set(lH,'Marker','none','LineStyle','-','LineWidth',2,'Color','r')



%% Fitting in linear scale without x offset
[hx,hy]=hekadat.HEKAhist(odt,100,0,80);

expdecay=@(q,x)((q(1)*exp(-(x)/q(2)))); %without offset
g=[400 10];
gy=expdecay(g,hx);
fc=nlinfit(hx,hy,expdecay,g);
fy=expdecay(fc,hx);
disp(fc)
fprintf('fit tau = %g ms\n',round(fc(2)*100)/100)

plot(hx,hy,'k.--','LineWidth',1)
hold on
plot(hx,gy,'g:','LineWidth',1)
plot(hx,fy,'r-','LineWidth',2)
hold off
xlim([0 50])
%% Fitting in linear scale with x offset

[hx,hy]=hekadat.HEKAhist(odt,100,0,80);

expdecay=@(q,x)(q(1)+(q(2)*exp(-(x)/q(3)))); %with offset
g=[0 400 10];
gy=expdecay(g,hx);
fc=nlinfit(hx,hy,expdecay,g);
fy=expdecay(fc,hx);
disp(fc)
fprintf('fit tau = %g ms\n',round(fc(3)*100)/100)

plot(hx,hy,'k.--','LineWidth',1)
hold on
plot(hx,gy,'g:','LineWidth',1)
plot(hx,fy,'r-','LineWidth',2)
hold off
xlim([0 50])
%%
% f(x) = sqrt(10^x*(amp1^2*e^(1-10^x/10^logtau1)/10^logtau1))
% for a double component fit:
% f(x) = sqrt(10^x*(amp1^2*(e^(1-10^x/10^logtau1)/10^logtau1)+amp2^2*(e^(1-10^x/10^logtau2)/10^logtau2)))

%% Fitting in linear scale without x offset
[hx,hy]=hekadat.HEKAhist(odt,80,0.1,158.4893);

expdecay=@(q,x)((q*exp(-(x)/9.503))); %without offset
g=[400];
gy=expdecay(g,hx);
fc=nlinfit(hx(2:end),hy(2:end),expdecay,g);
fy=expdecay(fc,hx);
disp(fc)

plot(hx,hy,'k.--','LineWidth',1)
hold on
plot(hx,gy,'g:','LineWidth',1)
plot(hx,fy,'r-','LineWidth',2)
hold off
xlim([0 50])