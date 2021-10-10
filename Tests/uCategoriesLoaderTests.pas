unit uCategoriesLoaderTests;

interface

uses
  DUnitX.TestFramework,
  uCategoriesLoader;

type
  TCategoriesLoaderTests = class
  private
    FObj: TCategoriesLoader;
  public
    [SetUp]
    procedure SetUp;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure ShouldPassParsingCategories;

  end;

implementation

{ TCategoriesLoaderTests }

procedure TCategoriesLoaderTests.SetUp;
begin
  FObj := TCategoriesLoader.Create;
end;

procedure TCategoriesLoaderTests.ShouldPassParsingCategories;
begin
  FObj.LoadCategories('..\Files\content\');
end;

procedure TCategoriesLoaderTests.TearDown;
begin
  FObj.Free;
end;

initialization

  TDUnitX.RegisterTestFixture(TCategoriesLoaderTests);

end.
