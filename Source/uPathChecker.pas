unit uPathChecker;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  uInterfaces;

type
  TContentPathChecker = class(TInterfacedObject, IContentPathChecker)
  public
    function IsValid(const APath: string): Boolean;
  end;


implementation

{ TContentPathChecker }

function TContentPathChecker.IsValid(const APath: string): Boolean;
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
