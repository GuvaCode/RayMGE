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
  Ship.Acceleration:=1.2;
  Ship.Decceleration:=0.01;
  Ship.MaxSpeed:=10;
  Ship.MinSpeed:=0;
//  Ship.RotationAngle:=90;
end;

procedure TGame.Update;
begin


  if IsKeyDown(Key_A) then // Left
  begin
    Vector3Set(@Ship.Axis, Ship.Axis.x,Ship.Axis.y-1 , 0);

  end;

  if IsKeyDown(Key_D) then //Right
  begin
    Vector3Set(@Ship.Axis, Ship.Axis.x,Ship.Axis.y+1 , 0);
  end;

    if IsKeyDown(Key_S) then //Right
  begin
    //Vector3Set(@Ship.Axis, Ship.Axis.x,Ship.Axis.y+1 , Ship.Axis.z);
   Ship.RotationAngle :=Ship.RotationAngle+1;
  end;


  if IsKeyDown(Key_UP) then  // Up
  begin
    Vector3Set(@Ship.Axis,Ship.Axis.x + 1, Ship.Axis.y , Ship.Axis.z);
  end;

  if IsKeyDown(KEY_DOWN) then  // Down
  begin
    Vector3Set(@Ship.Axis,Ship.Axis.x - 1, Ship.Axis.y , Ship.Axis.z);
  end;

  if IsKeyDown(Key_W) then  // Down
  begin
    Ship.Accelerate;
  end else ship.Deccelerate;


    Ship.Direction:= Ship.Axis.y+90;
    Ship.Rotation:=Ship.Axis.x+90;
 //   ship.RotationAngle:=ship.Rotation-180;
    Engine.EngineCamera.target:=Ship.Position;

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

