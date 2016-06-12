////////////////////////////////////////////////////////////////////////////////
// Unit Description  : dlprogress Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Monday 22, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

//constructor of dlprogress
function dlprogressCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @dlprogress_OnCreate, 'dlprogress');
end;

//OnCreate Event of dlprogress
procedure dlprogress_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    TProgressBar(Sender.Find('ProgressBar1')).Color := clNone;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//dlprogress initialization constructor
constructor
begin 
end.
