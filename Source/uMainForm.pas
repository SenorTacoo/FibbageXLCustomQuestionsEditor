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
  System.Messaging, System.DateUtils, uLog, uCategoriesLoader,
  FMX.Menus, System.StrUtils, uGetTextDlg, FMX.Objects, FMX.DialogService, uAsyncAction,
  FMX.Effects;

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

  TProjectScrollItem = class(TPanel)
  private
    FName: TLabel;
    FPath: TLabel;
    FOrgConfiguration: IContentConfiguration;
    FSelected: Boolean;
    procedure SetSelected(const Value: Boolean);
  protected
    procedure Resize; override;
  public
    constructor CreateItem(AOwner: TComponent; AConfiguration: IContentConfiguration);

    procedure RefreshData;

    property Selected: Boolean read FSelected write SetSelected;
    property OrgConfiguration: IContentConfiguration read FOrgConfiguration;
  end;

  TProjectScrollItems = class(TList<TProjectScrollItem>)
  private
    FOwnerScroll: TCustomScrollBox;
  public
    constructor Create(AOwner: TCustomScrollBox);

    procedure ClearSelection;
    procedure SelectAll;
    function SelectedCount: Integer;
  end;

  TAppTab = (atHomeBeforeImport, atHome, atQuestions, atSingleQuestion);

  TFrmMain = class(TForm)
    mvHomeOptions: TMultiView;
    bMenu: TButton;
    bImportQuestions: TButton;
    alMain: TActionList;
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
    aGoToHome: TChangeTabAction;
    bQuestions: TButton;
    sbxShortieQuestions: TVertScrollBox;
    sbxFinalQuestions: TVertScrollBox;
    tbQuestionProjects: TToolBar;
    lProjects: TLabel;
    ToolBar2: TToolBar;
    lProjectQuestions: TLabel;
    ToolBar3: TToolBar;
    lNewQuestion: TLabel;
    GridPanelLayout2: TGridPanelLayout;
    bShortieQuestions: TButton;
    bFinalQuestions: TButton;
    bNewProject: TButton;
    lineTabs: TLine;
    pmQuestions: TPopupMenu;
    miAddQuestion: TMenuItem;
    miEditQuestion: TMenuItem;
    miRemoveQuestions: TMenuItem;
    aRemoveQuestions: TAction;
    aAddQuestion: TAction;
    aEditQuestion: TAction;
    lyProjectsContent: TLayout;
    lyQuestionsContent: TLayout;
    mvQuestionsOptions: TMultiView;
    bQuestionsMenu: TButton;
    bSaveQuestions: TButton;
    Layout1: TLayout;
    sDarkModeOptions: TSwitch;
    lDarkModeOptions: TLabel;
    bGoToHome: TButton;
    bAddQuestion: TButton;
    bRemoveQuestions: TButton;
    Line1: TLine;
    Line2: TLine;
    aNewProject: TAction;
    aSaveProject: TAction;
    aImportProject: TAction;
    bRemoveProjects: TButton;
    aRemoveProjects: TAction;
    Line3: TLine;
    sbxProjects: TVertScrollBox;
    aInitializeProject: TAction;
    pmProjects: TPopupMenu;
    miAddProject: TMenuItem;
    miEditProjectDetails: TMenuItem;
    miRemoveProject: TMenuItem;
    miImportProject: TMenuItem;
    aEditProjectDetails: TAction;
    miAddSeparator: TMenuItem;
    miEditSeparator: TMenuItem;
    aRemoveProjectsAllData: TAction;
    aRemoveProjectsJustLastInfo: TAction;
    tiEditProject: TTabItem;
    ToolBar4: TToolBar;
    lEditProject: TLabel;
    bGoBackFromEditProject: TButton;
    lyEditProjectName: TLayout;
    eProjectName: TEdit;
    lEditProjectName: TLabel;
    lyEditProjectContent: TLayout;
    aGoToEditProject: TChangeTabAction;
    miEditProjectQuestions: TMenuItem;
    bSaveQuestionsAs: TButton;
    aSaveProjectAs: TAction;
    pLoading: TPanel;
    pContent: TPanel;
    pQuestionToolbar: TPanel;
    pQuestionsToolbar: TPanel;
    pProjectToolbar: TPanel;
    pProjectsToolbar: TPanel;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    GlowEffect3: TGlowEffect;
    pQuestionsButtons: TPanel;
    GlowEffect5: TGlowEffect;
    pQuestionsMultiview: TPanel;
    pProjectsMultiview: TPanel;
    procedure lDarkModeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvEditAllItemsUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure bSingleItemQuestionAudioClick(Sender: TObject);
    procedure bSingleItemCorrectAudioClick(Sender: TObject);
    procedure bSingleItemBumperAudioClick(Sender: TObject);
    procedure bGoBackFromDetailsClick(Sender: TObject);
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
    procedure aNewProjectExecute(Sender: TObject);
    procedure aSaveProjectExecute(Sender: TObject);
    procedure aImportProjectExecute(Sender: TObject);
    procedure bGoToHomeClick(Sender: TObject);
    procedure lDarkModeOptionsClick(Sender: TObject);
    procedure sDarkModeOptionsSwitch(Sender: TObject);
    procedure sDarkModeSwitch(Sender: TObject);
    procedure aRemoveProjectsExecute(Sender: TObject);
    procedure aInitializeProjectExecute(Sender: TObject);
    procedure aEditProjectDetailsExecute(Sender: TObject);
    procedure pmProjectsPopup(Sender: TObject);
    procedure aRemoveProjectsAllDataExecute(Sender: TObject);
    procedure aRemoveProjectsJustLastInfoExecute(Sender: TObject);
    procedure bGoBackFromEditProjectClick(Sender: TObject);
    procedure aSaveProjectAsExecute(Sender: TObject);
  private
    FAppCreated: Boolean;
    FChangingTab: Boolean;
    FContent: IFibbageContent;

    FSelectedQuestion: IQuestion;
    FSelectedCategory: ICategory;
    FSelectedConfiguration: IContentConfiguration;

    FLastQuestionProjects: ILastQuestionProjects;

    FLastClickedItem: TQuestionScrollItem;
    FLastClickedItemToEdit: TQuestionScrollItem;

    FLastClickedConfiguration: TProjectScrollItem;
    FLastClickedConfigurationToEdit: TProjectScrollItem;

    FShortieVisItems: TQuestionScrollItems;
    FFinalVisItems: TQuestionScrollItems;

    FProjectVisItems: TProjectScrollItems;

    procedure GoToQuestionDetails;
    procedure AddLastChoosenProject;
    procedure InitializeLastQuestionProjects;
    procedure GoToFinalQuestions;
    procedure GoToShortieQuestions;
    procedure GoToAllQuestions;
    procedure GoToHome;
    procedure GoToEditProject;

    procedure PrepareMultiViewButtons(AActTab: TAppTab);
    procedure OnProjectItemDoubleClick(Sender: TObject);
    procedure OnProjectItemMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
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
    procedure SetDarkMode(AEnabled: Boolean);
    function GetProjectName(out AName: string): Boolean;
    function GetProjectPath(out APath: string): Boolean;
    procedure ProcessInitializeProject;
    procedure ClearPreviousData;
    procedure ClearPreviousProjects;
    procedure RemoveProjects;
    procedure InitializeContentTask;
    procedure PostContentInitialized;
    procedure PreContentInitialized;
    procedure OnPostSaveAs;
    procedure OnPreSaveAs;
    procedure SaveProc;
    procedure OnPostSave;
    procedure OnPreSave;
    procedure OnRemoveProjectEnd;
    procedure OnRemoveProjectStart;
    procedure OnRemoveProject;
    procedure OnRemoveProjectFullWipe;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.aAddQuestionExecute(Sender: TObject);
begin
  if FChangingTab then
    Exit;

  if tcQuestions.ActiveTab = tiShortieQuestions then
    CreateNewShortieQuestion
  else
    CreateNewFinalQuestion;

  lNewQuestion.Text := 'New question';
  GoToQuestionDetails;
end;

procedure TFrmMain.AddLastChoosenProject;
begin
  FLastQuestionProjects.BeginUpdate;
  try
    FLastQuestionProjects.Add(FSelectedConfiguration);
  finally
    FLastQuestionProjects.EndUpdate;
  end;
end;

procedure TFrmMain.aEditProjectDetailsExecute(Sender: TObject);
begin
  if not Assigned(FLastClickedConfiguration) then
    Exit;

  eProjectName.Text := FLastClickedConfiguration.OrgConfiguration.GetName;
  GoToEditProject;
end;

procedure TFrmMain.aEditQuestionExecute(Sender: TObject);
begin
  if not Assigned(FLastClickedItemToEdit) then
    Exit;

  FSelectedQuestion := FLastClickedItemToEdit.OrgQuestion;
  FSelectedCategory := FLastClickedItemToEdit.OrgCategory;
  FLastClickedItemToEdit.Selected := True;

  lNewQuestion.Text := 'Edit question';
  GoToQuestionDetails;
end;

procedure TFrmMain.aImportProjectExecute(Sender: TObject);
var
  str: string;
begin
  var pathChecker := GlobalContainer.Resolve<IFibbagePathChecker>;
  var cfg := GlobalContainer.Resolve<IContentConfiguration>;
  while True do
    if not GetProjectPath(str) then
      Exit
    else if pathChecker.IsValid(str) then
      Break
    else
      ShowMessage('Invalid path, question directories not found');

  if not cfg.Initialize(str) then
  begin
    cfg.SetPath(str);
    if not GetProjectName(str) then
      Exit;
    cfg.SetName(str);
    cfg.Save(cfg.GetPath);
  end;

  sbxProjects.BeginUpdate;
  try
    FProjectVisItems.ClearSelection;
    var pItem := TProjectScrollItem.CreateItem(sbxProjects, cfg);
    pItem.Parent := sbxProjects;
    pItem.Align := TAlignLayout.Top;
    pItem.Position.Y := -999;
    pItem.OnMouseDown := OnProjectItemMouseDown;
    pItem.OnDblClick := OnProjectItemDoubleClick;
    FLastClickedConfigurationToEdit := pItem;
    FProjectVisItems.Add(pItem);
    pItem.Selected := True;
  finally
    sbxProjects.EndUpdate;
  end;

  aInitializeProject.Execute;
end;

procedure TFrmMain.aInitializeProjectExecute(Sender: TObject);
begin
  if Assigned(FContent) then
  begin
    TDialogService.MessageDialog('Save changes?', TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbCancel], TMsgDlgBtn.mbCancel, 0,
      procedure (const AResult: TModalResult)
      begin
        case AResult of
          mrYes: aSaveProject.Execute;
          mrCancel: Exit;
        end;
        ProcessInitializeProject;
      end);
  end
  else
    ProcessInitializeProject;
end;

procedure TFrmMain.ProcessInitializeProject;
begin
  FSelectedConfiguration := nil;
  for var item in FProjectVisItems do
    if item.Selected then
    begin
      FSelectedConfiguration := item.OrgConfiguration;
      Break;
    end;

  if not Assigned(FSelectedConfiguration) then
  begin
    LogE('ProcessInitializeProject selected configuration not assigned, selected count: %d/%d', [FProjectVisItems.SelectedCount, FProjectVisItems.Count]);
    Exit;
  end;
  ClearPreviousData;
  TAppConfig.GetInstance.LastEditPath := FSelectedConfiguration.GetPath;

  TAsyncAction.Create(PreContentInitialized, PostContentInitialized, InitializeContentTask).Start;
end;

procedure TFrmMain.PreContentInitialized;
begin
  aiContentLoading.Enabled := True;
  pLoading.Visible := True;
  mvHomeOptions.HideMaster;
end;

procedure TFrmMain.PostContentInitialized;
begin
  try
    FillShortiesScrollBox;
    FillFinalScrollBox;

    AddLastChoosenProject;
  finally
    GoToAllQuestions;
    pLoading.Visible := False;
    aiContentLoading.Enabled := False;
    FLastClickedItemToEdit := nil;
    aRemoveQuestions.Enabled := False;
    lProjectQuestions.Text := Format('Questions - %s', [FSelectedConfiguration.GetName]);
  end;
end;

procedure TFrmMain.InitializeContentTask;
begin
  FContent := GlobalContainer.Resolve<IFibbageContent>;
  FContent.Initialize(FSelectedConfiguration);
end;

procedure TFrmMain.ClearPreviousData;
begin
  sbxShortieQuestions.BeginUpdate;
  try
    while FShortieVisItems.Count > 0 do
    begin
      var item := FShortieVisItems.ExtractAt(0);
      FreeAndNil(item);
    end;
  finally
    sbxShortieQuestions.EndUpdate;
  end;

  sbxFinalQuestions.BeginUpdate;
  try
    while FFinalVisItems.Count > 0 do
    begin
      var item := FFinalVisItems.ExtractAt(0);
      FreeAndNil(item);
    end;
  finally
    sbxFinalQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.ClearPreviousProjects;
begin
  sbxFinalQuestions.BeginUpdate;
  try
    while FProjectVisItems.Count > 0 do
    begin
      var item := FProjectVisItems.ExtractAt(0);
      FreeAndNil(item);
    end;
  finally
    sbxFinalQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.aNewProjectExecute(Sender: TObject);
var
  str: string;
begin
  var cfg := GlobalContainer.Resolve<IContentConfiguration>;
  if not GetProjectName(str) then
    Exit;
  cfg.SetName(str);
  if not GetProjectPath(str) then
    Exit;
  cfg.SetPath(str);
  cfg.Save(cfg.GetPath);

  sbxProjects.BeginUpdate;
  try
    FProjectVisItems.ClearSelection;
    var pItem := TProjectScrollItem.CreateItem(sbxProjects, cfg);
    pItem.Parent := sbxProjects;
    pItem.Align := TAlignLayout.Top;
    pItem.Position.Y := -999;
    pItem.OnMouseDown := OnProjectItemMouseDown;
    pItem.OnDblClick := OnProjectItemDoubleClick;
    FLastClickedConfigurationToEdit := pItem;
    FProjectVisItems.Add(pItem);
    pItem.Selected := True;
  finally
    sbxProjects.EndUpdate;
  end;

  aInitializeProject.Execute;
end;

procedure TFrmMain.OnRemoveProjectStart;
begin
  pLoading.Visible := True;
  aiContentLoading.Enabled := True;
  sbxProjects.BeginUpdate;
  FLastQuestionProjects.BeginUpdate;
end;

procedure TFrmMain.OnRemoveProjectEnd;
begin
  for var idx := FProjectVisItems.Count - 1 downto 0 do
  begin
    if not FProjectVisItems[idx].Selected then
      Continue;

    var item := FProjectVisItems.ExtractAt(idx);
    FreeAndNil(item);
  end;
  FLastQuestionProjects.EndUpdate;
  sbxProjects.EndUpdate;

  pLoading.Visible := False;
  aiContentLoading.Enabled := False;
end;

procedure TFrmMain.OnRemoveProject;
begin
  for var idx := 0 to FProjectVisItems.Count - 1 do
  begin
    if not FProjectVisItems[idx].Selected then
      Continue;

    FLastQuestionProjects.Remove(FProjectVisItems[idx].OrgConfiguration);
  end;
end;

procedure TFrmMain.OnRemoveProjectFullWipe;
begin
  for var idx := 0 to FProjectVisItems.Count - 1 do
  begin
    if not FProjectVisItems[idx].Selected then
      Continue;
    TDirectory.Delete(FProjectVisItems[idx].OrgConfiguration.GetPath, True);
    FLastQuestionProjects.Remove(FProjectVisItems[idx].OrgConfiguration);
  end;
end;

procedure TFrmMain.aRemoveProjectsAllDataExecute(Sender: TObject);
begin
  TAsyncAction.Create(OnRemoveProjectStart, OnRemoveProjectEnd, OnRemoveProjectFullWipe).Start
end;

procedure TFrmMain.aRemoveProjectsExecute(Sender: TObject);
var
  closeContent: Boolean;
begin
  closeContent := False;
  for var item in FProjectVisItems do
    if item.Selected then
      if item.OrgConfiguration = FSelectedConfiguration then
      begin
        closeContent := True;
        Break;
      end;

  if closeContent then
  begin
    TDialogService.MessageDialog('You are trying to remove currently open project. Continue?',
      TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          RemoveProjects;

          ClearPreviousData;
          FContent := nil;
          FSelectedConfiguration := nil;
          bQuestions.Enabled := False;
        end;
      end);
  end
  else
    RemoveProjects;
end;

procedure TFrmMain.RemoveProjects;
begin
  TDialogService.MessageDialog('Do you also want to remove questions?',
    TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
        aRemoveProjectsAllData.Execute
      else
        aRemoveProjectsJustLastInfo.Execute;
      aRemoveProjects.Enabled := False;
    end);
end;

procedure TFrmMain.aRemoveProjectsJustLastInfoExecute(Sender: TObject);
begin
  TAsyncAction.Create(OnRemoveProjectStart, OnRemoveProjectEnd, OnRemoveProject).Start;
end;

procedure TFrmMain.aRemoveQuestionsExecute(Sender: TObject);
begin
  if tcQuestions.ActiveTab = tiShortieQuestions then
    RemoveSelectedShortieQuestions
  else
    RemoveSelectedFinalQuestions;
end;

procedure TFrmMain.aSaveProjectAsExecute(Sender: TObject);
var
  path: string;
begin
  if not GetProjectPath(path) then
    Exit;
  FSelectedConfiguration.SetPath(path);

  TAsyncAction.Create(OnPreSaveAs, OnPostSaveAs, SaveProc).Start;
end;

procedure TFrmMain.OnPreSaveAs;
begin
  pLoading.Visible := True;
  aiContentLoading.Enabled := True;
end;

procedure TFrmMain.OnPostSaveAs;
begin
  AddLastChoosenProject;
  InitializeLastQuestionProjects;
  aRemoveProjects.Enabled := False;

  pLoading.Visible := False;
  aiContentLoading.Enabled := False;
end;

procedure TFrmMain.SaveProc;
begin
  FContent.Save;
end;

procedure TFrmMain.aSaveProjectExecute(Sender: TObject);
begin
  TAsyncAction.Create(OnPreSave, OnPostSave, SaveProc).Start;
end;

procedure TFrmMain.OnPreSave;
begin
  pLoading.Visible := True;
  aiContentLoading.Enabled := True;
end;

procedure TFrmMain.OnPostSave;
begin
  pLoading.Visible := False;
  aiContentLoading.Enabled := False;
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
    aRemoveQuestions.Enabled := False;
    sbxShortieQuestions.EndUpdate;
  end;
end;

procedure TFrmMain.sDarkModeOptionsSwitch(Sender: TObject);
begin
  SetDarkMode(sDarkModeOptions.IsChecked);
end;

procedure TFrmMain.sDarkModeSwitch(Sender: TObject);
begin
  SetDarkMode(sDarkMode.IsChecked);
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
    aRemoveQuestions.Enabled := False;
    sbxFinalQuestions.EndUpdate;
  end;
end;

function TFrmMain.GetProjectPath(out APath: string): Boolean;
begin
  Result := SelectDirectory('Select directory', '', APath);
end;

function TFrmMain.GetProjectName(out AName: string): Boolean;
begin
  var dlg := TGetTextDlg.Create(Self);
  try
    Result := dlg.GetText('Enter new project name:', AName);
  finally
    dlg.Free;
  end;
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

procedure TFrmMain.OnProjectItemDoubleClick(Sender: TObject);
begin
  Log('OnProjectItemDoubleClick');
  if FChangingTab then
    Exit;

  aInitializeProject.Execute;
end;

procedure TFrmMain.OnProjectItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if FChangingTab then
    Exit;
  if not (Sender is TProjectScrollItem) then
    Exit;

  FLastClickedConfigurationToEdit := Sender as TProjectScrollItem;

  if Button = TMouseButton.mbRight then
  begin
    FLastClickedConfiguration := Sender as TProjectScrollItem;
    sbxProjects.BeginUpdate;
    try
      if not (Sender as TProjectScrollItem).Selected then
      begin
        FProjectVisItems.ClearSelection;
        (Sender as TProjectScrollItem).Selected := True;
      end;
    finally
      sbxProjects.EndUpdate;
    end;
    pmProjects.Popup(Screen.MousePos.X, Screen.MousePos.Y);
  end
  else if ssDouble in Shift then
  begin
    FProjectVisItems.ClearSelection;
    (Sender as TProjectScrollItem).Selected := True;
  end
  else if ssShift in Shift then
  begin
    var fIdx := 0;
    var sIdx := FProjectVisItems.IndexOf(Sender as TProjectScrollItem);
    if Assigned(FLastClickedConfiguration) then
      fIdx := FProjectVisItems.IndexOf(FLastClickedConfiguration);

    if fIdx > sIdx then
    begin
      var tmp := fIdx;
      fIdx := sIdx;
      sIdx := tmp;
    end;

    for var idx := 0 to FProjectVisItems.Count - 1 do
      FProjectVisItems[idx].Selected := (idx >= fIdx) and (idx <= sIdx);
  end
  else
  begin
    FLastClickedConfiguration := Sender as TProjectScrollItem;
    if ssCtrl in Shift then
      (Sender as TProjectScrollItem).Selected := not (Sender as TProjectScrollItem).Selected
    else
    begin
      for var item in FProjectVisItems do
        if item = Sender then
          item.Selected := not item.Selected
        else
          item.Selected := False;
    end;
  end;

  if not (Sender as TProjectScrollItem).Selected then
    FLastClickedConfigurationToEdit := nil;

  var selCnt := FProjectVisItems.SelectedCount;
  aRemoveProjects.Enabled :=  selCnt > 0;
  aRemoveProjects.Text := IfThen(selCnt > 1, 'Remove projects', 'Remove project');
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
  mvHomeOptions.BeginUpdate;
  try
    bQuestions.Enabled := AActTab <> atHomeBeforeImport;
  finally
    mvHomeOptions.EndUpdate;
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

procedure TFrmMain.pmProjectsPopup(Sender: TObject);
begin
  var selCnt := FProjectVisItems.SelectedCount;

  aRemoveProjects.Text := IfThen(selCnt > 1, 'Remove projects', 'Remove project');
  aRemoveProjects.Enabled := selCnt > 0;
  aEditProjectDetails.Enabled := Assigned(FLastClickedConfigurationToEdit) and (selCnt = 1);
end;

procedure TFrmMain.pmQuestionsPopup(Sender: TObject);
var
  selCnt: Integer;
begin
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

procedure TFrmMain.GoToEditProject;
begin
  FChangingTab := True;
  try
    aGoToEditProject.Execute;
  finally
    FChangingTab := False;
  end;
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

procedure TFrmMain.bGoBackFromEditProjectClick(Sender: TObject);
begin
  var doSave := eProjectName.Text <> FLastClickedConfiguration.OrgConfiguration.GetName;

  FLastClickedConfiguration.OrgConfiguration.SetName(eProjectName.Text);
  FLastClickedConfiguration.RefreshData;
  if doSave then
    FLastClickedConfiguration.OrgConfiguration.Save(FLastClickedConfiguration.OrgConfiguration.GetPath);
  GoToHome;
end;

procedure TFrmMain.bGoToHomeClick(Sender: TObject);
begin
  GoToHome;
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

  FProjectVisItems := TProjectScrollItems.Create(sbxProjects);

  FShortieVisItems := TQuestionScrollItems.Create;
  FFinalVisItems := TQuestionScrollItems.Create;

  sDarkMode.IsChecked := TAppConfig.GetInstance.DarkModeEnabled;

  tcEditTabs.ActiveTab := tiQuestionProjects;
  tcQuestions.ActiveTab := tiShortieQuestions;

  FLastQuestionProjects := GlobalContainer.Resolve<ILastQuestionProjects>;
  FLastQuestionProjects.Initialize;
  InitializeLastQuestionProjects;

  if FLastQuestionProjects.Count = 0 then
    mvHomeOptions.ShowMaster;

  FAppCreated := True;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Log('Destroying');
  FShortieVisItems.Free;
  FFinalVisItems.Free;
  FProjectVisItems.Free;
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
  var items := FLastQuestionProjects.GetAll;
  sbxProjects.BeginUpdate;
  try
    ClearPreviousProjects;
    for var item in items do
    begin
      var pItem := TProjectScrollItem.CreateItem(sbxProjects, item);
      pItem.Parent := sbxProjects;
      pItem.Align := TAlignLayout.Top;
      pItem.Position.Y := MaxInt;
      pItem.OnMouseDown := OnProjectItemMouseDown;
      pItem.OnDblClick := OnProjectItemDoubleClick;
      FProjectVisItems.Add(pItem);
    end;
  finally
    items.Free;
    sbxProjects.EndUpdate;
  end;
end;

procedure TFrmMain.lDarkModeClick(Sender: TObject);
begin
  sDarkMode.IsChecked := not sDarkMode.IsChecked;
end;

procedure TFrmMain.lDarkModeOptionsClick(Sender: TObject);
begin
  sDarkModeOptions.IsChecked := not sDarkModeOptions.IsChecked;
end;

procedure TFrmMain.SetDarkMode(AEnabled: Boolean);
begin
  sDarkMode.IsChecked := AEnabled;
  sDarkModeOptions.IsChecked := AEnabled;

  if AEnabled then
    StyleBook := sbDarkStyle
  else
    StyleBook := sbLightStyle;

  if FAppCreated then
    TAppConfig.GetInstance.DarkModeEnabled := AEnabled;
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

{ TProjectScrollItem }

constructor TProjectScrollItem.CreateItem(AOwner: TComponent; AConfiguration: IContentConfiguration);
begin
  inherited Create(AOwner);

  StyleLookup := 'rScrollItemStyle';
  HitTest := True;

  FOrgConfiguration := AConfiguration;

  FName := TLabel.Create(AOwner);
  FName.Parent := Self;
  FName.Align := TAlignLayout.Client;
  FName.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FName.TextAlign := TTextAlign.Center;
  FName.TextSettings.Font.Size := 18;
  FName.WordWrap := False;
  FName.Margins.Left := 10;
  FName.Margins.Right := 10;
  FName.Margins.Top := 15;
  FName.Margins.Bottom := 10;
  FName.StyleLookup := 'listboxitemlabel';

  FPath := TLabel.Create(AOwner);
  FPath.Parent := Self;
  FPath.Align := TAlignLayout.Bottom;
  FPath.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
  FPath.TextAlign := TTextAlign.Leading;
  FPath.TextSettings.Font.Size := 13;
  FPath.Margins.Left := 15;
  FPath.Margins.Right := 5;
  FPath.Margins.Bottom := 5;
  FPath.WordWrap := False;
  FPath.StyleLookup := 'listboxitemdetaillabel';

  RefreshData;
end;

procedure TProjectScrollItem.RefreshData;
begin
  FName.Text := FOrgConfiguration.GetName;
  FPath.Text := FOrgConfiguration.GetPath;
end;

procedure TProjectScrollItem.Resize;
begin
  inherited;

  FName.Canvas.Font.Assign(FName.Font);
  var wantedHeight := Ceil(FName.Canvas.TextHeight('Yy'));

  FPath.Canvas.Font.Assign(FPath.Font);
  wantedHeight := wantedHeight + Ceil(FPath.Canvas.TextHeight('Yy'));

  Height := wantedHeight + FPath.Margins.Top + FPath.Margins.Bottom +
    FName.Margins.Top + FName.Margins.Bottom
end;

procedure TProjectScrollItem.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
  if FSelected then
    StyleLookup := 'rScrollItemSelectedStyle'
  else
    StyleLookup := 'rScrollItemStyle';
end;

{ TProjectScrollItems }

procedure TProjectScrollItems.ClearSelection;
begin
  for var item in Self do
    item.Selected := False;
end;

constructor TProjectScrollItems.Create(AOwner: TCustomScrollBox);
begin
  inherited Create;
  FOwnerScroll := AOwner;
end;

procedure TProjectScrollItems.SelectAll;
begin
  for var item in Self do
    item.Selected := True;
end;

function TProjectScrollItems.SelectedCount: Integer;
begin
  Result := 0;
  for var item in Self do
    if item.Selected then
      Inc(Result);
end;

end.
