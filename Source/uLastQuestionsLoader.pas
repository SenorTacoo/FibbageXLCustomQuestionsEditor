unit uLastQuestionsLoader;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  uInterfaces;

type
  TLastQuestionsLoader = class(TInterfacedObject, ILastQuestionProjects)
  strict private const
    FIBBAGE_DIRECTORY = 'FibbageQE';
    LASTS_FILE_NAME = 'FibbageQE.lasts';
  private
    function GetLastsFile: string;
  public
    procedure Initialize;

    procedure Add(AContent: IFibbageContent);
    function GetAll: TStringList;
  end;

implementation

{ TLastQuestionsLoader }

procedure TLastQuestionsLoader.Add(AContent: IFibbageContent);
begin
  var paths := TStringList.Create;
  try
    paths.StrictDelimiter := True;

    if FileExists(GetLastsFile) then
      paths.LoadFromFile(GetLastsFile);

    var index := paths.IndexOf(AContent.GetPath);
    case index of
      -1: ;
      0: Exit;
      else
        paths.Delete(index);
    end;

    paths.Insert(0, AContent.GetPath);
    paths.SaveToFile(GetLastsFile);
  finally
    paths.Free;
  end;
end;

function TLastQuestionsLoader.GetAll: TStringList;
begin
  Result := TStringList.Create;
  Result.StrictDelimiter := True;

  if not FileExists(GetLastsFile) then
    Exit;
    
  var fs := TFileStream.Create(GetLastsFile, fmOpenRead);
  var sr := TStreamReader.Create(fs);
  try
    while not sr.EndOfStream do
      Result.Add(sr.ReadLine);  
  finally
    fs.Free;
    sr.Free;
  end;
end;

function TLastQuestionsLoader.GetLastsFile: string;
begin
  Result := 
    TPath.Combine(
      TPath.Combine(
        TPath.GetCachePath,
        FIBBAGE_DIRECTORY), 
      LASTS_FILE_NAME);
end;

procedure TLastQuestionsLoader.Initialize;
begin
  ForceDirectories(TPath.Combine(TPath.GetCachePath, FIBBAGE_DIRECTORY));
end;

end.
