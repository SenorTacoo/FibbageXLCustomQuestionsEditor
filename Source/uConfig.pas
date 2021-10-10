unit uConfig;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IniFiles;

type
  TAppConfig = class
  strict private const
    APP_CONFIG_NAME = 'FibbageQE.ini';
  strict private class var
    FInstance: TAppConfig;
  public
    class function GetInstance: TAppConfig;
    class destructor Destroy;
  private
    FIniFile: TMemIniFile;
    FDarkModeEnabled: Boolean;
    function GetDarkModeEnabled: Boolean;
    procedure SetDarkModeEnabled(const Value: Boolean);
    function GetLastEditPath: string;
    procedure SetLastEditPath(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property DarkModeEnabled: Boolean read GetDarkModeEnabled write SetDarkModeEnabled;
    property LastEditPath: string read GetLastEditPath write SetLastEditPath;
  end;

implementation

{ TAppConfig }

constructor TAppConfig.Create;
begin
  inherited;
  FIniFile := TMemIniFile.Create(APP_CONFIG_NAME, TEncoding.UTF8, False, False);
  FIniFile.AutoSave := True;
end;

destructor TAppConfig.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

class destructor TAppConfig.Destroy;
begin
  FreeAndNil(FInstance);
end;

function TAppConfig.GetDarkModeEnabled: Boolean;
begin
  Result := FIniFile.ReadBool('Style', 'DarkMode', False);
end;

class function TAppConfig.GetInstance: TAppConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TAppConfig.Create;
  Result := FInstance;
end;

function TAppConfig.GetLastEditPath: string;
begin
  Result := FIniFile.ReadString('Config', 'LastEditPath', '');
end;

procedure TAppConfig.SetDarkModeEnabled(const Value: Boolean);
begin
  FIniFile.WriteBool('Style', 'DarkMode', Value);
end;

procedure TAppConfig.SetLastEditPath(const Value: string);
begin
  FIniFile.WriteString('Config', 'LastEditPath', Value);
end;

end.
