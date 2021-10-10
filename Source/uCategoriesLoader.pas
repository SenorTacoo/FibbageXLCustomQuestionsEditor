unit uCategoriesLoader;

interface

uses
  REST.JSON,
  REST.Json.Types,
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  uInterfaces;

type
  TCategoryData = class(TInterfacedObject, ICategory)
  private
    FX: Boolean;
    FId: Integer;
    FCategory: string;
    FBumper: string;
  public
    procedure CloneFrom(AObj: ICategory);

    function GetId: Integer;
    function GetCategory: string;
    function GetIsFamilyFriendly: Boolean;

    procedure SetId(AId: Integer);
    procedure SetCategory(const ACategory: string);
    procedure SetIsFamilyFriendly(AValue: Boolean);

    function Bumper: string;
  end;

  TCategories = class(TInterfacedObject, ICategories)
  private
    FContent: TArray<TCategoryData>;
    FEpisodeId: Integer;

    [JSONMarshalledAttribute(False)]
    FContentList: TInterfaceList;
    [JSONMarshalledAttribute(False)]
    FContentListInitialized: Boolean;
    procedure InitializeContentList;
  public
    constructor Create;
    destructor Destroy; override;

    function Count: Integer;
    function Category(AIdx: Integer): ICategory;
    function EpisodeId: Integer;

    procedure Add(ACategory: ICategory);
    procedure Delete(AId: Integer);

    procedure Save(const APath, AName: string);
  end;

  TFibbageCategories = class(TInterfacedObject, IFibbageCategories)
  private
    FContentDir: string;
    FShortieCategories: ICategories;
    FFinalCategories: ICategories;
    procedure LoadFinalCategories;
    procedure LoadShortieCategories;
    function GetCategories(const APath: string): TCategories;
    function CreateNewCategory: ICategory;
    function GetAvailableId: Word;
  public
    function ShortieCategories: ICategories;
    function FinalCategories: ICategories;

    function GetShortieCategory(AQuestion: IQuestion): ICategory;
    function GetFinalCategory(AQuestion: IQuestion): ICategory;

    procedure LoadCategories(const AContentDir: string);
    function CreateNewShortieCategory: ICategory;
    function CreateNewFinalCategory: ICategory;
    procedure RemoveShortieCategory(AQuestion: IQuestion);
    procedure RemoveFinalCategory(AQuestion: IQuestion);
    procedure Save(const APath: string);
  end;

implementation

{ TFibbageCategories }

function TFibbageCategories.CreateNewCategory: ICategory;
begin
  Result := TCategoryData.Create;
  Result.SetId(GetAvailableId);
end;

function TFibbageCategories.CreateNewFinalCategory: ICategory;
begin
  var newCategory := CreateNewCategory;
  FFinalCategories.Add(newCategory);
  Result := newCategory;
end;

function TFibbageCategories.CreateNewShortieCategory: ICategory;
begin
  var newCategory := CreateNewCategory;
  FShortieCategories.Add(newCategory);
  Result := newCategory;
end;

function TFibbageCategories.FinalCategories: ICategories;
begin
  Result := FFinalCategories;
end;

procedure TFibbageCategories.LoadShortieCategories;
begin
  var shortiePath := IncludeTrailingPathDelimiter(FContentDir) + 'fibbageshortie.jet';
  FShortieCategories := GetCategories(shortiePath);
end;

procedure TFibbageCategories.RemoveShortieCategory(AQuestion: IQuestion);
begin
  FShortieCategories.Delete(AQuestion.GetId);
end;

procedure TFibbageCategories.RemoveFinalCategory(AQuestion: IQuestion);
begin
  FFinalCategories.Delete(AQuestion.GetId);
end;

procedure TFibbageCategories.LoadFinalCategories;
begin
  var finalPath := IncludeTrailingPathDelimiter(FContentDir) + 'finalfibbage.jet';
  FFinalCategories := GetCategories(finalPath);
end;

function TFibbageCategories.GetAvailableId: Word;
var
  res: Boolean;
  idx: Integer;
begin
  while True do
  begin
    Result := Random(High(Word) - 1000) + 1000;

    res := True;
    idx := 0;
    while idx < FShortieCategories.Count - 1 do
    begin
      if FShortieCategories.Category(idx).GetId = Result then
      begin
        res := False;
        Break;
      end;
      Inc(idx);
    end;

    if res then
    begin
      res := True;
      idx := 0;
      while idx < FFinalCategories.Count - 1 do
      begin
        if FFinalCategories.Category(idx).GetId = Result then
        begin
          res := False;
          Break;
        end;
        Inc(idx);
      end;
      if res then
        Break;
    end;
  end;
end;

function TFibbageCategories.GetCategories(const APath: string): TCategories;
begin
  if FileExists(APath) then
  begin
    var fs := TFileStream.Create(APath, fmOpenRead);
    var sr := TStreamReader.Create(fs);
    try
      Result := TJSON.JsonToObject<TCategories>(sr.ReadToEnd);
    finally
      sr.Free;
      fs.Free;
    end;
  end
  else
    Result := TCategories.Create;
end;

function TFibbageCategories.GetFinalCategory(AQuestion: IQuestion): ICategory;
var
  bestCategory: ICategory;
begin
  Result := nil;
  for var idx := 0 to FFinalCategories.Count - 1 do
  begin
    var category := FFinalCategories.Category(idx);
    if (AQuestion.GetId = category.GetId) then
      if SameText(AQuestion.GetCategory, category.GetCategory) then
        Exit(category)
      else
        bestCategory := category;
  end;
  Result := bestCategory;
end;

function TFibbageCategories.GetShortieCategory(AQuestion: IQuestion): ICategory;
var
  bestCategory: ICategory;
begin
  bestCategory := nil;
  for var idx := 0 to FShortieCategories.Count - 1 do
  begin
    var category := FShortieCategories.Category(idx);
    if (AQuestion.GetId = category.GetId) then
      if SameText(AQuestion.GetCategory, category.GetCategory) then
        Exit(category)
      else
        bestCategory := category;
  end;
  Result := bestCategory;
end;

procedure TFibbageCategories.LoadCategories(const AContentDir: string);
begin
  FContentDir := AContentDir;

  LoadShortieCategories;
  LoadFinalCategories;
end;

procedure TFibbageCategories.Save(const APath: string);
begin
  ShortieCategories.Save(APath, 'fibbageshortie');
  FinalCategories.Save(APath, 'finalfibbage');
end;

function TFibbageCategories.ShortieCategories: ICategories;
begin
  Result := FShortieCategories;
end;

{ TCategories }

procedure TCategories.Add(ACategory: ICategory);
begin
  FContentList.Add(ACategory);
end;

function TCategories.Category(AIdx: Integer): ICategory;
begin
  if not FContentListInitialized then
    InitializeContentList;
  Result := FContentList[AIdx] as ICategory;
end;

function TCategories.Count: Integer;
begin
  if not FContentListInitialized then
    InitializeContentList;
  Result := FContentList.Count;
end;

constructor TCategories.Create;
begin
  inherited;
  FContentList := TInterfaceList.Create;
end;

procedure TCategories.Delete(AId: Integer);
begin
  for var idx := Count - 1 downto 0 do
    if Category(idx).GetId = AId then
    begin
      FContentList.Delete(idx);
      Break;
    end;
end;

destructor TCategories.Destroy;
begin
  FContentList.Free;
  inherited;
end;

function TCategories.EpisodeId: Integer;
begin
  Result := FEpisodeId;
end;

procedure TCategories.InitializeContentList;
begin
  FContentList.Clear;
  for var item in FContent do
    FContentList.Add(item);
  FContentListInitialized := True;
end;

procedure TCategories.Save(const APath, AName: string);
begin
  if FContentListInitialized then
  begin
    SetLength(FContent, FContentList.Count);
    for var idx := 0 to FContentList.Count - 1 do
    begin
      var item := TCategoryData.Create;
      item.CloneFrom((FContentList[idx] as ICategory));
      FContent[idx] := item;
    end;
  end;

  InitializeContentList;

  var test := TJson.ObjectToJsonString(Self);
  var fs := TFileStream.Create(TPath.Combine(APath, AName + '.jet'), fmCreate);
  var sw := TStreamWriter.Create(fs);
  try
    sw.WriteLine(test);
  finally
    sw.Free;
    fs.Free;
  end;
end;

{ TCategoryData }

function TCategoryData.Bumper: string;
begin
  Result := FBumper;
end;

procedure TCategoryData.CloneFrom(AObj: ICategory);
begin
  SetId(AObj.GetId);
  SetCategory(AObj.GetCategory);
  SetIsFamilyFriendly(AObj.GetIsFamilyFriendly);
end;

function TCategoryData.GetCategory: string;
begin
  Result := FCategory;
end;

function TCategoryData.GetId: Integer;
begin
  Result := FId;
end;

function TCategoryData.GetIsFamilyFriendly: Boolean;
begin
  Result := not FX;
end;

procedure TCategoryData.SetCategory(const ACategory: string);
begin
  FCategory := ACategory;
end;

procedure TCategoryData.SetId(AId: Integer);
begin
  FId := AId;
end;

procedure TCategoryData.SetIsFamilyFriendly(AValue: Boolean);
begin
  FX := not AValue;
end;

end.
