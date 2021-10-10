unit uQuestionsLoaderTests;

interface

uses
  DUnitX.TestFramework,
  uQuestionsLoader;

type
  [TestFixture]
  TQuestionLoaderTests = class
  private
    FObj: TQuestionsLoader;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure ShouldPassAndReturnValidObject;
  end;

implementation

procedure TQuestionLoaderTests.Setup;
begin
  FObj := TQuestionsLoader.Create;
end;

procedure TQuestionLoaderTests.ShouldPassAndReturnValidObject;
begin
  FObj.LoadQuestions('..\Files\content\');
end;

procedure TQuestionLoaderTests.TearDown;
begin
  FObj.Free;
end;

initialization

  TDUnitX.RegisterTestFixture(TQuestionLoaderTests);

end.
