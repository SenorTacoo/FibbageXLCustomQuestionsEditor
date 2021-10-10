﻿unit uQuestionsLoader;

interface

uses
  uLog,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  REST.JSON,
  REST.Json.Types,
  DBXJSON,
  System.IOUtils,
  uInterfaces;

type
  TQuestionField = class
  private
    FT: string;      
    FV: string;     
    FN: string;
  public
    property T: string read FT write FT;
    property V: string read FV write FV;
    property N: string read FN write FN;
  end;

  TQuestionItem = class(TInterfacedObject, IQuestion)
  strict private const
    EMPTY_STRING = '{EMPTY_STRING}';
  private
    FFields: TArray<TQuestionField>;

    [JSONMarshalledAttribute(False)]
    FId: Integer;
    [JSONMarshalledAttribute(False)]
    FQuestionType: TQuestionType;
    [JSONMarshalledAttribute(False)]
    FQuestionAudioPath: string;
    [JSONMarshalledAttribute(False)]
    FAnswerAudioPath: string;
    [JSONMarshalledAttribute(False)]
    FBumperAudioPath: string;

    procedure PrepareEmptyValues;
    procedure SetHaveQuestionAudio(AHave: Boolean);
    procedure SetHaveAnswerAudio(AHave: Boolean);
    procedure SetHaveBumperAudio(AHave: Boolean);
    procedure SetAnswerAudioName(const AName: string);

    function GetQuestionAudioName: string;
    function GetAnswerAudioName: string;
    function GetBumperAudioName: string;
    procedure SetBumperAudioName(const AName: string);
    procedure SetQuestionAudioName(const AName: string);
    procedure InnerDeleteTempFile(const APath: string);
  public
    destructor Destroy; override;

    procedure SetDefaults;

    function GetId: Integer;
    function GetQuestion: string;
    function GetSuggestions: string;
    function GetAnswer: string;
    function GetAlternateSpelling: string;
    function GetHaveQuestionAudio: Boolean;
    function GetHaveAnswerAudio: Boolean;
    function GetHaveBumperAudio: Boolean;

    procedure SetId(AId: Integer);
    procedure SetQuestion(const AQuestion: string);
    procedure SetSuggestions(const ASuggestions: string);
    procedure SetAnswer(const AAnswer: string);
    procedure SetAlternateSpelling(const AAlternateSpelling: string);

    function GetQuestionAudioPath: string;
    function GetAnswerAudioPath: string;
    function GetBumperAudioPath: string;

    procedure SetQuestionAudioPath(const AAudioPath: string);
    procedure SetAnswerAudioPath(const AAudioPath: string);
    procedure SetBumperAudioPath(const AAudioPath: string);

    procedure Save(const APath: string);

    function GetQuestionType: TQuestionType;
    procedure SetQuestionType(AQuestionType: TQuestionType);
    procedure DeleteAnswerAudio;
    procedure DeleteBumperAudio;
    procedure DeleteQuestionAudio;

    property Fields: TArray<TQuestionField> read FFields write FFields;
  end;

  TQuestionListHelper = class helper for TQuestionList
  public
    procedure Save(const AProjectPath, AQuestionsDir: string);
  end;

  TQuestions = class(TInterfacedObject, IFibbageQuestions)
   private
    FShortieQuestions: TQuestionList;
    FFinalQuestions: TQuestionList;
  public
    constructor Create;
    destructor Destroy; override;

    function ShortieQuestions: TQuestionList;
    function FinalQuestions: TQuestionList;

    procedure Save(const APath: string);
    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
  end;

  TFibbageQuestions = class
  private
    FShortie: TQuestions;
    FFinal: TQuestions;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TQuestionsLoader = class(TInterfacedObject, IQuestionsLoader)
  private
    FContentPath: string;
    FQuestions: IFibbageQuestions;

    procedure LoadShorties;
    procedure LoadFinals;
    procedure FillQuestions(const AMainDir: string; AQuestionsList: TList<IQuestion>);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadQuestions(const AContentDir: string);
    function Questions: IFibbageQuestions;
  end;

implementation

{ TQuestionsLoader }

constructor TQuestionsLoader.Create;
begin
  inherited;
  FQuestions := TQuestions.Create;
end;

destructor TQuestionsLoader.Destroy;
begin
  FQuestions := nil;
  inherited;
end;

procedure TQuestionsLoader.LoadQuestions(const AContentDir: string);
begin
  FContentPath := AContentDir;

  LoadShorties;
  LoadFinals;
end;

procedure TQuestionsLoader.LoadShorties;
begin
  var shortieDir := TDirectory.GetDirectories(FContentPath, '*fibbageshortie*');
  if Length(shortieDir) = 0 then
    Exit;

  FillQuestions(shortieDir[0], FQuestions.ShortieQuestions);

  for var item in FQuestions.ShortieQuestions do
    item.SetQuestionType(qtShortie);
end;

procedure TQuestionsLoader.LoadFinals;
begin
  var finalDirs := TDirectory.GetDirectories(FContentPath, '*finalfibbage*');
  if Length(finalDirs) = 0 then
    Exit;

  FillQuestions(finalDirs[0], FQuestions.FinalQuestions);

  for var item in FQuestions.FinalQuestions do
    item.SetQuestionType(qtFinal);
end;

procedure TQuestionsLoader.FillQuestions(const AMainDir: string; AQuestionsList: TList<IQuestion>);
var
  questionDirs: string;
  singleQuestion: TQuestionItem;
  fs: TFileStream;
  sr: TStreamReader;
  buffer: TBytes;
begin
  if not Assigned(AQuestionsList) then
    Assert(False, 'AQuestionsList not assigned');

  var shortieDirs := TDirectory.GetDirectories(AMainDir);
  for var dir in shortieDirs do
  begin
    var dataFile := TDirectory.GetFiles(dir, '*.jet');
    var audioFiles := TDirectory.GetFiles(dir, '*.ogg');

    fs := TFileStream.Create(dataFile[0], fmOpenRead);
    sr := TStreamReader.Create(fs);
    try
      sr.OwnStream;
      singleQuestion := TJSON.JsonToObject<TQuestionItem>(sr.ReadToEnd);
    finally
      sr.Free;
    end;
    singleQuestion.FId := StrToIntDef(ExtractFileName(dir), 0);
    singleQuestion.FQuestionAudioPath := dir;
    singleQuestion.FAnswerAudioPath := dir;
    singleQuestion.FBumperAudioPath := dir;

    singleQuestion.PrepareEmptyValues;
    AQuestionsList.Add(singleQuestion);
  end;
end;

function TQuestionsLoader.Questions: IFibbageQuestions;
begin
  Result := FQuestions;
end;

{ TFibbageQuestions }

constructor TFibbageQuestions.Create;
begin
  inherited;
  FShortie := TQuestions.Create;
  FFinal := TQuestions.Create;
end;

destructor TFibbageQuestions.Destroy;
begin
  FShortie.Free;
  FFinal.Free;
  inherited;
end;

{ TQuestionItem }

destructor TQuestionItem.Destroy;
begin
  InnerDeleteTempFile(GetAnswerAudioPath);
  InnerDeleteTempFile(GetBumperAudioPath);
  InnerDeleteTempFile(GetQuestionAudioPath);

  for var idx := Length(FFields) - 1 downto 0 do
    FreeAndNil(FFields[idx]);
  SetLength(FFields, 0);
  inherited;
end;

procedure TQuestionItem.InnerDeleteTempFile(const APath: string);
begin
  if FileExists(APath) then
    if APath.StartsWith(TPath.GetTempPath) then
      TFile.Delete(APath);
end;

procedure TQuestionItem.DeleteQuestionAudio;
begin
  if FileExists(GetQuestionAudioPath) then
    TFile.Delete(GetQuestionAudioPath);
end;

procedure TQuestionItem.DeleteAnswerAudio;
begin
  if FileExists(GetAnswerAudioPath) then
    TFile.Delete(GetAnswerAudioPath);
end;

procedure TQuestionItem.DeleteBumperAudio;
begin
  if FileExists(GetBumperAudioPath) then
    TFile.Delete(GetBumperAudioPath);
end;

function TQuestionItem.GetAlternateSpelling: string;
begin
  for var field in FFields do
    if SameText('AlternateSpellings', field.N) then
      if SameText(EMPTY_STRING, field.V) then
        Exit('')
      else
        Exit(field.V);
end;

function TQuestionItem.GetAnswer: string;
begin
  for var field in FFields do
    if SameText('CorrectText', field.N) then
      Exit(field.V);
end;

function TQuestionItem.GetBumperAudioName: string;
begin
  Result := '';
  for var field in FFields do
    if SameText('BumperAudio', field.N) then
    begin
      Result := field.V;
      Break;
    end;
end;

function TQuestionItem.GetBumperAudioPath: string;
begin
  Result := TPath.Combine(FBumperAudioPath, GetBumperAudioName + '.ogg');
end;

function TQuestionItem.GetHaveAnswerAudio: Boolean;
begin
  Result := False;
  for var field in FFields do
    if SameText('HasCorrectAudio', field.N) then
    begin
      Result := StrToBoolDef(field.V, False);
      Break;
    end;
end;

function TQuestionItem.GetHaveBumperAudio: Boolean;
begin
  Result := False;
  for var field in FFields do
    if SameText('HasBumperAudio', field.N) then
    begin
      Result := StrToBoolDef(field.V, False);
      Break;
    end;
end;

function TQuestionItem.GetHaveQuestionAudio: Boolean;
begin
  Result := False;
  for var field in FFields do
    if SameText('HasQuestionAudio', field.N) then
    begin
      Result := StrToBoolDef(field.V, False);
      Break;
    end;
end;

function TQuestionItem.GetAnswerAudioName: string;
begin
  Result := '';
  for var field in FFields do
    if SameText('CorrectAudio', field.N) then
    begin
      Result := field.V;
      Break;
    end;
end;

function TQuestionItem.GetAnswerAudioPath: string;
begin
  Result := TPath.Combine(FAnswerAudioPath, GetAnswerAudioName + '.ogg');
end;

function TQuestionItem.GetId: Integer;
begin
  Result := FId;
end;

function TQuestionItem.GetQuestion: string;
begin
  for var field in FFields do
    if SameText('QuestionText', field.N) then
      Exit(field.V);
end;

function TQuestionItem.GetQuestionAudioName: string;
begin
  Result := '';
  for var field in FFields do
    if SameText('QuestionAudio', field.N) then
    begin
      Result := field.V;
      Break;
    end;
end;

function TQuestionItem.GetQuestionAudioPath: string;
begin
  Result := TPath.Combine(FQuestionAudioPath, GetQuestionAudioName + '.ogg');
end;

function TQuestionItem.GetQuestionType: TQuestionType;
begin
  Result := FQuestionType;
end;

procedure TQuestionItem.Save(const APath: string);
var
  fs: TFileStream;
  sw: TStreamWriter;
begin
  var data := TJson.ObjectToJsonString(Self, [joIgnoreEmptyStrings])
    .Replace(EMPTY_STRING, '');

  var dir := IncludeTrailingPathDelimiter(TPath.Combine(APath, IntToStr(FId)));
  ForceDirectories(dir);

  fs := TFileStream.Create(TPath.Combine(dir, 'data.jet'), fmCreate);
  sw := TStreamWriter.Create(fs);
  try
    sw.OwnStream;
    sw.Write(data);
  finally
    sw.Free;
  end;

  if GetHaveQuestionAudio then
    if FileExists(GetQuestionAudioPath) then
    begin
      if ExtractFilePath(GetQuestionAudioPath) <> dir then
      begin
        TFile.Move(GetQuestionAudioPath, TPath.Combine(dir, ExtractFileName(GetQuestionAudioPath)));
        SetQuestionAudioPath(TPath.Combine(dir, ExtractFileName(GetQuestionAudioPath)));
      end;
    end
    else
      LogE('Have question audio but file "%s" does not exist', [GetQuestionAudioPath]);

  if GetHaveAnswerAudio then
    if FileExists(GetAnswerAudioPath) then
    begin
      if ExtractFilePath(GetAnswerAudioPath) <> dir then
      begin
        TFile.Move(GetAnswerAudioPath, TPath.Combine(dir, ExtractFileName(GetAnswerAudioPath)));
        SetAnswerAudioPath(TPath.Combine(dir, ExtractFileName(GetAnswerAudioPath)));
      end;
    end
    else
      LogE('Have answer audio but file "%s" does not exist', [GetQuestionAudioPath]);

  if GetHaveBumperAudio then
    if FileExists(GetBumperAudioPath) then
    begin
      if ExtractFilePath(GetBumperAudioPath) <> dir then
      begin
        TFile.Move(GetBumperAudioPath, TPath.Combine(dir, ExtractFileName(GetBumperAudioPath)));
        SetBumperAudioPath(TPath.Combine(dir, ExtractFileName(GetBumperAudioPath)));
      end;
    end
    else
      LogE('Have bumper audio but file "%s" does not exist', [GetBumperAudioPath]);
end;

procedure TQuestionItem.SetAlternateSpelling(const AAlternateSpelling: string);
begin
  for var field in FFields do
    if SameText('AlternateSpellings', field.N) then
    begin
      if AAlternateSpelling.IsEmpty then
        field.V := EMPTY_STRING
      else
        field.V := AAlternateSpelling;
      Break;
    end;
end;

procedure TQuestionItem.SetAnswer(const AAnswer: string);
begin
  for var field in FFields do
    if SameText('CorrectText', field.N) then
    begin
      field.V := AAnswer;
      Break;
    end;
end;

procedure TQuestionItem.SetAnswerAudioPath(const AAudioPath: string);
begin
  FAnswerAudioPath := ExtractFilePath(AAudioPath);
  SetAnswerAudioName(ChangeFileExt(ExtractFileName(AAudioPath), ''));
end;

procedure TQuestionItem.SetAnswerAudioName(const AName: string);
begin
  for var field in FFields do
    if SameText('CorrectAudio', field.N) then
    begin
      field.V := AName;
      SetHaveAnswerAudio(not AName.IsEmpty);
      Break;
    end;
end;

procedure TQuestionItem.SetBumperAudioPath(const AAudioPath: string);
begin
  FBumperAudioPath := ExtractFilePath(AAudioPath);
  SetBumperAudioName(ChangeFileExt(ExtractFileName(AAudioPath), ''));
end;

procedure TQuestionItem.SetBumperAudioName(const AName: string);
begin
  for var field in FFields do
    if SameText('BumperAudio', field.N) then
    begin
      field.V := AName;
      SetHaveBumperAudio(not AName.IsEmpty);
      Break;
    end;
end;

procedure TQuestionItem.SetDefaults;
begin
  SetLength(FFields, 13);

  FFields[0] := TQuestionField.Create;
  FFields[0].N := 'HasBumperAudio';
  FFields[0].V := 'false';
  FFields[0].T := 'B';

  FFields[1] := TQuestionField.Create;
  FFields[1].N := 'HasBumperType';
  FFields[1].V := 'false';
  FFields[1].T := 'B';

  FFields[2] := TQuestionField.Create;
  FFields[2].N := 'HasCorrectAudio';
  FFields[2].V := 'false';
  FFields[2].T := 'B';

  FFields[3] := TQuestionField.Create;
  FFields[3].N := 'HasQuestionAudio';
  FFields[3].V := 'false';
  FFields[3].T := 'B';

  FFields[4] := TQuestionField.Create;
  FFields[4].N := 'Suggestions';
  FFields[4].V := '';
  FFields[4].T := 'S';

  FFields[5] := TQuestionField.Create;
  FFields[5].N := 'Category';
  FFields[5].V := '';
  FFields[5].T := 'S';

  FFields[6] := TQuestionField.Create;
  FFields[6].N := 'CorrectText';
  FFields[6].V := '';
  FFields[6].T := 'S';

  FFields[7] := TQuestionField.Create;
  FFields[7].N := 'BumperType';
  FFields[7].V := 'None';
  FFields[7].T := 'S';

  FFields[8] := TQuestionField.Create;
  FFields[8].N := 'QuestionText';
  FFields[8].V := '';
  FFields[8].T := 'S';

  FFields[9] := TQuestionField.Create;
  FFields[9].N := 'AlternateSpellings';
  FFields[9].V := '';
  FFields[9].T := 'S';

  FFields[10] := TQuestionField.Create;
  FFields[10].N := 'BumperAudio';
  FFields[10].V := '';
  FFields[10].T := 'A';

  FFields[11] := TQuestionField.Create;
  FFields[11].N := 'CorrectAudio';
  FFields[11].V := '';
  FFields[11].T := 'A';

  FFields[12] := TQuestionField.Create;
  FFields[12].N := 'QuestionAudio';
  FFields[12].V := '';
  FFields[12].T := 'A';
end;

procedure TQuestionItem.SetHaveAnswerAudio(AHave: Boolean);
begin
  for var field in FFields do
    if SameText('HasCorrectAudio', field.N) then
    begin
      field.V := BoolToStr(AHave, True);
      Break;
    end;
end;

procedure TQuestionItem.SetHaveBumperAudio(AHave: Boolean);
begin
  for var field in FFields do
    if SameText('HasBumperAudio', field.N) then
    begin
      field.V := BoolToStr(AHave, True);
      Break;
    end;
end;

procedure TQuestionItem.SetHaveQuestionAudio(AHave: Boolean);
begin
  for var field in FFields do
    if SameText('HasQuestionAudio', field.N) then
    begin
      field.V := BoolToStr(AHave, True);
      Break;
    end;
end;

procedure TQuestionItem.SetId(AId: Integer);
begin
  FId := AId;
end;

procedure TQuestionItem.SetQuestion(const AQuestion: string);
begin
  for var field in FFields do
    if SameText('QuestionText', field.N) then
    begin
      field.V := AQuestion;
      Break;
    end;
end;

procedure TQuestionItem.SetQuestionAudioPath(const AAudioPath: string);
begin
  FQuestionAudioPath := ExtractFilePath(AAudioPath);
  SetQuestionAudioName(ChangeFileExt(ExtractFileName(AAudioPath), ''));
end;

procedure TQuestionItem.SetQuestionAudioName(const AName: string);
begin
  for var field in FFields do
    if SameText('QuestionAudio', field.N) then
    begin
      field.V := AName;
      SetHaveQuestionAudio(not AName.IsEmpty);
      Break;
    end;
end;

procedure TQuestionItem.SetQuestionType(AQuestionType: TQuestionType);
begin
  FQuestionType := AQuestionType;
end;

procedure TQuestionItem.SetSuggestions(const ASuggestions: string);
begin
  for var field in FFields do
    if SameText('Suggestions', field.N) then
    begin
      field.V := ASuggestions;
      Break;
    end;
end;

function TQuestionItem.GetSuggestions: string;
begin
  for var field in FFields do
    if SameText('Suggestions', field.N) then
      Exit(field.V);
end;

procedure TQuestionItem.PrepareEmptyValues;
begin
  for var field in Fields do
    if SameText('AlternateSpellings', field.N) then
      if field.V.IsEmpty then
        field.V := EMPTY_STRING;
end;

{ TQuestions }

constructor TQuestions.Create;
begin
  inherited;
  FShortieQuestions := TList<IQuestion>.Create;
  FFinalQuestions := TList<IQuestion>.Create;
end;

destructor TQuestions.Destroy;
begin
  FShortieQuestions.Free;
  FFinalQuestions.Free;
  inherited;
end;

function TQuestions.FinalQuestions: TQuestionList;
begin
  Result := FFinalQuestions;
end;

procedure TQuestions.RemoveFinalQuestion(AQuestion: IQuestion);
begin
  FFinalQuestions.Remove(AQuestion);
end;

procedure TQuestions.RemoveShortieQuestion(AQuestion: IQuestion);
begin
  FShortieQuestions.Remove(AQuestion);
end;

procedure TQuestions.Save(const APath: string);
begin
  ShortieQuestions.Save(APath, 'fibbageshortie');
  FinalQuestions.Save(APath, 'finalfibbage');
end;

function TQuestions.ShortieQuestions: TQuestionList;
begin
  Result := FShortieQuestions;
end;

{ TQuestionListHelper }

procedure TQuestionListHelper.Save(const AProjectPath, AQuestionsDir: string);
begin
  var targetDir := TPath.Combine(AProjectPath, AQuestionsDir);
  ForceDirectories(targetDir);
  for var question in Self do
    question.Save(targetDir);
end;

end.
