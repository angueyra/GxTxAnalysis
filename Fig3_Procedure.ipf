#pragma rtGlobals=1		// Use modern global access method.
#include  <Append Calibrator>
function loader()
	loada1()
	loada2()
	loada3()
	loadb1()
	loadb2()
	loadb3()
	loadc()
	loadd1()
	loadd2()
	loadd3()
	loade()
	loadf1()
	loadf2()
	loadf3()
	loadg()
	loadh()
	revlogticks()
//	TileGraphs()
end

function loada1()
	loadfx("a1_ict")
	SetAxis left -11,2.5
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
	Execute("MakeScaleBarsRT(.20, .15, 1.6, 3.1,\"\", \"\",2)")
end
function loada2()
	loadfx("a2_ino")
	SetAxis left -11,2.5
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end
function loada3()
	loadfx("a3_igx")
	SetAxis left -11,2.5
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end

function loadb1()
	loadfx("b1_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces CtFit_Y,{Ct_Y}
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(Gx_Y)=1
	ModifyGraph hideTrace(No_Y)=1,hideTrace(NoFit_Y)=1
	Label left ""
	HideBottom()
end
function loadb2()
	loadfx("b2_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces NoFit_Y,{No_Y}
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(Gx_Y)=1
	ModifyGraph hideTrace(Ct_Y)=1,hideTrace(CtFit_Y)=1
	Label left ""
	HideBottom()
end
function loadb3()
	loadfx("b3_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces GxFit_Y,{Gx_Y}
	ModifyGraph hideTrace(CtFit_Y)=1,hideTrace(Ct_Y)=1
	ModifyGraph hideTrace(No_Y)=1,hideTrace(NoFit_Y)=1
	Label left ""
end

function loadc()
	loadfx("c_tflat")
	ModifyGraph log(left)=1
	SetAxis left 1,50
	FormatPop()
end

function loadd1()
	loadfx("d1_odtct")
	SetAxis left 0,8
	SetAxis bottom -0.5,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end
function loadd2()
	loadfx("d2_odtno")
	SetAxis left 0,10
	SetAxis bottom -0.5,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end
function loadd3()
	loadfx("d3_odtgx")
	SetAxis left 0,16
	SetAxis bottom -0.5,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end

function loade()
	loadfx("e_todt")
	ModifyGraph log(left)=1
	SetAxis left 1,20
	FormatPop()
end

function loadf1()
	loadfx("f1_cdtct")
	SetAxis left 0,12
	SetAxis bottom -0.5,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end
function loadf2()
	loadfx("f2_cdtno")
	SetAxis left 0,16
	SetAxis bottom -0.5,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end
function loadf3()
	loadfx("f3_cdtgx")
	SetAxis left 0,25
	SetAxis bottom -0.1,2.7
	Label left "sqrt[log(n)]"
//	Label left "Ã [log(n)]"
end

function loadg()
	loadfx("g_tcdt")
	ModifyGraph log(left)=1
	SetAxis left 0.5,50
	ModifyGraph useMrkStrokeRGB(Ct1_Y)=1,mrkStrokeRGB(Ct1_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx1_Y)=1, mrkStrokeRGB(Gx1_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No1_Y)=1,mrkStrokeRGB(No1_Y)=(0,0,65535)
	ModifyGraph useMrkStrokeRGB(Ct2_Y)=1,mrkStrokeRGB(Ct2_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx2_Y)=1, mrkStrokeRGB(Gx2_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No2_Y)=1,mrkStrokeRGB(No2_Y)=(0,0,65535)
	ModifyGraph useMrkStrokeRGB(Gx3_Y)=1, mrkStrokeRGB(Gx3_Y)=(65535,0,0)
	SetAxis bottom 0.5,3.5
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
end

function loadh()
	loadfx("h_longcdt")
	SetAxis left 0,0.5
	FormatPop()
end

function revlogticks()
Make/O/T oLabels={"0.1","","","","","","","","","1","","","","","","","","","10","","","","","","","","","100","","","","","","","","","1000"}
Make/O oLocs={0.1,.2,.3,.4,.5,.6,.7,.8,.9,1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000}
oLocs=log(oLocs)
ModifyGraph /W=d1_odtct userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=d2_odtno userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=d3_odtgx userticks(bottom)={oLocs,oLabels}

ModifyGraph /W=f1_cdtct userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=f2_cdtno userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=f3_cdtgx userticks(bottom)={oLocs,oLabels}
end

function revlogticks2()
Make/O/T oLabels={"0.1","1","10","100","1000"}
Make/O oLocs
oLocs=log(str2num(oLabels))
ModifyGraph /W=j_odtno userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=k_odtgx userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=m_cdtno userticks(bottom)={oLocs,oLabels}
ModifyGraph /W=n_cdtgx userticks(bottom)={oLocs,oLabels}
end


function loadfx(h5name)
string h5name
variable h5file
string h5path="HD:Users:angueyraaristjm:hdf5:GxTx:Fig3:" +h5name+".h5"
if (WinType(h5name)==1)
	KillWindow $h5name
endif
KillDataFolder/Z root:$h5name
NewDataFolder/o/s root:$h5name
HDF5OpenFile h5file as h5path
HDF5LoadGroup :,h5file , h5name
HDF5CloseFile h5file
DisplayFigFromMatlab(h5name,1)
FormatGraph()
Legend/K/N=text0
SetDataFolder root:
DoWindow/C/R $h5name
MoveWindow/W=$h5name 20,20,400,250
end

Window layfx() : Layout
	PauseUpdate; Silent 1
	string LayoutName="layfx" //make layout name same as window function name
	if (WinType(LayoutName)==3)
		KillWindow $LayoutName
	endif
	Layout/C=1/W=(0,44,900,650) as LayoutName
	
	
	
	Append a1_ict/O=1/F=0/T
	Append a2_ino/O=1/F=0/T
	Append a3_igx/O=1/F=0/T
	Append b1_flat/O=1/F=0/T
	Append b2_flat/O=1/F=0/T
	Append b3_flat/O=1/F=0/T
	Append c_tflat/O=1/F=0/T
	Append d1_odtct/O=1/F=0/T
	Append d2_odtno/O=1/F=0/T
	Append d3_odtgx/O=1/F=0/T
	Append e_todt/O=1/F=0/T
	Append f1_cdtct/O=1/F=0/T
	Append f2_cdtno/O=1/F=0/T
	Append f3_cdtgx/O=1/F=0/T
	Append g_tcdt/O=1/F=0/T
	Append h_longcdt/O=1/F=0/T

	
	variable rawL=40
	variable rawT=60
	variable rawW=980
	variable rawH=200
	ModifyLayout left(a1_ict)=rawL,top(a1_ict)=rawT+(rawH*0),width(a1_ict)=rawW,height(a1_ict)=rawH
	ModifyLayout left(a2_ino)=rawL,top(a2_ino)=rawT+(rawH*1),width(a2_ino)=rawW,height(a2_ino)=rawH
	ModifyLayout left(a3_igx)=rawL,top(a3_igx)=rawT+(rawH*2),width(a3_igx)=rawW,height(a3_igx)=rawH
	
	variable popW = 125
	variable popH = 300
	variable popL = rawW-popW+50
	variable flatL=rawL+15
	variable flatT=rawT+(rawH*3)+25
	variable flatW=rawW-popW-25
	variable flatH=120
	ModifyLayout left(b1_flat)=flatL,top(b1_flat)=flatT+(flatH*0*2/3),width(b1_flat)=flatW,height(b1_flat)=flatH
	ModifyLayout left(b2_flat)=flatL,top(b2_flat)=flatT+(flatH*1*2/3),width(b2_flat)=flatW,height(b2_flat)=flatH
	ModifyLayout left(b3_flat)=flatL,top(b3_flat)=flatT+(flatH*2*2/3),width(b3_flat)=flatW,height(b3_flat)=flatH
	ModifyLayout left(c_tflat)=popL,top(c_tflat)=flatT,width(c_tflat)=popW,height(c_tflat)=popH
	
	variable odtL=flatL
	variable odtT=flatT+(flatH*3*2/3)+80
	variable odtW=310
	variable odtH=150
	ModifyLayout left(d1_odtct)=odtL,top(d1_odtct)=odtT+(odtH*0),width(d1_odtct)=odtW,height(d1_odtct)=odtH
	ModifyLayout left(d2_odtno)=odtL,top(d2_odtno)=odtT+(odtH*1),width(d2_odtno)=odtW,height(d2_odtno)=odtH
	ModifyLayout left(d3_odtgx)=odtL,top(d3_odtgx)=odtT+(odtH*2),width(d3_odtgx)=odtW,height(d3_odtgx)=odtH

	variable todtL=odtL+odtW
	variable todtT=odtT+100
	ModifyLayout left(e_todt)=todtL,top(e_todt)=todtT,width(e_todt)=popW,height(e_todt)=popH
	
	variable cdtL=todtL+popW
	ModifyLayout left(f1_cdtct)=cdtL,top(f1_cdtct)=odtT+(odtH*0),width(f1_cdtct)=odtW,height(f1_cdtct)=odtH
	ModifyLayout left(f2_cdtno)=cdtL,top(f2_cdtno)=odtT+(odtH*1),width(f2_cdtno)=odtW,height(f2_cdtno)=odtH
	ModifyLayout left(f3_cdtgx)=cdtL,top(f3_cdtgx)=odtT+(odtH*2),width(f3_cdtgx)=odtW,height(f3_cdtgx)=odtH
	
	variable tcdtL=cdtL+odtW
	ModifyLayout left(g_tcdt)=tcdtL,top(g_tcdt)=todtT,width(g_tcdt)=popW,height(g_tcdt)=popH
	ModifyLayout left(h_longcdt)=tcdtL+popW,top(h_longcdt)=todtT,width(h_longcdt)=popW,height(h_longcdt)=popH

	TextBox/C/N=text1/O=90/F=0/S=1/A=LB/X=4.33/Y=45.39 "Cumulative Probability"
	
	TextBox/C/N=text2/F=0/S=1/A=LB/X=28.32/Y=95.20 "1.5 pA"
	TextBox/C/N=text3/F=0/S=1/A=LB/X=34.81/Y=95.01 "50 ms"
	
	ModifyLayout mag=.5, units=0
EndMacro



function FormatGraph()
	ModifyGraph font="Helvetica"//,fSize=18,
	ModifyGraph margin(left)=40,margin(bottom)=40,margin(top)=18,margin(right)=18
End

function FormatPop()
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No_Y)=1,mrkStrokeRGB(No_Y)=(0,0,65535)
	SetAxis bottom 0.5,3.5
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
end