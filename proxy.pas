////////////////////////////////////////////////////////////////////////////////
// Unit Description  : proxy Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 28, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of proxy
function proxyCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @proxy_OnCreate, 'proxy');
end;

//OnCreate Event of proxy
procedure proxy_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    TButtonPanel(Sender.Find('ButtonPanel1')).BorderSpacing.Around := 20;
    TEdit(Sender.Find('Edit1')).Text := appSettings.Values['proxy-host'];
    TEdit(Sender.Find('Edit2')).Text := appSettings.Values['proxy-port'];
    TEdit(Sender.Find('Edit3')).Text := appSettings.Values['proxy-user'];
    TEdit(Sender.Find('Edit4')).Text := appSettings.Values['proxy-pass'];

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    Sender.OnClose := @proxy_OnClose;
    Sender.OnCloseQuery := @proxy_OnCloseQuery;
    //</events-bind>
end;

procedure proxy_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure proxy_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        appSettings.Values['proxy-host'] := TEdit(Sender.Find('Edit1')).Text;
        appSettings.Values['proxy-port'] := TEdit(Sender.Find('Edit2')).Text;
        appSettings.Values['proxy-user'] := TEdit(Sender.Find('Edit3')).Text;
        appSettings.Values['proxy-pass'] := TEdit(Sender.Find('Edit4')).Text;
        clearProxy;
        setProxyHost(appSettings.Values['proxy-host']);
        setProxyPort(appSettings.Values['proxy-port']);
        setProxyUser(appSettings.Values['proxy-user']);
        setProxyPass(appSettings.Values['proxy-pass']);
        appSettings.SaveToFile(root+'LA.Store.settings');
        startSpinner;
        TTimer(Application.MainForm.Find('startTimer')).Enabled := true;
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//proxy initialization constructor
constructor
begin 
end.
