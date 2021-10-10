unit uContentConfiguration;

interface

uses
  uInterfaces,
  System.IOUtils,
  System.StrUtils,
  System.SysUtils,
  System.Classes;

type
  TContentConfiguration = class(TInterfacedObject, IContentConfiguration)
  private
    FRawCfg: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetName(const AName: string);
    procedure SetPath(const APath: string);

    function GetName: string;
    function GetPath: string;

    function Initialize(const APath: string): Boolean;
    procedure Save(const APath: string);
  end;

implementation

{ TContentConfiguration }

constructor TContentConfiguration.Create;
begin
  inherited;
  FRawCfg := TStringList.Create;
  FRawCfg.StrictDelimiter := True;
end;

destructor TContentConfiguration.Destroy;
begin
  FRawCfg.Free;
  inherited;
end;

function TContentConfiguration.GetName: string;
begin
  Result := FRawCfg.Values['ProjectName'];
  if Result.IsEmpty then
    Result := GetPath;
end;

function TContentConfiguration.GetPath: string;
begin
  Result := FRawCfg.Values['ProjectPath'];
end;

function TContentConfiguration.Initialize(const APath: string): Boolean;
begin
  Result := False;
  if FileExists(TPath.Combine(APath, '.fcqeinfo')) then
  begin
    Result := True;
    FRawCfg.LoadFromFile(TPath.Combine(APath, '.fcqeinfo'));
  end;
  SetPath(APath);
end;

procedure TContentConfiguration.Save(const APath: string);
begin
  ForceDirectories(APath);
  FRawCfg.SaveToFile(TPath.Combine(APath, '.fcqeinfo'));
end;

procedure TContentConfiguration.SetName(const AName: string);
begin
  FRawCfg.Values['ProjectName'] := AName;
end;

procedure TContentConfiguration.SetPath(const APath: string);
begin
  FRawCfg.Values['ProjectPath'] := APath;
end;

end.
