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
    procedure SaveManifest(const APath: string);
    procedure PrepareBackup(const APath: string);
    procedure RemoveBackup(const APath: string);
    procedure RestoreBackup(const APath: string);
    procedure PostSaveFailed(const APath: string);
    procedure PostSaveSuccessful(const APath: string);
    procedure PreSave(const APath: string);
    procedure InnerSave(const APath: string; ASaveOptions: TSaveOptions = []);
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(AConfiguration: IContentConfiguration);

    procedure Save; overload;
    procedure Save(const APath: string; ASaveOptions: TSaveOptions = []); overload;

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

procedure TFibbageContent.PreSave(const APath: string);
begin
  PrepareBackup(APath);
end;

procedure TFibbageContent.PostSaveSuccessful(const APath: string);
begin
  RemoveBackup(APath);
end;

procedure TFibbageContent.PostSaveFailed(const APath: string);
begin
  RestoreBackup(APath);
end;

procedure TFibbageContent.InnerSave(const APath: string; ASaveOptions: TSaveOptions = []);
begin
  PreSave(APath);
  try
    if not (soDoNotSaveConfig in ASaveOptions) then
      FConfig.Save(APath);
    FQuestionsLoader.Questions.Save(APath);
    FCategories.Save(APath);
    SaveManifest(APath);

    PostSaveSuccessful(APath);
  except
    on E: Exception do
    begin
      LogE('save exception %s/%s', [E.Message, E.ClassName]);
      PostSaveFailed(APath);
    end;
  end;
end;

procedure TFibbageContent.Save;
begin
  InnerSave(FConfig.GetPath);
end;

procedure TFibbageContent.SaveManifest(const APath: string);
begin
  var fs := TFileStream.Create(TPath.Combine(APath, 'manifest.jet'), fmCreate);
  var sw := TStreamWriter.Create(fs);
  try
    sw.WriteLine('{ "id":"Main", "name":"Main Content Pack", "types":["fibbageshortie","finalfibbage"] }');
  finally
    sw.Free;
    fs.Free;
  end;
end;

procedure TFibbageContent.Save(const APath: string; ASaveOptions: TSaveOptions = []);
begin
  InnerSave(APath, ASaveOptions);
end;

end.
