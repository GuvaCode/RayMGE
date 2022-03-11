unit mUnit;

{$mode objfpc}{$H+} 

interface

uses
  cmem, raylib, rlApplication, rlEngine, raymath;

type
TcolBox = class(TrlModel);
{ TPlayer }

TPlayer = class(TrlJumperModel)
 private
 oldPositionX:Single;
 oldPositionY:single;

 public
 procedure Update; override;
 constructor Create(Engine: TrlEngine); override;
 procedure DoCollision(CollisonModel: TrlModel); override;

end;

TGame = class(TrlApplication)
  private
  protected
  public
    engine: TrlEngine;
    ground_block: TcolBox;
    player:TPlayer;
    constructor Create; override;
    procedure Update; override;
    procedure Render; override;
    procedure Shutdown; override;
    procedure Resized; override;
  end;

implementation

{ TPlayer }

procedure TPlayer.Update;
var  Cbox:TBoundingBox;
begin
  inherited Update;
  Cbox.max:=Vector3Create(Self.Position.x+0.5, Self.Position.y +1.5 ,self.Position.z+0.5);
  Cbox.min:=Vector3Create(Self.Position.x-0.5, Self.Position.y      ,self.Position.z-0.5);
  CollisionBBox:=Cbox;

  if IsKeyPressed(Key_W) then
  begin
    self.AnimationIndex:=1;
    self.DoJump:=true;
    self.AnimationLoop:=false;
    //self.JumpState:=jsJumping;
  end;

  if IsKeyDown(Key_D) then
  begin
    self.Accelerate;
    self.AnimationIndex:=2;
    self.AnimationLoop:=true;
    self.JumpState:=jsFalling;
  end;

collision;
oldPositionX := self.Position.x;
oldPositionY := self.Position.y;
end;

constructor TPlayer.Create(Engine: TrlEngine);
var  Cbox:TBoundingBox;
begin
  inherited Create(Engine);
  self.LoadModel('model/mario.iqm');
  self.LoadModelTexture('texture/mario.png',MATERIAL_MAP_DIFFUSE);
  self.Axis:=Vector3Create(90,-90,self.Axis.z);
  self.Position:=Vector3Create(-4,2,0);
  self.DoJump:=true;
  self.Collisioned:=true;
  self.AnimationIndex:=0;
  self.AnimationSpeed:=50;
  self.Acceleration:=1;
  self.MaxSpeed:=5;
  self.Decceleration:=1;
  self.Direction:=Vector3Create(90,-90, 0);
  Cbox.max:=Vector3Create(Self.Position.x+0.5, Self.Position.y +1.5 ,self.Position.z+0.5);
  Cbox.min:=Vector3Create(Self.Position.x-0.5, Self.Position.y      ,self.Position.z-0.5);
  self.CollisionBBox:=Cbox;
end;

procedure TPlayer.DoCollision(CollisonModel: TrlModel);
begin
  inherited DoCollision(CollisonModel);
   if (CollisonModel is TcolBox)  then
   begin
   self.JumpState:=jsNone;
   self.Position:=Vector3Create(Self.oldPositionX ,OldPositionY,0);

   if self.Speed>0 then
   self.animationIndex:=2;
   self.AnimationLoop:=true;
   end;
end;

constructor TGame.Create;
var i:integer;
    copy_block: TModel;
    //Cbox:TBoundingBox;
begin
  //setup and initialization engine
  InitWindow(800, 600, 'raylib [Game Project]'); // Initialize window and OpenGL context 
  SetWindowState(FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT); // Set window configuration state using flags
  SetTargetFPS(60); // Set target FPS (maximum)
  ClearBackgroundColor:= BLACK; // Set background color (framebuffer clear color)

  // Create engine
  Engine:=TrlEngine.Create;
 // Engine.DrawDebugGrid:=True;
  Engine.EngineCameraMode:=CAMERA_THIRD_PERSON;

  // Create ground
  copy_block:=LoadModel(PChar('model/tile_forest.obj'));
  for i:= -4 to 4 do
  begin
  ground_block:=TcolBox.Create(Engine);
  ground_block.Model:=copy_block;
  ground_block.Position:=Vector3Create(i*2,0,0);
  ground_block.CollisionAutoSize:=true;
  ground_block.Collisioned:=true;
  end;

  for i:= 7 to 9 do
  begin
  ground_block:=TcolBox.Create(Engine);
  ground_block.Model:=copy_block;
  ground_block.Position:=Vector3Create(i*2,0,0);
  ground_block.CollisionAutoSize:=true;
  ground_block.Collisioned:=true;
  end;

  for i:= 13 to 19 do
  begin
  ground_block:=TcolBox.Create(Engine);
  ground_block.Model:=copy_block;
  ground_block.Position:=Vector3Create(i*2,0,0);
  ground_block.CollisionAutoSize:=true;
  ground_block.Collisioned:=true;
  end;

  Player:=TPlayer.Create(Engine);

end;

procedure TGame.Update;
begin
  Engine.Update;
  Engine.EngineCamera.target:=Player.Position;
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
end;

end.

