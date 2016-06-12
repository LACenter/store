////////////////////////////////////////////////////////////////////////////////
// Unit Description  : storelist Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'storepass', 'storeowner';

var
    tmpStoreID: int;
    storeListForm: TForm;

//constructor of storelist
function storelistCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @storelist_OnCreate, 'storelist');
end;

//OnCreate Event of storelist
procedure storelist_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    storeListForm := Sender;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.LeftRightSpacing := 5;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.TopBottomSpacing := 5;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.HorizontalSpacing := 0;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.VerticalSpacing := 5;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.Layout := cclLeftToRightThenTopToBottom;
    TScrollBox(Sender.Find('ScrollBox1')).ChildSizing.ControlsPerLine := 1;
    TScrollBox(Sender.Find('ScrollBox1')).HorzScrollBar.Tracking := true;
    TScrollBox(Sender.Find('ScrollBox1')).HorzScrollBar.Smooth := true;
    TScrollBox(Sender.Find('ScrollBox1')).HorzScrollBar.Visible := false;
    TScrollBox(Sender.Find('ScrollBox1')).VertScrollBar.Visible := false;
    TScrollBox(Sender.Find('ScrollBox1')).VertScrollBar.Tracking := true;
    TScrollBox(Sender.Find('ScrollBox1')).VertScrollBar.Smooth := true;
    TScrollBox(Sender.Find('ScrollBox1')).Color := clWhite;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @storelist_Edit1_OnChange;
    TSimpleAction(Sender.find('actPopulate')).OnExecute := @storelist_actPopulate_OnExecute;
    Sender.OnClose := @storelist_OnClose;
    Sender.OnCloseQuery := @storelist_OnCloseQuery;
    Sender.OnShow := @storelist_OnShow;
    //</events-bind>
end;

procedure storelist_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

function getStoreIndex(storeID: int): int;
var
    i: int;
begin
    for i := 0 to store.StoreCount -1 do
    begin
        if store.Stores[i].StoreID = storeID then
        begin
            result := i;
            break;
        end;
    end;
end;

procedure storeownerButtonClick(Sender: TBGRAButton);
var
    canClose: bool = true;
begin
    startSpinner;
    tmpStoreID := TVars(Sender.Owner.Find('Vars1')).asInt('ID');
    storeListForm.ModalResult := mrOK;
end;

procedure storelist_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    dlg: TForm;
begin
    if Sender.ModalResult = mrOK then
    begin
        if store.Stores[getStoreIndex(tmpStoreID)].isPrivate then
        begin
            dlg := storepassCreate(Sender);
            if dlg.ShowModal = mrOK then
            begin
                if store.Stores[getStoreIndex(tmpStoreID)].
                    isPasswordOK(TEdit(dlg.Find('Edit1')).Text) then
                begin
                    storeIndex := getStoreIndex(tmpStoreID);
                    storePassword := TEdit(dlg.Find('Edit1')).Text;
                    CanClose := true;
                end
                else
                begin
                    MsgError('Error', 'Invalid Store Password');
                    CanClose := false;
                end;
            end
                else
                CanClose := false;
        end
            else
        begin
            storeIndex := getStoreIndex(tmpStoreID);
            storePassword := '';
        end;
    end;

    if CanClose then
    begin
        Screen.Cursor := crDefault;
        Application.ProcessMessages;
    end;
end;

procedure storelist_Button1_OnClick(Sender: TButton);
begin
    TForm(Sender.Owner).ModalResult := mrCancel;
end;

procedure storelist_actPopulate_OnExecute(Sender: TSimpleAction);
var
    i: int;
    so: TFrame;
begin
    for i := TScrollBox(Sender.Owner.Find('ScrollBox1')).ComponentCount -1 downto 0 do
    begin
        try
            TScrollBox(Sender.Owner.Find('ScrollBox1')).Components[i].Free;
        except end;
    end;

    if Trim(TEdit(Sender.Owner.Find('Edit1')).Text) = '' then
    begin
        for i := 0 to store.StoreCount -1 do
        begin
            so := storeownerCreate(TScrollBox(Sender.Owner.Find('ScrollBox1')), store.Stores[i]);
            so.Parent := TScrollBox(Sender.Owner.Find('ScrollBox1'));
            so.Constraints.MaxHeight := 120;
            so.Constraints.MinHeight := 120;
            so.Constraints.MaxWidth := 447;
            so.Constraints.MinWidth := 447;
            so.Color := HexToColor('#f0f0f0');
            TBGRAButton(so.Find('bu')).OnClick := @storeownerButtonClick;
        end;
    end
        else
    begin
        for i := 0 to store.StoreCount -1 do
        begin
            if Pos(Lower(TEdit(Sender.Owner.Find('Edit1')).Text), Lower(store.Stores[i].StoreName)) > 0 then
            begin
                so := storeownerCreate(TScrollBox(Sender.Owner.Find('ScrollBox1')), store.Stores[i]);
                so.Parent := TScrollBox(Sender.Owner.Find('ScrollBox1'));
                so.Constraints.MaxHeight := 120;
                so.Constraints.MinHeight := 120;
                so.Constraints.MaxWidth := 447;
                so.Constraints.MinWidth := 447;
                so.Color := HexToColor('#f0f0f0');
                TBGRAButton(so.Find('bu')).OnClick := @storeownerButtonClick;
            end;
        end;
    end;
end;

procedure storelist_Edit1_OnChange(Sender: TEdit);
begin
    TAction(Sender.Owner.Find('actPopulate')).Execute;
end;

procedure storelist_OnShow(Sender: TForm);
begin
    TAction(Sender.Find('actPopulate')).Execute;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//storelist initialization constructor
constructor
begin 
end.
