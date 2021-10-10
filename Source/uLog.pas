unit uLog;

interface

uses
  Grijjy.CloudLogging,
  System.SysUtils,
  System.DateUtils,
  System.Messaging;

procedure Log(const AText: string; const AArgs: array of const); overload;
procedure LogW(const AText: string; const AArgs: array of const); overload;
procedure LogE(const AText: string; const AArgs: array of const); overload;
procedure LogEnter(AInstance: TObject; const AName: string);
procedure LogExit(AInstance: TObject; const AName: string);

procedure Log(const AText: string); overload;
procedure LogW(const AText: string); overload;
procedure LogE(const AText: string); overload;

implementation

var
  FStartTime: TDateTime;

procedure HandleLiveWatches(const Sender: TObject; const M: TMessage);
var
  Msg: TgoLiveWatchesMessage absolute M;
  ElapsedMs: Integer;
begin
  Assert(M is TgoLiveWatchesMessage);
  ElapsedMs := MilliSecondsBetween(Now, FStartTime);
  Msg.Add('Elapsed Seconds', ElapsedMs / 1000, 1);
end;

procedure InnerLog(const AText: string; ALogLevel: TgoLogLevel);
begin
  GrijjyLog.Send(AText, ALogLevel);
end;

procedure Log(const AText: string; const AArgs: array of const);
begin
  InnerLog(Format(AText, AArgs), TgoLogLevel.Info);
end;

procedure LogW(const AText: string; const AArgs: array of const);
begin
  InnerLog(Format(AText, AArgs), TgoLogLevel.Warning);
end;

procedure LogE(const AText: string; const AArgs: array of const);
begin
  InnerLog(Format(AText, AArgs), TgoLogLevel.Error);
end;

procedure Log(const AText: string); overload;
begin
  Log(AText, []);
end;

procedure LogW(const AText: string); overload;
begin
  LogW(AText, []);
end;

procedure LogE(const AText: string); overload;
begin
  LogE(AText, []);
end;

procedure LogEnter(AInstance: TObject; const AName: string);
begin
  GrijjyLog.EnterMethod(AInstance, AName);
end;

procedure LogExit(AInstance: TObject; const AName: string);
begin
  GrijjyLog.ExitMethod(AInstance, AName);
end;

initialization
  { Enable all log levels }
  GrijjyLog.SetLogLevel(TgoLogLevel.Info);
   { Subscribe to the Live Watches message to provide the Grijjy Log Viewer with
    a list of watches.
    Besides this form, TFrameWatches also subscribes to this message. }
  TMessageManager.DefaultManager.SubscribeToMessage(TgoLiveWatchesMessage,
    HandleLiveWatches);
  FStartTime := Now;
  Log('Initialized');

finalization

  Log('Finalized');
  TMessageManager.DefaultManager.Unsubscribe(TgoLiveWatchesMessage,
    HandleLiveWatches);
end.
