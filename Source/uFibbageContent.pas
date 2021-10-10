unit uFibbageContent;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.Threading,
  uInterfaces;

type
  TFibbageContent = class(TInterfacedObject, IFibbageContent)
  private
    FCategories: IFibbageCategories;
    FQuestionsLoader: IQuestionsLoader;
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;

    procedure Initialize(const AContentPath: string; AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
    procedure Save(const APath: string);
  end;

implementation

{ TFibbageContent }

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

procedure TFibbageContent.Initialize(const AContentPath: string;
  AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
begin
  TTask.Create(
  procedure
  begin
    try
      FCategories.LoadCategories(AContentPath);
      FQuestionsLoader.LoadQuestions(AContentPath);
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

procedure TFibbageContent.Save(const APath: string);
begin
  FQuestionsLoader.Questions.Save(TPath.Combine(APath, 'content'));
end;

end.
