unit uPathChecker;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  uInterfaces;

type
  TFibbagePathChecker = class(TInterfacedObject, IFibbagePathChecker)
  public
    function IsValid(const APath: string): Boolean;
  end;


implementation

{ TFibbagePathChecker }

function TFibbagePathChecker.IsValid(const APath: string): Boolean;
begin
  Result := False;
  if not DirectoryExists(APath) then
    Exit;

  if not DirectoryExists(IncludeTrailingPathDelimiter(APath) +
    IncludeTrailingPathDelimiter('fibbageshortie')) then
    Exit;

  if not DirectoryExists(IncludeTrailingPathDelimiter(APath) +
    IncludeTrailingPathDelimiter('finalfibbage')) then
    Exit;

  Result := True;
end;

end.
