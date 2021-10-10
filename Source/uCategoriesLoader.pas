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
    function GetId: Integer;
    function GetCategory: string;

    procedure SetId(AId: Integer);
    procedure SetCategory(const ACategory: string);

    function X: Boolean;
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

//    function GetIds: TArray<Cardinal>;
//    function GetCategories: TArray<string>;
    function Count: Integer;
    function Category(AIdx: Integer): ICategory;
    function EpisodeId: Integer;
  end;

  TFibbageCategories = class(TInterfacedObject, IFibbageCategories)
  private
    FContentDir: string;
    FShortieCategories: ICategories;
    FFinalCategories: ICategories;
    procedure LoadFinalCategories;
    procedure LoadShortieCategories;
    function GetCategories(const APath: string): TCategories;
  public
    constructor Create;
    destructor Destroy; override;

    function ShortieCategories: ICategories;
    function FinalCategories: ICategories;

    function GetShortieCategory(AQuestion: IQuestion): ICategory;
    function GetFinalCategory(AQuestion: IQuestion): ICategory;

    procedure LoadCategories(const AContentDir: string);
  end;

implementation

//{ TCategoriesLoader }
//
//function TCategoriesLoader.Categories: IFibbageCategories;
//begin
//  Result := FCategories;
//end;
//
//constructor TCategoriesLoader.Create;
//begin
//  inherited;
//  FCategories := TFibbageCategories.Create;
//end;
//
//destructor TCategoriesLoader.Destroy;
//begin
//  inherited;
//end;
//
//function TCategoriesLoader.GetCategories(const APath: string): TCategories;
//begin
//  var fs := TFileStream.Create(APath, fmOpenRead);
//  var sr := TStreamReader.Create(fs);
//  try
//    Result := TJSON.JsonToObject<TCategories>(sr.ReadToEnd);
//  finally
//    sr.Free;
//    fs.Free;
//  end;
//end;
//
//procedure TCategoriesLoader.LoadCategories(const AContentDir: string);
//begin
//  var shortiePath := IncludeTrailingPathDelimiter(AContentDir) + 'fibbageshortie.jet';
//  var finalPath := IncludeTrailingPathDelimiter(AContentDir) + 'finalfibbage.jet';
//
//  FCategories. ShortieCategories := GetCategories(shortiePath);
//  FCategories.FinalCategories := GetCategories(finalPath);
//end;

{ TFibbageCategories }

constructor TFibbageCategories.Create;
begin
  inherited;
end;

destructor TFibbageCategories.Destroy;
begin
  inherited;
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

procedure TFibbageCategories.LoadFinalCategories;
begin
  var finalPath := IncludeTrailingPathDelimiter(FContentDir) + 'finalfibbage.jet';
  FFinalCategories := GetCategories(finalPath);
end;

function TFibbageCategories.GetCategories(const APath: string): TCategories;
begin
  var fs := TFileStream.Create(APath, fmOpenRead);
  var sr := TStreamReader.Create(fs);
  try
    Result := TJSON.JsonToObject<TCategories>(sr.ReadToEnd);
  finally
    sr.Free;
    fs.Free;
  end;
end;

function TFibbageCategories.GetFinalCategory(AQuestion: IQuestion): ICategory;
begin
  Result := nil;
  for var idx := 0 to FFinalCategories.Count - 1 do
  begin
    var category := FFinalCategories.Category(idx);
    if AQuestion.GetId = category.GetId then
      Exit(category);
  end;
end;

function TFibbageCategories.GetShortieCategory(AQuestion: IQuestion): ICategory;
begin
  Result := nil;
  for var idx := 0 to FShortieCategories.Count - 1 do
  begin
    var category := FShortieCategories.Category(idx);
    if AQuestion.GetId = category.GetId then
      Exit(category);
  end;
end;

procedure TFibbageCategories.LoadCategories(const AContentDir: string);
begin
  FContentDir := AContentDir;

  LoadShortieCategories;
  LoadFinalCategories;
end;

function TFibbageCategories.ShortieCategories: ICategories;
begin
  Result := FShortieCategories;
end;

//{ TCategories }

//function TCategories.GetCategories: TArray<string>;
//begin
//  SetLength(Result, Length(FContent));
//  for var idx := 0 to Length(FContent) - 1 do
//    Result[idx] := FContent[idx].Category;
//end;

//function TCategories.GetIds: TArray<Cardinal>;
//begin
//  SetLength(Result, Length(FContent));
//  for var idx := 0 to Length(FContent) - 1 do
//    Result[idx] := FContent[idx].Id;
//end;

{ TCategories }

function TCategories.Category(AIdx: Integer): ICategory;
begin
  if not FContentListInitialized then
    InitializeContentList;
  Result := FContentList[AIdx] as ICategory;
end;

function TCategories.Count: Integer;
begin
  Result := Length(FContent);
end;

constructor TCategories.Create;
begin
  inherited;
  FContentList := TInterfaceList.Create;
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
  for var item in FContent do
    FContentList.Add(item);
  FContentListInitialized := True;
end;

{ TCategoryData }

function TCategoryData.Bumper: string;
begin
  Result := FBumper;
end;

function TCategoryData.GetCategory: string;
begin
  Result := FCategory;
end;

function TCategoryData.GetId: Integer;
begin
  Result := FId;
end;

procedure TCategoryData.SetCategory(const ACategory: string);
begin
  FCategory := ACategory;
end;

procedure TCategoryData.SetId(AId: Integer);
begin
  FId := AId;
end;

function TCategoryData.X: Boolean;
begin
  Result := FX;
end;

end.
