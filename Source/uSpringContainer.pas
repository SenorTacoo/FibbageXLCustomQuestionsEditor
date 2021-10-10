unit uSpringContainer;

interface

uses
  Spring.Container,
  uInterfaces,
  uQuestionsLoader,
  uCategoriesLoader,
  uPathChecker,
  uLastQuestionsLoader,
  uContentConfiguration,
  uFibbageContent;

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
  GlobalContainer.RegisterType<ILastQuestionProjects, TLastQuestionsLoader>;
  GlobalContainer.RegisterType<IContentConfiguration, TContentConfiguration>;
  GlobalContainer.Build;

finalization

  GlobalContainer.Free;

end.
