unit DriveSelect;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls;

type
	TForm2 = class(TForm)
		ListBox1: TListBox;
		Button1: TButton;
		procedure Button1Click(Sender: TObject);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
	private
		{ Private declarations }
		procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
	public
		{ Public declarations }
	end;

var
	Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
	tmp : string;
	tmpc : char;
begin
	if ListBox1.ItemIndex > -1 then
	begin
		tmp := Listbox1.Items.Strings[Listbox1.ItemIndex];
		tmpc := Char(tmp[1]);
		Form2.ModalResult := Byte(tmpc);
	end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	if Not(ModalResult in [Byte('A')..Byte('Z')]) then ModalResult := Byte('0');

end;

procedure TForm2.WMSysCommand(var Msg: TWMSysCommand);
begin
	if ((Msg.CmdType and $FFF0) = SC_MOVE) or
		((Msg.CmdType and $FFF0) = SC_SIZE) then
	begin
		Msg.Result := 0;
		Exit;
	end;
	inherited;
end;

end.
