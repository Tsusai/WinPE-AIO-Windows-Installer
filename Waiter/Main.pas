unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
	Form1: TForm1;

procedure RunAndWait(
	ExecuteFile : string;
	ParamString : string = '';
	StartInString : string = '');

implementation

{$R *.dfm}
uses ShellAPI;
procedure RunAndWait(
	ExecuteFile : string;
	ParamString : string = '';
	StartInString : string = '');
var
	SEInfo: TShellExecuteInfo;
	ExitCode: DWORD;
//	StartInString: string;
begin
	FillChar(SEInfo, SizeOf(SEInfo), 0) ;
	SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
	with SEInfo do begin
		fMask := SEE_MASK_NOCLOSEPROCESS;
		Wnd := GetDesktopWindow;
		lpFile := PChar(ExecuteFile) ;

		{
		ParamString can contain the
		application parameters.
		}
		lpParameters := PChar(ParamString) ;
		{
		StartInString specifies the
		name of the working directory.
		If ommited, the current directory is used.
		}
		lpDirectory := PChar(StartInString) ;

		nShow := SW_SHOWNORMAL;
	end;
	if ShellExecuteEx(@SEInfo) then begin
		repeat
			Application.ProcessMessages;
			GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
		until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
		//ShowMessage('Completed') ;
	end else ShowMessage('Error starting '+ ExecuteFile + ' ' + ParamString) ;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
	i : integer;
	Drive : char;
	Exit : boolean;
begin
	Exit := false;
	Timer1.Enabled := false;
	for i := 1 to 100 do
	begin
		for Drive := 'C' to 'Z' do
		begin
			if Drive = 'X' then continue;
			try
				if DirectoryExists(Drive + ':\boot\OSInstall') then
				begin
					RunAndWait(Drive + ':\Setup.exe');
					if MessageDlg('Setup was closed.  Reboot?',mtCustom,[mbYes,mbNo],0) = mrYes then
					begin
						Exit := True;
						break;
					end;
				end else
				begin
					Beep;
					Sleep(200);
				end;
			finally
			//MOO
			end;
		end;
		if Exit then break;
		if MessageDlg('Couldn''t find Setup.exe OR \boot\OSInstall Folder.  Bail?',mtCustom,[mbYes,mbNo],0) = mrYes then break;
	end;
	Application.Terminate;
end;

end.
