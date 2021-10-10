unit uFibbageContent;

interface

uses
  uLog,
  System.IOUtils,
  System.SysUtils,
  System.Threading,
  System.Classes,
  uQuestionsLoader,
  uCategoriesLoader,
  uInterfaces;

type
  TFibbageContent = class(TInterfacedObject, IFibbageContent)
  private
    FConfig: IContentConfiguration;
    FCategories: IFibbageCategories;
    FQuestionsLoader: IQuestionsLoader;
    procedure SaveManifest;
    procedure PrepareBackup(const APath: string);
    procedure RemoveBackup(const APath: string);
    procedure RestoreBackup(const APath: string);
    procedure PostSaveFailed;
    procedure PostSaveSuccessful;
    procedure PreSave;
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(AConfiguration: IContentConfiguration);

    procedure Save;

    procedure AddShortieQuestion;
    procedure AddFinalQuestion;

    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
  end;

implementation

{ TFibbageContent }

procedure TFibbageContent.AddFinalQuestion;
begin
  var id := FCategories.CreateNewFinalCategory;
  var question := TQuestionItem.Create;
  question.SetId(id);
  question.SetQuestionType(qtFinal);
  question.SetDefaults;

  FQuestionsLoader.Questions.FinalQuestions.Add(question);
end;

procedure TFibbageContent.AddShortieQuestion;
begin
  var id := FCategories.CreateNewShortieCategory;
  var question := TQuestionItem.Create;
  question.SetId(id);
  question.SetQuestionType(qtShortie);
  question.SetDefaults;

  FQuestionsLoader.Questions.ShortieQuestions.Add(question);
end;

function TFibbageContent.Categories: IFibbageCategories;
begin
  Result := FCategories;
end;

constructor TFibbageContent.Create(ACategories: IFibbageCategories;
  AQuestionsLoader: IQuestionsLoader);
begin
  inherited Create;
  FCategories := ACategories;
  FQuestionsLoader := AQuestionsLoader;
end;

function TFibbageContent.GetPath: string;
begin
  Result := FConfig.GetPath;
end;

procedure TFibbageContent.Initialize(AConfiguration: IContentConfiguration);
begin
  FConfig := AConfiguration;

  FCategories.LoadCategories(GetPath);
  FQuestionsLoader.LoadQuestions(GetPath);
end;

function TFibbageContent.Questions: IFibbageQuestions;
begin
  Result := FQuestionsLoader.Questions;
end;

procedure TFibbageContent.RemoveFinalQuestion(AQuestion: IQuestion);
begin
  FCategories.RemoveFinalCategory(AQuestion);
  FQuestionsLoader.Questions.RemoveFinalQuestion(AQuestion);
end;

procedure TFibbageContent.RemoveShortieQuestion(AQuestion: IQuestion);
begin
  FCategories.RemoveShortieCategory(AQuestion);
  FQuestionsLoader.Questions.RemoveShortieQuestion(AQuestion);
end;

procedure TFibbageContent.PrepareBackup(const APath: string);
begin
  if DirectoryExists(APath) then
  begin
    if DirectoryExists(APath + '_backup') then
      TDirectory.Delete(APath + '_backup', True);
    TDirectory.Move(APath, APath + '_backup');
  end;
end;

procedure TFibbageContent.RemoveBackup(const APath: string);
begin
  if DirectoryExists(APath + '_backup') then
    TDirectory.Delete(APath + '_backup', True);
end;

procedure TFibbageContent.RestoreBackup(const APath: string);
begin
  if DirectoryExists(APath + '_backup') then
  begin
    if TDirectory.Exists(APath) then
      TDirectory.Delete(APath);
    TDirectory.Move(APath + '_backup', APath);
  end;
end;

procedure TFibbageContent.PreSave;
begin
  PrepareBackup(FConfig.GetPath);
end;

procedure TFibbageContent.PostSaveSuccessful;
begin
  RemoveBackup(FConfig.GetPath);
end;

procedure TFibbageContent.PostSaveFailed;
begin
  RestoreBackup(FConfig.GetPath);
end;

procedure TFibbageContent.Save;
begin
  var path := FConfig.GetPath;
  PreSave;
  try
    FConfig.Save(path);
    FQuestionsLoader.Questions.Save(path);
    FCategories.Save(path);
    SaveManifest;

    PostSaveSuccessful;
  except
    on E: Exception do
    begin
      LogE('save exception %s/%s', [E.Message, E.ClassName]);
      PostSaveFailed;
    end;
  end;
end;

procedure TFibbageContent.SaveManifest;
begin
  var fs := TFileStream.Create(TPath.Combine(FConfig.GetPath, 'manifest.jet'), fmCreate);
  var sw := TStreamWriter.Create(fs);
  try
    sw.WriteLine('{ "id":"Main", "name":"Main Content Pack", "types":["fibbageshortie","finalfibbage"] }');
  finally
    sw.Free;
    fs.Free;
  end;
end;

end.
