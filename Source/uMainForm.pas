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
  NewACDSAudio, System.Generics.Collections, uRecordForm, FMX.ListBox, uSingleQuestionItem,
  FMX.Objects, System.Messaging, System.DateUtils, uLog;

type
  TQuestionScrollItem = class(TPanel)
  private
    FDetails: TLabel;
    FQuestion: TLabel;
  protected
    procedure Click; override;
    procedure Resize; override;
  public
    constructor CreateItem(AOwner: TComponent; AQuestionId: Integer; const AQuestionCategory, AQuestion: string);
  end;

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
    tiFinalQuestions: TTabItem;
    lyContent: TLayout;
    aGoToFinalQuestions: TChangeTabAction;
    aGoToShortieQuestions: TChangeTabAction;
    tiQuestions: TTabItem;
    tcQuestions: TTabControl;
    aGoToAllQuestions: TChangeTabAction;
    GridPanelLayout1: TGridPanelLayout;
    bSingleItemQuestionAudio: TButton;
    bSingleItemCorrectAudio: TButton;
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
    tiQuestionProjects: TTabItem;
    lvQuestionProjects: TListView;
    bHomeButton: TButton;
    aGoToHome: TChangeTabAction;
    bQuestions: TButton;
    sbxShortieQuestions: TVertScrollBox;
    pBackground: TPanel;
    sbxFinalQuestions: TVertScrollBox;
    tbQuestionProjects: TToolBar;
    lOpenRecentProjects: TLabel;
    ToolBar2: TToolBar;
    Label1: TLabel;
    ToolBar3: TToolBar;
    Label2: TLabel;
    GridPanelLayout2: TGridPanelLayout;
    bShortieQuestions: TButton;
    bFinalQuestions: TButton;
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
    procedure aGoToFinalQuestionsUpdate(Sender: TObject);
    procedure aGoToShortieQuestionsUpdate(Sender: TObject);
    procedure lvFinalQuestionsDblClick(Sender: TObject);
    procedure lvFinalQuestionsKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure bGoBackFromDetailsClick(Sender: TObject);
    procedure lvQuestionProjectsDblClick(Sender: TObject);
    procedure lvEditAllItemsClick(Sender: TObject);
    procedure bHomeButtonClick(Sender: TObject);
    procedure bQuestionsClick(Sender: TObject);
    procedure bShortieQuestionsClick(Sender: TObject);
    procedure bFinalQuestionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMouseDownPt: TPoint;
    FAppCreated: Boolean;
    FContent: IFibbageContent;
    FLastActiveTab: TTabItem;
    FSelectedQuestion: IQuestion;
    FSelectedCategory: ICategory;
    FLastQuestionProjects: ILastQuestionProjects;

    procedure OnContentInitialized;
    procedure OnContentError(const AError: string);
    procedure GoToQuestionDetails;
    procedure AddLastChoosenProject;
    procedure InitializeLastQuestionProjects;
    procedure InitializeContent(const APath: string);
    procedure PopulateScrollBox(AQuestions: TList<IQuestion>; AScrollBox: TCustomScrollBox);
    procedure GoToFinalQuestions;
    procedure GoToShortieQuestions;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.AddLastChoosenProject;
begin
  FLastQuestionProjects.Add(FContent);
end;

procedure TFrmMain.aGoToFinalQuestionsUpdate(Sender: TObject);
begin
  FLastActiveTab := tiFinalQuestions;
end;

procedure TFrmMain.aGoToShortieQuestionsUpdate(Sender: TObject);
begin
  FLastActiveTab := tiShortieQuestions;
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
    if not SelectDirectory('Select "Content" directory', rootDir, gameDir) then
      Exit
    else if pathChecker.IsValid(gameDir) then
      Break
    else
    begin
      rootDir := gameDir;
      ShowMessage('Question directories not found');
    end;
  end;

  InitializeContent(gameDir);
  aGoToAllQuestions.Execute;
  GoToShortieQuestions;
end;

procedure TFrmMain.bQuestionsClick(Sender: TObject);
begin
  aGoToAllQuestions.Execute;
end;

procedure TFrmMain.InitializeContent(const APath: string);
begin
  TAppConfig.GetInstance.LastEditPath := APath;
  FContent := GlobalContainer.Resolve<IFibbageContent>;
  FContent.Initialize(APath, OnContentInitialized, OnContentError);
  tcQuestions.Visible := False;
  aiContentLoading.Visible := True;
  aiContentLoading.Enabled := True;
  MultiView1.HideMaster;
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

procedure TFrmMain.PopulateScrollBox(AQuestions: TList<IQuestion>;
  AScrollBox: TCustomScrollBox);
begin
  AScrollBox.BeginUpdate;
  try
    for var item in AQuestions do
    begin
      var category: ICategory;
      if AScrollBox = sbxShortieQuestions then
        category := FContent.Categories.GetShortieCategory(item)
      else
        category := FContent.Categories.GetFinalCategory(item);
      var qItem := TQuestionScrollItem.CreateItem(AScrollBox, category.GetId, category.GetCategory.Trim, item.GetQuestion.Trim);
      qItem.Parent := AScrollBox;
      qItem.Align := TAlignLayout.Top;
    end;
  finally
    AScrollBox.EndUpdate;
  end;
end;

procedure TFrmMain.OnContentInitialized;
begin
  TThread.Synchronize(nil, procedure
    begin
      try
        PopulateScrollBox(FContent.Questions.ShortieQuestions, sbxShortieQuestions);
        PopulateScrollBox(FContent.Questions.FinalQuestions, sbxFinalQuestions);

        AddLastChoosenProject;
      finally
        aiContentLoading.Visible := False;
        aiContentLoading.Enabled := False;
        tcQuestions.Visible := True;
      end;
    end);
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

procedure TFrmMain.bFinalQuestionsClick(Sender: TObject);
begin
  GoToFinalQuestions;
end;

procedure TFrmMain.GoToFinalQuestions;
begin
  bShortieQuestions.StaysPressed := False;
  bShortieQuestions.IsPressed := False;
  bFinalQuestions.StaysPressed := True;
  bFinalQuestions.IsPressed := True;
  bFinalQuestions.Enabled := False;
  bShortieQuestions.Enabled := True;
  aGoToFinalQuestions.Execute;
end;

procedure TFrmMain.bGoBackFromDetailsClick(Sender: TObject);
begin
  bImportQuestions.Visible := True;
  bExportQuestions.Visible := True;

  bImportQuestions.Position.Y := bMenu.Position.Y + bMenu.Height;
  bExportQuestions.Position.Y := bImportQuestions.Position.Y + bImportQuestions.Height;

  FSelectedQuestion.SetQuestion(mSingleItemQuestion.Text.Trim);
  FSelectedQuestion.SetAnswer(mSingleItemAnswer.Text.Trim);
  FSelectedQuestion.SetAlternateSpelling(mSingleItemAlternateSpelling.Text.Replace(', ', ',').Trim);
  FSelectedQuestion.SetSuggestions(mSingleItemSuggestions.Text.Replace(', ', ',').Trim);
  FSelectedQuestion.SetId(StrToIntDef(eSingleItemId.Text.Trim, Random(High(Word))));
  FSelectedCategory.SetId(FSelectedQuestion.GetId);
  FSelectedCategory.SetCategory(eSingleItemCategory.Text.Trim);

//  var selected: TListViewItem;
//  if tcQuestions.ActiveTab = tiShortieQuestions then
//  begin
//    if not (lvEditAllItems.Selected is TListViewItem) then
//      Exit;
//    selected := (lvEditAllItems.Selected as TListViewItem);
//    selected.Data['Question'] := FSelectedQuestion.GetQuestion;
//    selected.Data['Suggestions'] := FSelectedQuestion.GetSuggestions;
//    selected.Data['Answer'] := FSelectedQuestion.GetAnswer;
//    selected.Data['ItemIdx'] := FContent.Questions.ShortieQuestions.IndexOf(FSelectedQuestion);
//    selected.Data['CategoryDetails'] := Format('Id: %d, Category: %s', [
//      FContent.Categories.GetShortieCategory(FSelectedQuestion).GetId,
//      FContent.Categories.GetShortieCategory(FSelectedQuestion).GetCategory]);
//  end
//  else if tcQuestions.ActiveTab = tiFinalQuestions then
//  begin
//    if not (lvFinalQuestions.Selected is TListViewItem) then
//      Exit;
//    selected := (lvFinalQuestions.Selected as TListViewItem);
//    selected.Data['Question'] := FSelectedQuestion.GetQuestion;
//    selected.Data['Suggestions'] := FSelectedQuestion.GetSuggestions;
//    selected.Data['Answer'] := FSelectedQuestion.GetAnswer;
//    selected.Data['ItemIdx'] := FContent.Questions.FinalQuestions.IndexOf(FSelectedQuestion);
//    selected.Data['CategoryDetails'] := Format('Id: %d, Category: %s', [
//      FContent.Categories.GetFinalCategory(FSelectedQuestion).GetId,
//      FContent.Categories.GetFinalCategory(FSelectedQuestion).GetCategory]);
//  end
//  else
//    Exit;

  aGoToAllQuestions.Execute;
end;

procedure TFrmMain.bHomeButtonClick(Sender: TObject);
begin
  aGoToHome.Execute;
end;

procedure TFrmMain.bShortieQuestionsClick(Sender: TObject);
begin
  GoToShortieQuestions;
end;

procedure TFrmMain.GoToShortieQuestions;
begin
  bFinalQuestions.StaysPressed := False;
  bFinalQuestions.IsPressed := False;
  bShortieQuestions.StaysPressed := True;
  bShortieQuestions.IsPressed := True;
  bShortieQuestions.Enabled := False;
  bFinalQuestions.Enabled := True;
  aGoToShortieQuestions.Execute;
end;

procedure TFrmMain.bSingleItemBumperAudioClick(Sender: TObject);
begin
  var form := TRecordForm.Create(Self);
  try
    form.EditBumperAudio(FSelectedQuestion);
  finally
    form.Free;
  end;
end;

procedure TFrmMain.bSingleItemCorrectAudioClick(Sender: TObject);
begin
  var form := TRecordForm.Create(Self);
  try
    form.EditAnswerAudio(FSelectedQuestion);
  finally
    form.Free;
  end;
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

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  Randomize;

  tcQuestions.Visible := False;
  sDarkMode.IsChecked := TAppConfig.GetInstance.DarkModeEnabled;

  tcEditTabs.ActiveTab := tiQuestionProjects;
  tcQuestions.ActiveTab := tiShortieQuestions;

  FLastQuestionProjects := GlobalContainer.Resolve<ILastQuestionProjects>;
  FLastQuestionProjects.Initialize;
  InitializeLastQuestionProjects;

  if lvQuestionProjects.Items.Count = 0 then
    MultiView1.ShowMaster;

  FAppCreated := True;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Log('Destroyed');
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  if ClientHeight < 480 then
    ClientHeight := 480;

  if ClientWidth < 640 then
    ClientWidth := 640;
end;

procedure TFrmMain.GoToQuestionDetails;
begin
  bImportQuestions.Visible := False;
  bExportQuestions.Visible := False;

  mSingleItemQuestion.Text := FSelectedQuestion.GetQuestion;
  mSingleItemAnswer.Text := FSelectedQuestion.GetAnswer;
  mSingleItemAlternateSpelling.Text :=  FSelectedQuestion.GetAlternateSpelling.Replace(',', ', ');
  mSingleItemSuggestions.Text := FSelectedQuestion.GetSuggestions.Replace(',', ', ');
  eSingleItemId.Text := FSelectedCategory.GetId.ToString;
  eSingleItemCategory.Text := FSelectedCategory.GetCategory;

  aGoToQuestionDetails.Execute;
end;

procedure TFrmMain.InitializeLastQuestionProjects;
begin
  var paths := FLastQuestionProjects.GetAll;
  try
    for var idx := 0 to paths.Count - 1 do
    begin
      var item := lvQuestionProjects.Items.Add;
      item.Data['ProjectPath'] := paths[idx];
      item.Data['ProjectName'] := 'Polskie pytania';
      item.Data['QuestionsCount'] := 'Shorties: 100' + sLineBreak + 'Final: 100';

    end;
  finally
    paths.Free;
  end;
end;

procedure TFrmMain.lDarkModeClick(Sender: TObject);
begin
  sDarkMode.IsChecked := not sDarkMode.IsChecked;
end;

procedure TFrmMain.lvEditAllItemsClick(Sender: TObject);
begin
//  lvEditAllItems.Items[0].HasClickOnSelectItems  // PRZEJSC Z LISTVIEW NA SCROLLA Z ITEMAMI
//  var selectedItem := lvEditAllItems.Items[lvEditAllItems.ItemIndex];
//  selectedItem.Checked := True;
end;

procedure TFrmMain.lvEditAllItemsDblClick(Sender: TObject);
begin
//  var selectedItem := lvEditAllItems.Items[lvEditAllItems.ItemIndex];
//  selectedItem.Checked := True;
//  FSelectedQuestion := FContent.Questions.ShortieQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
//  FSelectedCategory := FContent.Categories.GetShortieCategory(FSelectedQuestion);
//  GoToQuestionDetails;
end;

procedure TFrmMain.lvEditAllItemsKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) or (Key = vkRight) then
  begin
//    var selectedItem := lvEditAllItems.Items[lvEditAllItems.ItemIndex];
//    FSelectedQuestion := FContent.Questions.ShortieQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
//    FSelectedCategory := FContent.Categories.GetShortieCategory(FSelectedQuestion);
//    GoToQUestionDetails;
  end;
end;

procedure TFrmMain.lvEditAllItemsUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  var baseLV := Sender as TListView;

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
//  var selectedItem := lvFinalQuestions.Items[lvFinalQuestions.ItemIndex];
//  FSelectedQuestion := FContent.Questions.FinalQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
//  FSelectedCategory := FContent.Categories.GetFinalCategory(FSelectedQuestion);
//  GoToQuestionDetails;
end;

procedure TFrmMain.lvFinalQuestionsKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
//  if (Key = vkReturn) or (Key = vkRight) then
//  begin
//    var selectedItem := lvFinalQuestions.Items[lvFinalQuestions.ItemIndex];
//    FSelectedQuestion := FContent.Questions.FinalQuestions[selectedItem.Data['ItemIdx'].AsType<Integer>];
//    FSelectedCategory := FContent.Categories.GetFinalCategory(FSelectedQuestion);
//    GoToQuestionDetails;
//  end;
end;

procedure TFrmMain.lvQuestionProjectsDblClick(Sender: TObject);
begin
  var selectedItem := lvQuestionProjects.Items[lvQuestionProjects.ItemIndex];
  var contentDir := selectedItem.Data['ProjectPath'].AsString;

  var pathChecker := GlobalContainer.Resolve<IFibbagePathChecker>;
  if not pathChecker.IsValid(contentDir) then
    ShowMessage('Game content is not available at this path')
  else
  begin
    InitializeContent(contentDir);
    aGoToAllQuestions.Execute;
    GoToShortieQuestions;
  end;
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

{ TQuestionScrollItem }

procedure TQuestionScrollItem.Click;
begin
  StyleLookup := 'rScrollItemSelectedStyle';
  inherited;
end;

constructor TQuestionScrollItem.CreateItem(AOwner: TComponent;
  AQuestionId: Integer; const AQuestionCategory, AQuestion: string);
begin
  inherited Create(AOwner);

  StyleLookup := 'rScrollItemStyle';
  HitTest := True;

  FDetails := TLabel.Create(AOwner);
  FDetails.Parent := Self;
  FDetails.Align := TAlignLayout.MostTop;
  FDetails.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FDetails.Text := Format('Id: %d, Category: %s', [AQuestionId, AQuestionCategory]);
  FDetails.TextSettings.Font.Size := 13;
  FDetails.Margins.Left := 10;
  FDetails.Margins.Right := 10;
  FDetails.Margins.Top := 10;
  FDetails.StyleLookup := 'listboxitemdetaillabel';

  FQuestion := TLabel.Create(AOwner);
  FQuestion.Parent := Self;
  FQuestion.Align := TAlignLayout.Top;
  FQuestion.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FQuestion.Text := AQuestion;
  FQuestion.TextAlign := TTextAlign.Center;
  FQuestion.TextSettings.Font.Size := 18;
  FQuestion.Margins.Left := 15;
  FQuestion.Margins.Right := 5;
  FQuestion.StyleLookup := 'listboxitemlabel';
end;

procedure TQuestionScrollItem.Resize;
begin
  inherited;
  FDetails.Canvas.Font.Assign(FDetails.Font);
  FDetails.Height := Ceil(FDetails.Canvas.TextHeight('Yy'));

  FQuestion.Canvas.Font.Assign(FQuestion.Font);
  var R := RectF(0, 0, Width - FQuestion.Margins.Left - FQuestion.Margins.Right, 10000);
  FQuestion.Canvas.MeasureText(R, FQuestion.Text, True, [], TTextAlign.Center);
  FQuestion.Height := Ceil(R.Height + FQuestion.Margins.Top + FQuestion.Margins.Bottom);

  Height := Ceil((2 * FDetails.Height) + FDetails.Margins.Top + FDetails.Margins.Bottom +
      FQuestion.Height + FQuestion.Margins.Top + FQuestion.Margins.Bottom);
end;

end.
