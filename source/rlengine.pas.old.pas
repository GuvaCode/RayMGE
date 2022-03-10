(*
██████╗ ██╗      ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗     ██╗    ██████╗
██╔══██╗██║      ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝    ███║   ██╔═████╗
██████╔╝██║█████╗█████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗      ╚██║   ██║██╔██║
██╔══██╗██║╚════╝██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝       ██║   ████╔╝██║
██║  ██║███████╗ ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗     ██║██╗╚██████╔╝
╚═╝  ╚═╝╚══════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝     ╚═╝╚═╝ ╚═════╝
*)
unit rlEngine;

{$mode objfpc}{$H+}

interface

uses
  raylib, raymath, rlgl, rlFPCamera, rlTPCamera, rlights, ray_math2d, classes;

type
  TrlEngineDrawMode = (dmNormal, dmEx, dmWires, dmWiresEx);
  TrlEngineCameraMode = (cmFirstPerson, cmThirdPerson);
  TrlModelCollisionMode = (cmBBox,cmSphere);


  { TrlEngine }
  TrlEngine = class
    private
      FDebug: boolean;
      FDrawDistance: single;
      FDrawsGrid: boolean;
      FEngineCameraMode: TrlEngineCameraMode;
      FGridSlices: longint;
      FGridSpacing: single;
      FShowSkyBox: boolean;
      FUseMouse: boolean;
      FSkyBox: TModel;
      FUsesDrawDistance: boolean;
      FCollisionDrawDistance: TVector3;
      procedure SetDebug(AValue: boolean);
      procedure SetDrawDistance(AValue: single);
      procedure SetDrawsGrid(AValue: boolean);
      procedure SetEngineCameraMode(AValue: TrlEngineCameraMode);
      procedure SetGridSlices(AValue: longint);
      procedure SetGridSpacing(AValue: single);
      procedure SetShowSkyBox(AValue: boolean);
      procedure SetUseMouse(AValue: boolean);
      procedure SetUsesDrawDistance(AValue: boolean);
    protected
      FList: TList;
      FDeadList: TList;
      procedure CreateSkyBox;
      procedure GreateEngineLights;
      procedure DoMoveUpdate; virtual;
      procedure DoMoveEndUpdate; virtual;
    public
      shader: TShader;
      ambientLoc: integer;
      lights: TLight ;
      shaderVol: array [0..3] of single;

      CameraThirdPerson:TrlTPCamera;
      CameraFirstPerson:TrlFPCamera;

      constructor Create;
      destructor Destroy; override;

      procedure Move(MoveCount: single);
      procedure Draw; virtual;
      procedure ClearDeadModel;
      procedure LoadSkyBoxFile(FileName:string);

      property EngineCameraMode: TrlEngineCameraMode read FEngineCameraMode write SetEngineCameraMode;
      property DrawsGrid: boolean read FDrawsGrid write SetDrawsGrid;
      property DrawDistance: single read FDrawDistance write SetDrawDistance;
      property UsesDrawDistance: boolean read FUsesDrawDistance write SetUsesDrawDistance;
      property GridSlices:longint read FGridSlices write SetGridSlices;
      property GridSpacing: single read FGridSpacing write SetGridSpacing;
      property Debug: boolean read FDebug write SetDebug;
      property UseMouse: boolean read FUseMouse write SetUseMouse;
      property ShowSkyBox: boolean read FShowSkyBox write SetShowSkyBox;
  end;

  { TrlModel }
  TrlModel = class
    private
      FAngle: Single;
      FAnimationIndex: longint;
      FAnimationSpeed: Single;
      FAnims: PModelAnimation;
  //    FAxis: TVector3;
      FAxisX: Single;
      FAxisY: Single;
      FAxisZ: Single;
      FCollisionAutoSize: boolean;
      FCollisioned: Boolean;
      FCollisionMode: TrlModelCollisionMode;
      FCollisionRadius: single;
      FColor: TColor;
      FDrawMode: TrlEngineDrawMode;
      FPosition: TVector3;
      FPositionX: single;
      FPositionY: single;
      FPositionZ: single;
      FScale: Single;
      FScaleEx: TVector3;
      FAnimCont: integer;
      function GetPositionX: single;
      function GetPositionY: single;
      function GetPositionZ: single;
      procedure SetAnimationIndex(AValue: longint);
      procedure SetAnimationSpeed(AValue: Single);
      procedure SetCollisionAutoSize(AValue: boolean);
      procedure SetCollisionMode(AValue: TrlModelCollisionMode);
      procedure SetCollisionRadius(AValue: single);
      procedure SetDrawMode(AValue: TrlEngineDrawMode);
      procedure SetPosition(AValue: TVector3);
      procedure SetPositionX(AValue: single);
      procedure SetPositionY(AValue: single);
      procedure SetPositionZ(AValue: single);
      procedure SetScale(AValue: Single);
    protected
      FModelDead: Boolean;
      FEngine: TrlEngine;
      FModel: TModel;
      FTexture: TTexture;
      FCollisionBBox:TBoundingBox;
      FCollisionSphere: TVector3;
      FIsModelAnimation: boolean;
      FAnimFrameCounter: Single;
      procedure DoCollision(CollisonModel: TrlModel); virtual;
    public
      FAxis: TVector3;
      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;
      procedure Move(const MoveCount: Single); overload; virtual;
      procedure Update3dModelAnimations(MoveCount: Single);
      procedure LoadingModel(FileName: String);
      procedure LoadingModelTexture(TextureFileName:String; MaterialMap: integer);
      procedure Load3dModelAnimations(FileName:String);

      procedure Dead;
      procedure Draw; virtual;

      procedure Collision(const Other: TrlModel); overload; virtual;
      procedure Collision; overload; virtual;

      procedure SetLight(Engine:TrlEngine);

      property DrawMode: TrlEngineDrawMode read FDrawMode write SetDrawMode;
      property Model: TModel read FModel write FModel;
      property Color: TColor read FColor write FColor;
      property Scale: Single read FScale write SetScale;

      property CollisionAutoSize: boolean read FCollisionAutoSize write SetCollisionAutoSize;
      property CollisionRadius: single read FCollisionRadius write SetCollisionRadius;
      property Collisioned: Boolean read FCollisioned write FCollisioned;
      property CollisionSphere: TVector3 read FCollisionSphere write FCollisionSphere;

      property CollisionMode: TrlModelCollisionMode read FCollisionMode write SetCollisionMode;

      property Position: TVector3 read FPosition write SetPosition;
      property PositionX: single read GetPositionX write SetPositionX;
      property PositionY: single read GetPositionY write SetPositionY;
      property PositionZ: single read GetPositionZ write SetPositionZ;

      property X: Single read FPosition.X write FPosition.X;
      property Y: Single read FPosition.Y write FPosition.Y;
      property Z: Single read FPosition.Z write FPosition.Z;

      property AxisX: Single read FAxisX write FAxisX;
      property AxisY: Single read FAxisY write FAxisY;
      property AxisZ: Single read FAxisZ write FAxisZ;
      property Angle: Single read FAngle write FAngle;

      property Anims: PModelAnimation read FAnims write FAnims;
      property AnimationIndex: longint read FAnimationIndex write SetAnimationIndex;
      property AnimationSpeed: Single read FAnimationSpeed write SetAnimationSpeed;

    end;

  { TrlModelParticle }

  TrlModelParticle = class(TrlModel)
  private
    FAccelX: Real;
    FAccelY: Real;
    FAccelZ: Real;
    FVelocityX: Real;
    FVelocityY: Real;
    FUpdateSpeed: Single;
    FDecay: Real;
    FLifeTime: Real;
    FVelocityZ: Real;
  public
    constructor Create(Engine: TrlEngine); override;
    procedure Move(const MoveCount: Single); override;
    property AccelX: Real read FAccelX write FAccelX;
    property AccelZ: Real read FAccelY write FAccelZ;
    property VelocityX: Real read FVelocityX write FVelocityX;
    property VelocityZ: Real read FVelocityZ write FVelocityZ;
    property UpdateSpeed: Single read FUpdateSpeed write FUpdateSpeed;
    property Decay: Real read FDecay write FDecay;
    property LifeTime: Real read FLifeTime write FLifeTime;
  end;


  { TrlModelPlayer }
  TrlModelPlayer = class(TrlModel)
    private
      FSpeed: Single;
      FAcc: Single;
      FDcc: Single;
      FMinSpeed: Single;
      FMaxSpeed: Single;
      FVelocityX: Single;
      FVelocityY: Single;
      FDirection: Integer;
      FVelocityZ: Single;
      procedure SetSpeed(Value: Single);
      procedure SetDirection(Value: Integer);
    public
      constructor Create(Engine: TrlEngine); override;
      procedure Move(const MoveCount: Single); override;
      procedure Accelerate; virtual;
      procedure Deccelerate; virtual;
      property Speed: Single read FSpeed write SetSpeed;
      property MinSpeed: Single read FMinSpeed write FMinSpeed;
      property MaxSpeed: Single read FMaxSpeed write FMaxSpeed;
      property VelocityX: Single read FVelocityX write FVelocityX;
      property VelocityY: Single read FVelocityY write FVelocityY;
      property VelocityZ: Single read FVelocityZ write FVelocityZ;
      property Acceleration: Single read FAcc write FAcc;
      property Decceleration: Single read FDcc write FDcc;
      property Direction: Integer read FDirection write SetDirection;

    end;

const LE = #10; // line end;
const PIDiv180  =  0.017453292519943295769236907684886;

implementation

{ TrlModelParticle }
constructor TrlModelParticle.Create(Engine: TrlEngine);
begin
  inherited;// Create(AParent);
  FAccelX := 0;
  FAccelY := 0;
  FVelocityX := 0;
  FVelocityY := 0;
  FUpdateSpeed := 0;
  FDecay := 0;
  FLifeTime := 1;
end;

procedure TrlModelParticle.Move(const MoveCount: Single);
begin

X := X + FVelocityX * UpdateSpeed * MoveCount;
Z := Z + FVelocityZ * UpdateSpeed * MoveCount;

FVelocityX := FVelocityX + FAccelX * UpdateSpeed;
FVelocityZ := FVelocityZ + FAccelZ * UpdateSpeed;

FLifeTime := FLifeTime - FDecay * MoveCount;

if FLifeTime <= 0 then Dead;
 inherited;

// self.Scale:=self.Scale-0.1;


end;

{ TrlModelPlayer }

procedure TrlModelPlayer.SetSpeed(Value: Single);
begin
  if FSpeed > FMaxSpeed then FSpeed := FMaxSpeed
  else
  if FSpeed < FMinSpeed then  FSpeed := FMinSpeed;
  FSpeed := Value;
  VelocityX := m_Cos(FDirection) * Speed;
  VelocityZ := m_Sin(FDirection) * Speed;
end;

procedure TrlModelPlayer.SetDirection(Value: Integer);
begin
  FDirection := Value;
  VelocityX := m_Cos(FDirection) * Speed;
  VelocityZ := m_Sin(FDirection) * Speed;
end;

constructor TrlModelPlayer.Create(Engine: TrlEngine);
begin
  inherited;// Create(Engine);
  FVelocityX := 0;
  FVelocityY := 0;
  FVelocityZ := 0;
  Acceleration := 0;
  Decceleration := 0;
  Speed := 0;
  MinSpeed := 0;
  MaxSpeed := 0;
  FDirection := 0;
end;

procedure TrlModelPlayer.Move(const MoveCount: Single);
begin
  // Apply movement
  X := X + VelocityX * MoveCount;
  Y := Y + VelocityY * MoveCount;
  Z := Z + VelocityZ * MoveCount;
  inherited Move(MoveCount);
end;

procedure TrlModelPlayer.Accelerate;
begin
  if FSpeed <> FMaxSpeed then
  begin
    FSpeed := FSpeed + FAcc;
    if FSpeed > FMaxSpeed then
       FSpeed := FMaxSpeed;
    VelocityX :=  m_Cos(FDirection) * Speed ;
    VelocityZ :=  m_Sin(FDirection) * Speed ;
  end;
end;

procedure TrlModelPlayer.Deccelerate;
begin
  if FSpeed <> FMinSpeed then
  begin
    FSpeed := FSpeed - FDcc;
    if FSpeed < FMinSpeed then
       FSpeed := FMinSpeed;
    VelocityX := m_Cos(FDirection) * Speed;
    VelocityZ := m_Sin(FDirection) * Speed;
  end;
end;

{ TrlEngine }
procedure TrlEngine.SetEngineCameraMode(AValue: TrlEngineCameraMode);
begin
  if FEngineCameraMode=AValue then Exit;
  FEngineCameraMode:=AValue;
end;

procedure TrlEngine.SetGridSlices(AValue: longint);
begin
  if FGridSlices=AValue then Exit;
  FGridSlices:=AValue;
end;

procedure TrlEngine.SetGridSpacing(AValue: single);
begin
  if FGridSpacing=AValue then Exit;
  FGridSpacing:=AValue;
end;

procedure TrlEngine.SetShowSkyBox(AValue: boolean);
begin
  if FShowSkyBox=AValue then Exit;
  FShowSkyBox:=AValue;
end;

procedure TrlEngine.SetUseMouse(AValue: boolean);
begin
  if FUseMouse=AValue then Exit;
  FUseMouse:=AValue;
end;

procedure TrlEngine.SetUsesDrawDistance(AValue: boolean);
begin
  if FUsesDrawDistance=AValue then Exit;
  FUsesDrawDistance:=AValue;
end;

procedure TrlEngine.CreateSkyBox;
{$I shader/skybox.inc}
var Cube:TMesh;
    mMap:Integer;
begin
  // Create SkyBox
  Cube:=GenMeshCube(1.0,1.0,1.0);
  FSkyBox:=LoadModelFromMesh(cube);
  FSkybox.materials[0].shader := LoadShaderFromMemory(vs,fs);
  mMap:=MATERIAL_MAP_CUBEMAP;
  SetShaderValue(FSkybox.materials[0].shader, GetShaderLocation(FSkybox.materials[0].shader,
  'environmentMap'), @mMap , SHADER_UNIFORM_INT);
end;

procedure TrlEngine.GreateEngineLights;
//{$I shader/light.inc}
begin
  shader := LoadShader('base_lighting.vs','lighting.fs');
  shader.locs[SHADER_LOC_VECTOR_VIEW] := GetShaderLocation(shader, 'viewPos');
  ambientLoc := GetShaderLocation(shader, 'ambient');
  shaderVol[0]:=0.1;
  shaderVol[1]:=0.1;
  shaderVol[2]:=0.1;
  shaderVol[3]:=0.1;
  SetShaderValue(shader, ambientLoc, @shaderVol, SHADER_UNIFORM_VEC4);
  lights:= CreateLight(LIGHT_POINT, Vector3Create( 150, 100, 1 ), Vector3Zero, WHITE, shader);
end;

procedure TrlEngine.DoMoveUpdate;
begin
//
end;

procedure TrlEngine.DoMoveEndUpdate;
begin
//
end;

procedure TrlEngine.SetDrawsGrid(AValue: boolean);
begin
  if FDrawsGrid=AValue then Exit;
  FDrawsGrid:=AValue;
end;

procedure TrlEngine.SetDebug(AValue: boolean);
begin
  if FDebug=AValue then Exit;
  FDebug:=AValue;
end;

procedure TrlEngine.SetDrawDistance(AValue: single);
begin
  if FDrawDistance=AValue then Exit;
  FDrawDistance:=AValue;
end;

constructor TrlEngine.Create;
begin
  FList := TList.Create;
  FDeadList := TList.Create;

  SetEngineCameraMode(cmThirdPerson);

  rlTPCameraInit(@CameraThirdPerson, 45, Vector3Create( 0, 0 ,0 ));
  rlFPCameraInit(@CameraFirstPerson, 45, Vector3Create( 0, 0, 0 ));

  CameraFirstPerson.MoveSpeed.z := 10;
  CameraFirstPerson.MoveSpeed.x := 10;
  CameraFirstPerson.FarPlane := 5000;

  CameraThirdPerson.MoveSpeed.z:=10;
  CameraThirdPerson.MoveSpeed.x:=10;
  CameraThirdPerson.FarPlane:=5000;

  FUseMouse:=False;
  FDrawsGrid:=False;
  FDebug:=False;
  FGridSpacing:=2;
  FGridSlices:=10;
  FDrawDistance:=1000;
  FUsesDrawDistance:=false;

  CreateSkyBox;
  GreateEngineLights;

end;

destructor TrlEngine.Destroy;
var i: integer;
begin
  for i := 0 to FList.Count- 1 do TrlModel(FList.Items[i]).Destroy;
  FList.Destroy;
  FDeadList.Destroy;
  inherited Destroy;
end;

procedure TrlEngine.Move(MoveCount: single);
var
  i: Integer;
begin
   case FEngineCameraMode of
     cmFirstPerson:
       begin
         rlFPCameraUpdate(@CameraFirstPerson);
         rlFPCameraUseMouse(@CameraFirstPerson,FUseMouse);
         FCollisionDrawDistance:=CameraFirstPerson.CameraPosition;
       end;

     cmThirdPerson:
       begin
         rlTPCameraUpdate(@CameraThirdPerson);
         rlTPCameraUseMouse(@CameraThirdPerson,FUseMouse,1);
         FCollisionDrawDistance:=CameraThirdPerson.CameraPosition;
       end;
   end;

 DoMoveUpdate;
for i := 0 to FList.Count - 1 do
  begin
    TrlModel(FList.Items[i]).Update3dModelAnimations(MoveCount);
    TrlModel(FList.Items[i]).Move(MoveCount);
  end;

 DoMoveEndUpdate;

end;

procedure TrlEngine.Draw;
var
  i: Integer;
begin

  case FEngineCameraMode of
    cmFirstPerson: rlFPCameraBeginMode3D(@CameraFirstPerson);
    cmThirdPerson: rlTPCameraBeginMode3D(@CameraThirdPerson);
  end;

  if ShowSkyBox then // Draw Skybox
    begin
     rlDisableBackfaceCulling();
     rlDisableDepthMask();
     DrawModel(FSkybox, Vector3Create(0, 0, 0), 1.0, white);
     rlEnableBackfaceCulling();
     rlEnableDepthMask();
    end;

  for i := 0 to FList.Count - 1 do
    begin
     if FUsesDrawDistance then
       begin
        if Vector3Distance(FCollisionDrawDistance, TrlModel(FList.Items[i]).Position) <= self.FDrawDistance
        then TrlModel(FList.Items[i]).Draw;
       end
        else
        TrlModel(FList.Items[i]).Draw;



     if FDebug then
        begin // Draw debug collisions (Sphere or Bounding Box)
          if TrlModel(FList.Items[i]).CollisionMode = cmSphere then
          DrawSphereWires(TrlModel(FList.Items[i]).FCollisionSphere,TrlModel(FList.Items[i]).CollisionRadius,10,10,GREEN);
          if TrlModel(FList.Items[i]).CollisionMode = cmBBox then
          DrawBoundingBox(TrlModel(FList.Items[i]).FCollisionBBox,BLUE);
        end;
    end;


  if FDrawsGrid then DrawGrid(FGridSlices, FGridSpacing);

  case FEngineCameraMode of
     cmFirstPerson: rlFPCameraEndMode3D;
     cmThirdPerson: rlTPCameraEndMode3D;
  end;

end;

procedure TrlEngine.ClearDeadModel;
var
  i: Integer;
begin
  for i := 0 to FDeadList.Count - 1 do
  begin
    if FDeadList.Count >= 1 then
    begin
      if TrlModel(FDeadList.Items[i]).FModelDead = True then
      begin
        TrlModel(FDeadList.Items[i]).FEngine.FList.Remove(FDeadList.Items[i]);
      end;
    end;
  end;
  FDeadList.Clear;
end;

procedure TrlEngine.LoadSkyBoxFile(FileName: string);
var img:TImage;
begin
   img := LoadImage(PChar(FileName));// сделать отдельный класс для скай бокса
   //if Self.FShowSkyBox then
   FSkybox.materials[0].maps[MATERIAL_MAP_CUBEMAP].texture := LoadTextureCubemap(img, CUBEMAP_LAYOUT_AUTO_DETECT);
   UnloadImage(img);
end;

{ TrlModel }
procedure TrlModel.SetScale(AValue: Single);
begin
  FScale:=AValue;
  Vector3Set(@FScaleEx,FScale,FScale,FScale);
  FModel.transform:=MatrixScale(FScale,FScale,FScale);
end;

{$HINTS OFF}
procedure TrlModel.DoCollision(CollisonModel: TrlModel);
begin
// Nothing
end;
{$HINTS ON}

procedure TrlModel.SetPosition(AValue: TVector3);
begin
  FPosition:=AValue;
end;

procedure TrlModel.SetPositionX(AValue: single);
begin
  if FPositionX=AValue then Exit;
  FPositionX:=AValue;
  FPosition.X:=FPositionX;
end;

procedure TrlModel.SetPositionY(AValue: single);
begin
  if FPositionY=AValue then Exit;
  FPositionY:=AValue;
  FPosition.Y:=FPositionY;
end;

procedure TrlModel.SetPositionZ(AValue: single);
begin
  if FPositionZ=AValue then Exit;
  FPositionZ:=AValue;
  FPosition.Z:=FPositionZ;
end;

procedure TrlModel.SetDrawMode(AValue: TrlEngineDrawMode);
begin
  if FDrawMode=AValue then Exit;
  FDrawMode:=AValue;
end;

function TrlModel.GetPositionX: single;
begin
  result:=FPosition.x;
end;

function TrlModel.GetPositionY: single;
begin
  result:=FPosition.y;
end;

function TrlModel.GetPositionZ: single;
begin
  result:=FPosition.z;
end;

procedure TrlModel.SetAnimationIndex(AValue: longint);
begin
  if FAnimationIndex=AValue then Exit;
  FAnimationIndex:=AValue;
end;

procedure TrlModel.SetAnimationSpeed(AValue: Single);
begin
  if FAnimationSpeed=AValue then Exit;
  FAnimationSpeed:=AValue;
end;

procedure TrlModel.SetCollisionAutoSize(AValue: boolean);
begin
  if FCollisionAutoSize=AValue then Exit;
  FCollisionAutoSize:=AValue;
end;

procedure TrlModel.SetCollisionMode(AValue: TrlModelCollisionMode);
begin
  if FCollisionMode=AValue then Exit;
  FCollisionMode:=AValue;
end;

procedure TrlModel.SetCollisionRadius(AValue: single);
begin
  if FCollisionRadius=AValue then Exit;
  FCollisionRadius:=AValue;
end;

constructor TrlModel.Create(Engine: TrlEngine);
begin
  FEngine := Engine;
  FEngine.FList.Add(Self);
  FDrawMode:=dmNormal;
  FColor:=WHITE;
  FAngle:=0.0;
  FPosition:=Vector3Create(0.0,0.0,0.0);
  FAxis:=Vector3Create(0.0,0.0,0.0);

  FScaleEx:= Vector3Create(1.0,1.0,1.0);
  Scale:=1.0;

  CollisionMode:=cmBBox;
  CollisionRadius:=1;
  Collisioned:=false;
  FCollisionAutoSize:=true;
  DrawMode:=dmEx;
end;

destructor TrlModel.Destroy;
begin
  UnloadTexture(Self.FTexture);
  UnloadModel(Self.FModel);
  inherited Destroy;
end;
{$HINTS OFF}
procedure TrlModel.Move(const MoveCount: Single);
var transform: TMatrix;
begin
   //FModel.transform:=MatrixRotateXYZ(Vector3Create(DEG2RAD*FAxisX,DEG2RAD*FAxisY,DEG2RAD*FAxisZ));
   transform := MatrixIdentity;
   transform := MatrixMultiply(transform,MatrixRotateX(DEG2RAD*FAxisX));
   transform := MatrixMultiply(transform,MatrixRotateY(DEG2RAD*FAxisY));
   transform := MatrixMultiply(transform,MatrixRotateZ(DEG2RAD*FAxisZ));
   FModel.transform:=transform;

   Vector3Set(@FAxis, DEG2RAD*FAxis.X , DEG2RAD * FAxis.Y , DEG2RAD * FAxis.Z);
  // Vector3Set(@FAxis, DEG2RAD*FAxisX , DEG2RAD * FAxisY , DEG2RAD * FAxisZ);
 //  Faxis.x:=DEG2RAD*Faxis.x;

   if (CollisionMode = cmSphere) and FCollisionAutoSize then
     // memorize the position for collisions
     Vector3Set(@FCollisionSphere,PositionX,PositionY,PositionZ);

   if (CollisionMode = cmBBox) and FCollisionAutoSize then
   begin
     // memorize the collision position and adjust to the size
     FCollisionBBox:=GetModelBoundingBox(self.Model);
     FCollisionBBox.min:=Vector3Scale(FCollisionBBox.min,Self.Scale);
     FCollisionBBox.max:=Vector3Scale(FCollisionBBox.max,Self.Scale);
     FCollisionBBox.min:=Vector3Add(FCollisionBBox.min,self.Position);
     FCollisionBBox.max:=Vector3Add(FCollisionBBox.max,self.Position);
   end;
   { #todo 2 -oguvacode -cCollison : Add ray collision for First Person }
   collision;
end;

procedure TrlModel.Update3dModelAnimations(MoveCount: Single);
begin
  if Self.FIsModelAnimation then
 begin
   FAnimFrameCounter:= FAnimFrameCounter + FAnimationSpeed * MoveCount;
   UpdateModelAnimation(Fmodel, FAnims[FAnimationIndex], Round(FAnimFrameCounter));
   if FAnimFrameCounter >= FAnims[FAnimationIndex].frameCount then FAnimFrameCounter := 0;
 end;
end;

{$HINTS ON}
procedure TrlModel.LoadingModel(FileName: String);
begin
  FModel:=LoadModel(PChar(FileName));
end;

procedure TrlModel.LoadingModelTexture(TextureFileName: String;
  MaterialMap: integer);
begin
  FTexture:= LoadTexture(PChar(TextureFileName));
  SetMaterialTexture(@FModel.materials[0], MaterialMap, FTexture);
end;

procedure TrlModel.Load3dModelAnimations(FileName: String);
begin
  FModel:=LoadModel(PChar(FileName));
  FAnimCont:=0;
  FAnims:=LoadModelAnimations(PChar(FileName),@FAnimCont);
  FAnimationIndex:=0;
  FIsModelAnimation:=True;
end;

procedure TrlModel.Dead;
begin
   if FModelDead = False then
  begin
    FModelDead := True;
    FEngine.FDeadList.Add(Self);
  end;
end;

procedure TrlModel.Draw;
begin
    if Assigned(FEngine) then
      case FDrawMode of
        dmNormal: DrawModel(FModel, FPosition, FScale, WHITE); // Draw 3d model with texture
        dmEx: DrawModelEx(FModel, FPosition, FAxis, -9 , FScaleEx, FColor); // Draw a model with extended parameters
        dmWires: DrawModelWires(FModel, FPosition, FScale, FColor);  // Draw a model wires (with texture if set)
        dmWiresEX: DrawModelWiresEx(FModel,FPosition,FAxis, FAngle, FScaleEx,FColor);
    end;
   {  for i:=0 to self.Model.meshCount -1 do
     begin
     bb:=GetMeshBoundingBox(self.Model.meshes[i]);
     bb.min:=Vector3Scale(bb.min,Self.Scale);
     bb.max:=Vector3Scale(bb.max,Self.Scale);
     bb.min:=Vector3Add(bb.min,self.Position);
     bb.max:=Vector3Add(bb.max,self.Position);
     DrawBoundingBox(bb,RED);}
    // end;
     //  DrawCube(anims[0].framePoses[trunc(FAnimFrameCounter)][0].translation, 0.2, 0.2, 0.2, RED);

end;

procedure TrlModel.Collision(const Other: TrlModel);
var
  IsCollide: Boolean;
begin
  IsCollide := False;

   if (Collisioned and Other.Collisioned) and (not FModelDead) and (not Other.FModelDead) then
   begin
   // Sphere <> Shpere
   if (self.CollisionMode = cmSphere) and (Other.CollisionMode = cmSphere) then
   isCollide := CheckCollisionSpheres(Self.FCollisionSphere,Self.FCollisionRadius,Other.FCollisionSphere,Other.FCollisionRadius);
   // Box <> Box
   if (self.CollisionMode = cmBBox) and (Other.CollisionMode = cmBBox) then
   isCollide:= CheckCollisionBoxes(Self.FCollisionBBox,Other.FCollisionBBox);
   // Box <> Sphere
   if (self.CollisionMode = cmBBox) and (Other.CollisionMode = cmSphere) then
   isCollide:= CheckCollisionBoxSphere(Self.FCollisionBBox,Other.FCollisionSphere,Other.FCollisionRadius);
   // Sphere <> Box
   if (self.CollisionMode = cmSphere) and (Other.CollisionMode = cmBBox) then
   isCollide:= CheckCollisionBoxSphere(Other.FCollisionBBox,Self.FCollisionSphere,Self.FCollisionRadius);
   end;
   { #todo 2 -oguvacode -cCollison : Add ray collision for First Person }
   if IsCollide then
     begin
       DoCollision(Other);
       Other.DoCollision(Self);
     end;
end;

procedure TrlModel.Collision;
var I: Integer;
begin
if (FEngine <> nil) and (not FModelDead) and (FCollisioned) then
 begin
   for i := 0 to FEngine.FList.Count - 1 do Self.Collision(TrlModel(FEngine.FList.Items[i]));
 end;
end;

procedure TrlModel.SetLight(Engine: TrlEngine);
var i:integer;
begin
 for i:=0 to self.Model.materialCount-1 do
  Model.materials[i].shader:=Engine.Shader;
end;

end.

