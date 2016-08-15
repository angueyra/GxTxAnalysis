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
	SetAxis left -12,2
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end
function loada2()
	loadfx("a2_ino")
	SetAxis left -12,2
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
end
function loada3()
	loadfx("a3_igx")
	SetAxis left -12,2
	SetAxis bottom 0,.5
	FormatCal()
	ModifyGraph margin(left)=10,margin(bottom)=10,margin(top)=10,margin(right)=5
//	Execute("MakeScaleBarsRT(.48, .46, -11, -9,\"\", \"\",2)")
end

function loadb1()
	loadfx("b1_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces CtFit_Y,{Ct_Y}
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(Gx_Y)=1
	ModifyGraph hideTrace(No_Y)=1,hideTrace(NoFit_Y)=1
end
function loadb2()
	loadfx("b2_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces NoFit_Y,{No_Y}
	ModifyGraph hideTrace(GxFit_Y)=1,hideTrace(Gx_Y)=1
	ModifyGraph hideTrace(Ct_Y)=1,hideTrace(CtFit_Y)=1
end
function loadb3()
	loadfx("b3_flat")
	SetAxis bottom 0,400
	SetAxis left 0,1
	ReorderTraces GxFit_Y,{Gx_Y}
	ModifyGraph hideTrace(CtFit_Y)=1,hideTrace(Ct_Y)=1
	ModifyGraph hideTrace(No_Y)=1,hideTrace(NoFit_Y)=1
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
Make/O/T oLabels={"0.1","","","","","1","","","","","10","","","","","100","","","","","1000"}
Make/O oLocs={0.1,.2,.3,.4,0.5,1,2,3,4,5,10,20,30,40,50,100,200,300,400,500,1000}
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
	
	
	
	Append a_stim/O=1/F=0/T

	
	variable rawL=20
	variable rawW=330
	variable rawH=220
	ModifyLayout left(b_rawno)=rawL,top(b_rawno)=0,width(b_rawno)=rawW,height(b_rawno)=rawH
	ModifyLayout left(c_rawgx)=rawL,top(c_rawgx)=222,width(c_rawgx)=rawW,height(c_rawgx)=rawH
	ModifyLayout left(a_stim)=rawL,top(a_stim)=450,width(a_stim)=rawW,height(a_stim)=rawH/2
	
	//TextBox/C/N=text2/F=0/S=1/A=LB/X=13.65/Y=82 "2 pA"
	//TextBox/C/N=text3/F=0/S=1/A=LB/X=15.40/Y=78.46 "100 ms"
	
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