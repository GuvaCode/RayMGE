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
      procedure Draw;
      procedure ClearDeadModel;

      property EngineCameraMode: TrlEngineCameraMode read FEngineCameraMode write SetEngineCameraMode;
      property DrawsGrid: boolean read FDrawsGrid write SetDrawsGrid;
      property GridSlices:longint read FGridSlices write SetGridSlices;
      property GridSpacing: single read FGridSpacing write SetGridSpacing;

   end;

  { TrlModel }

  TrlModel = class
    private

    protected
    public
      constructor Create(Engine: TrlEngine); virtual;
      destructor Destroy; override;
      procedure Move(const MoveCount: Single);
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
  rlTPCameraInit(@CameraThirdPerson, 45, Vector3Create( 1, 0 ,0 ));
  rlFPCameraInit(@CameraFirstPerson, 45, Vector3Create( 1, 0, 0 ));

  CameraFirstPerson.MoveSpeed.z := 10;
  CameraFirstPerson.MoveSpeed.x := 5;
  CameraFirstPerson.FarPlane := 5000;

  FDrawsGrid:=False;
  FGridSpacing:=0.5;
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
     // TrlModel(FList.Items[i]).Draw;
    end;

  if FDrawsGrid then DrawGrid(FGridSlices, FGridSpacing);

  case FEngineCameraMode of
     cmFirstPerson: rlFPCameraEndMode3D;
     cmThirdPerson: rlTPCameraEndMode3D;
  end;
end;

procedure TrlEngine.ClearDeadModel;
begin

end;

{ TrlModel }

constructor TrlModel.Create(Engine: TrlEngine);
begin

end;

destructor TrlModel.Destroy;
begin
  inherited Destroy;
end;



procedure TrlModel.Move(const MoveCount: Single);
begin

end;

end.

