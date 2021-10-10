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
    FContentPath: string;
    FCategories: IFibbageCategories;
    FQuestionsLoader: IQuestionsLoader;
  public
    constructor Create(ACategories: IFibbageCategories; AQuestionsLoader: IQuestionsLoader);

    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

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

procedure TFibbageContent.Save(const APath: string);
begin
  FQuestionsLoader.Questions.Save(TPath.Combine(APath, 'content'));
end;

end.
