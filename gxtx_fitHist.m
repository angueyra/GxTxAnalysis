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
          tableinput.headerWidth=72;
          hGUI.infoTable(tableinput);
          
          bw=.065;
          bh=0.08;
          bl=0.995-bw;
          
          pleft=.235;
          pwidth=.48;
          pheight=.42;
          ptop=.57;
          ptop2=.14;
          
          % Next and Previous Buttons
          nextBt=struct('Position',[bl pheight+.03 bw bh]);
          hGUI.nextButton(nextBt);
          prevBt=struct('Position',[bl pheight+.12 bw bh]);
          hGUI.prevButton(prevBt);
          % Save Button
          lockBt=struct('Position', [bl-.02 .03 bw+.02 bh],'String','Idealize&Save');
          hGUI.lockButton(lockBt);
          

          % Hist Sliders
          lSlide=struct('tag','leftSlider','Position',[pleft-.015 pheight+.05 pwidth+.03 .05]);
          lSlide.Min=-1;
          lSlide.Max=2;
          lSlide.Value=floor(lSlide.Min);
          lSlide.SliderStep=[1/1000 1/100];
          lSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(lSlide);
          
          rSlide=struct('tag','rightSlider','Position',[pleft-.015 pheight+.02 pwidth+.03 .05]);
          rSlide.Min=-1;
          rSlide.Max=2;
          rSlide.Value=floor(rSlide.Max);
          rSlide.SliderStep=[1/10000 1/100];
          rSlide.Callback=@hGUI.lSlideCall;
          hGUI.createSlider(rSlide);
          
          % Zoom button
          zBt=struct('tag','Zoom','Position',[pleft+pwidth+0.085 pheight+.03 .065 .08]);
          zBt.Callback=@hGUI.zoomCall;
          hGUI.createButton(zBt);
          
          % Unzoom button
          uzBt=struct('tag','Unzoom','Position',[pleft+pwidth+0.15 pheight+.03 .065 .08]);
          uzBt.Callback=@hGUI.unzoomCall;
          hGUI.createButton(uzBt);
          
          % Fit button
          blBt=struct('tag','Fit','Position',[pleft+pwidth+0.02 pheight+.03 .065 .08]);
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
          %c line
          lH=line([NaN NaN],[0 1],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','cLine')
          %o line
          lH=line([NaN NaN],[0 1],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','oLine')
          %hath line
          lH=line([NaN NaN],[0 1],'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','--','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','hathLine')
          
          % corrected Hist
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currHist')
          
          % All data Hist2ogram
          lH=line(hekadat.stairx,hekadat.stairy,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
          set(lH,'DisplayName','allHist')
          
          % closed fit
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .5 .5])
          set(lH,'DisplayName','cFit')
          % open fit
          lH=line(hnan,hnan,'Parent',hGUI.figData.plotHist);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.5 .5 1])
          set(lH,'DisplayName','oFit')
          
          
          % Current trace
          plotSub=struct('Position',[pleft ptop2 pwidth pheight-.11],'tag','plotSub');
          plotSub.XLim=[0 hekadat.stAxis(end)];
          plotSub.YLim=[-1 2];
          hGUI.makePlot(plotSub);
          hGUI.labelx(hGUI.figData.plotSub,'Time (s)');
          hGUI.labely(hGUI.figData.plotSub,'i (pA)');
          
          % Current wave
          lH=line(hGUI.hekadat.stAxis,NaN(1,size(hGUI.hekadat.HEKAbldata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',colors(params.PlotNow,:))
          set(lH,'DisplayName','currWave')
          % Idealied wave
          lH=line(hGUI.hekadat.stAxis,NaN(1,size(hGUI.hekadat.HEKAbldata,2)),'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',1,'MarkerSize',5,'Color',whithen(colors(params.PlotNow,:),0.5))
          set(lH,'DisplayName','iWave')
          
          % Wave Sliders
          wlSlide=struct('tag','wleftSlider','Position',[pleft-.015 .035 pwidth+.03 .05]);
          wlSlide.Min=1;
          wlSlide.Max=size(hekadat.HEKAbldata,2);
          wlSlide.Value=floor(wlSlide.Min);
          wlSlide.SliderStep=[1/1000 1/100];
          wlSlide.Callback=@hGUI.wSlideCall;
          hGUI.createSlider(wlSlide);
          
          wrSlide=struct('tag','wrightSlider','Position',[pleft-.015 .005 pwidth+.03 .05]);
          wrSlide.Min=1;
          wrSlide.Max=size(hekadat.HEKAbldata,2);
          wrSlide.Value=floor(wrSlide.Max);
          wrSlide.SliderStep=[1/10000 1/100];
          wrSlide.Callback=@hGUI.wSlideCall;
          hGUI.createSlider(wrSlide);
          
          % Wave Zoom button
          wzBt=struct('tag','wZoom','Position',[pleft+pwidth+0.02 .03 .065 .08]);
          wzBt.Callback=@hGUI.wzoomCall;
          hGUI.createButton(wzBt);
          
          % Wave Unzoom button
          wuzBt=struct('tag','wUnzoom','Position',[pleft+pwidth+0.085 .03 .065 .08]);
          wuzBt.Callback=@hGUI.wunzoomCall;
          hGUI.createButton(wuzBt);
          
          % Change line style buttons
          wlsBt=struct('tag','wlStyle','Position',[pleft+pwidth+0.085 .23 .065 .08]);
          wlsBt.String='w: . . .';
          wlsBt.Callback=@hGUI.wlStyleCall;
          hGUI.createButton(wlsBt);
          ilsBt=struct('tag','ilStyle','Position',[pleft+pwidth+0.02 .23 .065 .08]);
          ilsBt.String='i: . . .';
          ilsBt.Callback=@hGUI.ilStyleCall;
          hGUI.createButton(ilsBt);
          
          %left line
          lH=line([hGUI.hekadat.stAxis(wlSlide.Value) hGUI.hekadat.stAxis(wlSlide.Value)],plotSub.YLim,'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[1 .75 .75])
          set(lH,'DisplayName','wleftLine')
          %right line
          lH=line([hGUI.hekadat.stAxis(wrSlide.Value) hGUI.hekadat.stAxis(wrSlide.Value)],plotSub.YLim,'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','-','Marker','none','LineWidth',2,'MarkerSize',5,'Color',[.75 .75 1])
          set(lH,'DisplayName','wrightLine')
          
          %hath line
          lH=line([hGUI.hekadat.stAxis(1) hGUI.hekadat.stAxis(end)],[NaN NaN],'Parent',hGUI.figData.plotSub);
          set(lH,'LineStyle','--','Marker','none','LineWidth',1,'MarkerSize',5,'Color',[.75 .75 .75])
          set(lH,'DisplayName','hathLine2')
                    
          hGUI.fittingCall();
          hGUI.updatePlots();
        end
        
        function updatePlots(hGUI,~,~)
            Selected=get(hGUI.figData.infoTable,'Data');
            PlotNow=find(cell2mat(Selected(:,end)));
            hGUI.params.PlotNow=PlotNow;
            Rows=size(Selected,1);
            colors=pmkmp(Rows,'CubicL');
            % current wave
            currWaveName=hGUI.getRowName;
            currWavei=hGUI.hekadat.HEKAsnamefind(currWaveName);
            % current trace (baseline corrected)
            currWave=hGUI.hekadat.sdata(currWavei,:);
            lHNow=findobj('DisplayName','currWave');
            set(lHNow,'YData',currWave,'Color',colors(PlotNow,:))
            %idealized wave
            iWave=hGUI.hekadat.HEKAidealize(currWave,hGUI.params.hath).*hGUI.params.hist_o(1);
            lHNow=findobj('DisplayName','iWave');
            set(lHNow,'YData',iWave,'Color',[.4 .4 .4])%whithen(colors(PlotNow,:),0.5))
            % current histograms
            [currHistX,currHistY]=hGUI.calculateHist(currWave,hGUI.params.nbins,-1,2);
            hHNow=findobj('DisplayName','currHist');
            set(hHNow,'XData',currHistX,'YData',currHistY,'Color',colors(PlotNow,:))
            
            hGUI.refocusTable(PlotNow);
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
            o_hw1=find(hGUI.hekadat.histy(tg_ind+1:end)>o_peak/2,1,'first')+tg_ind; %half width
            o_hw2=find(hGUI.hekadat.histy(tg_ind+1:end)>o_peak/2,1,'last')+tg_ind; %half width
            
            gauss=@(b,x)(b(3).*normalize(normpdf(x,b(1),b(2))));
            c0=[0 0.1 c_peak];
            c_coeffs=nlinfit(hGUI.hekadat.histx(c_hw1:c_hw2),hGUI.hekadat.histy(c_hw1:c_hw2),gauss,c0);
            disp(c_coeffs)
            
            o0=[1.1 0.1 o_peak];
            o_coeffs=nlinfit(hGUI.hekadat.histx(o_hw1:o_hw2),hGUI.hekadat.histy(o_hw1:o_hw2),gauss,o0);
            
            lHNow=findobj('DisplayName','cFit');
            set(lHNow,'XData',hGUI.hekadat.histx,'YData',gauss(c_coeffs,hGUI.hekadat.histx))
            
            lHNow=findobj('DisplayName','oFit');
            set(lHNow,'XData',hGUI.hekadat.histx,'YData',gauss(o_coeffs,hGUI.hekadat.histx))
            
            % hist lines
            lHNow=findobj('DisplayName','cLine');
            set(lHNow,'XData',[c_coeffs(1) c_coeffs(1)])
            lHNow=findobj('DisplayName','oLine');
            set(lHNow,'XData',[o_coeffs(1) o_coeffs(1)])
            lHNow=findobj('DisplayName','hathLine');
            set(lHNow,'XData',[c_coeffs(1)+o_coeffs(1) c_coeffs(1)+o_coeffs(1)]/2)
            uistack(findobj('DisplayName','allHist'),'top')
            
            % plot lines
            lHNow=findobj('DisplayName','hathLine2');
            set(lHNow,'YData',[c_coeffs(1)+o_coeffs(1) c_coeffs(1)+o_coeffs(1)]/2)
            uistack(findobj('DisplayName','hathLine2'),'bottom')
            
            fprintf('i_c = %g \ni_o = %g\n',c_coeffs(1),o_coeffs(1))
            % save current coeffs
            hGUI.params.histfx=gauss;
            hGUI.params.hist_c=c_coeffs;
            hGUI.params.hist_o=o_coeffs;
            hGUI.params.hath=(hGUI.params.hist_c(1)+hGUI.params.hist_o(1))/2;
            hGUI.enableGui;
        end
        
        function lockButtonCall(hGUI,~,~)
            hGUI.disableGui;
            hGUI.hekadat.histfx=hGUI.params.histfx;
            hGUI.hekadat.hist_c=hGUI.params.hist_c;
            hGUI.hekadat.hist_o=hGUI.params.hist_o;
            hGUI.hekadat.hath=hGUI.params.hath;
            
            hGUI.hekadat.itAxis=hGUI.hekadat.stAxis;
            hGUI.hekadat.itags=hGUI.hekadat.stags;
            hGUI.hekadat.iwaveNames=hGUI.hekadat.swaveNames;
            hGUI.hekadat.idata=hGUI.hekadat.HEKAidealize(hGUI.hekadat.sdata,hGUI.hekadat.hath);
            
            hGUI.hekadat.HEKAsave();
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
        
        function wSlideCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.wleftSlider,'Value');
            rValue=get(hGUI.figData.wrightSlider,'Value');
            lTime=hGUI.hekadat.stAxis(ceil(lValue));
            rTime=hGUI.hekadat.stAxis(floor(rValue));
            
            lH=findobj('DisplayName','wleftLine');
            set(lH,'XData',[lTime lTime])
            rH=findobj('DisplayName','wrightLine');
            set(rH,'XData',[rTime rTime])
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
        
        function wzoomCall(hGUI,~,~)
            hGUI.disableGui;
            lValue=get(hGUI.figData.wleftSlider,'Value');
            rValue=get(hGUI.figData.wrightSlider,'Value');
            if lValue<rValue
                lTime=hGUI.hekadat.stAxis(ceil(lValue));
                rTime=hGUI.hekadat.stAxis(floor(rValue));
            else
                set(hGUI.figData.wleftSlider,'Value',rValue);
                set(hGUI.figData.wrightSlider,'Value',lValue);
                lTime=hGUI.hekadat.stAxis(ceil(rValue));
                rTime=hGUI.hekadat.stAxis(floor(lValue));
                lH=findobj('DisplayName','wleftLine');
                set(lH,'XData',[lTime lTime])
                rH=findobj('DisplayName','wrightLine');
                set(rH,'XData',[rTime rTime])
            end
            set(hGUI.figData.plotSub,'XLim',[lTime rTime])
            
            hGUI.enableGui;
        end
        
        function wunzoomCall(hGUI,~,~)
            hGUI.disableGui;
            
            lValue=get(hGUI.figData.wleftSlider,'Min');
            lTime=hGUI.hekadat.stAxis(ceil(lValue));
            set(hGUI.figData.wleftSlider,'Value',lValue);
            
            rValue=get(hGUI.figData.wrightSlider,'Max');
            rTime=hGUI.hekadat.stAxis(floor(rValue));
            set(hGUI.figData.wrightSlider,'Value',rValue);
            
            lH=findobj('DisplayName','wleftLine');
            set(lH,'XData',[lTime lTime])
            rH=findobj('DisplayName','wrightLine');
            set(rH,'XData',[rTime rTime])
            set(hGUI.figData.plotSub,'XLim',[lTime rTime])
            hGUI.enableGui;
        end
        
        function wlStyleCall(hGUI,~,~)
            hGUI.disableGui;
            lH=findobj('DisplayName','currWave');
            if strcmpi(get(lH,'Marker'),'none')
                set(lH,'Marker','.','MarkerSize',8);
            else
                set(lH,'Marker','none');
            end
            hGUI.enableGui;
        end
        function ilStyleCall(hGUI,~,~)
            hGUI.disableGui;
            lH=findobj('DisplayName','iWave');
            if strcmpi(get(lH,'Marker'),'none')
                set(lH,'Marker','.','MarkerSize',8);
            else
                set(lH,'Marker','none');
            end
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
           
           hGUI.unzoomCall();
           hGUI.wunzoomCall();
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
           hGUI.unzoomCall();
           hGUI.wunzoomCall();
           hGUI.updatePlots();
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
           hGUI.unzoomCall();
           hGUI.wunzoomCall();
           hGUI.updatePlots();
           hGUI.enableGui;
       end
    end
    
    methods (Static=true)
         
    end
end