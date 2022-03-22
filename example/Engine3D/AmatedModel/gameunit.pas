unit gameunit;

{$mode objfpc}{$H+} 

interface

uses
  cmem, raylib, rlApplication, rlEngine;

type
TGame = class(TrlApplication)
  private
  protected
  public
    RifleTex:TTexture2d;
    Engine: TrlEngine;
    Character: TrlAnimatedModel;
    constructor Create; override;
    procedure Update; override;
    procedure Render; override;
    procedure Shutdown; override;
    procedure Resized; override;
  end;

const AnimCount = 17;
var   AnimName: array[0..17] of string = ('Dance', 'Death', 'Hello','HitRecieve_1',
'HitRecieve_2','Idle','Jump','Kick','No','Pickup','Punch','Run','Run_Holding','Shoot',
'SwordSlash','Walk','Walk_Holding','Yes');


implementation
uses sysutils;

constructor TGame.Create;
begin
  //setup and initialization engine
  InitWindow(800, 600, 'raylib [Game Project]'); // Initialize window and OpenGL context 
  SetWindowState(FLAG_VSYNC_HINT or FLAG_MSAA_4X_HINT); // Set window configuration state using flags
  SetTargetFPS(60); // Set target FPS (maximum)
  ClearBackgroundColor:= BLACK; // Set background color (framebuffer clear color)

  Engine:=TrlEngine.Create;
 // Engine.DrawDebugGrid:=true;

  Character:=TrlAnimatedModel.Create(Engine);
  Character.LoadModel('model/iqm/stan/Stan.iqm');

  Character.LoadModelTexture('model/iqm/stan/Stan_Texture.png',MATERIAL_MAP_DIFFUSE);
  Character.Axis:=Vector3Create(90,0,0);
  Character.AnimationLoop:=true;
  Character.AnimationSpeed:=20;
  Character.AnimationIndex:=0;

end;

procedure TGame.Update;
begin
  if IsKeyReleased(KEY_SPACE) then
  begin
   if Character.AnimationIndex < AnimCount then
      Character.AnimationIndex:= Character.AnimationIndex+1
      else
      Character.AnimationIndex:=0;
  end;

  if IsKeyReleased(KEY_ONE) then
  Character.LoadModelTexture('model/iqm/stan/Stan_1_Texture.png',MATERIAL_MAP_DIFFUSE);

  if IsKeyReleased(KEY_TWO) then
  Character.LoadModelTexture('model/iqm/stan/Stan_2_Texture.png',MATERIAL_MAP_DIFFUSE);

  if IsKeyReleased(KEY_THREE) then
  Character.LoadModelTexture('model/iqm/stan/Stan_3_Texture.png',MATERIAL_MAP_DIFFUSE);

  if IsKeyReleased(KEY_FOUR) then
  Character.LoadModelTexture('model/iqm/stan/Stan_4_Texture.png',MATERIAL_MAP_DIFFUSE);

  if IsKeyReleased(KEY_FIVE) then
  Character.LoadModelTexture('model/iqm/stan/Stan_Texture.png',MATERIAL_MAP_DIFFUSE);


  Engine.Update;
end;

procedure TGame.Render;
var AnimTxt:String;
begin
  Engine.Render;
  AnimTxt:='Animation name: '+AnimName[Character.AnimationIndex];
  DrawText('Press space to change animation  -  1 of 5 to change model texture',10,30,10,RED);
  DrawText(Pchar(AnimTxt),10,45,10,BLUE);
  AnimTxt:='Animation: '+ IntTostr(Character.AnimationIndex)
  + ' of ' + IntTostr(AnimCount);
  DrawText(Pchar(AnimTxt),10,60,10,GREEN);
  DrawText('Model by Quaternius',10,GetScreenHeight-20,10,SKYBLUE);


  DrawFPS(10, 10); // Draw current FPS
end;

procedure TGame.Resized;
begin
end;

procedure TGame.Shutdown;
begin
end;

end.

