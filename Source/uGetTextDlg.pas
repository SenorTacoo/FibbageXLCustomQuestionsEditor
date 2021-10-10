unit uGetTextDlg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Layouts;

type
  TGetTextDlg = class(TForm)
    eText: TEdit;
    gplButtons: TGridPanelLayout;
    bOk: TButton;
    bCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure eTextKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
  public
    function GetText(const AInfo: string; out AText: string): Boolean;
  end;

implementation

{$R *.fmx}

uses
  uMainForm;

procedure TGetTextDlg.eTextKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    ModalResult := mrOk
  else if Key = vkEscape then
    ModalResult := mrCancel;
end;

procedure TGetTextDlg.FormCreate(Sender: TObject);
begin
  StyleBook := Application.MainForm.StyleBook;
end;

function TGetTextDlg.GetText(const AInfo: string; out AText: string): Boolean;
begin
  Result := False;
  Caption := AInfo;
  eText.SetFocus;
  if ShowModal = mrOk then
  begin
    Result := True;
    AText := eText.Text.Trim;
  end;
end;

end.
