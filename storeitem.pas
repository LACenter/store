////////////////////////////////////////////////////////////////////////////////
// Unit Description  : storeitem Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'dlprogress', 'report';

var
    appItem: TLAStoreAppItem;
    pogressDlg: TForm;

//constructor of storeitem
function storeitemCreate(Owner: TComponent; item: TLAStoreAppItem): TFrame;
begin
    appItem := item;
    result := TFrame.CreateWithConstructorFromResource(Owner, @storeitem_OnCreate, 'storeitem');
end;

//OnCreate Event of storeitem
procedure storeitem_OnCreate(Sender: TFrame);
var
    bu: TBGRAButton;
    pt: string;
    pop: TPopupMenu;
    menu: TMenuItem;
    i: int;
    http: THttp;
    fs: TFileStream;
begin
    //Frame Constructor

    //todo: some additional constructing code
    bu := TBGRAButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := 0;
    bu.Width := Sender.Width;
    bu.Height := 30;
    bu.Top := 255 - bu.Height;
    bu.Style := bbtDropDown;
    bu.Caption := 'Launch';
    bu.OnButtonClick := @storeitem_ButtonMenuClick;
    bu.OnClick := @storeitem_ButtonClick;
    bu.Name := 'bu';
    bu.Hint := appItem.LauncherID;
    bu.Name := 'bLaunch';
    _setButton(bu);

    pop := TPopupMenu.Create(Sender);
    pop.Name := 'pop';

    TLabel(Sender.Find('lAppName')).Caption := appItem.AppName;
    TLabel(Sender.Find('lAppDesc')).Caption := appItem.AppDescription;
    TPanel(Sender.Find('Panel1')).Color := clWhite;
    TPanel(Sender.Find('Panel2')).Color := clWhite;

    ForceDir(root+'iconCache');

    http := THttp.Create;
    if Pos('noicon.png', appItem.AppIconUrl) = 0 then
    begin
        if not FileExists(root+'iconCache'+DirSep+appItem.LauncherID+'.png') then
        begin
            try
                fs := TFileStream.Create(root+'iconCache'+DirSep+appItem.LauncherID+'.png', fmCreate);
                http.urlGetBinary(appItem.AppIconUrl, fs);
                fs.free;
                TImage(Sender.Find('Image2')).Picture.LoadFromFile(root+'iconCache'+DirSep+appItem.LauncherID+'.png');
            except
                deletefile(root+'iconCache'+DirSep+appItem.LauncherID+'.png');
            end;
        end
            else
            TImage(Sender.Find('Image2')).Picture.LoadFromFile(root+'iconCache'+DirSep+appItem.LauncherID+'.png');
    end;

    http.free;

    //TImage(Sender.Find('Image2')).

    if appItem.AppType = atDownload then
    begin
        if appItem.PriceType = ptFree then
        begin
            bu.Caption := 'Download';
            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Hint := bu.Hint;
            menu.OnClick := @storeitem_MenuDownloadClick;
            pop.Items.Add(menu);
        end
            else
        begin
            if appItem.PriceType = ptPerMonth then
            pt := ' - Month';
            if appItem.PriceType = ptPerUserPerMonth then
            pt := ' - User/Month';
            if appItem.PriceType = ptPerYear then
            pt := ' - Year';
            if appItem.PriceType = ptPerUserPerYear then
            pt := ' - User/Year';
            if appItem.PriceType = ptOneTimePayment then
            pt := ' - Single Payment';

            TLabel(Sender.Find('lPrice')).Visible := true;
            //TLabel(Sender.Find('lPrice')).Font.Color := HexToColor('#ff4400');
            TLabel(Sender.Find('lPrice')).Font.Style := fsBold;
            TLabel(Sender.Find('lPrice')).Font.Size := 12;
            TLabel(Sender.Find('lPrice')).Caption := 'only $'+DoubleFormat('#,##0.00', appItem.Price)+pt;
            TImage(Sender.Find('imgFree')).Visible := false;
            TImage(Sender.Find('imgTrial')).Visible := true;
            bu.Caption := 'Download Trial Version';

            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Hint := bu.Hint;
            menu.OnClick := @storeitem_MenuDownloadClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            menu.Caption := '-';
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            if appItem.PriceType <> ptOneTimePayment then
            menu.Caption := 'Subscribe Now for '+TLabel(Sender.Find('lPrice')).Caption
            else
            menu.Caption := 'Buy now for '+TLabel(Sender.Find('lPrice')).Caption;
            menu.Hint := appItem.LauncherID;
            menu.OnClick := @storeitem_OnBuyClick;
            pop.Items.Add(menu);
        end;
    end
    else if appItem.AppType = atInstaller then
    begin
        if appItem.PriceType = ptFree then
        begin
            if DirExists(root+appItem.LauncherID) then
            bu.Caption := 'Remove'
            else
            bu.Caption := 'Install';

            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Name := 'mInstaller';
            menu.Hint := bu.Hint;
            menu.OnClick := @storeitem_MenuInstallClick;
            pop.Items.Add(menu);
        end
            else
        begin
            if DirExists(root+appItem.LauncherID) then
            bu.Caption := 'Remove'
            else
            bu.Caption := 'Install';

            if appItem.PriceType = ptPerMonth then
            pt := ' - Month';
            if appItem.PriceType = ptPerUserPerMonth then
            pt := ' - User/Month';
            if appItem.PriceType = ptPerYear then
            pt := ' - Year';
            if appItem.PriceType = ptPerUserPerYear then
            pt := ' - User/Year';
            if appItem.PriceType = ptOneTimePayment then
            pt := ' - Single Payment';

            TLabel(Sender.Find('lPrice')).Visible := true;
            //TLabel(Sender.Find('lPrice')).Font.Color := HexToColor('#ff4400');
            TLabel(Sender.Find('lPrice')).Font.Style := fsBold;
            TLabel(Sender.Find('lPrice')).Font.Size := 12;
            TLabel(Sender.Find('lPrice')).Caption := 'only $'+DoubleFormat('#,##0.00', appItem.Price)+pt;
            TImage(Sender.Find('imgFree')).Visible := false;
            TImage(Sender.Find('imgTrial')).Visible := true;
            bu.Caption := 'Install Trial Version';

            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Hint := bu.Hint;
            menu.Name := 'mInstaller';
            menu.OnClick := @storeitem_MenuInstallClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            menu.Caption := '-';
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            if appItem.PriceType <> ptOneTimePayment then
            menu.Caption := 'Subscribe Now for '+TLabel(Sender.Find('lPrice')).Caption
            else
            menu.Caption := 'Buy now for '+TLabel(Sender.Find('lPrice')).Caption;
            menu.Hint := appItem.LauncherID;
            menu.OnClick := @storeitem_OnBuyClick;
            pop.Items.Add(menu);
        end;
    end
        else
    begin
        if appItem.PriceType = ptFree then
        begin
            bu.Caption := 'Launch';
            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Hint := bu.Hint;
            menu.OnClick := @storeitem_MenuLaunchClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end
            else
        begin
            if appItem.PriceType = ptPerMonth then
            pt := ' - Month';
            if appItem.PriceType = ptPerUserPerMonth then
            pt := ' - User/Month';
            if appItem.PriceType = ptPerYear then
            pt := ' - Year';
            if appItem.PriceType = ptPerUserPerYear then
            pt := ' - User/Year';
            if appItem.PriceType = ptOneTimePayment then
            pt := ' - Single Payment';

            TLabel(Sender.Find('lPrice')).Visible := true;
            //TLabel(Sender.Find('lPrice')).Font.Color := HexToColor('#ff4400');
            TLabel(Sender.Find('lPrice')).Font.Style := fsBold;
            TLabel(Sender.Find('lPrice')).Font.Size := 12;
            TLabel(Sender.Find('lPrice')).Caption := 'only $'+DoubleFormat('#,##0.00', appItem.Price)+pt;
            TImage(Sender.Find('imgFree')).Visible := false;
            TImage(Sender.Find('imgTrial')).Visible := true;
            bu.Caption := 'Launch Trial Version';

            menu := TMenuItem.Create(Sender);
            menu.Caption := bu.Caption;
            menu.Hint := bu.Hint;
            menu.OnClick := @storeitem_MenuLaunchClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender);
            menu.Caption := '-';
            pop.Items.Add(menu);

                menu := TMenuItem.Create(Sender);
                if appItem.PriceType <> ptOneTimePayment then
                menu.Caption := 'Subscribe Now for '+TLabel(Sender.Find('lPrice')).Caption
                else
                menu.Caption := 'Buy Now for '+TLabel(Sender.Find('lPrice')).Caption;
                menu.Hint := appItem.LauncherID;
                menu.OnClick := @storeitem_OnBuyClick;
                pop.Items.Add(menu);

                menu := TMenuItem.Create(Sender);
                menu.Caption := '-';
                pop.Items.Add(menu);
            end;

        menu := TMenuItem.Create(Sender);
        menu.Caption := 'Add a Live Shortcut on my Desktop';
        menu.Hint := appItem.LauncherID;
        menu.OnClick := @storeitem_OnDesktopShortcutClick;
        pop.Items.Add(menu);

        menu := TMenuItem.Create(Sender);
        menu.Caption := 'Add a Live Shortcut in my Start Menu';
        menu.Hint := appItem.LauncherID;
        menu.OnClick := @storeitem_OnStartMenuShortcutClick;
        pop.Items.Add(menu);
    end;

    if (appItem.SupportEmail <> '')  or
       (appItem.SupportWeb <> '') then
    begin
        menu := TMenuItem.Create(Sender);
        menu.Caption := '-';
        pop.Items.Add(menu);

        if appItem.SupportEmail <> '' then
        begin
            menu := TMenuItem.Create(Sender);
            menu.Caption := 'Contact Product Support';
            menu.Hint := appItem.LauncherID;
            menu.OnClick := @storeitem_OnEmailClick;
            pop.Items.Add(menu);
        end;

        if appItem.SupportWeb <> '' then
        begin
            menu := TMenuItem.Create(Sender);
            menu.Caption := 'Go to Product Web Site';
            menu.Hint := appItem.LauncherID;
            menu.OnClick := @storeitem_OnWebClick;
            pop.Items.Add(menu);
        end;
    end;

    menu := TMenuItem.Create(Sender);
    menu.Caption := '-';
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Report this Application';
    menu.Hint := appItem.LauncherID;
    menu.OnClick := @storeitem_OnReportClick;
    pop.Items.Add(menu);

    _storeFonts(Sender);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

procedure storeitem_OnReportClick(Sender: TMenuItem);
var
    f: TForm;
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            f := reportCreate(Application.MainForm, store.Stores[storeIndex].Applications[i].LauncherID);
            f.ShowModalDimmed;
            break;
        end;
    end;
end;

procedure DataReceived(Sender: TLAStore; bytesReceived, totalBytes: int64);
begin
    try
        TProgressBar(pogressDlg.Find('ProgressBar1')).Max := totalBytes;
        TProgressBar(pogressDlg.Find('ProgressBar1')).Position := bytesReceived;
        TLabel(pogressDlg.Find('Label2')).Caption :=
            DoubleFormat('#,##0.00', (bytesReceived / 1024) / 1024)+' of '+
            DoubleFormat('#,##0.00', (totalBytes / 1024) / 1024)+' MB';
    except end;
end;

procedure storeitem_MenuInstallClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            if Sender.Caption = 'Install' then
            begin
                store.OnDataReceived := @DataReceived;

                pogressDlg := dlprogressCreate(Sender.Owner);
                pogressDlg.Show;
                Application.ProcessMessages;

                store.Stores[storeIndex].Applications[i].RunInstallerApplication(root);

                Application.ProcessMessages;
                pogressDlg.free;

                TBGRAButton(Sender.Owner.Find('bLaunch')).Caption := 'Remove';
                Sender.Caption := 'Remove';
            end
                else
            begin
                ForceDeleteDir(root+store.Stores[storeIndex].Applications[i].LauncherID);
                Sender.Caption := 'Install';
                TBGRAButton(Sender.Owner.Find('bLaunch')).Caption := 'Install';
            end;
            break;
        end;
    end;
end;

procedure storeitem_MenuDownloadClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            TSaveDialog(Sender.Owner.Find('SD')).InitialDir := UserDir+'Downloads';
            TSaveDialog(Sender.Owner.Find('SD')).FileName :=
                store.Stores[storeIndex].Applications[i].AppName+'.zip';
            if TSaveDialog(Sender.Owner.Find('SD')).Execute then
            begin
                store.OnDataReceived := @DataReceived;

                pogressDlg := dlprogressCreate(Sender.Owner);
                pogressDlg.Show;
                Application.ProcessMessages;

                store.Stores[storeIndex].Applications[i].Download(
                    TSaveDialog(Sender.Owner.Find('SD')).FileName);

                Application.ProcessMessages;
                pogressDlg.free;
            end;
            break;
        end;
    end;
end;

procedure storeitem_OnBuyClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            ShellOpen(store.Stores[storeIndex].Applications[i].BuyUrl);
            break;
        end;
    end;
end;

procedure storeitem_OnEmailClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            ShellOpen('mailto:'+store.Stores[storeIndex].Applications[i].SupportEmail);
            break;
        end;
    end;
end;

procedure storeitem_OnWebClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            ShellOpen(store.Stores[storeIndex].Applications[i].SupportWeb);
            break;
        end;
    end;
end;

procedure storeitem_OnDesktopShortcutClick(Sender: TMenuItem);
var
    i: int;
    iconFile: string;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin

            if Windows then
            begin
                iconFile := root+'app.ico';
                ResToFile('icon_ico', iconFile);
            end;

            if Linux or FreeBsd then
            begin
                iconFile := root+'app.png';
                ResToFile('icon_png', iconFile);
            end;

            if OSX then
            begin
                iconFile := root+'app.icns';
                ResToFile('icon_icns', iconFile);
            end;

            if FileExists(iconFile) then
            begin
                CreateShortCut(
                    ArgumentByIndex(0),
                    '"-launcherid='+Sender.Hint+'" "-launchtext=Launching '+store.Stores[storeIndex].Applications[i].AppName+', please wait..."',
                    store.Stores[storeIndex].Applications[i].AppName,
                    iconFile,
                    store.Stores[storeIndex].Applications[i].AppDescription,
                    '',
                    slDesktop
                );
            end;
            break;
        end;
    end;
end;

procedure storeitem_OnStartMenuShortcutClick(Sender: TMenuItem);
var
    i: int;
    iconFile: string;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin

            if Windows then
            begin
                iconFile := root+'app.ico';
                ResToFile('icon_ico', iconFile);
            end;

            if Linux or FreeBsd then
            begin
                iconFile := root+'app.png';
                ResToFile('icon_png', iconFile);
            end;

            if OSX then
            begin
                iconFile := root+'app.icns';
                ResToFile('icon_icns', iconFile);
            end;

            if FileExists(iconFile) then
            begin
                CreateShortCut(
                    ArgumentByIndex(0),
                    '"-launcherid='+Sender.Hint+'" "-launchtext=Launching '+store.Stores[storeIndex].Applications[i].AppName+', please wait..."',
                    store.Stores[storeIndex].Applications[i].AppName,
                    iconFile,
                    store.Stores[storeIndex].Applications[i].AppDescription,
                    'LA.Store;Other',
                    slStartMenu
                );
            end;
            break;
        end;
    end;
end;

procedure storeitem_MenuLaunchClick(Sender: TMenuItem);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            store.Stores[storeIndex].Applications[i].RunApplication;
            break;
        end;
    end;
end;

procedure storeitem_ButtonMenuClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('pop'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    if OSX then
    begin
        x := x + Application.MainForm.Left;
        y := y + Application.MainForm.Top + 90 + scroller.VertScrollBar.Position;
    end;

    pop.PopUpAt(x, y);
end;

procedure storeitem_ButtonClick(Sender: TBGRAButton);
var
    i: int;
begin
    for i := 0 to store.Stores[storeIndex].ApplicationCount -1 do
    begin
        if store.Stores[storeIndex].Applications[i].LauncherID = Sender.Hint then
        begin
            if store.Stores[storeIndex].Applications[i].AppType = atInstaller then
            begin
                store.OnDataReceived := @DataReceived;

                if Sender.Caption = 'Install' then
                begin
                    pogressDlg := dlprogressCreate(Sender.Owner);
                    pogressDlg.Show;
                    Application.ProcessMessages;

                    store.Stores[storeIndex].Applications[i].RunInstallerApplication(root);

                    Application.ProcessMessages;
                    pogressDlg.free;

                    Sender.Caption := 'Remove';
                    TMenuItem(Sender.Owner.Find('mInstaller')).Caption := 'Remove';
                end
                    else
                begin
                    ForceDeleteDir(root+store.Stores[storeIndex].Applications[i].LauncherID);
                    Sender.Caption := 'Install';
                    TMenuItem(Sender.Owner.Find('mInstaller')).Caption := 'Install';
                end;
            end
            else if store.Stores[storeIndex].Applications[i].AppType = atDownload then
            begin
                TSaveDialog(Sender.Owner.Find('SD')).InitialDir := UserDir+'Downloads';
                TSaveDialog(Sender.Owner.Find('SD')).FileName :=
                    store.Stores[storeIndex].Applications[i].AppName+'.zip';
                if TSaveDialog(Sender.Owner.Find('SD')).Execute then
                begin
                    store.OnDataReceived := @DataReceived;

                    pogressDlg := dlprogressCreate(Sender.Owner);
                    pogressDlg.Show;
                    Application.ProcessMessages;

                    store.Stores[storeIndex].Applications[i].Download(
                        TSaveDialog(Sender.Owner.Find('SD')).FileName);

                    Application.ProcessMessages;
                    pogressDlg.free;
                end;
            end
            else
            store.Stores[storeIndex].Applications[i].RunApplication;

            break;
        end;
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//storeitem initialization constructor
constructor
begin 
end.
