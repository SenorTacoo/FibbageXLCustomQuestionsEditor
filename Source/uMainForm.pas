unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.Layouts, uConfig,
  Spring.Container, uInterfaces, uPathChecker, System.IOUtils,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Data.Bind.GenData, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Platform, uQuestionsLoader, uSpringContainer, System.Math,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Media,
  ACS_Classes, ACS_DXAudio, ACS_Vorbis, ACS_Converters, ACS_Wave,
  NewACDSAudio, System.Generics.Collections, uRecordForm;

type
  TFibbageSoundType = (fstNone, fstQuestion, fstAnswer, fstBumper); // TODO

  TFrmMain = class(TForm)
    MultiView1: TMultiView;
    bMenu: TButton;
    bExportQuestions: TButton;
    bImportQuestions: TButton;
    alMain: TActionList;
    ToolBar1: TToolBar;
    bMinimize: TButton;
    bMaximize: TButton;
    bClose: TButton;
    aWindowClose: TWindowClose;
    aWindowMinimize: TAction;
    aWindowMaximize: TAction;
    aWindowNormal: TAction;
    lCaption: TLabel;
    tcEditTabs: TTabControl;
    tiShortieQuestions: TTabItem;
    tiEditSingleItem: TTabItem;
    lvEditAllItems: TListView;
    pbsAllItems: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    aiContentLoading: TAniIndicator;
    lyDarkMode: TLayout;
    sDarkMode: TSwitch;
    lDarkMode: TLabel;
    aGoToQuestionDetails: TChangeTabAction;
    bGoBackFromDetails: TButton;
    lySingleItemControls: TLayout;
    lySingleItemQuestion: TLayout;
    pSingleItemQuestion: TPanel;
    lSingleItemQuestion: TLabel;
    mSingleItemQuestion: TMemo;
    lySingleItemAnswer: TLayout;
    pSingleItemAnswer: TPanel;
    lSingleItemAnswer: TLabel;
    mSingleItemAnswer: TMemo;
    lySingleItemAlternateSpelling: TLayout;
    pSingleItemAlternateSpelling: TPanel;
    lSingleItemAlternateSpelling: TLabel;
    mSingleItemAlternateSpelling: TMemo;
    lySingleItemSuggestions: TLayout;
    pSingleItemSuggestions: TPanel;
    lSingleItemSuggestions: TLabel;
    mSingleItemSuggestions: TMemo;
    lySingleItemPossibleAnswers: TLayout;
    sSingleItemPossibleAnswers: TSplitter;
    Splitter1: TSplitter;
    lySingleItemAudio: TLayout;
    pSingleItemAudio: TPanel;
    lSingleItemAudio: TLabel;
    MediaPlayer1: TMediaPlayer;
    tiFinalQuestions: TTabItem;
    lyContent: TLayout;
    aGoToFinalQuestions: TChangeTabAction;
    aGoToShortieQuestions: TChangeTabAction;
    tiQuestions: TTabItem;
    tcQuestions: TTabControl;
    aGoToAllQuestions: TChangeTabAction;
    lvFinalQuestions: TListView;
    GridPanelLayout1: TGridPanelLayout;
    bSingleItemQuestionAudio: TButton;
    bSingleItemCorrectAudio: TButton;
    bSingleItemBumperAudio: TButton;
    lySingleItemAdditionalInfo: TLayout;
    pSingleItemId: TPanel;
    lSingleItemId: TLabel;
    pSingleItemCategory: TPanel;
    lSingleItemCategory: TLabel;
    lySingleItemBase: TLayout;
    lySingleItemId: TLayout;
    lySingleItemCategory: TLayout;
    Splitter4: TSplitter;
    eSingleItemId: TEdit;
    eSingleItemCategory: TEdit;
    sbLightStyle: TStyleBook;
    sbDarkStyle: TStyleBook;
    procedure aWindowMinimizeExecute(Sender: TObject);
    procedure aWindowMaximizeExecute(Sender: TObject);
    procedure aWindowNormalExecute(Sender: TObject);
    procedure sDarkModeSwitch(Sender: TObject);
    procedure lDarkModeClick(Sender: TObject);
    procedure ToolBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ToolBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure lyGameDirectoryPathClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bImportQuestionsClick(Sender: TObject);
    procedure bExportQuestionsClick(Sender: TObject);
    procedure lvEditAllItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvEditAllItemsKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure lvEditAllItemsDblClick(Sender: TObject);
    procedure Panel1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure bSingleItemQuestionAudioClick(Sender: TObject);
    procedure bSingleItemCorrectAudioClick(Sender: TObject);
    procedure bSingleItemBumperAudioClick(Sender: TObject);
    procedure aGoToQuestionDetailsUpdate(Sender: TObject);
    procedure aGoToFinalQuestionsUpdate(Sender: TObject);
    procedure aGoToShortieQuestionsUpdate(Sender: TObject);
    procedure lvFinalQuestionsDblClick(Sender: TObject);
    procedure lvFinalQuestionsKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure DSAudioOut1Progress(Sender: TComponent);
    procedure DSAudioOut1Done(Sender: TComponent);
    procedure voMicSyncDone(Sender: TComponent);
    procedure FormDestroy(Sender: TObject);
  private
    FMouseDownPt: TPoint;
    FAppCreated: Boolean;
    FMic: TVorbisOut;
//    FSoundMgr: TGameAudioManager;
//    FContainer: TContainer;
//    FLoader: IQuestionsLoader;
    FContent: IFibbageContent;
    FLastActiveTab: TTabItem;
    FSelectedQuestion: IQuestion;
    FSelectedCategory: ICategory;
    FCurrentRecordingType: TFibbageSoundType;
    procedure OnContentInitialized;
    procedure OnContentError(const AError: string);
    procedure PopulateListView(AQuestions: TList<IQuestion>;
      AListView: TListView);
    procedure PlaySound(const APath: string);
    procedure StartRecording(ASoundType: TFibbageSoundType);
    procedure StopRecording;
    procedure OnStartRecord;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.aGoToFinalQuestionsUpdate(Sender: TObject);
begin
  FLastActiveTab := tiFinalQuestions;
end;

procedure TFrmMain.aGoToShortieQuestionsUpdate(Sender: TObject);
begin
  FLastActiveTab := tiShortieQuestions;
end;

procedure TFrmMain.aGoToQuestionDetailsUpdate(Sender: TObject);
begin
  mSingleItemQuestion.Text := FSelectedQuestion.Question;
  mSingleItemAnswer.Text := FSelectedQuestion.Answer;
  mSingleItemAlternateSpelling.Text :=  FSelectedQuestion.AlternateSpelling.Replace(',', ', ');
  mSingleItemSuggestions.Text := FSelectedQuestion.Suggestions.Replace(',', ', ');
  eSingleItemId.Text := FSelectedCategory.Id.ToString;
  eSingleItemCategory.Text := FSelectedCategory.Category;
  bSingleItemQuestionAudio.Enabled := (not FSelectedQuestion.QuestionAudioPath.IsEmpty) and FileExists(FSelectedQuestion.QuestionAudioPath);
  bSingleItemCorrectAudio.Enabled := (not FSelectedQuestion.CorrectItemAudioPath.IsEmpty) and FileExists(FSelectedQuestion.CorrectItemAudioPath);
  bSingleItemBumperAudio.Enabled := (not FSelectedQuestion.BumperAudioPath.IsEmpty) and FileExists(FSelectedQuestion.BumperAudioPath);
end;

procedure TFrmMain.aWindowMaximizeExecute(Sender: TObject);
begin
  WindowState := TWindowState.wsMaximized;
  bMaximize.StyleLookup := 'bNormalWindowStyle';
  bMaximize.Action := aWindowNormal;
end;

procedure TFrmMain.aWindowMinimizeExecute(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

procedure TFrmMain.aWindowNormalExecute(Sender: TObject);
begin
  WindowState := TWindowState.wsNormal;
  bMaximize.StyleLookup := 'bMaximizeWindowStyle';
  bMaximize.Action := aWindowMaximize;
end;

procedure TFrmMain.bImportQuestionsClick(Sender: TObject);
var
  dlg: IFMXDialogServiceAsync;
  rootDir: string;
  gameDir: string;
begin
  var pathChecker := GlobalContainer.Resolve<IFibbagePathChecker>;
  if (not TAppConfig.GetInstance.LastEditPath.IsEmpty) and pathChecker.IsValid(TAppConfig.GetInstance.LastEditPath) then
    rootDir := TAppConfig.GetInstance.LastEditPath
  else
  begin
    rootDir :=
      IncludeTrailingPathDelimiter(GetEnvironmentVariable('programfiles')) +
      IncludeTrailingPathDelimiter('Steam') +
      IncludeTrailingPathDelimiter('steamapps') +
      IncludeTrailingPathDelimiter('common') +
      IncludeTrailingPathDelimiter('Fibbage XL');
    if not pathChecker.IsValid(rootDir) then
      rootDir := GetCurrentDir;
  end;

  while True do
  begin
    if not SelectDirectory('Select directory with content inside', rootDir, gameDir) then
      Exit
    else if pathChecker.IsValid(gameDir) then
      Break
    else
    begin
      rootDir := gameDir;
      ShowMessage('Question directories not found');
    end;
  end;

  TAppConfig.GetInstance.LastEditPath := gameDir;
  FContent := GlobalContainer.Resolve<IFibbageContent>;
  FContent.Initialize(gameDir, OnContentInitialized, OnContentError);
  tcQuestions.Visible := False;
  aiContentLoading.Visible := True;
  aiContentLoading.Enabled := True;
  MultiView1.HideMaster;
end;

procedure TFrmMain.DSAudioOut1Done(Sender: TComponent);
begin
//
end;

procedure TFrmMain.DSAudioOut1Progress(Sender: TComponent);
begin
//
end;

procedure TFrmMain.OnContentError(const AError: string);
begin
  TThread.Synchronize(nil, procedure
  begin
    aiContentLoading.Visible := False;
    aiContentLoading.Enabled := False;
    ShowMessage(Format('Could not parse data, "%s"', [AError]));
  end);
end;

procedure TFrmMain.PopulateListView(AQuestions: TList<IQuestion>; AListView: TListView);
begin
  AListView.BeginUpdate;
  try
    AListView.Items.Clear;
    for var item in AQuestions do
    begin
      var lvItem := AListView.Items.Add;
      lvItem.Data['Question'] := item.Question;
      lvItem.Data['Suggestions'] := item.Suggestions;
      lvItem.Data['Answer'] := item.Answer;
      lvItem.Data['ItemIdx'] := AQuestions.IndexOf(item);
      if AListView = lvEditAllItems then
        lvItem.Data['CategoryDetails'] := Format('Id: %d, Category: %s', [
          FContent.Categories.GetShortieCategory(item).Id,
          FContent.Categories.GetShortieCategory(item).Category])
      else
        lvItem.Data['CategoryDetails'] := Format('Id: %d, Category: %s', [
          FContent.Categories.GetFinalCategory(item).Id,
          FContent.Categories.GetFinalCategory(item).Category])

    end;
  finally
    AListView.EndUpdate;
  end;
end;

procedure TFrmMain.OnContentInitialized;
begin
  TThread.Synchronize(nil, procedure
    begin
      try
        PopulateListView(FContent.Questions.ShortieQuestions, lvEditAllItems);
        PopulateListView(FContent.Questions.FinalQuestions, lvFinalQuestions);
      finally
        aiContentLoading.Visible := False;
        aiContentLoading.Enabled := False;
        tcQuestions.Visible := True;
      end;
    end);
end;

procedure TFrmMain.OnStartRecord;
begin
//  TThread.Synchronize(nil,
//  procedure
//  begin
//    case FCurrentRecordingType of
//      fstQuestion:
//        bSingleItemRecordQuestion.StyleLookup := 'stoprecordtoolbutton';
//      fstAnswer:
//        bSingleItemRecordAnswer.StyleLookup := 'stoprecordtoolbutton';
//      fstBumper:
//        bSingleItemRecordBumper.StyleLookup := 'stoprecordtoolbutton';
//      else
//        Assert(False, 'unknown recording type');
//    end;
//  end);
end;

procedure TFrmMain.Panel1KeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkLeft then
    aGoToAllQuestions.Execute;
end;

procedure TFrmMain.bExportQuestionsClick(Sender: TObject);
begin
  var rootDir := TAppConfig.GetInstance.LastEditPath;
  var gameDir: string;
  while True do
  begin
    if not SelectDirectory('Select directory where you want to store questions', rootDir, gameDir) then
      Exit;
    Break;
  end;

  FContent.Save(gameDir);
end;

procedure TFrmMain.bSingleItemBumperAudioClick(Sender: TObject);
begin
  PlaySound(FSelectedQuestion.BumperAudioPath);
end;

procedure TFrmMain.bSingleItemCorrectAudioClick(Sender: TObject);
begin
  PlaySound(FSelectedQuestion.CorrectItemAudioPath);
end;

procedure TFrmMain.bSingleItemQuestionAudioClick(Sender: TObject);
begin
  var form := TRecordForm.Create(Self);
  try
    form.EditQuestionAudio(FSelectedQuestion);
  finally
    form.Free;
  end;
end;

procedure TFrmMain.PlaySound(const APath: string);
begin
//  DSAudioOut1.Stop(False);
//  VorbisIn1.FileName := APath;
//  DSAudioOut1.Run;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  tcQuestions.Visible := False;
  sDarkMode.IsChecked := TAppConfig.GetInstance.DarkModeEnabled;
//  voMic.OnStart := OnStartRecord;

  tcEditTabs.ActiveTab := tiQuestions;
  tcQuestions.ActiveTab := tiShortieQuestions;
  MultiView1.ShowMaster;
  FAppCreated := True;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
//  voMic.Stop(False);
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  if ClientHeight < 480 then
    ClientHeight := 480;

  if ClientWidth < 640 then
    ClientWidth := 640;
end;

procedure TFrmMain.lDarkModeClick(Sender: TObject);
begin
  sDarkMode.IsChecked := not sDarkMode.IsChecked;
end;

procedure TFrmMain.lvEditAllItemsDblClick(Sender: TObject);
begin
  var selectedItem := lvEditAllItems.Items[lvEditAllItems.ItemIndex];
  FSelectedQuestion := FContent.Questions.ShortieQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
  FSelectedCategory := FContent.Categories.GetShortieCategory(FSelectedQuestion);
  aGoToQuestionDetails.Execute;
end;

procedure TFrmMain.lvEditAllItemsKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) or (Key = vkRight) then
  begin
    var selectedItem := lvEditAllItems.Items[lvEditAllItems.ItemIndex];
    FSelectedQuestion := FContent.Questions.ShortieQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
    FSelectedCategory := FContent.Categories.GetShortieCategory(FSelectedQuestion);
    aGoToQuestionDetails.Execute;
  end;
end;

procedure TFrmMain.lvEditAllItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  var baseLV := Sender as TListView;
  var wholeHeight := 0;
  var qDrawable := AItem.View.FindDrawable('Question') as TListItemText;
  var aDrawable := AItem.View.FindDrawable('Answer') as TListItemText;
  var sDrawable := AItem.View.FindDrawable('Suggestions') as TListItemText;
  var cdDrawable := AItem.View.FindDrawable('CategoryDetails') as TListItemText;

  if (not Assigned(qDrawable)) or (not Assigned(aDrawable)) or (not Assigned(sDrawable)) or (not Assigned(cdDrawable)) then
    Exit;

  baseLV.Canvas.Font.Assign(qDrawable.Font);

  cdDrawable.Height := baseLV.Canvas.TextHeight('Yy');
  cdDrawable.PlaceOffset.Y := 3;
  cdDrawable.PlaceOffset.X := 5;

  var R := RectF(0, 0, baseLV.Width - baseLV.ItemSpaces.Left - baseLV.ItemSpaces.Right, 10000);
  baseLV.Canvas.MeasureText(R, AItem.Data['Question'].ToString, True, [], qDrawable.TextAlign, qDrawable.TextVertAlign);
  qDrawable.Height := R.Height;
  qDrawable.PlaceOffset.Y := cdDrawable.PlaceOffset.Y + cdDrawable.Height + 10;

  aDrawable.Height := baseLV.Canvas.TextHeight('Yy');
  aDrawable.PlaceOffset.Y := qDrawable.PlaceOffset.Y + qDrawable.Height + 5;

  sDrawable.Height := baseLV.Canvas.TextHeight('Yy');
  sDrawable.PlaceOffset.Y := aDrawable.PlaceOffset.Y + aDrawable.Height + 5;

  qDrawable.Width := baseLV.Width;
  aDrawable.Width := baseLV.Width;
  sDrawable.Width := baseLV.Width;
  cdDrawable.Width := baseLV.Width - cdDrawable.PlaceOffset.X;

  AItem.Height := Round(sDrawable.PlaceOffset.Y + sDrawable.Height + 6);
end;

procedure TFrmMain.lvFinalQuestionsDblClick(Sender: TObject);
begin
  var selectedItem := lvFinalQuestions.Items[lvFinalQuestions.ItemIndex];
  FSelectedQuestion := FContent.Questions.FinalQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
  FSelectedCategory := FContent.Categories.GetFinalCategory(FSelectedQuestion);
  aGoToQuestionDetails.Execute;
end;

procedure TFrmMain.lvFinalQuestionsKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) or (Key = vkRight) then
  begin
    var selectedItem := lvFinalQuestions.Items[lvFinalQuestions.ItemIndex];
    FSelectedQuestion := FContent.Questions.FinalQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
    FSelectedCategory := FContent.Categories.GetFinalCategory(FSelectedQuestion);
    aGoToQuestionDetails.Execute;
  end;
end;

procedure TFrmMain.lyGameDirectoryPathClick(Sender: TObject);
var
  rootDir: string;
  gameDir: string;
begin
//  if (not TAppConfig.GetInstance.GameDirPath.IsEmpty) and FContainer.Resolve<IFibbagePathChecker>.IsValid(TAppConfig.GetInstance.GameDirPath) then
//    rootDir := TAppConfig.GetInstance.GameDirPath
//  else
//  begin
//    rootDir :=
//      IncludeTrailingPathDelimiter(GetEnvironmentVariable('programfiles')) +
//      IncludeTrailingPathDelimiter('Steam') +
//      IncludeTrailingPathDelimiter('steamapps') +
//      IncludeTrailingPathDelimiter('common') +
//      IncludeTrailingPathDelimiter('Fibbage XL');
//    if not FContainer.Resolve<IFibbagePathChecker>.IsValid(rootDir) then
//      rootDir := GetCurrentDir;
//  end;
//
//  while True do
//  begin
//    if (not SelectDirectory('Select game directory path', rootDir, gameDir)) then
//      Exit
//    else if FContainer.Resolve<IFibbagePathChecker>.IsValid(gameDir) then
//      Break
//    else
//    begin
//      ShowMessage('Fibbage files not found');
//      rootDir := gameDir;
//    end;
//  end;
//
//  eGameDirectoryPath.Text := gameDir;
end;

procedure TFrmMain.sDarkModeSwitch(Sender: TObject);
begin
  if sDarkMode.IsChecked then
    StyleBook := sbDarkStyle
  else
    StyleBook := sbLightStyle;

  if FAppCreated then
    TAppConfig.GetInstance.DarkModeEnabled := sDarkMode.IsChecked;
end;

procedure TFrmMain.StartRecording(ASoundType: TFibbageSoundType);
begin
  FCurrentRecordingType := ASoundType;
//  voMic.Run;
end;

procedure TFrmMain.StopRecording;
begin
//  voMic.Stop;
end;

procedure TFrmMain.ToolBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FMouseDownPt := Point(Round(X), Round(Y));
  if (ssDouble in Shift) and (ssLeft in Shift) then
    if WindowState = TWindowState.wsNormal then
      aWindowMaximize.Execute
    else
      aWindowNormal.Execute;
end;

procedure TFrmMain.ToolBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if WindowState = TWindowState.wsMaximized then
    Exit;

  if ssLeft in Shift then
  begin
    Left := Left + (Round(X) - FMouseDownPt.X);
    Top := Top + (Round(Y) - FMouseDownPt.Y);
  end;
end;

procedure TFrmMain.voMicSyncDone(Sender: TComponent);
begin
//  TThread.Synchronize(nil,
//  procedure
//  begin
//    case FCurrentRecordingType of
//      fstQuestion:
//        bSingleItemRecordQuestion.StyleLookup := 'mictoolbutton';
//      fstAnswer:
//        bSingleItemRecordAnswer.StyleLookup := 'mictoolbutton';
//      fstBumper:
//        bSingleItemRecordBumper.StyleLookup := 'mictoolbutton';
//      else
//        Assert(False, 'unknown recording type');
//    end;
//    FCurrentRecordingType := fstNone;
//  end);
end;

end.
