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
  NewACDSAudio, System.Generics.Collections, uRecordForm, FMX.ListBox,
  FMX.Objects, System.Messaging, System.DateUtils, uLog, uCategoriesLoader,
  FMX.Menus, System.StrUtils;

type
  TQuestionScrollItem = class(TPanel)
  private
    FDetails: TLabel;
    FQuestion: TLabel;
    FOrgQuestion: IQuestion;
    FOrgCategory: ICategory;
    FSelected: Boolean;
    procedure SetSelected(const Value: Boolean);
  protected
    procedure Resize; override;
  public
    constructor CreateItem(AOwner: TComponent; AQuestion: IQuestion; ACategory: ICategory);
    procedure RefreshData;
    
    property Selected: Boolean read FSelected write SetSelected;
    property OrgQuestion: IQuestion read FOrgQuestion;
    property OrgCategory: ICategory read FOrgCategory;
  end;

  TQuestionScrollItems = class(TList<TQuestionScrollItem>)
  public
    procedure ClearSelection;
    procedure SelectAll;
    function SelectedCount: Integer;
  end;

  TAppTab = (atHomeBeforeImport, atHome, atQuestions, atSingleQuestion);

  TFrmMain = class(TForm)
    mvOptions: TMultiView;
    bMenu: TButton;
    bExportQuestions: TButton;
    bImportQuestions: TButton;
    alMain: TActionList;
    ToolBar1: TToolBar;
    bMinimize: TButton;
    bMaximize: TButton;
    bClose: TButton;
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
    bAddQuestion: TButton;
    bRemoveQuestions: TButton;
    lineTabs: TLine;
    lineActions: TLine;
    pmQuestions: TPopupMenu;
    miAddQuestion: TMenuItem;
    miEditQuestion: TMenuItem;
    miRemoveQuestions: TMenuItem;
    aRemoveQuestions: TAction;
    aAddQuestion: TAction;
    aEditQuestion: TAction;
    procedure sDarkModeSwitch(Sender: TObject);
    procedure lDarkModeClick(Sender: TObject);
    procedure ToolBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bImportQuestionsClick(Sender: TObject);
    procedure bExportQuestionsClick(Sender: TObject);
    procedure lvEditAllItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bSingleItemQuestionAudioClick(Sender: TObject);
    procedure bSingleItemCorrectAudioClick(Sender: TObject);
    procedure bSingleItemBumperAudioClick(Sender: TObject);
    procedure bGoBackFromDetailsClick(Sender: TObject);
    procedure lvQuestionProjectsDblClick(Sender: TObject);
    procedure bHomeButtonClick(Sender: TObject);
    procedure bQuestionsClick(Sender: TObject);
    procedure bShortieQuestionsClick(Sender: TObject);
    procedure bFinalQuestionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure aRemoveQuestionsExecute(Sender: TObject);
    procedure aAddQuestionExecute(Sender: TObject);
    procedure aEditQuestionExecute(Sender: TObject);
    procedure pmQuestionsPopup(Sender: TObject);
  private
    FAppCreated: Boolean;
    FChangingTab: Boolean;
    FContent: IFibbageContent;

    FSelectedQuestion: IQuestion;
    FSelectedCategory: ICategory;

    FLastQuestionProjects: ILastQuestionProjects;

    FLastClickedItem: TQuestionScrollItem;
    FLastClickedItemToEdit: TQuestionScrollItem;

    FShortieVisItems: TQuestionScrollItems;
    FFinalVisItems: TQuestionScrollItems;

    procedure OnContentInitialized;
    procedure OnContentError(const AError: string);
    procedure GoToQuestionDetails;
    procedure AddLastChoosenProject;
    procedure InitializeLastQuestionProjects;
    procedure InitializeContent(const APath: string);
    procedure GoToFinalQuestions;
    procedure GoToShortieQuestions;
    procedure GoToAllQuestions;
    procedure GoToHome;

    procedure PrepareMultiViewButtons(AActTab: TAppTab);
    procedure OnShortieQuestionItemDoubleClick(Sender: TObject);
    procedure OnFinalQuestionItemDoubleClick(Sender: TObject);
    procedure OnShortieQuestionItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure OnFinalQuestionItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure RemoveSelectedShortieQuestions;
    procedure RemoveSelectedFinalQuestions;
    procedure FillFinalScrollBox;
    procedure FillShortiesScrollBox;
    procedure RefreshSelectedFinalQuestion;
    procedure RefreshSelectedShortieQuestion;
    procedure CreateNewFinalQuestion;
    procedure CreateNewShortieQuestion;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.aAddQuestionExecute(Sender: TObject);
begin
  if tcQuestions.ActiveTab = tiShortieQuestions then
    CreateNewShortieQuestion
  else
    CreateNewFinalQuestion;

  GoToQuestionDetails;
end;

procedure TFrmMain.AddLastChoosenProject;
begin
  FLastQuestionProjects.Add(FContent);
end;

procedure TFrmMain.aEditQuestionExecute(Sender: TObject);
begin
  if not Assigned(FLastClickedItemToEdit) then
    Exit;

  FSelectedQuestion := FLastClickedItemToEdit.OrgQuestion;
  FSelectedCategory := FLastClickedItemToEdit.OrgCategory;
  FLastClickedItemToEdit.Selected := True;

  GoToQuestionDetails;
end;

procedure TFrmMain.aRemoveQuestionsExecute(Sender: TObject);
begin
  if tcQuestions.ActiveTab = tiShortieQuestions then
    RemoveSelectedShortieQuestions
  else
    RemoveSelectedFinalQuestions;
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
end;

procedure TFrmMain.bQuestionsClick(Sender: TObject);
begin
  GoToAllQuestions;
end;

procedure TFrmMain.RemoveSelectedShortieQuestions;
begin
  sbxShortieQuestions.BeginUpdate;
  try
    for var idx := FShortieVisItems.Count - 1 downto 0 do
      if FShortieVisItems[idx].Selected then
      begin
        var item := FShortieVisItems.ExtractAt(idx);
        FContent.RemoveShortieQuestion(item.OrgQuestion);
        FreeAndNil(item);
      end;
  finally
    FLastClickedItemToEdit := nil;
    sbxShortieQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.RemoveSelectedFinalQuestions;
begin
  sbxFinalQuestions.BeginUpdate;
  try
    for var idx := FFinalVisItems.Count - 1 downto 0 do
      if FFinalVisItems[idx].Selected then
      begin
        var item := FFinalVisItems.ExtractAt(idx);
        FContent.RemoveFinalQuestion(item.OrgQuestion);
        FreeAndNil(item);
      end;
  finally
    FLastClickedItemToEdit := nil;
    sbxFinalQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.InitializeContent(const APath: string);
begin
  TAppConfig.GetInstance.LastEditPath := APath;
  FContent := GlobalContainer.Resolve<IFibbageContent>;
  FContent.Initialize(APath, OnContentInitialized, OnContentError);
  tcEditTabs.Visible := False;
  aiContentLoading.Visible := True;
  aiContentLoading.Enabled := True;
  mvOptions.HideMaster;
end;

procedure TFrmMain.OnContentError(const AError: string);
begin
  TThread.Synchronize(nil, procedure
  begin
    aiContentLoading.Visible := False;
    aiContentLoading.Enabled := False;
    tcEditTabs.Visible := True;
    ShowMessage(Format('Could not parse data, "%s"', [AError]));
  end);
end;

procedure TFrmMain.OnShortieQuestionItemDoubleClick(Sender: TObject);
begin
  if FChangingTab then
    Exit;

  Log('OnShortieQuestionItemDoubleClick');
  aEditQuestion.Execute;
end;

procedure TFrmMain.OnFinalQuestionItemDoubleClick(Sender: TObject);
begin
  if FChangingTab then
    Exit;

  Log('OnFinalQuestionItemDoubleClick');
  aEditQuestion.Execute;
end;

procedure TFrmMain.OnFinalQuestionItemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Log('OnFinalQuestionItemMouseDown');
  if FChangingTab then
    Exit;
  if not (Sender is TQuestionScrollItem) then
    Exit;

  FLastClickedItemToEdit := Sender as TQuestionScrollItem;

  if Button = TMouseButton.mbRight then
  begin
    FLastClickedItem := Sender as TQuestionScrollItem;
    sbxFinalQuestions.BeginUpdate;
    try
      if not (Sender as TQuestionScrollItem).Selected then
      begin
        FFinalVisItems.ClearSelection;
        (Sender as TQuestionScrollItem).Selected := True;
      end;
    finally
      sbxFinalQuestions.EndUpdate;
    end;
    pmQuestions.Popup(Screen.MousePos.X, Screen.MousePos.Y);
  end
  else if ssDouble in Shift then
  begin
    FFinalVisItems.ClearSelection;
    (Sender as TQuestionScrollItem).Selected := True;
  end
  else if ssShift in Shift then
  begin
    var fIdx := 0;
    var sIdx := FFinalVisItems.IndexOf(Sender as TQuestionScrollItem);
    if Assigned(FLastClickedItem) then
      fIdx := FFinalVisItems.IndexOf(FLastClickedItem);

    if fIdx > sIdx then
    begin
      var tmp := fIdx;
      fIdx := sIdx;
      sIdx := tmp;
    end;

    for var idx := 0 to FFinalVisItems.Count - 1 do
      FFinalVisItems[idx].Selected := (idx >= fIdx) and (idx <= sIdx);
  end
  else
  begin
    FLastClickedItem := Sender as TQuestionScrollItem;
    if ssCtrl in Shift then
      (Sender as TQuestionScrollItem).Selected := not (Sender as TQuestionScrollItem).Selected
    else
    begin
      for var item in FFinalVisItems do
        if item = Sender then
          item.Selected := not item.Selected
        else
          item.Selected := False;
    end;
  end;
  if not (Sender as TQuestionScrollItem).Selected then
    FLastClickedItemToEdit := nil;

  var selCnt := FFinalVisItems.SelectedCount;
  aRemoveQuestions.Enabled :=  selCnt > 0;
  aRemoveQuestions.Text := IfThen(selCnt > 1, 'Remove questions', 'Remove question');
end;

procedure TFrmMain.OnShortieQuestionItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Log('OnShortieQuestionItemMouseDown');
  if FChangingTab then
    Exit;
  if not (Sender is TQuestionScrollItem) then
    Exit;

  FLastClickedItemToEdit := Sender as TQuestionScrollItem;

  if Button = TMouseButton.mbRight then
  begin
    FLastClickedItem := Sender as TQuestionScrollItem;
    sbxShortieQuestions.BeginUpdate;
    try
      if not (Sender as TQuestionScrollItem).Selected then
      begin
        FShortieVisItems.ClearSelection;
        (Sender as TQuestionScrollItem).Selected := True;
      end;
    finally
      sbxShortieQuestions.EndUpdate;
    end;
    pmQuestions.Popup(Screen.MousePos.X, Screen.MousePos.Y);
  end
  else if ssDouble in Shift then
  begin
    FShortieVisItems.ClearSelection;
    (Sender as TQuestionScrollItem).Selected := True;
  end
  else if ssShift in Shift then
  begin
    var fIdx := 0;
    var sIdx := FShortieVisItems.IndexOf(Sender as TQuestionScrollItem);
    if Assigned(FLastClickedItem) then
      fIdx := FShortieVisItems.IndexOf(FLastClickedItem);

    if fIdx > sIdx then
    begin
      var tmp := fIdx;
      fIdx := sIdx;
      sIdx := tmp;
    end;

    for var idx := 0 to FShortieVisItems.Count - 1 do
      FShortieVisItems[idx].Selected := (idx >= fIdx) and (idx <= sIdx);
  end
  else
  begin
    FLastClickedItem := Sender as TQuestionScrollItem;
    if ssCtrl in Shift then
      (Sender as TQuestionScrollItem).Selected := not (Sender as TQuestionScrollItem).Selected
    else
    begin
      for var item in FShortieVisItems do
        if item = Sender then
          item.Selected := not item.Selected
        else
          item.Selected := False;
    end;
  end;

  if not (Sender as TQuestionScrollItem).Selected then
    FLastClickedItemToEdit := nil;

  var selCnt := FShortieVisItems.SelectedCount;
  aRemoveQuestions.Enabled :=  selCnt > 0;
  aRemoveQuestions.Text := IfThen(selCnt > 1, 'Remove questions', 'Remove question');
end;

procedure TFrmMain.PrepareMultiViewButtons(AActTab: TAppTab);
begin
  mvOptions.BeginUpdate;
  try
    bHomeButton.Visible := AActTab <> atSingleQuestion;
    bHomeButton.Enabled := (AActTab <> atHomeBeforeImport) and (AActTab <> atHome);
    bQuestions.Visible := (AActTab <> atHomeBeforeImport) and (AActTab <> atSingleQuestion);
    bQuestions.Enabled := AActTab <> atQuestions;
    bImportQuestions.Visible := (AActTab = atHome) or (AActTab = atHomeBeforeImport);
    bExportQuestions.Visible := AActTab = atQuestions;
    bAddQuestion.Visible := AActTab = atQuestions;
    bRemoveQuestions.Visible := AActTab = atQuestions;
    lineTabs.Visible := bImportQuestions.Visible or bExportQuestions.Visible;
    lineActions.Visible := bAddQuestion.Visible or bRemoveQuestions.Visible;
    
    bHomeButton.Position.Y := bMenu.Position.Y + bMenu.Height;
    bQuestions.Position.Y := bHomeButton.Position.Y + bHomeButton.Height;
    lineTabs.Position.Y := bQuestions.Position.Y + bQuestions.Height;
    bImportQuestions.Position.Y := lineTabs.Position.Y + lineTabs.Height;
    bExportQuestions.Position.Y := bImportQuestions.Position.Y + bImportQuestions.Height;
    lineActions.Position.Y := bExportQuestions.Position.Y + bExportQuestions.Height;
    bAddQuestion.Position.Y := lineActions.Position.Y + lineActions.Height;
    bRemoveQuestions.Position.Y := bAddQuestion.Position.Y + bAddQuestion.Height;
  finally
    mvOptions.EndUpdate;
  end;
end;

procedure TFrmMain.FillShortiesScrollBox;
begin
  sbxShortieQuestions.BeginUpdate;
  try
    for var item in FContent.Questions.ShortieQuestions do
    begin
      var qItem := TQuestionScrollItem.CreateItem(sbxShortieQuestions, item, FContent.Categories.GetShortieCategory(item));
      qItem.Parent := sbxShortieQuestions;
      qItem.Align := TAlignLayout.Top;
      qItem.Position.Y := MaxInt;
      qItem.OnMouseDown := OnShortieQuestionItemMouseDown;
      qItem.OnDblClick := OnShortieQuestionItemDoubleClick;
      FShortieVisItems.Add(qItem);
    end;
  finally
    sbxShortieQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.FillFinalScrollBox;
begin
  sbxFinalQuestions.BeginUpdate;
  try
    for var item in FContent.Questions.FinalQuestions do
    begin
      var qItem := TQuestionScrollItem.CreateItem(sbxFinalQuestions, item, FContent.Categories.GetFinalCategory(item));
      qItem.Parent := sbxFinalQuestions;
      qItem.Align := TAlignLayout.Top;
      qItem.Position.Y := MaxInt;
      qItem.OnMouseDown := OnFinalQuestionItemMouseDown;
      qItem.OnDblClick := OnFinalQuestionItemDoubleClick;
      FFinalVisItems.Add(qItem);
    end;
  finally
    sbxFinalQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.OnContentInitialized;
begin
  TThread.Synchronize(nil, procedure
    begin
      try
        FillShortiesScrollBox;
        FillFinalScrollBox;

        AddLastChoosenProject;
      finally
        GoToAllQuestions;
        aiContentLoading.Visible := False;
        aiContentLoading.Enabled := False;
        tcEditTabs.Visible := True;
        FLastClickedItemToEdit := nil;
        aRemoveQuestions.Enabled := False;
      end;
    end);
end;

procedure TFrmMain.pmQuestionsPopup(Sender: TObject);
begin
  var selCnt := 0;
  if tcQuestions.ActiveTab = tiShortieQuestions then
    selCnt := FShortieVisItems.SelectedCount
  else
    selCnt := FFinalVisItems.SelectedCount;
  aRemoveQuestions.Text := IfThen(selCnt > 1, 'Remove questions', 'Remove question');
  aRemoveQuestions.Enabled := selCnt > 0;
  aEditQuestion.Enabled := Assigned(FLastClickedItemToEdit) and (selCnt = 1);
end;

procedure TFrmMain.CreateNewShortieQuestion;
begin
  FContent.AddShortieQuestion;
  FSelectedQuestion := FContent.Questions.ShortieQuestions.Last;
  FSelectedCategory := FContent.Categories.GetShortieCategory(FSelectedQuestion);

  sbxShortieQuestions.BeginUpdate;
  try
    FShortieVisItems.ClearSelection;
    var qItem := TQuestionScrollItem.CreateItem(sbxShortieQuestions, FSelectedQuestion, FSelectedCategory);
    qItem.Parent := sbxShortieQuestions;
    qItem.Align := TAlignLayout.Top;
    qItem.Position.Y := MaxInt;
    qItem.OnMouseDown := OnShortieQuestionItemMouseDown;
    qItem.OnDblClick := OnShortieQuestionItemDoubleClick;
    FLastClickedItemToEdit := qItem;
    FShortieVisItems.Add(qItem);
  finally
    sbxShortieQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.CreateNewFinalQuestion;
begin
  FContent.AddFinalQuestion;
  FSelectedQuestion := FContent.Questions.FinalQuestions.Last;
  FSelectedCategory := FContent.Categories.GetFinalCategory(FSelectedQuestion);

  sbxFinalQuestions.BeginUpdate;
  try
    FFinalVisItems.ClearSelection;
    var qItem := TQuestionScrollItem.CreateItem(sbxFinalQuestions, FSelectedQuestion, FSelectedCategory);
    qItem.Parent := sbxFinalQuestions;
    qItem.Align := TAlignLayout.Top;
    qItem.Position.Y := MaxInt;
    qItem.OnMouseDown := OnFinalQuestionItemMouseDown;
    qItem.OnDblClick := OnFinalQuestionItemDoubleClick;
    FLastClickedItemToEdit := qItem;
    FFinalVisItems.Add(qItem);
  finally
    sbxFinalQuestions.EndUpdate;
  end;
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
  LogEnter(Self, 'bShortieQuestionsClick');
  GoToFinalQuestions;
  LogExit(Self, 'bShortieQuestionsClick');
end;

procedure TFrmMain.GoToAllQuestions;
begin
  FChangingTab := True;
  try
    aGoToAllQuestions.Execute;
  finally
    FChangingTab := False;
  end;
  PrepareMultiViewButtons(atQuestions);
end;

procedure TFrmMain.GoToFinalQuestions;
begin
  bShortieQuestions.IsPressed := False;
  bFinalQuestions.IsPressed := True;
  sbxFinalQuestions.BeginUpdate;
  try
    FFinalVisItems.ClearSelection;
    FLastClickedItemToEdit := nil;
    aRemoveQuestions.Enabled := FFinalVisItems.SelectedCount > 0;
  finally
    sbxFinalQuestions.EndUpdate;
  end;
  FChangingTab := True;
  try
    aGoToFinalQuestions.Execute;
  finally
    FChangingTab := False;
  end;

  bFinalQuestions.Enabled := False;
  bShortieQuestions.Enabled := True;
end;

procedure TFrmMain.GoToHome;
begin
  FChangingTab := True;
  try
    aGoToHome.Execute;
  finally
    FChangingTab := False;
  end;
  PrepareMultiViewButtons(atHome);
end;

procedure TFrmMain.bGoBackFromDetailsClick(Sender: TObject);
begin
  FSelectedQuestion.SetQuestion(mSingleItemQuestion.Text.Trim);
  FSelectedQuestion.SetAnswer(mSingleItemAnswer.Text.Trim);
  FSelectedQuestion.SetAlternateSpelling(mSingleItemAlternateSpelling.Text.Replace(', ', ',').Trim);
  FSelectedQuestion.SetSuggestions(mSingleItemSuggestions.Text.Replace(', ', ',').Trim);
  FSelectedQuestion.SetId(StrToIntDef(eSingleItemId.Text.Trim, Random(High(Word))));
  FSelectedCategory.SetId(FSelectedQuestion.GetId);
  FSelectedCategory.SetCategory(eSingleItemCategory.Text.Trim);

  if FSelectedQuestion.GetQuestionType = qtShortie then
    RefreshSelectedShortieQuestion
  else
    RefreshSelectedFinalQuestion;

  GoToAllQuestions;
end;

procedure TFrmMain.RefreshSelectedShortieQuestion;
begin
  sbxShortieQuestions.BeginUpdate;
  try
    for var item in FShortieVisItems do
      if item.OrgQuestion = FSelectedQuestion then
      begin
        item.RefreshData;
        item.Resize;
      end;
  finally
    sbxShortieQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.RefreshSelectedFinalQuestion;
begin
  sbxFinalQuestions.BeginUpdate;
  try
    for var item in FFinalVisItems do
      if item.OrgQuestion = FSelectedQuestion then
      begin
        item.RefreshData;
        item.Resize;
      end;
  finally
    sbxFinalQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.bHomeButtonClick(Sender: TObject);
begin
  GoToHome;
end;

procedure TFrmMain.bShortieQuestionsClick(Sender: TObject);
begin
  LogEnter(Self, 'bShortieQuestionsClick');
  GoToShortieQuestions;
  LogExit(Self, 'bShortieQuestionsClick');
end;

procedure TFrmMain.GoToShortieQuestions;
begin
  bFinalQuestions.IsPressed := False;
  bShortieQuestions.IsPressed := True;
  sbxShortieQuestions.BeginUpdate;
  try
    FShortieVisItems.ClearSelection;
    FLastClickedItemToEdit := nil;
    aRemoveQuestions.Enabled := FShortieVisItems.SelectedCount > 0;
  finally
    sbxShortieQuestions.EndUpdate;
  end;
  FChangingTab := True;
  try
    aGoToShortieQuestions.Execute;
  finally
    FChangingTab := False;
  end;
  bShortieQuestions.Enabled := False;
  bFinalQuestions.Enabled := True;
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

  PrepareMultiViewButtons(atHomeBeforeImport);

  FShortieVisItems := TQuestionScrollItems.Create;
  FFinalVisItems := TQuestionScrollItems.Create;

  sDarkMode.IsChecked := TAppConfig.GetInstance.DarkModeEnabled;

  tcEditTabs.ActiveTab := tiQuestionProjects;
  tcQuestions.ActiveTab := tiShortieQuestions;

  FLastQuestionProjects := GlobalContainer.Resolve<ILastQuestionProjects>;
  FLastQuestionProjects.Initialize;
  InitializeLastQuestionProjects;

  if lvQuestionProjects.Items.Count = 0 then
    mvOptions.ShowMaster;

  FAppCreated := True;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Log('Destroying');
  FShortieVisItems.Free;
  FFinalVisItems.Free;
  Log('Destroyed');
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if tcEditTabs.ActiveTab <> tiQuestions then
    Exit;

  if (ssCtrl in Shift) and (Key = vkA) then
  begin
    if tcQuestions.ActiveTab = tiShortieQuestions then
      FShortieVisItems.SelectAll
    else if tcQuestions.ActiveTab = tiFinalQuestions then
      FFinalVisItems.SelectAll;
  end;
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
  mSingleItemQuestion.Text := FSelectedQuestion.GetQuestion;
  mSingleItemAnswer.Text := FSelectedQuestion.GetAnswer;
  mSingleItemAlternateSpelling.Text :=  FSelectedQuestion.GetAlternateSpelling.Replace(',', ', ');
  mSingleItemSuggestions.Text := FSelectedQuestion.GetSuggestions.Replace(',', ', ');
  eSingleItemId.Text := FSelectedCategory.GetId.ToString;
  eSingleItemCategory.Text := FSelectedCategory.GetCategory;

  FChangingTab := True;
  try
    aGoToQuestionDetails.Execute;
  finally
    FChangingTab := False;
  end;
  PrepareMultiViewButtons(atSingleQuestion);
  aRemoveQuestions.Enabled := True;
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

procedure TFrmMain.lvQuestionProjectsDblClick(Sender: TObject);
begin
  var selectedItem := lvQuestionProjects.Items[lvQuestionProjects.ItemIndex];
  var contentDir := selectedItem.Data['ProjectPath'].AsString;

  var pathChecker := GlobalContainer.Resolve<IFibbagePathChecker>;
  if not pathChecker.IsValid(contentDir) then
    ShowMessage('Game content is not available at this path')
  else
    InitializeContent(contentDir);
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

procedure TFrmMain.ToolBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin

end;

{ TQuestionScrollItem }

constructor TQuestionScrollItem.CreateItem(AOwner: TComponent; AQuestion: IQuestion; ACategory: ICategory);
begin
  inherited Create(AOwner);

  StyleLookup := 'rScrollItemStyle';
  HitTest := True;

  FOrgQuestion := AQuestion;
  FOrgCategory := ACategory;

  FDetails := TLabel.Create(AOwner);
  FDetails.Parent := Self;
  FDetails.Align := TAlignLayout.MostTop;
  FDetails.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FDetails.TextSettings.Font.Size := 13;
  FDetails.Margins.Left := 10;
  FDetails.Margins.Right := 10;
  FDetails.Margins.Top := 10;
  FDetails.StyleLookup := 'listboxitemdetaillabel';

  FQuestion := TLabel.Create(AOwner);
  FQuestion.Parent := Self;
  FQuestion.Align := TAlignLayout.Top;
  FQuestion.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FQuestion.TextAlign := TTextAlign.Center;
  FQuestion.TextSettings.Font.Size := 18;
  FQuestion.Margins.Left := 15;
  FQuestion.Margins.Right := 5;
  FQuestion.StyleLookup := 'listboxitemlabel';

  RefreshData;
end;

procedure TQuestionScrollItem.RefreshData;
begin
  FDetails.Text := Format('Id: %d, Category: %s', [FOrgCategory.GetId, FOrgCategory.GetCategory]);
  FQuestion.Text := FOrgQuestion.GetQuestion;
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

procedure TQuestionScrollItem.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  if FSelected then
    StyleLookup := 'rScrollItemSelectedStyle'
  else
    StyleLookup := 'rScrollItemStyle';
end;

{ TQuestionScrollItems }

procedure TQuestionScrollItems.ClearSelection;
begin
  for var item in Self do
    item.Selected := False;
end;

procedure TQuestionScrollItems.SelectAll;
begin
  for var item in Self do
    item.Selected := True;
end;

function TQuestionScrollItems.SelectedCount: Integer;
begin
  Result := 0;
  for var item in Self do
    if item.Selected then
      Inc(Result);
end;

end.
