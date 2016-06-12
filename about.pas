////////////////////////////////////////////////////////////////////////////////
// Unit Description  : about Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Monday 22, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of about
function aboutCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @about_OnCreate, 'about');
end;

//OnCreate Event of about
procedure about_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    if not OSX then
        Sender.PopupMode := pmAuto;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button1')).OnClick := @about_Button1_OnClick;
    //</events-bind>
end;

procedure about_Button1_OnClick(Sender: TButton);
begin
    TForm(Sender.Owner).Close;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//about initialization constructor
constructor
begin 
end.
