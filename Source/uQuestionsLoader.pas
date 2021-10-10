unit uQuestionsLoader;

interface

uses
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

  TAudioItem = class
  private
    FPath: string;
    FData: TBytes;
    function GetName: string;
  public
    property Path: string read FPath write FPath;
    property Data: TBytes read FData write FData;
    property Name: string read GetName;
  end;

  TQuestionItem = class(TInterfacedObject, IQuestion)
  strict private const
    EMPTY_STRING = '{EMPTY_STRING}';
  private
    FFields: TArray<TQuestionField>;

    [JSONMarshalledAttribute(False)]
    FAudios: TArray<TAudioItem>;
    [JSONMarshalledAttribute(False)]
    FId: Integer;

    procedure PrepareEmptyValues;
  public
    function GetId: Integer;
    function GetQuestion: string;
    function GetSuggestions: string;
    function GetAnswer: string;
    function GetAlternateSpelling: string;
    function GetQuestionAudioPath: string;
    function GetAnswerAudioPath: string;
    function GetBumperAudioPath: string;

    procedure SetId(AId: Integer);
    procedure SetQuestion(const AQuestion: string);
    procedure SetSuggestions(const ASuggestions: string);
    procedure SetAnswer(const AAnswer: string);
    procedure SetAlternateSpelling(const AAlternateSpelling: string);
    procedure SetQuestionAudioPath(const AAudioPath: string);
    procedure SetAnswerAudioPath(const AAudioPath: string);
    procedure SetBumperAudioPath(const AAudioPath: string);

    procedure Save(const APath: string);

    property Fields: TArray<TQuestionField> read FFields write FFields;
  end;

  TQuestions = class(TInterfacedObject, IFibbageQuestions)
   private
    FShortieQuestions: TList<IQuestion>;
    FFinalQuestions: TList<IQuestion>;
  public
    constructor Create;
    destructor Destroy; override;

    function ShortieQuestions: TList<IQuestion>;
    function FinalQuestions: TList<IQuestion>;

    procedure Save(const APath: string);
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
  FillQuestions(shortieDir[0], FQuestions.ShortieQuestions);
end;

procedure TQuestionsLoader.LoadFinals;
begin
  var finalDirs := TDirectory.GetDirectories(FContentPath, '*finalfibbage*');
  FillQuestions(finalDirs[0], FQuestions.FinalQuestions);
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
    SetLength(singleQuestion.FAudios, Length(audioFiles));
    for var idx := 0 to Length(audioFiles) - 1 do
    begin
      fs := TFileStream.Create(audioFiles[idx], fmOpenRead);
      try
        var newAudio := TAudioItem.Create;
        newAudio.Path := audioFiles[idx];
        SetLength(buffer, fs.Size);
        fs.Read(buffer[0], fs.Size);
        newAudio.Data := buffer;
        singleQuestion.FAudios[idx] := newAudio;
      finally
        fs.Free;
      end;
    end;
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

function TQuestionItem.GetBumperAudioPath: string;
begin
  Result := '';
  var audioName := '';
  for var field in FFields do
    if SameText('BumperAudio', field.N) then
    begin
      audioName := field.V;
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
      Exit(audio.Path);
end;

function TQuestionItem.GetAnswerAudioPath: string;
begin
  Result := '';
  var audioName := '';
  for var field in FFields do
    if SameText('CorrectAudio', field.N) then
    begin
      audioName := field.V;
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
      Exit(audio.Path);
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

function TQuestionItem.GetQuestionAudioPath: string;
begin
  Result := '';
  var audioName := '';
  for var field in FFields do
    if SameText('QuestionAudio', field.N) then
    begin
      audioName := field.V;
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
      Exit(audio.Path);
end;

procedure TQuestionItem.Save(const APath: string);
var
  fs: TFileStream;
  sw: TStreamWriter;
begin
  var data := TJson.ObjectToJsonString(Self, [joIgnoreEmptyStrings])
    .Replace(EMPTY_STRING, '');

  var dir := TPath.Combine(APath, IntToStr(FId));
  ForceDirectories(dir);

  fs := TFileStream.Create(TPath.Combine(dir, 'data.jet'), fmCreate);
  sw := TStreamWriter.Create(fs);
  try
    sw.OwnStream;
    sw.Write(data);
  finally
    sw.Free;
  end;

  for var audioFile in FAudios do
  begin
    fs := TFileStream.Create(TPath.Combine(dir, audioFile.GetName + '.ogg'), fmCreate);
    try
      fs.Write(audioFile.Data, Length(audioFile.Data));
    finally
      fs.Free;
    end;
  end;
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
  var audioName := '';
  for var field in FFields do
    if SameText('CorrectAudio', field.N) then
    begin
      audioName := field.V;
      field.V := ChangeFileExt(ExtractFileName(AAudioPath), '');
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
    begin
      audio.Path := AAudioPath;
      Break;
    end;
end;

procedure TQuestionItem.SetBumperAudioPath(const AAudioPath: string);
begin
  var audioName := '';
  for var field in FFields do
    if SameText('BumperAudio', field.N) then
    begin
      audioName := field.V;
      field.V := ChangeFileExt(ExtractFileName(AAudioPath), '');
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
    begin
      audio.Path := AAudioPath;
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
  var audioName := '';
  for var field in FFields do
    if SameText('QuestionAudio', field.N) then
    begin
      audioName := field.V;
      field.V := ChangeFileExt(ExtractFileName(AAudioPath), '');
      Break;
    end;
  if audioName.IsEmpty then
    Exit;
  for var audio in FAudios do
    if SameText(ChangeFileExt(ExtractFileName(audio.FPath), ''), audioName) then
    begin
      audio.Path := AAudioPath;
      Break;
    end;
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

function TQuestions.FinalQuestions: TList<IQuestion>;
begin
  Result := FFinalQuestions;
end;

procedure TQuestions.Save(const APath: string);
begin
  var shortieDir := TPath.Combine(APath, 'fibbageshortie');
  var finalDir := TPath.Combine(APath, 'finalfibbage');
  for var question in ShortieQuestions do
    question.Save(shortieDir);
  for var question in FinalQuestions do
    question.Save(finalDir);
end;

function TQuestions.ShortieQuestions: TList<IQuestion>;
begin
  Result := FShortieQuestions;
end;

{ TAudioItem }

function TAudioItem.GetName: string;
begin
  Result := ChangeFileExt(ExtractFileName(FPath), '');
end;

end.
