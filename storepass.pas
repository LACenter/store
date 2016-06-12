////////////////////////////////////////////////////////////////////////////////
// Unit Description  : storepass Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of storepass
function storepassCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @storepass_OnCreate, 'storepass');
end;

//OnCreate Event of storepass
procedure storepass_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    TButtonPanel(Sender.Find('ButtonPanel1')).BorderSpacing.Around := 20;
    TButtonPanel(Sender.Find('ButtonPanel1')).OKButton.Enabled := false;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @storepass_Edit1_OnChange;
    Sender.OnClose := @storepass_OnClose;
    //</events-bind>
end;

procedure storepass_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure storepass_Edit1_OnChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.Find('ButtonPanel1')).OKButton.Enabled :=
        (Trim(Sender.Text) <> '');
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//storepass initialization constructor
constructor
begin 
end.
