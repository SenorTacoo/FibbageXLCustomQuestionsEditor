unit uRecordForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, NewAC_DSP,
  ACS_Classes, NewACIndicators, FMX.Controls.Presentation, FMX.StdCtrls,
  ACS_Vorbis, ACS_DXAudio, FMX.ListBox, uInterfaces, FMX.Layouts,
  ACS_Converters, NewACDSAudio, FMX.Media, uConfig, System.IOUtils;

type
  TAudioType = (atQuestion, atAnswer, atBumper);

  TRecordForm = class(TForm)
    DXAudioIn1: TDXAudioIn;
    voMic: TVorbisOut;
    bPlayOriginalAudio: TButton;
    bPlayRecordedAudio: TButton;
    bRecordAudio: TButton;
    bGoBack: TButton;
    bSaveRecordedAudio: TButton;
    Layout1: TLayout;
    lAudioInput: TLabel;
    cbAudioInput: TComboBox;
    Layout2: TLayout;
    lAudioOutput: TLabel;
    cbAudioOutput: TComboBox;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    DSAudioOut1: TDSAudioOut;
    VorbisIn1: TVorbisIn;
    StereoBalance1: TStereoBalance;
    procedure bPlayOriginalAudioClick(Sender: TObject);
    procedure bPlayRecordedAudioClick(Sender: TObject);
    procedure bGoBackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bRecordAudioClick(Sender: TObject);
    procedure bSaveRecordedAudioClick(Sender: TObject);
    procedure bRefreshDevicesClick(Sender: TObject);
    procedure cbAudioOutputChange(Sender: TObject);
    procedure cbAudioInputChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure voMicDone(Sender: TComponent);
    procedure DSAudioOut1Done(Sender: TComponent);
  private
    FAudioType: TAudioType;
    FQuestion: IQuestion;
    FFormCreated: Boolean;

    procedure FillDevices;
    procedure DisablePlay;
    procedure DisableRecord;
    procedure PlayAudio(const APath: string);
    procedure OnOutputAudioStart;
    procedure SaveAudio;
    procedure RemoveTmpFile;
    procedure OnInputAudioStart;
  public
    procedure EditQuestionAudio(AQuestion: IQuestion);
    procedure EditAnswerAudio(AQuestion: IQuestion);
    procedure EditBumperAudio(AQuestion: IQuestion);
  end;

implementation

{$R *.fmx}

uses
  uMainForm;

procedure TRecordForm.bPlayOriginalAudioClick(Sender: TObject);
begin
  case FAudioType of
    atQuestion:
      PlayAudio(FQuestion.QuestionAudioPath);
    atAnswer:
      PlayAudio(FQuestion.CorrectItemAudioPath);
    atBumper:
      PlayAudio(FQuestion.BumperAudioPath);
  end;
end;

procedure TRecordForm.bPlayRecordedAudioClick(Sender: TObject);
begin
  PlayAudio(voMic.FileName);
end;

procedure TRecordForm.bRecordAudioClick(Sender: TObject);
begin
  if voMic.Input.IsBusy then
    voMic.Stop
  else
  begin
    RemoveTmpFile;

    DXAudioIn1.DeviceNumber := cbAudioInput.ItemIndex;
    voMic.FileName := TPath.Combine(TPath.GetTempPath, ChangeFileExt(TPath.GetRandomFileName, '.ogg'));
    voMic.Run;
  end;
end;

procedure TRecordForm.bRefreshDevicesClick(Sender: TObject);
begin
  FillDevices;
end;

procedure TRecordForm.bSaveRecordedAudioClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TRecordForm.cbAudioInputChange(Sender: TObject);
begin
  if not FFormCreated then
    Exit;

  TAppConfig.GetInstance.InputDeviceName := cbAudioInput.Items[cbAudioInput.ItemIndex];
end;

procedure TRecordForm.cbAudioOutputChange(Sender: TObject);
begin
  if not FFormCreated then
    Exit;

  TAppConfig.GetInstance.OutputDeviceName := cbAudioOutput.Items[cbAudioOutput.ItemIndex];
end;

procedure TRecordForm.DisablePlay;
begin
  bPlayOriginalAudio.Enabled := False;
  bPlayRecordedAudio.Enabled := False;
end;

procedure TRecordForm.DisableRecord;
begin
  bRecordAudio.Enabled := False;
end;

procedure TRecordForm.DSAudioOut1Done(Sender: TComponent);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    bPlayOriginalAudio.Enabled := True;
    bRecordAudio.Enabled := True;
    bPlayRecordedAudio.Enabled := (voMic.FileName <> '') and FileExists(voMic.FileName);
  end);
end;

procedure TRecordForm.EditAnswerAudio(AQuestion: IQuestion);
begin
  FAudioType := atAnswer;
  FQuestion := AQuestion;
  if ShowModal = mrOk then
  begin

  end;
end;

procedure TRecordForm.EditBumperAudio(AQuestion: IQuestion);
begin
  FAudioType := atBumper;
  FQuestion := AQuestion;
  if ShowModal = mrOk then
  begin

  end;
end;

procedure TRecordForm.EditQuestionAudio(AQuestion: IQuestion);
begin
  FAudioType := atQuestion;
  FQuestion := AQuestion;
  if ShowModal = mrOk then
    SaveAudio
  else
    RemoveTmpFile;
end;

procedure TRecordForm.bGoBackClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TRecordForm.FillDevices;
var
  idx: Integer;
  itemWidth: Single;
  itemIndex: Integer;
begin
  itemWidth := 0.0;
  itemIndex := 0;
  cbAudioOutput.Items.BeginUpdate;
  try
    cbAudioOutput.Items.Clear;
    for idx := 0 to DSAudioOut1.DeviceCount - 1 do
    begin
      cbAudioOutput.Items.Add(DSAudioOut1.DeviceName[idx]);
      if DSAudioOut1.DeviceName[idx].Equals(TAppConfig.GetInstance.OutputDeviceName) then
        itemIndex := idx;
      if itemWidth < cbAudioOutput.Canvas.TextWidth(DSAudioOut1.DeviceName[idx]) then
        itemWidth := cbAudioOutput.Canvas.TextWidth(DSAudioOut1.DeviceName[idx]);
    end;
    if cbAudioOutput.Items.Count = 0 then
      DisablePlay
    else
      cbAudioOutput.ItemIndex := itemIndex;
    cbAudioOutput.ItemWidth := itemWidth;
    cbAudioOutput.ItemHeight := cbAudioOutput.Canvas.TextHeight('Yy');
  finally
    cbAudioOutput.Items.EndUpdate;
  end;

  itemWidth := 0;
  itemIndex := 0;
  cbAudioInput.Items.BeginUpdate;
  try
    cbAudioInput.Items.Clear;
    for idx := 0 to DXAudioIn1.DeviceCount - 1 do
    begin
      cbAudioInput.Items.Add(DXAudioIn1.DeviceName[idx]);
      if DXAudioIn1.DeviceName[idx].Equals(TAppConfig.GetInstance.InputDeviceName) then
        itemIndex := idx;
      if itemWidth < cbAudioInput.Canvas.TextWidth(DXAudioIn1.DeviceName[idx]) then
        itemWidth := cbAudioInput.Canvas.TextWidth(DXAudioIn1.DeviceName[idx]);
    end;
    if cbAudioInput.Items.Count = 0 then
      DisableRecord
    else
      cbAudioInput.ItemIndex := itemIndex;
    cbAudioInput.ItemWidth := itemWidth;
    cbAudioInput.ItemHeight := cbAudioInput.Canvas.TextHeight('Yy');
  finally
    cbAudioInput.Items.EndUpdate;
  end;
end;

procedure TRecordForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  voMic.Stop(False);
  DSAudioOut1.Stop(False);
end;

procedure TRecordForm.FormCreate(Sender: TObject);
begin
  StyleBook := Application.MainForm.StyleBook;

  var font := TFont.Create;
  font.Family := 'Segoe UI';
  font.Size := 18;
  font.Style := [];

  cbAudioOutput.Canvas.Font.Assign(font);
  cbAudioInput.Canvas.Font.Assign(font);
  DSAudioOut1.OnStart := OnOutputAudioStart;
  voMic.OnStart := OnInputAudioStart;
//  DXAudioIn1.OnStart :=

  FillDevices;
  FFormCreated := True;
end;

procedure TRecordForm.OnInputAudioStart;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    bPlayOriginalAudio.Enabled := False;
    bRecordAudio.StyleLookup := 'stoptoolbuttonmultiview';
    bPlayRecordedAudio.Enabled := False;
  end);
end;

procedure TRecordForm.OnOutputAudioStart;
begin
  TThread.Synchronize(nil,
  procedure
  begin
    bPlayOriginalAudio.Enabled := False;
    bRecordAudio.Enabled := False;
    bPlayRecordedAudio.Enabled := False;
  end);
end;

procedure TRecordForm.PlayAudio(const APath: string);
begin
  DSAudioOut1.DeviceNumber := cbAudioOutput.ItemIndex;
  DSAudioOut1.Stop(False);

  VorbisIn1.FileName := APath;
  DSAudioOut1.Run;
end;

procedure TRecordForm.RemoveTmpFile;
begin
  if (voMic.FileName <> '') and FileExists(voMic.FileName) then
    DeleteFile(voMic.FileName);
end;

procedure TRecordForm.SaveAudio;
begin
  if (voMic.FileName <> '') and FileExists(voMic.FileName) then
    case FAudioType of
      atQuestion:
      begin
        if FileExists(FQuestion.QuestionAudioPath) then
          DeleteFile(FQuestion.QuestionAudioPath);
        TFile.Move(voMic.FileName, ExtractFileDir(FQuestion.QuestionAudioPath));
      end;
      atAnswer:
      begin
        if FileExists(FQuestion.CorrectItemAudioPath) then
          DeleteFile(FQuestion.CorrectItemAudioPath);
        TFile.Move(voMic.FileName, ExtractFileDir(FQuestion.CorrectItemAudioPath));
      end;
      atBumper:
      begin
        if FileExists(FQuestion.BumperAudioPath) then
          DeleteFile(FQuestion.BumperAudioPath);
        TFile.Move(voMic.FileName, ExtractFileDir(FQuestion.BumperAudioPath));
      end;
    end;
end;

procedure TRecordForm.voMicDone(Sender: TComponent);
begin
  TThread.Synchronize(nil,
  procedure
  begin
    bPlayOriginalAudio.Enabled := True;
    bRecordAudio.StyleLookup := 'mictoolbuttonmultiview';
    bPlayRecordedAudio.Enabled := (voMic.FileName <> '') and FileExists(voMic.FileName);
  end);
end;

end.
