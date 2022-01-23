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
  raylib, raymath, rlgl, rlFPCamera, rlTPCamera, classes;

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
      procedure DoMoveUpdate; virtual;
      procedure DoMoveEndUpdate; virtual;
    public

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
      FAxis: TVector3;
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
      function GetPositionX: single;
      function GetPositionY: single;
      function GetPositionZ: single;
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
      procedure DoCollision(CollisonModel: TrlModel); virtual;
    public
      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;
      procedure Move(const MoveCount: Single); overload; virtual;

      procedure LoadingModel(FileName: String);
      procedure LoadingModelTexture(FileName: String);

      procedure Dead;
      procedure Draw;

      procedure Collision(const Other: TrlModel); overload; virtual;
      procedure Collision; overload; virtual;

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
    end;

  const LE = #10; // line end;

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
  FDrawDistance:=100;
  FUsesDrawDistance:=true;

  CreateSkyBox;
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
    //TrlModel(List.Items[i]).Update3dModelAnimations(MoveCount);
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
       end;

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
begin
   FModel.transform:=MatrixRotateXYZ(Vector3Create(DEG2RAD*FAxisX,DEG2RAD*FAxisY,DEG2RAD*FAxisZ));
   Vector3Set(@FAxis,DEG2RAD*FAxisX,DEG2RAD*FAxisY,DEG2RAD*FAxisZ);

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
{$HINTS ON}
procedure TrlModel.LoadingModel(FileName: String);
begin
  FModel:=LoadModel(PChar(FileName));
end;

procedure TrlModel.LoadingModelTexture(FileName: String);
begin
  FTexture:= LoadTexture(PChar(FileName));
  SetMaterialTexture(@FModel.materials[0], MATERIAL_MAP_DIFFUSE, FTexture);
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

end.

