unit Main;

interface

uses
	Windows, Forms,
	StdCtrls, jpeg, ExtCtrls, Controls, Classes, Easysize, VistaAltFixUnit,
  JvExControls, JvFormWallpaper;

type
	TForm1 = class(TForm)
		XPBtn: TButton;
		VistaBtn: TButton;
		SevenBtn: TButton;
		CmdBtn: TButton;
		RebootBtn: TButton;
		CubicBtn: TButton;
    EightBtn: TButton;
    VistaAltFix1: TVistaAltFix;
    BBG: TJvFormWallpaper;
		procedure XPBtnClick(Sender: TObject);
		procedure VistaBtnClick(Sender: TObject);
		procedure SevenBtnClick(Sender: TObject);
		procedure CmdBtnClick(Sender: TObject);
		procedure RebootBtnClick(Sender: TObject);
		procedure CubicBtnClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
    procedure EightBtnClick(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
		WinPE : boolean;
		procedure ChangeSize(newWidth, newHeight: integer);
	end;


var
	Form1: TForm1;
	AppDrv : Char;

implementation
uses
	SysUtils,
	ShellAPI,
	Dialogs;

{$R *.dfm}

type
	TOSInfo = class(TObject)
	public
		class function IsWOW64: Boolean;
	end;

class function TOSInfo.IsWOW64: Boolean;
type
	TIsWow64Process = function(
		Handle: THandle;
		var Res: BOOL
	): BOOL; stdcall;
var
	IsWow64Result: BOOL;
	IsWow64Process: TIsWow64Process;
begin
	IsWow64Process := GetProcAddress(
		GetModuleHandle('kernel32'), 'IsWow64Process'
	);
	if Assigned(IsWow64Process) then
	begin
		if not IsWow64Process(GetCurrentProcess, IsWow64Result) then
			raise Exception.Create('Bad process handle');
		Result := IsWow64Result;
	end
	else
		Result := False;
end;

function ExpandEnvVars(const Str: string): string;
var
	BufSize: Integer; // size of expanded string
begin
	// Get required buffer size
	BufSize := ExpandEnvironmentStrings(
		PChar(Str), nil, 0);
	if BufSize > 0 then
	begin
		// Read expanded string into result string
		SetLength(Result, BufSize - 1);
		ExpandEnvironmentStrings(PChar(Str),
			PChar(Result), BufSize);
	end
	else
		// Trying to expand empty string
		Result := '';
end;

procedure Execute(
	Command : string;
	Params : string = '';
	StartFolder : string = '');
begin
	ShellExecute(
		Form1.Handle,
		'open',
		PChar(Command),
		PChar(Params),
		PChar(StartFolder),
		SW_SHOWNORMAL);
end;

procedure TForm1.XPBtnClick(Sender: TObject);
begin
	Execute(AppDrv + ':\boot\OSInstall\XP\Setup.exe');
end;

procedure TForm1.VistaBtnClick(Sender: TObject);
begin
	Execute(AppDrv + ':\boot\OSInstall\VISTA\Setup.exe');
end;

procedure TForm1.SevenBtnClick(Sender: TObject);
begin
	Execute(AppDrv + ':\boot\OSInstall\SEVEN\Setup.exe');
end;

procedure TForm1.EightBtnClick(Sender: TObject);
begin
	Execute(AppDrv + ':\boot\OSInstall\EIGHT\Setup.exe');
end;

procedure TForm1.CmdBtnClick(Sender: TObject);
begin
	Execute('CMD.exe');
end;

procedure TForm1.RebootBtnClick(Sender: TObject);
begin
	Execute('Wpeutil','Reboot');
end;

procedure TForm1.CubicBtnClick(Sender: TObject);
begin
	if WinPE then
	begin
		if not DirectoryExists(
			ExpandEnvVars('%SystemRoot%\system32\config\systemprofile\desktop')
			)
		then ForceDirectories(
			ExpandEnvVars('%SystemRoot%\system32\config\systemprofile\desktop')
		);
	end;
	Execute(AppDrv + ':\Tech-Tools\CubicExplorer\CubicExplorer.exe');
end;

procedure TForm1.ChangeSize(newWidth, newHeight: integer);
var
	i, oldWidth, oldHeight : integer;
begin
	oldWidth:=Width;
	oldHeight:=Height;
	for i:=0 to ControlCount-1 do
		with Controls[i] do
		begin
			Width:=Width*newWidth div oldWidth;
			Height:=Height*newHeight div oldHeight;
			Left:=Left*newWidth div oldWidth;
			Top:=Top*newHeight div oldHeight;
		end;
	Width:=newWidth;
	Height:=newHeight;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
	AppDrv := ExtractFileDrive(ParamStr(0))[1];

	XPBtn.Enabled := FileExists(AppDrv + ':\boot\OSInstall\XP\Setup.exe');
	VistaBtn.Enabled := FileExists(AppDrv + ':\boot\OSInstall\VISTA\Setup.exe');
	SevenBtn.Enabled := FileExists(AppDrv + ':\boot\OSInstall\SEVEN\Setup.exe');
	EightBtn.Enabled := FileExists(AppDrv + ':\boot\OSInstall\EIGHT\Setup.exe');

	if FileExists(
		ExpandEnvVars('%SystemRoot%\system32\wpeutil.exe')
	) then
	begin
		Left := 0;
		Top := 0;
		ChangeSize(Screen.Width,Screen.Height);
		WinPE := true;
	end
	else
	begin
		BorderStyle := bsToolWindow;
		ClientWidth := 800;
		ClientHeight := 600;
		Left:=(Screen.Width-Width)  div 2;
		Top:=(Screen.Height-Height) div 2;
		RebootBtn.Enabled := false;
		WinPE := false;
	end;
end;


end.
