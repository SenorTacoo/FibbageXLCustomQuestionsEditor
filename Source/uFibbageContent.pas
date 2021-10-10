unit uFibbageContent;

interface

uses
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
    FProjectPath: string;
    FCategories: IFibbageCategories;
    FQuestionsLoader: IQuestionsLoader;
    procedure SaveManifest(const APath: string);
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(AConfiguration: IContentConfiguration; AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);

    procedure Save(const APath: string);

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
  Result := FProjectPath;
end;

procedure TFibbageContent.Initialize(AConfiguration: IContentConfiguration;
  AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
begin
  FProjectPath := AConfiguration.GetPath;
  TTask.Create(
    procedure
    begin
      try
        FCategories.LoadCategories(FProjectPath);
        FQuestionsLoader.LoadQuestions(FProjectPath);

        if Assigned(AOnContentInitialized) then
          AOnContentInitialized;
      except
        on E: Exception do
          if Assigned(AOnContentError) then
            AOnContentError(E.Message);
      end;
    end).Start;
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

procedure TFibbageContent.Save(const APath: string);
begin
  FQuestionsLoader.Questions.Save(APath);
  FCategories.Save(APath);
  SaveManifest(APath);
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

end.
