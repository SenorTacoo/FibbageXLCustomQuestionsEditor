unit uInterfaces;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  IQuestion = interface;

  IFibbagePathChecker = interface
    ['{D91F90A7-5AE3-44AF-BC55-60E0A89974BD}']
    function IsValid(const APath: string): Boolean;
  end;

  ICategory = interface
    ['{A0359347-2ED4-4141-88D4-F83BD6BEA2B4}']
    function GetId: Integer;
    function GetCategory: string;
    procedure SetId(AId: Integer);
    procedure SetCategory(const ACategory: string);
  end;

  ICategories = interface
    ['{705D1649-BB15-41E4-BBFE-8DB36E16C3F8}']
    function Count: Integer;
    function Category(AIdx: Integer): ICategory;
    procedure Add(ACategory: ICategory);
    procedure Delete(AId: Integer);
  end;

  IFibbageCategories = interface
    ['{C079C47F-9F11-4CEA-B404-FC1393155440}']
    function GetShortieCategory(AQuestion: IQuestion): ICategory;
    function GetFinalCategory(AQuestion: IQuestion): ICategory;
    procedure LoadCategories(const AContentDir: string);
    function GetAvailableId: Word;
    function CreateNewShortieCategory: Integer;
    function CreateNewFinalCategory: Integer;
    procedure RemoveShortieCategory(AQuestion: IQuestion);
    procedure RemoveFinalCategory(AQuestion: IQuestion);
  end;

  TQuestionType = (qtShortie, qtFinal);

  IQuestion = interface
   ['{EE283E65-E86A-4FCF-952F-4C9FAC7CBD69}']
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

    function GetQuestionType: TQuestionType;
    procedure SetQuestionType(AQuestionType: TQuestionType);
    procedure Save(const APath: string);
  end;

  IFibbageQuestions = interface
    ['{E703044F-3534-4F18-892D-99D381446C1C}']
    function ShortieQuestions: TList<IQuestion>;
    function FinalQuestions: TList<IQuestion>;
    procedure Save(const APath: string);
    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
  end;

  IQuestionsLoader = interface
    ['{64B170E4-BEF8-46F8-BE7F-502FA2027E98}']
    procedure LoadQuestions(const AContentDir: string);
    function Questions: IFibbageQuestions;
  end;

  TOnContentInitialized = procedure of object;
  TOnContentError = procedure(const AMsg: string) of object;

  IFibbageContent = interface
    ['{C29008F3-5F9B-4053-8947-792D2430F7AE}']
    function Questions: IFibbageQuestions;
    function Categories: IFibbageCategories;
    function GetPath: string;

    procedure Initialize(const AContentPath: string; AOnContentInitialized: TOnContentInitialized; AOnContentError: TOnContentError);
    procedure Save(const APath: string);
    procedure AddShortieQuestion;
    procedure AddFinalQuestion;
    procedure RemoveShortieQuestion(AQuestion: IQuestion);
    procedure RemoveFinalQuestion(AQuestion: IQuestion);
  end;

  ILastQuestionProjects = interface
    ['{3AC14137-BA00-4639-9CA3-07DA510AC191}']
    procedure Initialize;
    procedure Add(AContent: IFibbageContent);
    function GetAll: TStringList;
  end;

implementation

end.
