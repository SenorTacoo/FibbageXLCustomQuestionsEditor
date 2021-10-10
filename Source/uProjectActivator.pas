unit uProjectActivator;

interface

uses
  uInterfaces;

type
  TProjectActivator = class(TInterfacedObject, IProjectActivator)
  private
    FTempContent: IFibbageContent;
  public
    procedure Activate(AConfig: IContentConfiguration; const APath: string);
  end;

implementation

uses
  uSpringContainer;

{ TProjectActivator }

procedure TProjectActivator.Activate(AConfig: IContentConfiguration;
  const APath: string);
begin
  FTempContent := GlobalContainer.Resolve<IFibbageContent>;
  try
    FTempContent.Initialize(AConfig);
    FTempContent.Save(APath, [soDoNotSaveConfig]);
  finally
    FTempContent := nil;
  end;
end;

end.
