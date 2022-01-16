unit rlEngine;

{$mode objfpc}{$H+}

interface

uses
  raylib, raymath, rlgl, rlFPCamera, rlTPCamera, classes;

type
  TrlEngineDrawMode = (dmNormal, dmEx, dmWires, dmWiresEx);
  TrlEngineCameraMode = (cmFirstPerson, cmThirdPerson);

  { TrlEngine }
  TrlEngine = class
    private
      FDrawsGrid: boolean;

      FEngineCameraMode: TrlEngineCameraMode;
      FGridSlices: longint;
      FGridSpacing: single;

      procedure SetDrawsGrid(AValue: boolean);
      procedure SetEngineCameraMode(AValue: TrlEngineCameraMode);
      procedure SetGridSlices(AValue: longint);
      procedure SetGridSpacing(AValue: single);
    protected
      FList: TList;
      FDeadList: TList;
    public
      CameraThirdPerson:TrlTPCamera;
      CameraFirstPerson:TrlFPCamera;

      constructor Create;
      destructor Destroy; override;

      procedure Move(MoveCount: single);
      procedure Draw; virtual;
      procedure ClearDeadModel;

      property EngineCameraMode: TrlEngineCameraMode read FEngineCameraMode write SetEngineCameraMode;
      property DrawsGrid: boolean read FDrawsGrid write SetDrawsGrid;
      property GridSlices:longint read FGridSlices write SetGridSlices;
      property GridSpacing: single read FGridSpacing write SetGridSpacing;
   end;

  { TrlModel }
  TrlModel = class
    private
      FAngle: Single;
      FAxis: TVector3;
      FAxisX: Single;
      FAxisY: Single;
      FAxisZ: Single;
      FColor: TColor;
      FDrawMode: TrlEngineDrawMode;
    //  FPoly: TSegment3D;
      FPosition: TVector3;
      FPositionX: single;
      FPositionY: single;
      FPositionZ: single;
      FScale: Single;
      FScaleEx: TVector3;
      function GetPositionX: single;
      function GetPositionY: single;
      function GetPositionZ: single;
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
      FTexture: TTexture2d;
      FCollisionBBox:TBoundingBox;
    public

      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;

      procedure Move(const MoveCount: Single);
      procedure LoadingModel(FileName: String);
      procedure LoadingModelTexture(FileName: String);
      procedure Dead;
      procedure Draw;

      property DrawMode: TrlEngineDrawMode read FDrawMode write SetDrawMode;
      property Model: TModel read FModel write FModel;
      property Color: TColor read FColor write FColor;
      property Scale: Single read FScale write SetScale;

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
    end;

implementation

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

procedure TrlEngine.SetDrawsGrid(AValue: boolean);
begin
  if FDrawsGrid=AValue then Exit;
  FDrawsGrid:=AValue;
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

  FDrawsGrid:=False;
  FGridSpacing:=1.5;
  FGridSlices:=10;
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
     cmFirstPerson: rlFPCameraUpdate(@CameraFirstPerson);
     cmThirdPerson: rlTPCameraUpdate(@CameraThirdPerson);
   end;

   rlTPCameraUseMouse(@CameraThirdPerson,true,1);

for i := 0 to FList.Count - 1 do
  begin
    //TrlModel(List.Items[i]).Update3dModelAnimations(MoveCount);
    TrlModel(FList.Items[i]).Move(MoveCount);
  end;
end;

procedure TrlEngine.Draw;
var
  i: Integer;
begin

  case FEngineCameraMode of
     cmFirstPerson: rlFPCameraBeginMode3D(@CameraFirstPerson);
     cmThirdPerson: rlTPCameraBeginMode3D(@CameraThirdPerson);
   end;

  for i := 0 to FList.Count - 1 do
    begin
      TrlModel(FList.Items[i]).Draw;
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

{ TrlModel }

procedure TrlModel.SetScale(AValue: Single);
begin
  FScale:=AValue;
  Vector3Set(@FScaleEx,FScale,FScale,FScale);
  FModel.transform:=MatrixScale(FScale,FScale,FScale);
end;

procedure TrlModel.SetPosition(AValue: TVector3);
begin
  FPosition:=AValue;
end;

procedure TrlModel.SetPositionX(AValue: single);
begin
  if FPositionX=AValue then Exit;
  FPositionX:=AValue;
  FPosition.x:=FPositionX;
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

constructor TrlModel.Create(Engine: TrlEngine);
begin
  FEngine := Engine;
  FEngine.FList.Add(Self);
  FDrawMode:=dmNormal;
  FColor:=WHITE;
  FAngle:=0.0;
  FPosition:=Vector3Create(0.0,0.0,0.0);
  FAxis:=Vector3Create(0.0,0.0,0.0);
  DrawMode:=dmEx;
end;

destructor TrlModel.Destroy;
begin
  UnloadTexture(Self.FTexture);
  UnloadModel(Self.FModel);
  inherited Destroy;
end;

procedure TrlModel.Move(const MoveCount: Single);
var m_collisionBox:TBoundingBox;


begin
   FModel.transform:=MatrixRotateXYZ(Vector3Create(DEG2RAD*FAxisX,DEG2RAD*FAxisY,DEG2RAD*FAxisZ));
   Vector3Set(@FAxis,DEG2RAD*FAxisX,DEG2RAD*FAxisY,DEG2RAD*FAxisZ);

   m_collisionBox:=GetModelBoundingBox(model);

   m_collisionBox.max:=Vector3Scale(m_collisionBox.max,FScale);
   m_collisionBox.min:=Vector3Scale(m_collisionBox.min,FScale);

   m_collisionBox.max := Vector3Add(Fposition,  m_collisionBox.max);
   m_collisionBox.min := Vector3Add(Fposition,  m_collisionBox.min);

   FCollisionBBox:= m_collisionBox;

end;

procedure TrlModel.LoadingModel(FileName: String);
begin
  FModel:=LoadModel(PChar(FileName));
end;

procedure TrlModel.LoadingModelTexture(FileName: String);
begin
  FTexture:= LoadTexture(PChar(FileName));
  SetMaterialTexture(@FModel.materials[0], MATERIAL_MAP_DIFFUSE, FTexture);//todo
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
    dmEx: DrawModelEx(FModel, FPosition, FAxis, FAngle, FScaleEx, FColor); // Draw a model with extended parameters
    dmWires: DrawModelWires(FModel, FPosition, FScale, FColor);  // Draw a model wires (with texture if set)
    dmWiresEX: DrawModelWiresEx(FModel,FPosition,FAxis, FAngle, FScaleEx,FColor);
    end;
   // DrawBoundingBox(FCollisionBBox,RED);
end;

end.

