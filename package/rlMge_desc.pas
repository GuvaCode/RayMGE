unit rlMge_desc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazIDEIntf, ProjectIntf, Controls, Forms;

type

    { TRgfApplicationDescriptor }

    TrlMgeApplicationDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function InitProject(AProject: TLazProject): TModalResult; override;
    function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

    { TRgfFileUnit }

    TrlMgeFileUnit = class(TFileDescPascalUnit)
  public
    constructor Create; override;
    function GetInterfaceUsesSection: string; override;
    function GetUnitDirectives: string; override;
    function GetImplementationSource(const Filename, SourceName, ResourceName: string): string; override;
    function GetInterfaceSource(const aFilename, aSourceName, aResourceName: string): string; override;
    end;

     const LE = #10;

 procedure Register;

 resourcestring
   AboutPrj = 'Ray Game Application';
   AboutDsc='The Ray Game Framework is a set of classes for helping in the creation of 2D and 3D games in pascal.';



implementation

procedure Register;
begin
  RegisterProjectFileDescriptor(TrlMgeFileUnit.Create,FileDescGroupName);
  RegisterProjectDescriptor(TrlMgeApplicationDescriptor.Create);
end;
 function FileDescriptorByName() : TProjectFileDescriptor;
begin
  Result:=ProjectFileDescriptors.FindByName('rlMge_Unit');
end;
{ TRgfFileUnit }

constructor TrlMgeFileUnit.Create;
begin
   inherited Create;
  Name:='rlMge_Unit';
  UseCreateFormStatements:=False;
end;

function TrlMgeFileUnit.GetInterfaceUsesSection: string;
begin
    Result:='cmem, raylib, rlApplication'
end;

function TrlMgeFileUnit.GetUnitDirectives: string;
begin
  result := '{$mode objfpc}{$H+} '
end;

function TrlMgeFileUnit.GetImplementationSource(const Filename, SourceName,
  ResourceName: string): string;
begin
    Result:=
  'constructor TGame.Create;'+LE+
  'begin'+LE+
  ' //setup and initialization engine' +LE+
  ' InitWindow(800, 600, ''raylib [Game Project]''); // Initialize window and OpenGL context '+LE+
  ' SetWindowState(FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT); // Set window configuration state using flags'+LE+
  ' SetTargetFPS(60); // Set target FPS (maximum)' +LE+
  ' ClearBackgroundColor:= BLACK; // Set background color (framebuffer clear color)'+LE+
  'end;'+LE+
  ''+LE+
  'procedure TGame.Update;'+LE+
  'begin'+LE+
  'end;'+LE+
  ''+LE+
  'procedure TGame.Render;'+LE+
  'begin'+LE+
  ' DrawFPS(10,10); // Draw current FPS'+LE+
  'end;'+LE+
  ''+LE+
  'procedure TGame.Resized;'+LE+
  'begin'+LE+
  'end;'+LE+
  ''+LE+
  'procedure TGame.Shutdown;'+LE+
  'begin'+LE+
  'end;' +LE+LE;

end;

function TrlMgeFileUnit.GetInterfaceSource(const aFilename, aSourceName,
  aResourceName: string): string;
begin
   Result:=
'type'+LE+
'TGame = class(TrlApplication)'+LE+
'  private'+LE+
'  protected'+LE+
'  public'+LE+
'    constructor Create; override;'+LE+
'    procedure Update; override;'+LE+
'    procedure Render; override;'+LE+
'    procedure Shutdown; override;'+LE+
'    procedure Resized; override;'+LE+
'  end;'+LE+LE
end;

{ TRgfApplicationDescriptor }

constructor TrlMgeApplicationDescriptor.Create;
begin
  inherited Create;
  Name := AboutDsc;
end;

function TrlMgeApplicationDescriptor.GetLocalizedName: string;
begin
  Result := AboutPrj;
end;

function TrlMgeApplicationDescriptor.GetLocalizedDescription: string;
begin
  Result := AboutDsc;
end;

function TrlMgeApplicationDescriptor.InitProject(AProject: TLazProject
  ): TModalResult;
var
  NewSource: String;
  MainFile: TLazProjectFile;
begin
  Result:=inherited InitProject(AProject);

  MainFile:=AProject.CreateProjectFile('myGame.lpr');
  MainFile.IsPartOfProject:=true;
  AProject.AddFile(MainFile,false);
  AProject.MainFileID:=0;
  AProject.UseAppBundle:=true;
 // AProject.LoadDefaultIcon;
 // AProject.LazCompilerOptions.SyntaxMode:='Delphi';

   // create program source
  NewSource:=
  'program Game1;'+LE+
   ''+LE+
  'uses'+LE+
  '   SysUtils;'+LE+
  ''+LE+
  ''+LE+
  'var Game: TGame;'+LE+
  ''+LE+
  'begin'+LE+
  '  Game:= TGame.Create;'+LE+
  '  Game.Run;'+LE+
  '  Game.Free;'+LE+
  'end.'+LE;

  AProject.MainFile.SetSourceText(NewSource,true);


  AProject.AddPackageDependency('ray4laz');
  AProject.AddPackageDependency('rlMge');
  AProject.LazCompilerOptions.UnitOutputDirectory:='lib'+PathDelim+'$(TargetCPU)-$(TargetOS)';
  AProject.LazCompilerOptions.TargetFilename:='Game';
//  AProject.LazCompilerOptions.Win32GraphicApp:=True;
//AProject.LazCompilerOptions.GenerateDebugInfo:=False;

end;



function TrlMgeApplicationDescriptor.CreateStartFiles(AProject: TLazProject
  ): TModalResult;
begin
  Result:=LazarusIDE.DoNewEditorFile(FileDescriptorByName,'','',[nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
end;


end.

