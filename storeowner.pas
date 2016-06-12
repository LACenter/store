////////////////////////////////////////////////////////////////////////////////
// Unit Description  : storeowner Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Saturday 27, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

var
    storeItem: TLAStoreItem;

//constructor of storeowner
function storeownerCreate(Owner: TComponent; refStore: TLAStoreItem): TFrame;
begin
    storeItem := refStore;
    result := TFrame.CreateWithConstructorFromResource(Owner, @storeowner_OnCreate, 'storeowner');
end;

//OnCreate Event of storeowner
procedure storeowner_OnCreate(Sender: TFrame);
var
    bu: TBGRAButton;
begin
    //Frame Constructor

    //todo: some additional constructing code

    bu := TBGRAButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := 0;
    bu.Width := Sender.Width -3;
    bu.Height := 30;
    bu.Top := 107 - bu.Height;
    bu.Caption := 'Select Store';
    bu.Name := 'bu';
    _setButton(bu);

    TShape(Sender.Find('Shape1')).Pen.Color := HexToColor('#ff5500');
    TShape(Sender.Find('Shape1')).Height := 2;
    TLabel(Sender.Find('lStoreName')).Caption := storeItem.StoreName+' ('+IntToStr(storeItem.AppsInStore)+')';
    TLabel(Sender.Find('lOwnerName')).Caption := storeItem.StoreOwner;
    TLabel(Sender.Find('lPhone')).Caption := storeItem.StorePhone;
    TUrlLink(Sender.Find('UrlLink1')).Caption := storeItem.StoreWeb;
    TUrlLink(Sender.Find('UrlLink1')).Link := storeItem.StoreWeb;
    TUrlLink(Sender.Find('UrlLink2')).Caption := storeItem.StoreEmail;
    TUrlLink(Sender.Find('UrlLink2')).Link := storeItem.StoreEmail;
    TVars(Sender.Find('Vars1')).SetVar('ID', storeItem.StoreID);
    TImage(Sender.Find('Image2')).Visible := storeItem.isPrivate;

    _storeFonts(Sender);

    if OSX then
    TLabel(Sender.Find('lStoreName')).Font.Size := 14
    else
    TLabel(Sender.Find('lStoreName')).Font.Size := 12;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//storeowner initialization constructor
constructor
begin 
end.
