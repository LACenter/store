////////////////////////////////////////////////////////////////////////////////
// Unit Description  : mainform Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'storeitem', 'storelist', 'about', 'proxy';

var
    spinner: TGradientBackground;
    spinTimer: TTimer;
    status: TLabel;

//constructor of mainform
function mainformCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @mainform_OnCreate, 'mainform');
end;

//OnCreate Event of mainform
procedure mainform_OnCreate(Sender: TForm);
var
    blabel: TBGRALabelFx;
    pan: TPanel;
    bu: TBGRAButton;
    pop: TPopupMenu;
    menu: TMenuItem;
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Color := clWhite;
    Sender.Constraints.MinWidth := 570;
    Sender.Constraints.MinHeight := 450;

    spinTimer := TTimer(Sender.Find('spinTimer'));
    status := TLabel(Sender.Find('status'));
    status.BorderSpacing.Top := 15;

    TScrollBox(Sender.Find('scroller')).ChildSizing.LeftRightSpacing := 10;
    TScrollBox(Sender.Find('scroller')).ChildSizing.TopBottomSpacing := 0;
    TScrollBox(Sender.Find('scroller')).ChildSizing.HorizontalSpacing := 10;
    TScrollBox(Sender.Find('scroller')).ChildSizing.VerticalSpacing := 10;
    TScrollBox(Sender.Find('scroller')).ChildSizing.Layout := cclLeftToRightThenTopToBottom;
    TScrollBox(Sender.Find('scroller')).ChildSizing.ControlsPerLine := 3;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Tracking := true;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Smooth := true;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Visible := false;
    TScrollBox(Sender.Find('scroller')).VertScrollBar.Tracking := true;
    TScrollBox(Sender.Find('scroller')).VertScrollBar.Smooth := true;
    scroller := TScrollBox(Sender.Find('scroller'));

    {blabel := TBGRALabelFx.Create(Sender);
    blabel.Parent := TPanel(Sender.Find('topPanel'));
    blabel.Caption := 'LA.';
    blabel.Left := 5;
    blabel.Font.Color := HexToColor('#ee5500');
    blabel.Font.Size := 17;

    blabel := TBGRALabelFx.Create(Sender);
    blabel.Parent := TPanel(Sender.Find('topPanel'));
    blabel.Caption := 'Store';
    blabel.Left := 40;
    blabel.Font.Size := 17;}

    pan := TPanel.Create(Sender);
    pan.Parent := Sender;
    pan.BevelOuter := bvNone;
    pan.Left := 0;
    pan.Width := Sender.Width;
    pan.Height := 4;
    pan.Top := 40;
    pan.Anchors := akTop + akLeft + akRight;
    pan.Color := HexToColor('#ff6600');

    bu := TBGRAButton.Create(Sender);
    bu.Parent := TPanel(Sender.Find('topPanel'));
    bu.Width := 100;
    bu.Left := 530;
    bu.Height := 30;
    bu.Top := 5;
    bu.Style := bbtDropDown;
    bu.Caption := 'Stores';
    bu.Anchors := akTop + akRight;
    bu.OnButtonClick := @mainform_ButtonMenuClick;
    bu.OnClick := @mainform_ButtonClick;
    bu.Name := 'bStore';
    _setButton(bu);

    spinner := TGradientBackground.Create(Sender);
    spinner.Parent := TPanel(Sender.Find('topPanel'));
    spinner.Height := 3;
    spinner.Width := 200;
    spinner.Top := 36;
    spinner.Left := 0;
    spinner.ColorStart := clWhite;
    spinner.ColorEnd := HexToColor('#666666');
    spinner.Style := gsHorizontal;
    spinner.Name := 'spinner';
    spinner.Left := -200;

    store := TLAStore(Sender.Find('LAStore1'));
    startSpinner;

    storeIndex := StrToIntDef(appSettings.Values['store-Index'], 0);
    storePassword := appSettings.Values['store-Pass'];

    pop := TPopupMenu.Create(Sender);
    pop.Name := 'pop';

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Set current Store as Default Store';
    menu.OnClick := @mainform_DefaultClick;
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Setup Proxy Server';
    menu.OnClick := @mainform_ProxyClick;
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := '-';
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'About';
    menu.OnClick := @mainform_AboutClick;
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := '-';
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Exit';
    menu.OnClick := @mainform_ExitClick;
    pop.Items.Add(menu);

    _storeFonts(Sender);


    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TTimer(Sender.find('startTimer')).OnTimer := @mainform_startTimer_OnTimer;
    TTimer(Sender.find('spinTimer')).OnTimer := @mainform_spinTimer_OnTimer;
    Sender.OnResize := @mainform_OnResize;
    //</events-bind>

    //Set as Application.MainForm
    Sender.setAsMainForm;
end;

procedure mainform_ProxyClick(Sender: TMenuItem);
begin
    proxyCreate(Sender.Owner).ShowModalDimmed;
end;

procedure mainform_DefaultClick(Sender: TMenuItem);
begin
    appSettings.Values['store-Index'] := IntToStr(storeIndex);
    appSettings.Values['store-Pass'] := storePassword;
    appSettings.SaveToFile(root+'LA.Store.settings');
end;

procedure mainform_AboutClick(Sender: TMenuItem);
begin
    aboutCreate(Sender.Owner).ShowModalDimmed;
end;

procedure mainform_ExitClick(Sender: TMenuItem);
begin
    TForm(Sender.Owner).Close;
end;

procedure mainform_ButtonMenuClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('pop'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    pop.PopUpAt(x, y);
end;

procedure mainform_ButtonClick(Sender: TBGRAButton);
var
    dlg: TForm;
    index: int;
begin
    dlg := storelistCreate(Sender.Owner);
    if dlg.ShowModalDimmed = mrOK then
        populateStores(storeIndex);

    Screen.Cursor := crDefault;
    Application.ProcessMessages;
end;

procedure startSpinner();
begin
    spinner.Left := -200;
    spinTimer.Enabled := true;
    Application.ProcessMessages;
end;

procedure stopSpinner();
begin
    spinTimer.setTag(1);
end;

procedure mainform_OnResize(Sender: TForm);
begin
    TScrollBox(Sender.Find('scroller')).ChildSizing.ControlsPerLine := Sender.Width div 260;
end;

procedure mainform_spinTimer_OnTimer(Sender: TTimer);
begin
    Application.ProcessMessages;

    TControl(Sender.Owner.Find('spinner')).Left :=
        TControl(Sender.Owner.Find('spinner')).Left + 10;

    if TControl(Sender.Owner.Find('spinner')).Left > TForm(Sender.Owner).Width + 100 then
    begin
        TControl(Sender.Owner.Find('spinner')).Left := -200;
        if Sender.Tag = 1 then
        begin
            Sender.Enabled := false;
            Sender.Tag := 0;
        end;
    end;

    Application.ProcessMessages;
end;

procedure populateApps();
var
    i, j: int;
    fr: TFrame;
begin
    for i := scroller.ComponentCount -1 downto 0 do
        try scroller.Components[i].free except end;

    for i := 0 to store.StoreCount -1 do
    begin
        if i = storeIndex then
        begin
            store.Stores[i].ListApplications(storePassword);

            for j := 0 to store.Stores[i].ApplicationCount -1 do
            begin
                fr := storeitemCreate(scroller, store.Stores[i].Applications[j]);
                fr.Parent := scroller;
                fr.Constraints.MinWidth := 260;
                fr.Constraints.MinHeight := 260;
                fr.Constraints.MaxWidth := 260;
                fr.Constraints.MaxHeight := 260;
                fr.Color := HexToColor('#f0f0f0');
            end;

            break;
        end;
    end;
end;

procedure populateStores(index: int);
var
    i: int;
begin
    if not StoresListed then
        store.ListStores;

    StoresListed := (store.StoreCount <> 0);

    for i := 0 to store.StoreCount -1 do
    begin
        if i = index then
        begin
            storeIndex := i;
            status.Caption := store.Stores[i].StoreName+' ('+IntToStr(store.Stores[Index].AppsInStore)+')';
            break;
        end;
    end;

    populateApps;
    stopSpinner;
end;

procedure mainform_startTimer_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    populateStores(storeIndex);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//mainform initialization constructor
constructor
begin 
end.
