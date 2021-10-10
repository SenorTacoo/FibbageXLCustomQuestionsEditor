unit uFibbageContent;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.Threading,
  uQuestionsLoader,
  uCategoriesLoader,
  uInterfaces;

type
  TFibbageContent = class(TInterfacedObject, IFibbageContent)
  private
    FContentPath: string;
    FCategories: IFibbageCategories;
    FQuestionsLoader: IQuestionsLoader;

    procedure PrepareNewQuestion(out AQuestion: IQuestion; out ACategory: ICategory);
    function GetAvailableId: Word;
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(const AContentPath: string; AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
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

procedure TFibbageContent.PrepareNewQuestion(out AQuestion: IQuestion; out ACategory: ICategory);
begin
  AQuestion := TQuestionItem.Create;
  AQuestion.SetId(FCategories.GetAvailableId);
  ACategory := TCategoryData.Create;
  ACategory.SetId(AQuestion.GetId);
end;

function TFibbageContent.GetAvailableId: Word;
begin
  Result := Random(High(Word) - 1000) + 1000;

end;

function TFibbageContent.GetPath: string;
begin
  Result := FContentPath;
end;

procedure TFibbageContent.Initialize(const AContentPath: string;
  AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
begin
  FContentPath := AContentPath;
  TTask.Create(
  procedure
  begin
    try
      FCategories.LoadCategories(FContentPath);
      FQuestionsLoader.LoadQuestions(FContentPath);
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
  FQuestionsLoader.Questions.Save(TPath.Combine(APath, 'content'));
end;

end.
