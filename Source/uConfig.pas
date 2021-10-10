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
    DEFAULT_LOGGING_BROKER = 'tcp:/' + '/localhost:7337';
    DEFAULT_LOGGING_SERVICE = 'Default';
  strict private class var
    FInstance: TAppConfig;
  public
    class function GetInstance: TAppConfig;
    class destructor Destroy;
  private
    FIniFile: TMemIniFile;
    FDarkModeEnabled: Boolean;
    FLogBroker: string;
    FLogService: string;
    function GetDarkModeEnabled: Boolean;
    procedure SetDarkModeEnabled(const Value: Boolean);
    function GetLastEditPath: string;
    procedure SetLastEditPath(const Value: string);
    function GetInputDeviceName: string;
    function GetOutputDeviceName: string;
    procedure SetInputDeviceName(const Value: string);
    procedure SetOutputDeviceName(const Value: string);
    function GetLogBroker: string;
    function GetLogService: string;
    procedure SetLogBroker(const Value: string);
    procedure SetLogService(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    property DarkModeEnabled: Boolean read GetDarkModeEnabled write SetDarkModeEnabled;
    property LastEditPath: string read GetLastEditPath write SetLastEditPath;
    property OutputDeviceName: string read GetOutputDeviceName write SetOutputDeviceName;
    property InputDeviceName: string read GetInputDeviceName write SetInputDeviceName;
    property LogBroker: string read GetLogBroker write SetLogBroker;
    property LogService: string read GetLogService write SetLogService;
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

function TAppConfig.GetInputDeviceName: string;
begin
  Result := FIniFile.ReadString('Audio', 'InputDeviceName', '');
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

function TAppConfig.GetLogBroker: string;
begin
  Result := FIniFile.ReadString('Logging', 'LogBroker', DEFAULT_LOGGING_BROKER);
end;

function TAppConfig.GetLogService: string;
begin
  Result := FIniFile.ReadString('Logging', 'LogService', DEFAULT_LOGGING_SERVICE);
end;

function TAppConfig.GetOutputDeviceName: string;
begin
  Result := FIniFile.ReadString('Audio', 'OutputDeviceName', '');
end;

procedure TAppConfig.SetDarkModeEnabled(const Value: Boolean);
begin
  FIniFile.WriteBool('Style', 'DarkMode', Value);
end;

procedure TAppConfig.SetInputDeviceName(const Value: string);
begin
  FIniFile.WriteString('Audio', 'InputDeviceName', Value);
end;

procedure TAppConfig.SetLastEditPath(const Value: string);
begin
  FIniFile.WriteString('Config', 'LastEditPath', Value);
end;

procedure TAppConfig.SetLogBroker(const Value: string);
begin
  FIniFile.WriteString('Logging', 'LogBroker', Value);
end;

procedure TAppConfig.SetLogService(const Value: string);
begin
  FIniFile.WriteString('Logging', 'LogService', Value);
end;

procedure TAppConfig.SetOutputDeviceName(const Value: string);
begin
  FIniFile.WriteString('Audio', 'OutputDeviceName', Value);
end;

end.
