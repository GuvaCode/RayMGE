unit mUnit;

{$mode objfpc}{$H+} 

interface

uses
  cmem, raylib, rlApplication, rlEngine;

type
TGame = class(TrlApplication)
  private
  protected
  public
    Engine: TrlEngine;
    Ship: TrlPlayermodel;
    constructor Create; override;
    procedure Update; override;
    procedure Render; override;
    procedure Shutdown; override;
    procedure Resized; override;
  end;

implementation

constructor TGame.Create;
begin
  //setup and initialization engine
  InitWindow(800, 600, 'raylib [Game Project]'); // Initialize window and OpenGL context 
  SetWindowState(FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT); // Set window configuration state using flags
  SetTargetFPS(60); // Set target FPS (maximum)
  ClearBackgroundColor:= BLACK; // Set background color (framebuffer clear color)

  Engine:=TrlEngine.Create;
  Engine.EngineCameraMode:=4;
  Engine.DrawDebugGrid:=true;

  Ship:=TrlPlayerModel.Create(Engine);
  Ship.LoadModel('model/spaceship2.iqm');
  Ship.LoadModelTexture('texture/Pallette.png',0);
  Ship.Axis:=Vector3Create(90,-90,0);
  Ship.Scale:=0.5;
end;

procedure TGame.Update;
begin
  Engine.Update;
end;

procedure TGame.Render;
begin
  Engine.Render;
  DrawFPS(10, 10); // Draw current FPS
end;

procedure TGame.Resized;
begin
end;

procedure TGame.Shutdown;
begin
  Engine.Free;
end;

end.

