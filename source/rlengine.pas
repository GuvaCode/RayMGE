(*
██████╗ ██╗      ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
██╔══██╗██║      ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
██████╔╝██║█████╗█████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗
██╔══██╗██║╚════╝██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝
██║  ██║███████╗ ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
╚═╝  ╚═╝╚══════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
*)
unit rlengine;

{$mode objfpc}{$H+}

interface

uses
  raylib, raymath, rlgl, rlFPCamera, rlTPCamera, rlFreeCamera, classes, sysutils;

type
  TrlEngineDrawMode = (dmNormal, dmEx, dmWires, dmWiresEx); // draw model mode
  TrlEngineCameraMode = (cmFree, cmThird, cmFirst);
  TJumpState = (jsNone, jsJumping, jsFalling); // state for jump
  TrlModelCollisionMode = (cmBBox,cmSphere);

  { TrlEngine }
  TrlEngine = class
    private
      FDrawDebugGrid: boolean;
      FDrawDistance: single;
      FGridSlice: longint;
      FGridSpace: single;
      FEngineCameraMode: TrlEngineCameraMode;//TCameraMode;
      procedure SetDrawDebugGrid(AValue: boolean);
      procedure SetDrawDistance(AValue: single);
      procedure SetEngineCameraMode(AValue: TrlEngineCameraMode);
    protected
      FList: TList; // list of model
      FDeadList: TList; // model dead list
    public
      EngineTpCamera:TrlTPCamera;
      EngineFpCamera:TrlFPCamera;
      EngineFreeCamera:TrlFreeCamera;
      constructor Create;
      destructor Destroy; override;
      procedure Update;  // update engine
      procedure Render; virtual; // render engine
      procedure ClearDeadModel;  // clear of death model
      procedure SetDebugGrid(slices:longint; spacing:single); // set grid size and slice
    published
      property EngineCameraMode: TrlEngineCameraMode read FEngineCameraMode write SetEngineCameraMode;
      property DrawDebugGrid: boolean read FDrawDebugGrid write SetDrawDebugGrid;
      property DrawDistance: single read FDrawDistance write SetDrawDistance;
  end;

  { TrlModel }
  TrlModel = class
    private
      FAxis: TVector3;
      FCollisionAutoSize: boolean;
      FCollisionBBox: TBoundingBox;
      FCollisioned: Boolean;
      FCollisionMode: TrlModelCollisionMode;
      FCollisionRadius: single;
      FCollisionSphere: TVector3;
      FDrawMode: TrlEngineDrawMode;
      FName: string;
      FPosition: TVector3;

      FRotationAngle: single;
      FScale: Single;
      function GetPositionX: Single;
      function GetPositionY: Single;
      function GetPositionZ: Single;
      procedure SetAxis(AValue: TVector3);
      procedure SetCollisionAutoSize(AValue: boolean);
      procedure SetCollisionBBox(AValue: TBoundingBox);
      procedure SetCollisionMode(AValue: TrlModelCollisionMode);
      procedure SetCollisionRadius(AValue: single);
      procedure SetCollisionSphere(AValue: TVector3);
      procedure SetDrawMode(AValue: TrlEngineDrawMode);
      procedure SetName(AValue: string);
      procedure SetPosition(AValue: TVector3);
      procedure SetPositionX(AValue: Single);
      procedure SetPositionY(AValue: Single);
      procedure SetPositionZ(AValue: Single);
      procedure SetRotationAngle(AValue: single);
      procedure SetScale(AValue: Single);
      procedure Collision(const OtherModel: TrlModel); overload; virtual;
    protected
      FModelDead: Boolean;
      FEngine: TrlEngine;
      FModel: TModel;
      FTexture: TTexture;
      procedure DoCollision(CollisonModel: TrlModel); virtual;
    public
      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;
      procedure Update; overload; virtual;
      procedure Render; virtual;
      procedure Dead;
      procedure LoadModel(FileName: String); virtual;
      procedure LoadModelTexture(TextureFileName:String; MaterialMap: TMaterialMapIndex);

      procedure Collision; overload; virtual;
      property CollisionAutoSize: boolean read FCollisionAutoSize write SetCollisionAutoSize;
      property CollisionSphere: TVector3 read FCollisionSphere write SetCollisionSphere;
      property CollisionBBox: TBoundingBox read FCollisionBBox write SetCollisionBBox;
      property Collisioned: Boolean read FCollisioned write FCollisioned;
      property CollisionMode: TrlModelCollisionMode read FCollisionMode write SetCollisionMode;
      property CollisionRadius: single read FCollisionRadius write SetCollisionRadius;

      property DrawMode: TrlEngineDrawMode read FDrawMode write SetDrawMode;
      property Model: TModel read FModel write FModel;
      property Axis: TVector3 read FAxis write SetAxis;
      property Position: TVector3 read FPosition write SetPosition;
      property PositionX: Single read GetPositionX write SetPositionX;
      property PositionY: Single read GetPositionY write SetPositionY;
      property PositionZ: Single read GetPositionZ write SetPositionZ;
      property Scale: Single read FScale write SetScale;
      property RotationAngle: single read FRotationAngle write SetRotationAngle;
      property Name:string read FName write SetName;
    end;

  { TrlAnimatedModel }
  TrlAnimatedModel = class(TrlModel)
  private
    FAnimationIndex: longint;
    FAnimationLoop: boolean;
    FAnimationSpeed: Single;
    FAnims: PModelAnimation;
    FAnimFrameCounter: Single;
    FAnimCont: integer;
    procedure SetAnimationIndex(AValue: longint);
    procedure SetAnimationLoop(AValue: boolean);
    procedure SetAnimationSpeed(AValue: Single);
  protected
    procedure UpdateModelAnimation;
  public
    constructor Create(Engine: TrlEngine); override;
    procedure Update; override;
    procedure LoadModel(FileName: String); override;
    property Anims: PModelAnimation read FAnims write FAnims;
    property AnimationIndex: longint read FAnimationIndex write SetAnimationIndex;
    property AnimationSpeed: Single read FAnimationSpeed write SetAnimationSpeed;
    property AnimationLoop: boolean read FAnimationLoop write SetAnimationLoop;
  end;

  { TrlPlayerModel }
  TrlPlayerModel = class(TrlAnimatedModel)
  private
    FAcc: Single;
    FDcc: Single;
    FDirection: Single;
    FMaxSpeed: Single;
    FMinSpeed: Single;
    FRotation: Single;
    FSpeed: Single;
    FVelocity: TVector3;
    procedure SetDirection(AValue: Single);
    procedure SetRotation(AValue: Single);
    procedure SetSpeed(AValue: Single);
  public
    constructor Create(Engine: TrlEngine); override;
    procedure Update; override;
    procedure Accelerate; virtual;
    procedure Deccelerate; virtual;
    property Speed: Single read FSpeed write SetSpeed;
    property MinSpeed: Single read FMinSpeed write FMinSpeed;
    property MaxSpeed: Single read FMaxSpeed write FMaxSpeed;
    property Velocity: TVector3 read FVelocity write FVelocity;
    property Acceleration: Single read FAcc write FAcc;
    property Decceleration: Single read FDcc write FDcc;
    property Direction: Single read FDirection write SetDirection;
    property Rotation: Single read FRotation write SetRotation;
  end;

  { TJumperSprite }
  TrlJumperModel = class(TrlPlayerModel)
     private
         FJumpCount: Integer;
         FJumpSpeed: Single;
         FJumpHeight: Single;
         FMaxFallSpeed: Single;
         FDoJump: Boolean;
         FJumpState: TJumpState;
         procedure SetJumpState(Value: TJumpState);
    public
         constructor Create(Engine: TrlEngine); override;
         procedure Update; override;
         procedure Accelerate; override;
         procedure Deccelerate; override;
         property JumpCount: Integer read FJumpCount write FJumpCount;
         property JumpState: TJumpState read FJumpState write SetJumpState;
         property JumpSpeed: Single read FJumpSpeed write FJumpSpeed;
         property JumpHeight: Single read FJumpHeight write FJumpHeight;
         property MaxFallSpeed: Single read FMaxFallSpeed write FMaxFallSpeed;
         property DoJump: Boolean read  FDoJump write FDoJump;
    end;

  function  m_Cos( Angle : Integer ) : Single;
  function  m_Sin( Angle : Integer ) : Single;
  procedure InitCosSinTables;

var    cosTable : array[ 0..360 ] of Single;
       sinTable : array[ 0..360 ] of Single;

implementation

function m_Cos(Angle: Integer): Single;
begin
   if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := cosTable[ Angle ];
end;

function m_Sin(Angle: Integer): Single;
begin
  if Angle > 360 Then
    DEC( Angle, ( Angle div 360 ) * 360 )
  else
    if Angle < 0 Then
      INC( Angle, ( abs( Angle ) div 360 + 1 ) * 360 );
  Result := sinTable[ Angle ];
end;

procedure InitCosSinTables;
var
  i         : Integer;
  rad_angle : Single;
begin
for i := 0 to 360 do
  begin
    rad_angle := i * ( pi / 180 );
    cosTable[ i ] := cos( rad_angle );
    sinTable[ i ] := sin( rad_angle );
  end;
end;

{ TrlJumperModel }
procedure TrlJumperModel.SetJumpState(Value: TJumpState);
begin
   if FJumpState <> Value then
     begin
          FJumpState := Value;
          case Value of
               jsNone,
               jsFalling:
               begin
                    FVelocity.Y := 0;
               end;
          end;
     end;
end;

constructor TrlJumperModel.Create(Engine: TrlEngine);
begin
  inherited;
     FVelocity.X := 0;
     FVelocity.Y := 0;
     MaxSpeed := FMaxSpeed;
     FDirection := 0;
     FJumpState := jsNone;
     FJumpSpeed := 0.25;
     FJumpHeight := 5;
     Acceleration := 0.2;
     Decceleration := 0.2;
     FMaxFallSpeed := 10;
     DoJump:= False;
end;

procedure TrlJumperModel.Update;
begin
  inherited Update;
   case FJumpState of
          jsNone:
          begin
               if DoJump then
               begin
                    FJumpState := jsJumping;
                    FVelocity.Y :=  FJumpHeight;
               end;
          end;
          jsJumping:
          begin
               FPosition.Y:=Position.Y + FVelocity.Y * GetFrameTime;
               FVelocity.Y:=FVelocity.Y + FJumpSpeed;
               if FVelocity.Y > 0 then
                 FJumpState := jsFalling;

          end;
          jsFalling:
          begin
               FPosition.Y:=FPosition.Y + FVelocity.Y * GetFrameTime;;
               FVelocity.Y:=Velocity.Y-FJumpSpeed;
               if FVelocity.Y > FMaxFallSpeed then
                  FVelocity.Y := FMaxFallSpeed;
          end;
     end;
     DoJump := False;
end;

procedure TrlJumperModel.Accelerate;
begin
 if FSpeed <> FMaxSpeed then
 begin
   FSpeed:= FSpeed+FAcc;
   if FSpeed > FMaxSpeed then FSpeed := FMaxSpeed;
    FVelocity.X := m_Sin(Trunc(FDirection)) * Speed;
    FVelocity.Z := m_Sin(Trunc(FDirection)) * Speed;
 end;
end;

procedure TrlJumperModel.Deccelerate;
begin
  if FSpeed <> FMaxSpeed then
    begin
      FSpeed:= FSpeed+FAcc;
      if FSpeed < FMaxSpeed then FSpeed := FMaxSpeed;
        FVelocity.X := m_Sin(Trunc(FDirection)) * Speed;
        FVelocity.Z := m_Sin(Trunc(FDirection)) * Speed;
     end;
end;

{ TrlPlayerModel }
procedure TrlPlayerModel.SetSpeed(AValue: Single);
begin
  if FSpeed > FMaxSpeed then FSpeed := FMaxSpeed
  else
  if FSpeed < FMinSpeed then  FSpeed := FMinSpeed;
  FSpeed := AValue;
  FVelocity.x := m_Cos(Trunc(FDirection)) * Speed;
  FVelocity.z := m_Sin(Trunc(FDirection)) * Speed;
  FVelocity.y := sin(DEG2RAD * -FRotation) * Speed ;
end;

procedure TrlPlayerModel.SetDirection(AValue: Single);
begin
  FDirection := AValue;
  FVelocity.x := m_Cos(Trunc(FDirection)) * Speed;
  FVelocity.z := m_Sin(Trunc(FDirection)) * Speed;
  FVelocity.y := sin(DEG2RAD * -FRotation) * Speed ;
end;

procedure TrlPlayerModel.SetRotation(AValue: Single);
begin
  if FRotation=AValue then Exit;
  FRotation:=AValue;
end;

constructor TrlPlayerModel.Create(Engine: TrlEngine);
begin
  inherited Create(Engine);
  FVelocity:=Vector3Create(0,0,0);
  Direction:=0;
  Acceleration:=0;
  Decceleration:=0;
  Speed:=0;
  MinSpeed:=0;
  MaxSpeed:=0;
end;

procedure TrlPlayerModel.Update;
begin
  inherited Update;
  FPosition.x := FPosition.x + FVelocity.x * GetFrameTime;
  FPosition.z := FPosition.z + FVelocity.z * GetFrameTime;
  FPosition.y := FPosition.y + FVelocity.y * GetFrameTime;
end;

procedure TrlPlayerModel.Accelerate;
begin
   if FSpeed <> FMaxSpeed then
  begin
    FSpeed := FSpeed + FAcc;
    if FSpeed > FMaxSpeed then
    FSpeed := FMaxSpeed;
    FVelocity.x := m_Cos(Trunc(FDirection)) * Speed;
    FVelocity.z := m_Sin(Trunc(FDirection)) * Speed;
    FVelocity.y := sin(DEG2RAD * -FRotation) * Speed ;
  end;
end;

procedure TrlPlayerModel.Deccelerate;
begin
   if FSpeed <> FMinSpeed then
  begin
    FSpeed := FSpeed - FDcc;
    if FSpeed < FMinSpeed then
    FSpeed := FMinSpeed;
    FVelocity.x := m_Cos(Trunc(FDirection)) * Speed;
    FVelocity.z := m_Sin(Trunc(FDirection)) * Speed;
    FVelocity.y := sin(DEG2RAD * -FRotation) * Speed ;
  end;
end;

{ TrlAnimatedModel }
procedure TrlAnimatedModel.SetAnimationIndex(AValue: longint);
begin
  if FAnimationLoop = false then FAnimFrameCounter:=0;
  if FAnimationIndex=AValue then Exit;
  FAnimFrameCounter:=0;
  FAnimationIndex:=AValue;
end;

procedure TrlAnimatedModel.SetAnimationLoop(AValue: boolean);
begin
  if FAnimationLoop=AValue then Exit;
  FAnimationLoop:=AValue;
end;

procedure TrlAnimatedModel.SetAnimationSpeed(AValue: Single);
begin
  if FAnimationSpeed=AValue then Exit;
  FAnimationSpeed:=AValue;
end;

constructor TrlAnimatedModel.Create(Engine: TrlEngine);
begin
  inherited Create(Engine);
  AnimationLoop:=True;
end;

procedure TrlAnimatedModel.Update;
begin
  if Model.boneCount>0 then UpdateModelAnimation;
  inherited Update;
end;

procedure TrlAnimatedModel.UpdateModelAnimation;
begin
  FAnimFrameCounter:= FAnimFrameCounter + FAnimationSpeed * GetFrameTime;
  Raylib.UpdateModelAnimation(Fmodel, FAnims[FAnimationIndex], Round(FAnimFrameCounter));

  if (FAnimFrameCounter >= FAnims[FAnimationIndex].frameCount) and (FAnimationLoop) then
      FAnimFrameCounter:=0
  else
  if FAnimFrameCounter >= FAnims[FAnimationIndex].frameCount then
     FAnimFrameCounter:=FAnims[FAnimationIndex].frameCount;
end;

procedure TrlAnimatedModel.LoadModel(FileName: String);
begin
  inherited LoadModel(FileName);
  FAnimCont:=0;
  FAnims:=LoadModelAnimations(PChar(FileName),@FAnimCont);
  FAnimationIndex:=0;
end;

procedure TrlModel.SetPosition(AValue: TVector3);
begin
  FPosition:=AValue;
end;

procedure TrlModel.SetPositionX(AValue: Single);
begin
  if FPosition.x=AValue then Exit;
  FPosition.x:=AValue;
end;

procedure TrlModel.SetPositionY(AValue: Single);
begin
  if FPosition.y=AValue then Exit;
  FPosition.y:=AValue;
end;

procedure TrlModel.SetPositionZ(AValue: Single);
begin
  if FPosition.z=AValue then Exit;
  FPosition.z:=AValue;
end;

procedure TrlModel.SetRotationAngle(AValue: single);
begin
  if FRotationAngle=AValue then Exit;
  FRotationAngle:=AValue;
end;

procedure TrlModel.SetAxis(AValue: TVector3);
begin
  FAxis:=AValue;
end;

function TrlModel.GetPositionX: Single;
begin
 result:=Fposition.x;
end;

function TrlModel.GetPositionY: Single;
begin
 result:=Fposition.y;
end;

function TrlModel.GetPositionZ: Single;
begin
 result:=Fposition.z;
end;

procedure TrlModel.SetCollisionAutoSize(AValue: boolean);
begin
  if FCollisionAutoSize=AValue then Exit;
  FCollisionAutoSize:=AValue;
end;

procedure TrlModel.SetCollisionBBox(AValue: TBoundingBox);
begin
  FCollisionBBox:=AValue;
end;

procedure TrlModel.SetCollisionMode(AValue: TrlModelCollisionMode);
begin
  FCollisionMode:=AValue;
end;

procedure TrlModel.SetCollisionRadius(AValue: single);
begin
  if FCollisionRadius=AValue then Exit;
  FCollisionRadius:=AValue;
end;

procedure TrlModel.SetCollisionSphere(AValue: TVector3);
begin
  FCollisionSphere:=AValue;
end;

procedure TrlModel.SetDrawMode(AValue: TrlEngineDrawMode);
begin
  if FDrawMode=AValue then Exit;
  FDrawMode:=AValue;
end;

procedure TrlModel.SetName(AValue: string);
begin
  if FName=AValue then Exit;
  FName:=AValue;
end;

procedure TrlModel.SetScale(AValue: Single);
begin
  if FScale=AValue then Exit;
  FScale:=AValue;
end;
{$HINTS OFF}
procedure TrlModel.DoCollision(CollisonModel: TrlModel);
begin
  // Nothing
end;
{$HINTS ON}
{ TrlModel }
constructor TrlModel.Create(Engine: TrlEngine);
begin
  FEngine := Engine;
  FEngine.FList.Add(Self);
  DrawMode:=dmEx;
  FModelDead:=False;
  Position:=Vector3Create(0.0,0.0,0.0);
  Axis:=Vector3Create(0.0,0.0,0.0);
  Scale:=1.0;
  CollisionMode:=cmBBox;
  CollisionRadius:=1;
  Collisioned:=false;
end;

destructor TrlModel.Destroy;
begin
  UnloadTexture(Self.FTexture);
  UnloadModel(Self.FModel);
  inherited Destroy;
end;

procedure TrlModel.Update;
var transform: TMatrix;
begin
   transform := MatrixIdentity;
   transform := MatrixMultiply(transform,MatrixRotateX(DEG2RAD*FAxis.x));
   transform := MatrixMultiply(transform,MatrixRotateY(DEG2RAD*FAxis.y));
   transform := MatrixMultiply(transform,MatrixRotateZ(DEG2RAD*FAxis.z));
   FModel.transform:=transform;

   if (CollisionMode = cmSphere) then
     Vector3Set(@FCollisionSphere,FPosition.x,FPosition.y,FPosition.z);

   if (CollisionMode = cmBBox) and (FCollisionAutoSize) then
   begin
     FCollisionBBox:=GetModelBoundingBox(self.Model);
     FCollisionBBox.min:=Vector3Scale(FCollisionBBox.min,FScale);
     FCollisionBBox.max:=Vector3Scale(FCollisionBBox.max,FScale);
     FCollisionBBox.min:=Vector3Add(FCollisionBBox.min,FPosition);
     FCollisionBBox.max:=Vector3Add(FCollisionBBox.max,FPosition);
   end;
   { #todo 2 -oguvacode -cCollison : Add ray collision for First Person }
end;

procedure TrlModel.Render;
var FScaleEx: TVector3;
    FColor: TColor;
begin
  FScaleEx:=Vector3Create(Fscale,Fscale,FScale);
  FColor:=WHITE;
  if Assigned(FEngine) then
    case FDrawMode of
      dmNormal: DrawModel(FModel, FPosition, FScale, WHITE); // Draw 3d model with texture
      dmEx: DrawModelEx(FModel, FPosition, FAxis, FRotationAngle, FScaleEx, FColor); // Draw a model with extended parameters
      dmWires: DrawModelWires(FModel, FPosition, FScale, FColor);  // Draw a model wires (with texture if set)
      dmWiresEX: DrawModelWiresEx(FModel,FPosition,FAxis, FRotationAngle, FScaleEx,FColor); // Draw a model wires with extended parameters
  end;
  DrawBoundingBox(FCollisionBBox,RED)
end;

procedure TrlModel.Dead;
begin
  if FModelDead = False then
 begin
   FModelDead := True;
   FEngine.FDeadList.Add(Self);
 end;
end;

procedure TrlModel.LoadModel(FileName: String);
begin  //todo model exists
  FModel:=raylib.LoadModel(PChar(FileName));
end;

procedure TrlModel.LoadModelTexture(TextureFileName: String;
  MaterialMap: TMaterialMapIndex);
begin   // todo file exits
  FTexture:= LoadTexture(PChar(TextureFileName));
  SetMaterialTexture(@FModel.materials[0], MaterialMap, FTexture);// loadig material map texture
end;  // MATERIAL_MAP_DIFFUSE or etc.

procedure TrlModel.Collision(const OtherModel: TrlModel);
var
  IsCollide: Boolean=false;
begin
   if (Collisioned and OtherModel.Collisioned) and (not FModelDead) and (not OtherModel.FModelDead) then
   begin
  { // Sphere <> Shpere
   if (self.CollisionMode = cmSphere) and (OtherModel.CollisionMode = cmSphere) then
   isCollide := CheckCollisionSpheres(Self.FCollisionSphere,Self.FCollisionRadius,OtherModel.FCollisionSphere,
   OtherModel.FCollisionRadius);}
   // Box <> Box
   if (self.CollisionMode = cmBBox) and (OtherModel.CollisionMode = cmBBox) then
   isCollide:= CheckCollisionBoxes(Self.FCollisionBBox,OtherModel.FCollisionBBox);
 {  // Box <> Sphere
   if (self.CollisionMode = cmBBox) and (OtherModel.CollisionMode = cmSphere) then
   isCollide:= CheckCollisionBoxSphere(Self.FCollisionBBox,OtherModel.FCollisionSphere,OtherModel.FCollisionRadius);
   // Sphere <> Box
   if (self.CollisionMode = cmSphere) and (OtherModel.CollisionMode = cmBBox) then
   isCollide:= CheckCollisionBoxSphere(OtherModel.FCollisionBBox,Self.FCollisionSphere,Self.FCollisionRadius); }
   end;
   { #todo 2 -oguvacode -cCollison : Add ray collision for First Person }
   if IsCollide then
     begin
       DoCollision(OtherModel);
       OtherModel.DoCollision(Self);
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

{ TrlEngine }
procedure TrlEngine.SetEngineCameraMode(AValue: TrlEngineCameraMode);
begin
  FEngineCameraMode:=AValue;   // set camera mode CAMERA_TP or CAMERA_FREE and etc..
end;

procedure TrlEngine.SetDrawDebugGrid(AValue: boolean);
begin
  if FDrawDebugGrid=AValue then Exit;
  FDrawDebugGrid:=AValue;
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

 rlFreeCam_Init(@EngineFreeCamera,Vector3Create ( 0, 1, 0 ),Vector3Create ( 0, 1, 0 ));

 rlTPCameraInit(@EngineTpCamera, 45, Vector3Create ( 1, 0, 0 ));
 EngineTpCamera.MoveSpeed.z := 10;
 EngineTpCamera.MoveSpeed.x := 5;
 EngineTpCamera.CameraPullbackDistance:=20;
 EngineTpCamera.FarPlane := 5000;

 rlFPCameraInit(@EngineFpCamera, 45, Vector3Create ( 1, 0, 0 ));
 EngineFpCamera.MoveSpeed.z := 10;
 EngineFpCamera.MoveSpeed.x := 5;
 EngineFpCamera.FarPlane := 5000;

 self.EngineCameraMode:=cmThird;
 DrawDistance:=0.0;
 SetEngineCameraMode(cmThird); // set camera mode
 SetDebugGrid(10,1); // set size debug grid
end;

destructor TrlEngine.Destroy;
  var i: integer;
begin
  for i := 0 to FList.Count- 1 do TrlModel(FList.Items[i]).Destroy;
  FList.Destroy;
  FDeadList.Destroy;
  inherited Destroy;
end;

procedure TrlEngine.Update;
var i: integer;
begin
 case FEngineCameraMode of
   cmFree: rlFreeCameraUpdate(@EngineFreeCamera);
   cmThird: rlTPCameraUpdate(@EngineTPCamera);
   cmFirst: rlFPCameraUpdate(@EngineFPCamera);
 end;

 for i := 0 to FList.Count - 1 do  // update all model and animation
    begin
      TrlModel(FList.Items[i]).Update;
    end;
end;

procedure TrlEngine.Render;
var i: longint; CamPos:TVector3;
begin
 case FEngineCameraMode of
   cmFree:
     begin
       rlFreeCameraBeginMode3D(@EngineFreeCamera);
       CamPos:=EngineFreeCamera.Position;
     end;
   cmThird:
     begin
       rlTPCameraBeginMode3D(@EngineTPCamera);
       CamPos:=EngineTPCamera.CameraPosition;
     end;
   cmFirst:
     begin
       rlFPCameraBeginMode3D(@EngineFPCamera);
       CamPos:=EngineFPCamera.CameraPosition;
     end;
 end;

 for i:=0 to FList.Count-1 do
   begin
    if FDrawDistance >0 then
     begin
       if Vector3Distance(CamPos, TrlModel(FList.Items[i]).Position) <= FDrawDistance
       then TrlModel(FList.Items[i]).Render;
     end else TrlModel(FList.Items[i]).Render;
   end;

 if DrawDebugGrid then DrawGrid(FGridSlice, FGridSpace);

 case FEngineCameraMode of
   cmFree: rlFreeCameraEndMode3D;
   cmThird: rlTPCameraEndMode3D;
   cmFirst: rlFPCameraEndMode3D
 end;
end;

procedure TrlEngine.ClearDeadModel;
var i: Integer;
  begin
    for i := 0 to FDeadList.Count - 1 do
    begin
      if FDeadList.Count >= 1 then
      begin
        if TrlModel(FDeadList.Items[i]).FModelDead = True then
        TrlModel(FDeadList.Items[i]).FEngine.FList.Remove(FDeadList.Items[i]);
      end;
    end;
    FDeadList.Clear;
end;

procedure TrlEngine.SetDebugGrid(slices: longint; spacing: single);
begin
  FGridSlice:= Slices;
  FGridSpace:= Spacing;
end;

initialization
InitCosSinTables();

end.

