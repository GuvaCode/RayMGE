(*
██████╗ ██╗      ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗     ██╗    ██████╗
██╔══██╗██║      ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝    ███║   ██╔═████╗
██████╔╝██║█████╗█████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗      ╚██║   ██║██╔██║
██╔══██╗██║╚════╝██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝       ██║   ████╔╝██║
██║  ██║███████╗ ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗     ██║██╗╚██████╔╝
╚═╝  ╚═╝╚══════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝     ╚═╝╚═╝ ╚═════╝
*)
unit rlengine;

{$mode objfpc}{$H+}

interface

uses
  raylib, raymath, rlgl, classes,sysutils;

type
  TrlEngineDrawMode = (dmNormal, dmEx, dmWires, dmWiresEx); // draw model mode
  TJumpState = (jsNone, jsJumping, jsFalling); // state for jump

  { TrlEngine }
  TrlEngine = class
    private
      FDrawDebugGrid: boolean;
      FDrawDistance: single;
      FGridSlice: longint;
      FGridSpace: single;
      FEngineCameraMode: TCameraMode;
      procedure SetDrawDebugGrid(AValue: boolean);
      procedure SetDrawDistance(AValue: single);
      procedure SetEngineCameraMode(AValue: TCameraMode);
    protected
      FList: TList; // list of model
      FDeadList: TList; // model dead list
    public
      EngineCamera: TCamera3D;
      constructor Create;
      destructor Destroy; override;
      procedure Update;  // update engine
      procedure Render; virtual; // render engine
      procedure ClearDeadModel;  // clear of death model
      procedure SetDebugGrid(slices:longint; spacing:single); // set grid size and slice
    published
      property EngineCameraMode: TCameraMode read FEngineCameraMode write SetEngineCameraMode;
      property DrawDebugGrid: boolean read FDrawDebugGrid write SetDrawDebugGrid;
      property DrawDistance: single read FDrawDistance write SetDrawDistance;
  end;

  { TrlModel }
  TrlModel = class
    private
      FAxis: TVector3;
      FDrawMode: TrlEngineDrawMode;
      FPosition: TVector3;
      FRotationAngle: single;
      FScale: Single;
      procedure SetAxis(AValue: TVector3);
      procedure SetDrawMode(AValue: TrlEngineDrawMode);
      procedure SetPosition(AValue: TVector3);
      procedure SetRotationAngle(AValue: single);
      procedure SetScale(AValue: Single);
    protected
      FModelDead: Boolean;
      FEngine: TrlEngine;
      FModel: TModel;
      FTexture: TTexture;
    public
      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;
      procedure Update; overload; virtual;
      procedure Render; virtual;
      procedure Dead;

      procedure LoadModel(FileName: String); virtual;
      procedure LoadModelTexture(TextureFileName:String; MaterialMap: TMaterialMapIndex);

      property DrawMode: TrlEngineDrawMode read FDrawMode write SetDrawMode;
      property Model: TModel read FModel write FModel;
      property Axis: TVector3 read FAxis write SetAxis;
      property Position: TVector3 read FPosition write SetPosition;
      property Scale: Single read FScale write SetScale;
      property RotationAngle: single read FRotationAngle write SetRotationAngle;
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
    FDirection: TVector3;
    FMaxSpeed: Single;
    FMinSpeed: Single;
    FSpeed: Single;
    FVelocity: TVector3;
    procedure SetDirection(AValue: TVector3);
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
    property Direction: TVector3 read FDirection write SetDirection;
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
    property DoJump: Boolean read FDoJump write FDoJump;
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

{ TJumperModel }
procedure TrlJumperModel.SetJumpState(Value: TJumpState);
begin
  if FJumpState <> Value then
  begin
       FJumpState := Value;
       case Value of
            jsNone, jsFalling:
            begin
                 FVelocity.y := 0;
            end;
       end;
  end;
end;

constructor TrlJumperModel.Create(Engine: TrlEngine);
begin
  inherited Create(Engine);
  FVelocity:=Vector3Create(0,0,0);
  FDirection := Vector3Create(0,0,0);
  MaxSpeed := FMaxSpeed;
  FJumpState := jsNone;
  FJumpSpeed := 0.25;
  FJumpHeight := 8;
  Acceleration := 0.2;
  Decceleration := 0.2;
  FMaxFallSpeed := 5;
  DoJump := False;
end;

procedure TrlJumperModel.Update;
begin
  inherited;
  case FJumpState of
    jsNone:
      begin
        if DoJump then
        begin
          FJumpState := jsJumping;
          FVelocity.Y := FJumpHeight;
        end;
      end;
    jsJumping:
      begin

        Fposition.y := Fposition.y + FVelocity.y * GetFrameTime;
        FVelocity.y := FVelocity.y + FJumpSpeed;
        if FVelocity.Y > 0 then
          FJumpState := jsFalling;
      end;
    jsFalling:
      begin
        Fposition.Y := Fposition.Y + FVelocity.Y * GetFrameTime;
        FVelocity.Y := FVelocity.Y - FJumpSpeed;
        if FVelocity.Y > FMaxFallSpeed then
          FVelocity.Y := FMaxFallSpeed;

        if FPosition.Y < 0 then
        begin
          FJumpState := jsNone;
          FVelocity.Y:=0;
        end;

      end;
  end;
  DoJump := False;
end;

procedure TrlJumperModel.Accelerate;
begin
    if FSpeed <> FMaxSpeed then
  begin
    FSpeed := FSpeed + FAcc;
    if FSpeed > FMaxSpeed then
       FSpeed := FMaxSpeed;
  end;
    FVelocity.X := m_Sin(Trunc(FDirection.X)) * Speed;
    FVelocity.Z := m_Sin(Trunc(FDirection.Z)) * Speed;
end;

procedure TrlJumperModel.Deccelerate;
begin
if FSpeed <> FMinSpeed then
  begin
    FSpeed := FSpeed - FDcc;
    if FSpeed < FMinSpeed then
      FSpeed := FMinSpeed;
  end;
  FVelocity.X := m_Sin(Trunc(FDirection.X)) * Speed;
  FVelocity.Z := m_Sin(Trunc(FDirection.Z)) * Speed;
end;

{ TrlPlayerModel }

procedure TrlPlayerModel.SetSpeed(AValue: Single);
begin
  if FSpeed > FMaxSpeed then FSpeed := FMaxSpeed
  else
  if FSpeed < FMinSpeed then  FSpeed := FMinSpeed;
  FSpeed := AValue;
  FVelocity.x := m_Cos(Trunc(FDirection.x)) * Speed;
  FVelocity.z := m_Sin(Trunc(FDirection.z)) * Speed;
  FVelocity.y := m_Sin(Trunc(FDirection.y)) * Speed;
end;

procedure TrlPlayerModel.SetDirection(AValue: TVector3);
begin
  FDirection := AValue;
  FVelocity.x := m_Cos(Trunc(FDirection.x)) * Speed;
  FVelocity.z := m_Sin(Trunc(FDirection.z)) * Speed;
  FVelocity.y := m_Sin(Trunc(FDirection.y)) * Speed;
end;


constructor TrlPlayerModel.Create(Engine: TrlEngine);
begin
  inherited Create(Engine);
  FVelocity:=Vector3Create(0,0,0);
  Direction:=Vector3Create(0,0,0);
  Acceleration:=0;
  Decceleration:=0;
  Speed:=0;
  MinSpeed:=0;
  MaxSpeed:=0;
end;

procedure TrlPlayerModel.Update;
begin
  FPosition.x := FPosition.x + FVelocity.x * GetFrameTime;
  FPosition.z := FPosition.z + FVelocity.z * GetFrameTime;
  FPosition.y := FPosition.y + FVelocity.y * GetFrameTime;
  inherited Update;
end;

procedure TrlPlayerModel.Accelerate;
begin
   if FSpeed <> FMaxSpeed then
  begin
    FSpeed := FSpeed + FAcc;
    if FSpeed > FMaxSpeed then
    FSpeed := FMaxSpeed;
    FVelocity.x := m_Cos(Trunc(FDirection.x)) * Speed;
    FVelocity.z := m_Sin(Trunc(FDirection.z)) * Speed;
    FVelocity.y := m_Sin(Trunc(FDirection.y)) * Speed;
  end;
end;

procedure TrlPlayerModel.Deccelerate;
begin
   if FSpeed <> FMinSpeed then
  begin
    FSpeed := FSpeed - FDcc;
    if FSpeed < FMinSpeed then
    FSpeed := FMinSpeed;
    FVelocity.x := m_Cos(Trunc(FDirection.x)) * Speed;
    FVelocity.z := m_Sin(Trunc(FDirection.z)) * Speed;
    FVelocity.y := m_Sin(Trunc(FDirection.y)) * Speed;
  end;
end;

{ TrlAnimatedModel }
procedure TrlAnimatedModel.SetAnimationIndex(AValue: longint);
begin
  FAnimFrameCounter:=0;
  if FAnimationIndex=AValue then Exit;
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

procedure TrlModel.SetRotationAngle(AValue: single);
begin
  if FRotationAngle=AValue then Exit;
  FRotationAngle:=AValue;
end;

procedure TrlModel.SetAxis(AValue: TVector3);
begin
  FAxis:=AValue;
end;

procedure TrlModel.SetDrawMode(AValue: TrlEngineDrawMode);
begin
  if FDrawMode=AValue then Exit;
  FDrawMode:=AValue;
end;

procedure TrlModel.SetScale(AValue: Single);
begin
  if FScale=AValue then Exit;
  FScale:=AValue;
end;

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

{ TrlEngine }
procedure TrlEngine.SetEngineCameraMode(AValue: TCameraMode);
begin
  FEngineCameraMode:=AValue;   // set camera mode CAMERA_CUSTOM or CAMERA_FREE and etc..
  SetCameraMode(EngineCamera, FEngineCameraMode);
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

  EngineCamera.position:=Vector3Create(10,10,10);    // Camera position
  EngineCamera.target:=Vector3Create(0.0,0.0,0.0);   // Camera looking at point
  EngineCamera.up:=Vector3Create(0.0,1.0,0.0);       // Camera up vector (rotation towards target)
  EngineCamera.fovy:=45.0;                           // Camera field-of-view Y
  EngineCamera.projection:=CAMERA_PERSPECTIVE;       // Camera mode type

  DrawDistance:=0.0;
  SetEngineCameraMode(CAMERA_ORBITAL); // set camera mode CAMERA_CUSTOM or CAMERA_FREE and etc..
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
  UpdateCamera(@EngineCamera); // camera update
  for i := 0 to FList.Count - 1 do  // update all model and animation
    begin
      TrlModel(FList.Items[i]).Update;
    end;
end;

procedure TrlEngine.Render;
var i: longint;
begin
  BeginMode3D(EngineCamera);

  for i:=0 to FList.Count-1 do
    begin
      TrlModel(FList.Items[i]).Render;
      if Self.DrawDistance >0 then  // DrawDistance
        begin
         if Vector3Distance(EngineCamera.position, TrlModel(FList.Items[i]).Position) <= self.FDrawDistance
         then TrlModel(FList.Items[i]).Render;
        end else
         TrlModel(FList.Items[i]).Render; // else Draw all model
    end;

  if DrawDebugGrid then DrawGrid(FGridSlice, FGridSpace);
  EndMode3D;
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

