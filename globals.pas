////////////////////////////////////////////////////////////////////////////////
// Unit Description  : globals Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Sunday 21, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////


//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

var
    store: TLAStore;
    scroller: TScrollBox;
    storeIndex: int = 0;
    storePassword: string = '';
    StoresListed: bool;
    appSettings: TStringList = nil;
    root: string = '';

procedure _setButton(bu: TBGRAButton);
begin
    bu.TextShadowOffSetX := 1;
    bu.TextShadowOffSetY := 1;
    bu.TextShadowRadius := 1;
    // Normal
    bu.BodyNormal.BorderColor := HexToColor('#ff6600');
    bu.BodyNormal.Font.Color := clWhite;
    if Windows then
    bu.BodyNormal.Font.Size := 10
    else if OSX then
    bu.BodyNormal.Font.Size := 12
    else
    bu.BodyNormal.Font.Size := 8;
    bu.BodyNormal.Gradient1.StartColor := HexToColor('#ff6600');
    bu.BodyNormal.Gradient1.EndColor := HexToColor('#ff4400');
    bu.BodyNormal.Gradient2.StartColor := HexToColor('#ff4400');
    bu.BodyNormal.Gradient2.EndColor := HexToColor('#ff6600');
    // Hover
    bu.BodyHover.BorderColor := HexToColor('#ff6600');
    bu.BodyHover.Font.Color := clWhite;
    if Windows then
    bu.BodyHover.Font.Size := 10
    else if OSX then
    bu.BodyHover.Font.Size := 12
    else
    bu.BodyHover.Font.Size := 8;
    bu.BodyHover.Gradient1.StartColor := HexToColor('#ff7700');
    bu.BodyHover.Gradient1.EndColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.StartColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.EndColor := HexToColor('#ff7700');
    // Clicked
    bu.BodyClicked.BorderColor := HexToColor('#ff4400');
    bu.BodyClicked.Font.Color := clWhite;
    if Windows then
    bu.BodyClicked.Font.Size := 10
    else if OSX then
    bu.BodyClicked.Font.Size := 12
    else
    bu.BodyClicked.Font.Size := 8;
    bu.BodyClicked.Gradient1.StartColor := HexToColor('#ff6600');
    bu.BodyClicked.Gradient1.EndColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.StartColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.EndColor := HexToColor('#ff6600');
end;

procedure _storeFonts(comp: TComponent);
var
    i: int;
begin
    for i := 0 to comp.ComponentCount -1 do
    begin
        if comp.Components[i].hasProp('Font') then
        begin
            if Screen.Fonts.IndexOf('DejaVu Sans') then
            TControl(comp.Components[i]).Font.Name := 'DejaVu Sans'
            else if Screen.Fonts.IndexOf('Liberation Sans') then
            TControl(comp.Components[i]).Font.Name := 'Liberation Sans'
            else if Screen.Fonts.IndexOf('Open Sans') then
            TControl(comp.Components[i]).Font.Name := 'Open Sans'
            else if Screen.Fonts.IndexOf('Segoe UI') then
            TControl(comp.Components[i]).Font.Name := 'Segoe UI'
            else if Screen.Fonts.IndexOf('Verdana') then
            TControl(comp.Components[i]).Font.Name := 'Verdana'
            else if Screen.Fonts.IndexOf('Tahoma') then
            TControl(comp.Components[i]).Font.Name := 'Tahoma'
            else if Screen.Fonts.IndexOf('Arial') then
            TControl(comp.Components[i]).Font.Name := 'Arial';

            if OSX then
            TControl(comp.Components[i]).Font.Size := 14
            else if Windows then
            TControl(comp.Components[i]).Font.Size := 11
            else
            TControl(comp.Components[i]).Font.Size := 10;

            if comp.Components[i].Name = 'status' then
            begin
                if OSX then
                TControl(comp.Components[i]).Font.Size := 16
                else
                TControl(comp.Components[i]).Font.Size := 12;
            end;
        end;
    end;
end;

//globals initialization constructor
constructor
begin
    //adjust ModalDimmed Rect
    if IsWindowsXP then
    begin
        AdjustDimOffsetLeft(-9);
        AdjustDimOffsetWidth(9);
    end;
    if IsWindowsVista or IsWindows7 then
    begin
        AdjustDimOffsetLeft(-8);
        AdjustDimOffsetWidth(16);
        AdjustDimOffsetHeight(8);
    end;
    if Linux then
    begin
        AdjustDimOffsetLeft(-1);
        AdjustDimOffsetTop(-1);
        AdjustDimOffsetWidth(4);
        AdjustDimOffsetHeight(2);
    end;

    root := UserDir+'LA.Store'+DirSep;
    ForceDir(root);

    appSettings := TStringList.Create;
    if not FileExists(root+'LA.Store.settings') then
    begin
        appSettings.Values['store-Index'] := '0';
        appSettings.Values['store-Pass'] := '';
        appSettings.SaveToFile(root+'LA.Store.settings');
    end
        else
        appSettings.LoadFromFile(root+'LA.Store.settings');

    setProxyHost(appSettings.Values['proxy-host']);
    setProxyPort(appSettings.Values['proxy-port']);
    setProxyUser(appSettings.Values['proxy-user']);
    setProxyPass(appSettings.Values['proxy-pass']);
end.
