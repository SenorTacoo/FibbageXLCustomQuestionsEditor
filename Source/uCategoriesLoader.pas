unit uCategoriesLoader;

interface

uses
  REST.JSON,
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  uInterfaces;

type
  TCategoryData = class(TInterfacedObject, ICategory)
  private
    FX: Boolean;
    FId: Cardinal;
    FCategory: string;
    FBumper: string;
  public
    property X: Boolean read FX write FX;
    property Id: Cardinal read FId write FId;
    property Category: string read FCategory write FCategory;
    property Bumper: string read FBumper write FBumper;
  end;

  TCategories = class(TInterfacedObject, ICategories)
  private
    FContent: TArray<TCategoryData>;
    FEpisodeId: Integer;
  public
    property Content: TArray<TCategoryData> read FContent write FContent;
    property EpisodeId: Integer read FEpisodeId write FEpisodeId;
  end;

  TFibbageCategories = class(TInterfacedObject, IFibbageCategories)
  private
    FShortieCategories: ICategories;
    FFinalCategories: ICategories;
  public
    constructor Create;
    destructor Destroy; override;

    function ShortieCategories: ICategories;
    function FinalCategories: ICategories;
  end;

  TCategoriesLoader = class(TInterfacedObject, ICategoriesLoader)
  private
    FCategories: IFibbageCategories;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadCategories(const AContentDir: string);      
    function Categories: IFibbageCategories;
  end;

implementation

{ TCategoriesLoader }

function TCategoriesLoader.Categories: IFibbageCategories;
begin
  Result := FCategories;
end;

constructor TCategoriesLoader.Create;
begin
  inherited;
  FCategories := TFibbageCategories.Create;
end;

destructor TCategoriesLoader.Destroy;
begin
//  FCategories.Free;
  inherited;
end;

procedure TCategoriesLoader.LoadCategories(const AContentDir: string);
var
  fs: TFileStream;
  sr: TStreamReader;
  categories: TCategories;
begin
  var shortiePath := IncludeTrailingPathDelimiter(AContentDir) + 'fibbageshortie.jet';
  var finalPath := IncludeTrailingPathDelimiter(AContentDir) + 'finalfibbage.jet';

  fs := TFileStream.Create(shortiePath, fmOpenRead);
  sr := TStreamReader.Create(fs);
  try
//    FCategories.ShortieCategories := TJSON.JsonToObject<TCategories>(sr.ReadToEnd);
  finally
    sr.Free;
    fs.Free;
  end;

  fs := TFileStream.Create(finalPath, fmOpenRead);
  sr := TStreamReader.Create(fs);
  try
//    FCategories.FinalCategories := TJSON.JsonToObject<TCategories>(sr.ReadToEnd);
  finally
    sr.Free;
    fs.Free;
  end;
end;

{ TFibbageCategories }

constructor TFibbageCategories.Create;
begin
  inherited;
//  FShortieCategories := TList<ICategory>.Create;
//  FFinalCategories := TList<ICategory>.Create;
end;

destructor TFibbageCategories.Destroy;
begin
//  FShortieCategories.Free;
//  FFinalCategories.Free;
  inherited;
end;

function TFibbageCategories.FinalCategories: ICategories;
begin
  Result := FFinalCategories;
end;

function TFibbageCategories.ShortieCategories: ICategories;
begin
  Result := FShortieCategories;
end;

end.
