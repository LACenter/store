////////////////////////////////////////////////////////////////////////////////
// Unit Description  : report Description
// Unit Author       : LA.Center Corporation
// Date Created      : June, Sunday 26, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

var
    _appid: string;

//constructor of report
function reportCreate(Owner: TComponent; AppID: string): TForm;
begin
    _appid := AppID;
    result := TForm.CreateWithConstructorFromResource(Owner, @report_OnCreate, 'report');
end;

//OnCreate Event of report
procedure report_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    TLabel(Sender.Find('Label1')).Font.Style := fsBold;
    TLabel(Sender.Find('Label2')).Font.Style := fsBold;
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TMemo(Sender.find('Memo1')).OnChange := @report_Memo1_OnChange;
    TEdit(Sender.find('Edit2')).OnChange := @report_Edit2_OnChange;
    TEdit(Sender.find('Edit1')).OnChange := @report_Edit1_OnChange;
    Sender.OnClose := @report_OnClose;
    Sender.OnCloseQuery := @report_OnCloseQuery;
    //</events-bind>
end;

procedure report_Edit1_OnChange(Sender: TComponent);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled :=
        (Trim(TEdit(Sender.Owner.Find('Edit1')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.Find('Edit2')).Text) <> '') and
        (Trim(TMemo(Sender.Owner.Find('Memo1')).Lines.Text) <> '');
end;

procedure report_Edit2_OnChange(Sender: TEdit);
begin
    report_Edit1_OnChange(Sender);
end;

procedure report_Memo1_OnChange(Sender: TMemo);
begin
    report_Edit1_OnChange(Sender);
end;

procedure report_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure report_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    http: THttp;
    data: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        screen.Cursor := crHourGlass;
        application.ProcessMessages;

        data := 'email='+TEdit(Sender.Find('Edit2')).Text+'&'+
                'name='+TEdit(Sender.Find('Edit1')).Text+'&'+
                'message='+TComboBox(Sender.Find('ComboBox1')).Text+#13#10#13#10+'AppID: '+_appid+#13#10#13#10+
                TMemo(Sender.Find('Memo1')).Lines.Text;
        http := THttp.Create;
        http.urlPost('https://liveapps.center/inc/mailer.php', data);
        http.free;

        screen.Cursor := crDefault;
        application.ProcessMessages;

        MsgInfo('Report Received', 'We have received your report and may contact you for further investigation. Thank you for helping us.');
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//report initialization constructor
constructor
begin 
end.
