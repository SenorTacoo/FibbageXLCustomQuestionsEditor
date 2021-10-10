unit uSpringContainer;

interface

uses
  Spring.Container,
  uInterfaces,
  uQuestionsLoader,
  uCategoriesLoader,
  uPathChecker,
  uFibbageContent;

//type
//  TAppContainer = class
//  private class var
//    FInstance: TContainer;
//  private
//    class constructor Create;
//    class destructor Destroy
//  public
//
//  end;

var
  GlobalContainer: TContainer;

implementation

initialization

  GlobalContainer := TContainer.Create;

  GlobalContainer.RegisterType<IFibbagePathChecker, TFibbagePathChecker>;
  GlobalContainer.RegisterType<IQuestionsLoader, TQuestionsLoader>;
  GlobalContainer.RegisterType<ICategories, TCategories>;
  GlobalContainer.RegisterType<IFibbageCategories, TFibbageCategories>;
  GlobalContainer.RegisterType<IFibbageContent, TFibbageContent>;
  GlobalContainer.Build;

finalization

  GlobalContainer.Free;

end.
