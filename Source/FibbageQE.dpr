program FibbageQE;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm in 'uMainForm.pas' {FrmMain},
  uConfig in 'uConfig.pas',
  uInterfaces in 'uInterfaces.pas',
  uPathChecker in 'uPathChecker.pas',
  uQuestionsLoader in 'uQuestionsLoader.pas',
  uCategoriesLoader in 'uCategoriesLoader.pas',
  uFibbageContent in 'uFibbageContent.pas',
  uSpringContainer in 'uSpringContainer.pas',
  GameAudioManager in 'GameAudioManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
