////////////////////////////////////////////////////////////////////////////////
// Unit Description  : lastore Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////


uses 'mainform';

var
    ver,v: string;
    i: int;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

procedure AppException(Sender: TObject; E: Exception);
begin
    //Uncaught Exceptions
    MsgError('Error', E.Message);
end;

//lastore initialization constructor
constructor
begin
    v := DoubleToStr(VERSION);
    for i := Len(v) downto 1 do
    begin
        ver := v[i]+ver;
        if len(ver) = 3 then
            ver := '.'+ver;
    end;

    Application.Initialize;
    Application.Icon.LoadFromResource('appicon');
    Application.Title := 'LA.Store '+ver;
    mainformCreate(nil);
    Application.Run;
end.

//Project Resources
//$res:appicon=[project-home]resources/app.ico
//$res:mainform=[project-home]mainform.pas.frm
//$res:storeitem=[project-home]storeitem.pas.frm
//$res:splash=[project-home]resources/splash.jpg
//$res:icon_ico=[project-home]resources/logo.ico
//$res:icon_png=[project-home]resources/logo48.png
//$res:icon_icns=[project-home]resources/logo.icns
//$res:storelist=[project-home]storelist.pas.frm
//$res:storepass=[project-home]storepass.pas.frm
//$res:dlprogress=[project-home]dlprogress.pas.frm
//$res:about=[project-home]about.pas.frm
//$res:storeowner=[project-home]storeowner.pas.frm
//$res:proxy=[project-home]proxy.pas.frm
