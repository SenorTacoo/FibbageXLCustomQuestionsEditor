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
    FCategoriesLoader: ICategoriesLoader;
    FQuestionsLoader: IQuestionsLoader;
  public
    constructor Create(ACategoriesLoader: ICategoriesLoader; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    procedure Initialize(const AContentPath: string; AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
    procedure Save(const APath: string);
  end;

implementation

{ TFibbageContent }

constructor TFibbageContent.Create(ACategoriesLoader: ICategoriesLoader;
  AQuestionsLoader: IQuestionsLoader);
begin
  inherited Create;    // kategorie ogarnąć i korzystać z contentu
  FCategoriesLoader := ACategoriesLoader;
  FQuestionsLoader := AQuestionsLoader;
end;

procedure TFibbageContent.Initialize(const AContentPath: string;
  AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
begin
  TTask.Create(
  procedure
  begin
    try
      FCategoriesLoader.LoadCategories(AContentPath);
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
