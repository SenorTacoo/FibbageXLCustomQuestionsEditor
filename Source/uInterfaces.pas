unit uInterfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  IQuestion = interface;

  IContentPathChecker = interface
    ['{D91F90A7-5AE3-44AF-BC55-60E0A89974BD}']
    function IsValid(const APath: string): Boolean;
  end;

  ICategory = interface
    ['{A0359347-2ED4-4141-88D4-F83BD6BEA2B4}']
    function GetId: Integer;
    function GetCategory: string;
    function GetIsFamilyFriendly: Boolean;

    procedure SetId(AId: Integer);
    procedure SetCategory(const ACategory: string);
    procedure SetIsFamilyFriendly(AValue: Boolean);

    procedure CloneFrom(AObj: ICategory);
  end;

  ICategories = interface
    ['{705D1649-BB15-41E4-BBFE-8DB36E16C3F8}']
    function Count: Integer;
    function Category(AIdx: Integer): ICategory;
    procedure Add(ACategory: ICategory);
    procedure Delete(AId: Integer);
    procedure Save(const APath, AName: string);
  end;

  IFibbageCategories = interface
    ['{C079C47F-9F11-4CEA-B404-FC1393155440}']
    function GetShortieCategory(AQuestion: IQuestion): ICategory;
    function GetFinalCategory(AQuestion: IQuestion): ICategory;
    procedure LoadCategories(const AContentDir: string);
    function GetAvailableId: Word;
    function CreateNewShortieCategory: ICategory;
    function CreateNewFinalCategory: ICategory;
    procedure RemoveShortieCategory(AQuestion: IQuestion);
    procedure RemoveFinalCategory(AQuestion: IQuestion);
    procedure Save(const APath: string);
  end;

  TQuestionType = (qtShortie, qtFinal);

  IQuestion = interface
   ['{EE283E65-E86A-4FCF-952F-4C9FAC7CBD69}']
    function GetId: Integer;
    function GetQuestion: string;
    function GetSuggestions: string;
    function GetAnswer: string;
    function GetAlternateSpelling: string;
    function GetHaveQuestionAudio: Boolean;
    function GetHaveAnswerAudio: Boolean;
    function GetHaveBumperAudio: Boolean;

    function GetQuestionAudioData: TBytes;
    function GetAnswerAudioData: TBytes;
    function GetBumperAudioData: TBytes;
    function GetCategoryObj: ICategory;
    function GetCategory: string;

    procedure SetQuestion(const AQuestion: string);
    procedure SetSuggestions(const ASuggestions: string);
    procedure SetAnswer(const AAnswer: string);
    procedure SetAlternateSpelling(const AAlternateSpelling: string);
    procedure SetQuestionAudioData(const AData: TBytes);
    procedure SetAnswerAudioData(const AData: TBytes);
    procedure SetBumperAudioData(const AData: TBytes);
    procedure SetCategoryObj(ACategory: ICategory);

    function GetQuestionType: TQuestionType;
    procedure SetQuestionType(AQuestionType: TQuestionType);
    procedure Save(const APath: string);
    procedure CloneFrom(AObj: IQuestion);
  end;

  TQuestionList = TList<IQuestion>;

  IFibbageQuestions = interface
    ['{E703044F-3534-4F18-892D-99D381446C1C}']
    function ShortieQuestions: TQuestionList;
    function FinalQuestions: TQuestionList;
    procedure Save(const APath: string);
    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
    function CreateNewShortieQuestion: IQuestion;
    function CreateNewFinalQuestion: IQuestion;
  end;

  IQuestionsLoader = interface
    ['{64B170E4-BEF8-46F8-BE7F-502FA2027E98}']
    procedure LoadQuestions(const AContentDir: string);
    function Questions: IFibbageQuestions;
  end;

  TSaveOption = (soDoNotSaveConfig);
  TSaveOptions = set of TSaveOption;

  IContentConfiguration = interface
    ['{B756232F-2FC1-4BD9-8CDB-76D33AC44D4B}']
    function Initialize(const APath: string): Boolean;
    procedure Save(const APath: string); overload;
    procedure Save; overload;

    procedure SetName(const AName: string);
    procedure SetPath(const APath: string);
    procedure SetShowCategoryDuplicated(AValue: Boolean);
    procedure SetShowTooFewSuggestions(AValue: Boolean);

    function GetName: string;
    function GetPath: string;
    function GetShowCategoryDuplicated: Boolean;
    function GetShowTooFewSuggestions: Boolean;
  end;

  TOnContentInitialized = procedure of object;
  TOnContentError = procedure(const AMsg: string) of object;

  IFibbageContent = interface
    ['{C29008F3-5F9B-4053-8947-792D2430F7AE}']
    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(AConfiguration: IContentConfiguration);

    procedure Save; overload;
    procedure Save(const APath: string; ASaveOptions: TSaveOptions = []); overload;

    procedure CopyToFinalQuestions(const AQuestion: IQuestion; out ANewQuestion: IQuestion);
    procedure CopyToShortieQuestions(const AQuestion: IQuestion; out ANewQuestion: IQuestion);
    procedure MoveToFinalQuestions(const AQuestion: IQuestion);
    procedure MoveToShortieQuestions(const AQuestion: IQuestion);

    procedure AddShortieQuestion;
    procedure AddFinalQuestion;
    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
  end;

  TContentConfigurations = TList<IContentConfiguration>;

  ILastQuestionProjects = interface
    ['{3AC14137-BA00-4639-9CA3-07DA510AC191}']
    procedure Initialize;
    procedure Add(AContent: IContentConfiguration);
    procedure Remove(AConfiguration: IContentConfiguration);
    function GetAll: TContentConfigurations;
    function Count: Integer;
    procedure BeginUpdate;
    procedure EndUpdate;
  end;

  IProjectActivator = interface
    ['{A598EA48-727C-4EAB-8E8D-EB38C5ABDC47}']
    procedure Activate(AConfig: IContentConfiguration; const APath: string);
  end;


implementation

end.
