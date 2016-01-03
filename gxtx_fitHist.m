classdef gxtx_fitHist<hekaGUI
    properties
    end
    
    methods
        % Constructor (gui objects and initial plotting)
        function hGUI=gxtx_fitHist(hekadat,params,fign) 
          params=checkStructField(params,'PlotNow',1);
          params=checkStructField(params,'LockNow',0);
          params=checkStructField(params,'nbins',400);
          hGUI@hekaGUI(hekadat,params,fign);
          
          % only plot ccc, coc and ooo
          Rows=size(hekadat.swaveNames,1);
          colors=pmkmp(Rows,'CubicL');
          tcolors=round(colors./1.2.*255);
          
          RowNames=cell(size(Rows));
          for i=1:Rows
              RowNames{i}=sprintf('<html><font color=rgb(%d,%d,%d)>%s</font></html>',tcolors(i,1),tcolors(i,2),tcolors(i,3),hekadat.swaveNames{i});
          end
          
          % info Table
          Selected=false(Rows,1);         
          Selected(params.PlotNow,end)=true;
          infoData=[hGUI.hekadat.stags num2cell(hekadat.sBaseline) num2cell(Selected)];
          
          tableinput=struct;
          tableinput.Position=[0.01, .005, 0.185, .985];
          tableinput.FontSize=10;
          tableinput.ColumnWidth={40};
          tableinput.Data=infoData;
          tableinput.ColumnName={'tag','bline','P'};
          tableinput.RowName=RowNames;
          tableinput.headerWidth=63;
          hGUI.infoTable(tableinput);
          
          bw=.065;
          bh=0.08;
          bl=0.995-bw;
          
          pleft=.235;
          pwidth=.48;
          pheight=.43;
          ptop=.555;
          ptop2=.08;
          hleft=.735;
          hwidth=.17;
          
          % Next and Previous Buttons
          nextBt=struct('Position',[bl pheight bw bh]);
          hGUI.nextButton(nextBt);
          prevBt=struct('Position',[bl pheight+.1 bw bh]);
          hGUI.prevButton(prevBt);
          
          lockBt=struct('Position', [bl .03 bw bh]);
          hGUI.lockButton(lockBt);
          

          % Sliders
          lSlide=struct('tag','leftSlider','Position',[pleft-.015 .45 pwidth+.03 .05]);
          lSlide.Min=-1;
          lSlide.Max=2;
          lSlide.Value=floor(lSlide.Min);
          lSlide.SliderStep=[1/1000 1/100];
          lSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(lSlide);
          
          rSlide=struct('tag','rightSlider','Position',[pleft-.015 .42 pwidth+.03 .05]);
          rSlide.Min=-1;
          rSlide.Max=2;
          rSlide.Value=floor(rSlide.Max);
          rSlide.SliderStep=[1/10000 1/100];
          rSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(rSlide);
          
          % Zoom button
          zBt=struct('tag','Zoom','Position',[pleft+pwidth+0.085 pheight .065 .08]);
          zBt.Callback=@hGUI.zoomCall;
          hGUI.createButton(zBt);
          
          % Unzoom button
          uzBt=struct('tag','Unzoom','Position',[pleft+pwidth+0.15 pheight .065 .08]);
          uzBt.Callback=@hGUI.unzoomCall;
          hGUI.createButton(uzBt);
          
          % Fit button
          blBt=struct('tag','Fit','Position',[pleft+pwidth+0.02 pheight .065 .08]);
          blBt.Callback=@hGUI.fittingCall;
          hGUI.createButton(blBt);
          
          
          hnan=NaN(1,50);
          
          % Histograms and fits
          plotHist=struct('Position',[pleft ptop pwidth pheight],'tag','plotHist');
          plotHist.YLim=[0 .08];
          plotHist.XLim=[-1 2];
          hGUI.makePlot(plotHist);
          hGUI.labelx(hGUI.figData.plotHist,'i (pA)');
          hGUI.labely(hGUI.figData.plotHist,'Freq');
          
          %left line
          lH=line([lSlide.Value lSlide.Value],plotHist.YLim,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .75 .75])
          set(lH,'DisplayName','leftLine')
          %right line
          lH=line([rSlide.Value rSlide.Value],plotHist.YLim,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 1])
          set(lH,'DisplayName','rightLine')
          %zero line
          lH=line([0 0],[0 1],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLine')
          
          % corrected Hist
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currHist')
          
          % All data Hist2ogram
          lH=line(hekadat.stairx,hekadat.stairy,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
          set(lH,'DisplayName','allHist')
          
          
          plotSub=struct('Position',[pleft ptop2 pwidth pheight-.11],'tag','plotSub');
          plotSub.XLim=[0 hekadat.stAxis(end)];
          plotSub.YLim=[-1 2];
          hGUI.makePlot(plotSub);
          hGUI.labelx(hGUI.figData.plotSub,'Time (s)');
          hGUI.labely(hGUI.figData.plotSub,'i (pA)');
          
          % refined trace
          lH=line(hGUI.hekadat.stAxis,NaN(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          
          %zero line
          lH=line(hGUI.hekadat.stAxis,zeros(1,size(hGUI.hekadat.sdata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','zeroLineCurr')
          
          hGUI.updatePlots();
%           if params.LockNow
%               hGUI.lockButtonCall();
%           end
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            hGUI.params.PlotNow=PlotNow;
            
            % current wave
            currWave=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAsnamefind(currWave);
            
            Rows=size(Selected,1);
            colors=pmkmp(Rows,'CubicL');
            
            % current trace
            currentTrace=hGUI.hekadat.sdata(currWavei,:)-hGUI.hekadat.sBaseline(currWavei);
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',currentTrace,'Color',colors(PlotNow,:))
            
            
            
            % current histograms
            [currHistX,currHistY]=hGUI.calculateHist(currentTrace,hGUI.params.nbins,-1,2);
            hHNow=findobj('DisplayName','currHist');
            set(hHNow,'XData',currHistX,'YData',currHistY,'Color',colors(PlotNow,:))
            
%             % after baseline correction
%             baseline=Selected{PlotNow,2};
%             lHNow=findobj('DisplayName','subWave');
%             set(lHNow,'YData',currentTrace-baseline,'Color',colors(PlotNow,:))
%             
%             [currHistX,currHistY]=hGUI.calculateHist(currentTrace-baseline,hGUI.params.nbins,-1,2);
%             hHNow=findobj('DisplayName','subHist');
%             set(hHNow,'XData',currHistY,'YData',currHistX,'Color',colors(PlotNow,:))
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            Selected=get(hGUI.figData.infoTable,'Data');
            
            hGUI.hekadat.HEKAsave();
            hGUI.enableGui;
        end
        
        function fittingCall(hGUI,~,~)
            hGUI.disableGui;
            tg=1.1/2; %threshold guess
            tg_ind=find(hGUI.hekadat.histx<tg,1,'last');
            c_peak=max(hGUI.hekadat.histy(1:tg_ind));
            c_i=find(hGUI.hekadat.histy==c_peak);
            c_hw1=find(hGUI.hekadat.histy(1:tg_ind)>c_peak/2,1,'first'); %half width
            c_hw2=find(hGUI.hekadat.histy(1:tg_ind)>c_peak/2,1,'last'); %half width
            o_peak=max(hGUI.hekadat.histy(tg_ind+1:end));
            o_i=find(hGUI.hekadat.histy==o_peak);
            o_hw1=find(hGUI.hekadat.histy(tg_ind+1:end)>o_peak/2,1,'first'); %half width
            o_hw2=find(hGUI.hekadat.histy(tg_ind+1:end)>o_peak/2,1,'last'); %half width
            
            clsq.objective=@(beta,x)(1/sqrt(2*pi*beta(2)^2)).*(exp(-((x-beta(1)).^2)./(2*beta(2)^2)));;
            clsq.x0=[0 0.1];
            clsq.xdata=hGUI.hekadat.histx(1:tg_ind);
            clsq.ydata=hGUI.hekadat.histx(1:tg_ind);
            clsq.lb=[];
            clsq.ub=[];
            clsq.solver='lsqcurvefit';
            clsq.options=optimset('TolX',1e-20,'TolFun',1e-20,'MaxFunEvals',1000);
            
            c_fitcoeffs=lsqcurvefit(clsq);
            disp(c_fitcoeffs);
            
            hGUI.enableGui;
        end
        
        function lSlideCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Value');
            rValue=get(hGUI.figData.rightSlider,'Value');
%             li=hGUI.hekadat.histx(ceil(lValue));
%             ri=hGUI.hekadat.histy(floor(rValue));
            
            lH=findobj('DisplayName','leftLine');
            set(lH,'XData',[lValue lValue])
            rH=findobj('DisplayName','rightLine');
            set(rH,'XData',[rValue rValue])
            hGUI.enableGui;
        end
        
        function zoomCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.leftSlider,'Value');
            rValue=get(hGUI.figData.rightSlider,'Value');
            if lValue>rValue
                set(hGUI.figData.leftSlider,'Value',rValue);
                set(hGUI.figData.rightSlider,'Value',lValue);
                lH=findobj('DisplayName','leftLine');
                set(lH,'XData',[rValue rValue])
                rH=findobj('DisplayName','rightLine');
                set(rH,'XData',[lValue lValue])
            end
            set(hGUI.figData.plotHist,'XLim',[lValue rValue])
            
            hGUI.enableGui;
        end
        
        function unzoomCall(hGUI,~,~)
            hGUI.disableGui;
            
            lValue=get(hGUI.figData.leftSlider,'Min');
            set(hGUI.figData.leftSlider,'Value',lValue);
            
            rValue=get(hGUI.figData.rightSlider,'Max');
            set(hGUI.figData.rightSlider,'Value',rValue);
            
            lH=findobj('DisplayName','leftLine');
            set(lH,'XData',[lValue lValue])
            rH=findobj('DisplayName','rightLine');
            set(rH,'XData',[rValue rValue])
            set(hGUI.figData.plotHist,'XLim',[lValue rValue])
            hGUI.enableGui;
        end
        
        function updateTable(hGUI,~,eventdata)
           hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Plotted=find(cell2mat(Selected(:,end)));
           Previous=Plotted(Plotted~=eventdata.Indices(1));
           Plotted=Plotted(Plotted==eventdata.Indices(1));
           
           Selected{Previous,end}=false;
           Selected{Plotted,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.5);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Previous});
           set(curt,'Color',colors(Previous,:),'LineWidth',1)
           
           updatePlots(hGUI);
           hGUI.enableGui;
        end
       
        function nextButtonCall(hGUI,~,~)
           hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Current=find(cell2mat(Selected(:,end)));
           PlotNext=Current+1;
           if PlotNext>size(Selected,1)
               PlotNext=1;
           end
           Selected{Current,end}=false;
           Selected{PlotNext,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.6);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Current});
           set(curt,'Color',colors(Current,:),'LineWidth',1)
           hGUI.updatePlots();
           hGUI.unzoomCall();
           hGUI.enableGui;
       end
       
       function prevButtonCall(hGUI,~,~)
           hGUI.disableGui;
           Selected=get(hGUI.figData.infoTable,'Data');
           Previous=find(cell2mat(Selected(:,end)));
           PlotNext=Previous-1;
           if PlotNext<1
               PlotNext=size(Selected,1);
           end
           Selected{Previous,end}=false;
           Selected{PlotNext,end}=true;
           set(hGUI.figData.infoTable,'Data',Selected)
           
           Rows=size(hGUI.hekadat.waveNames,1);
           colors=whithen(pmkmp(Rows,'CubicL'),0.6);
           curt=findobj('DisplayName',hGUI.hekadat.waveNames{Previous});
           set(curt,'Color',colors(Previous,:),'LineWidth',1)
           hGUI.updatePlots();
           hGUI.unzoomCall();
           hGUI.enableGui;
       end
    end
    
    methods (Static=true)
         
    end
end