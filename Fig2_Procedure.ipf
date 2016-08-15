#pragma rtGlobals=1		// Use modern global access method.
#include  <Append Calibrator>
function loader()
	loada()
	loadb1()
	loadb2()
	loadb3()
	loadc()
	loadd1()
	loadd2()
	loadd3()
	loade()
	loadf()
	loadg1()
	loadg2()
	loadg3()
	loadh()
	loadi()
//	TileGraphs()
end

function loada()
	loadfx("a_stim")
	SetAxis bottom 0,0.84
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end

function loadb1()
	loadfx("b1_rawCt")
	SetAxis left -12,2
	SetAxis bottom 0,0.84
	FormatCal()
	ModifyGraph lsize=1
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end
function loadb2()
	loadfx("b2_rawNo")
	SetAxis left -12,2
	SetAxis bottom 0,0.84
	FormatCal()
	ModifyGraph lsize=1
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end
function loadb3()
	loadfx("b3_rawGx")
	SetAxis left -12,2
	SetAxis bottom 0,0.84
	FormatCal()
	ModifyGraph lsize=1
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
//	Execute("MakeScaleBarsRT(.05, .025, .8, 2.8,\"\", \"\",2)")
	Execute("MakeScaleBarsRT(.05, .025, 2.6, 0.6,\"\", \"\",2)")
end

function loadc()
	loadfx("c_fbound")
	ModifyGraph nticks(bottom)=5;
	SetAxis bottom 0.5,2.5
	SetAxis left 0,1
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	Make/O sfTags={1,2}
	Make/O/T sfLabels={"Control","+GxTx"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
//	ModifyGraph margin(left)=60
end

function loadd1()
	loadfx("d1_averagei")
	SetAxis bottom 0,0.5
	SetAxis left 0,1.4
	ModifyGraph hideTrace(Gx_Y)=1,hideTrace(No_Y)=1
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(NoFit_Y)=1
	ReorderTraces CtFit_Y,{Ct_Y}
	FormatCal()
end
function loadd2()
	loadfx("d2_averagei")
	SetAxis bottom 0,0.5
	SetAxis left 0,1.4
	ModifyGraph hideTrace(Gx_Y)=1,hideTrace(Ct_Y)=1
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(CtFit_Y)=1
	ReorderTraces NoFit_Y,{No_Y}
	FormatCal()
end
function loadd3()
	loadfx("d3_averagei")
	SetAxis bottom 0,0.5
	SetAxis left 0,1.4
	ModifyGraph hideTrace(Ct_Y)=1,hideTrace(No_Y)=1
	ModifyGraph hideTrace(CtFit_Y)=1,hideTrace(NoFit_Y)=1
	ReorderTraces GxFit_Y,{Gx_Y}
	HideLeft()
	Execute("MakeScaleBarsRT(-.01, -.01, 0, 1,\"\", \"\",2)")
end

function loade()
	loadfx("e_tactivation")
	ModifyGraph nticks(bottom)=5
	SetAxis bottom 0.5,3.5
	ModifyGraph log(left)=1
	SetAxis left 1,50
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No_Y)=1,mrkStrokeRGB(No_Y)=(0,0,65535)
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
//	ModifyGraph margin(left)=60
end

function loadf()
	loadfx("f_ssi")
	ModifyGraph nticks(bottom)=5
	SetAxis bottom 0.5,3.5
	SetAxis left 0,1.4
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No_Y)=1,mrkStrokeRGB(No_Y)=(0,0,65535)
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
//	ModifyGraph margin(left)=60
end

function loadg1()
	loadfx("g1_hCt")
	ModifyGraph lsize=2
	ModifyGraph lowTrip(left)=0.01
	ModifyGraph nticks(left)=4
	SetAxis left 0,0.03
	SetAxis bottom -1,2
	HideBottom()
	ModifyGraph margin(bottom)=40,margin(top)=18,margin(right)=18
	ModifyGraph margin(left)=45
end
function loadg2()
	loadfx("g2_hNo")
	ModifyGraph lsize=2
	ModifyGraph lowTrip(left)=0.01
	ModifyGraph nticks(left)=4
	SetAxis left 0,0.03
	SetAxis bottom -1,2
	HideBottom()
	ModifyGraph margin(bottom)=40,margin(top)=18,margin(right)=18
	ModifyGraph margin(left)=45
end
function loadg3()
	loadfx("g3_hGx")
	ModifyGraph lsize=2
	ModifyGraph lowTrip(left)=0.01
	ModifyGraph nticks(left)=4
	SetAxis left 0,0.03
	SetAxis bottom -1,2
	ModifyGraph margin(bottom)=40,margin(top)=18,margin(right)=18
	ModifyGraph margin(left)=45
end

function loadh()
	loadfx("h_sci")
	ModifyGraph nticks(bottom)=5
	SetAxis bottom 0.5,3.5
	SetAxis left 0,1.6
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No_Y)=1,mrkStrokeRGB(No_Y)=(0,0,65535)
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
//	ModifyGraph margin(left)=60
end

function loadi()
	loadfx("i_popen")
	ModifyGraph nticks(bottom)=5
	SetAxis bottom 0.5,3.5
	SetAxis left 0,1
	ModifyGraph useMrkStrokeRGB(Ct_Y)=1,mrkStrokeRGB(Ct_Y)=(19661,19661,19661)
	ModifyGraph useMrkStrokeRGB(Gx_Y)=1, mrkStrokeRGB(Gx_Y)=(65535,0,0)
	ModifyGraph useMrkStrokeRGB(No_Y)=1,mrkStrokeRGB(No_Y)=(0,0,65535)
	Make/O sfTags={1,2,3}
	Make/O/T sfLabels={"Control","Free","Bound"}
	ModifyGraph userticks(bottom)={sfTags,sfLabels}
	ModifyGraph axThick(bottom)=0
	ModifyGraph tkLblRot(bottom)=90
	ModifyGraph margin(bottom)=60
//	ModifyGraph margin(left)=60
end


function loadfx(h5name)
string h5name
variable h5file
string h5path="HD:Users:angueyraaristjm:hdf5:GxTx:Fig2:" +h5name+".h5"
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
	
	Append a_stim/O=1/F=0/T
	Append b1_rawCt/O=1/F=0/T
	Append b2_rawNo/O=1/F=0/T
	Append b3_rawGx/O=1/F=0/T
	Append c_fbound/O=1/F=0/T
	Append d1_averagei/O=1/F=0/T
	Append d2_averagei/O=1/F=0/T
	Append d3_averagei/O=1/F=0/T
	Append e_tactivation/O=1/F=0/T
	Append f_ssi/O=1/F=0/T
	Append g1_hCt/O=1/F=0/T
	Append g2_hNo/O=1/F=0/T
	Append g3_hGx/O=1/F=0/T
	Append h_sci/O=1/F=0/T
	Append i_popen/O=1/F=0/T
	
	variable rawL=40
	variable rawW=980
	variable rawH=200
	ModifyLayout left(a_stim)=rawL,top(a_stim)=40,width(a_stim)=rawW,height(a_stim)=120
	ModifyLayout left(b1_rawCt)=rawL,top(b1_rawCt)=190,width(b1_rawCt)=rawW,height(b1_rawCt)=rawH
	ModifyLayout left(b2_rawNo)=rawL,top(b2_rawNo)=190+(rawH*1.01),width(b2_rawNo)=rawW,height(b2_rawNo)=rawH
	ModifyLayout left(b3_rawGx)=rawL,top(b3_rawGx)=190+(rawH*2.02),width(b3_rawGx)=rawW,height(b3_rawGx)=rawH
	
	variable popT = 820
	variable popW = 100
	variable popH = 300
	ModifyLayout left(c_fbound)=rawL,top(c_fbound)=popT,width(c_fbound)=popW,height(c_fbound)=popH
	
	variable exW = 200
	variable exH = 120
	variable exL = rawL+(popW*.8)
	ModifyLayout left(d1_averagei)=exL,top(d1_averagei)=popT,width(d1_averagei)=exW,height(d1_averagei)=exH
	ModifyLayout left(d2_averagei)=exL,top(d2_averagei)=popT+80,width(d2_averagei)=exW,height(d2_averagei)=exH
	ModifyLayout left(d3_averagei)=exL,top(d3_averagei)=popT+160,width(d3_averagei)=exW,height(d3_averagei)=exH
	
	variable pop2L = exL+exW
	variable pop2W = 125
	ModifyLayout left(e_tactivation)=pop2L,top(e_tactivation)=popT,width(e_tactivation)=pop2W,height(e_tactivation)=popH
	ModifyLayout left(f_ssi)=pop2L+pop2W,top(f_ssi)=popT,width(f_ssi)=pop2W,height(f_ssi)=popH
	ModifyLayout left(g1_hCt)=pop2L+pop2W*2,top(g1_hCt)=popT,width(g1_hCt)=exW,height(g1_hCt)=exH
	ModifyLayout left(g2_hNo)=pop2L+pop2W*2,top(g2_hNo)=popT+80,width(g2_hNo)=exW,height(g2_hNo)=exH
	ModifyLayout left(g3_hGx)=pop2L+pop2W*2,top(g3_hGx)=popT+160,width(g3_hGx)=exW,height(g3_hGx)=exH
	
	variable pop3L = pop2L+pop2W*2+exW
	ModifyLayout left(h_sci)=pop3L,top(h_sci)=popT,width(h_sci)=pop2W,height(h_sci)=popH
	ModifyLayout left(i_popen)=pop3L+pop2W,top(i_popen)=popT,width(i_popen)=pop2W,height(i_popen)=popH
	
	TextBox/C/N=text2/F=0/S=1/A=LB/X=4.80/Y=61.25 "2 pA"
	TextBox/C/N=text3/F=0/S=1/A=LB/X=7.06/Y=62.64 "25 ms"
	
	ModifyLayout mag=.5, units=0
EndMacro

Window layfxalt() : Layout
	PauseUpdate; Silent 1
	string LayoutName="layfxalt" //make layout name same as window function name
	if (WinType(LayoutName)==3)
		KillWindow $LayoutName
	endif
	Layout/C=1/W=(0,44,900,650) as LayoutName
	
	Append a_stim/O=1/F=0/T
	Append b1_rawCt/O=1/F=0/T
	Append b2_rawNo/O=1/F=0/T
	Append b3_rawGx/O=1/F=0/T
	Append c_fbound/O=1/F=0/T
	Append d1_averagei/O=1/F=0/T
	Append d2_averagei/O=1/F=0/T
	Append d3_averagei/O=1/F=0/T
	Append e_tactivation/O=1/F=0/T
	Append f_ssi/O=1/F=0/T
	Append g1_hCt/O=1/F=0/T
	Append g2_hNo/O=1/F=0/T
	Append g3_hGx/O=1/F=0/T
	Append h_sci/O=1/F=0/T
	Append i_popen/O=1/F=0/T
	
	variable rawL=40
	variable rawW=980
	variable rawH=200
	ModifyLayout left(a_stim)=rawL,top(a_stim)=40,width(a_stim)=rawW,height(a_stim)=120
	ModifyLayout left(b1_rawCt)=rawL,top(b1_rawCt)=190,width(b1_rawCt)=rawW,height(b1_rawCt)=rawH
	ModifyLayout left(b2_rawNo)=rawL,top(b2_rawNo)=190+(rawH*1.01),width(b2_rawNo)=rawW,height(b2_rawNo)=rawH
	ModifyLayout left(b3_rawGx)=rawL,top(b3_rawGx)=190+(rawH*2.02),width(b3_rawGx)=rawW,height(b3_rawGx)=rawH
	
	variable popT = 820
	variable popW = 180
	variable popH = 300
	ModifyLayout left(c_fbound)=rawL,top(c_fbound)=popT,width(c_fbound)=popW,height(c_fbound)=popH
	
	variable exW = 320
	variable exH = 120
	variable exL = 200
	ModifyLayout left(d1_averagei)=exL,top(d1_averagei)=popT,width(d1_averagei)=exW,height(d1_averagei)=exH
	ModifyLayout left(d2_averagei)=exL,top(d2_averagei)=popT+80,width(d2_averagei)=exW,height(d2_averagei)=exH
	ModifyLayout left(d3_averagei)=exL,top(d3_averagei)=popT+160,width(d3_averagei)=exW,height(d3_averagei)=exH
	
	variable pop2W = 250
	ModifyLayout left(e_tactivation)=550,top(e_tactivation)=popT,width(e_tactivation)=pop2W,height(e_tactivation)=popH
	ModifyLayout left(f_ssi)=800,top(f_ssi)=popT,width(f_ssi)=pop2W,height(f_ssi)=popH

	variable pop2T = 1150
	ModifyLayout left(g1_hCt)=exL,top(g1_hCt)=pop2T,width(g1_hCt)=exW,height(g1_hCt)=exH
	ModifyLayout left(g2_hNo)=exL,top(g2_hNo)=pop2T+80,width(g2_hNo)=exW,height(g2_hNo)=exH
	ModifyLayout left(g3_hGx)=exL,top(g3_hGx)=pop2T+160,width(g3_hGx)=exW,height(g3_hGx)=exH
	
	ModifyLayout left(h_sci)=550,top(h_sci)=pop2T,width(h_sci)=pop2W,height(h_sci)=popH
	ModifyLayout left(i_popen)=800,top(i_popen)=pop2T,width(i_popen)=pop2W,height(i_popen)=popH
	
	TextBox/C/N=text2/F=0/S=1/A=LB/X=4.80/Y=61.25 "2 pA"
	TextBox/C/N=text3/F=0/S=1/A=LB/X=7.06/Y=62.64 "25 ms"
	
	ModifyLayout mag=.5, units=0
EndMacro

function FormatGraph()
	ModifyGraph font="Helvetica"//,fSize=18,
	ModifyGraph margin(left)=40,margin(bottom)=40,margin(top)=18,margin(right)=18
End
