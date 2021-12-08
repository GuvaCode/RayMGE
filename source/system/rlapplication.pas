unit rlApplication;

{$mode objfpc}{$H+}

interface

uses
  raylib;

type
{ TrlApplication }
TrlApplication = class (TObject)
  private
    FClearBackgroundColor: TColor;
    procedure SetCaption(AValue: string);
  protected

  public
    // Create a new application
    constructor Create; virtual;
    // Free the application
    destructor Destroy; override;
    // Shutdown the application
    procedure Shutdown; virtual;
    // Update the application
    procedure Update; virtual;
    // Render the application
    procedure Render; virtual;
    // Called when the device is resized
    procedure Resized; virtual;
    // Run the application
    procedure Run;
    // Terminate the application
    procedure Terminate;
    // Caption on window
    property Caption: string write SetCaption;
    property ClearBackgroundColor: TColor read FClearBackgroundColor write FClearBackgroundColor;
  end;

implementation

procedure TrlApplication.SetCaption(AValue: string);
begin
  SetWindowTitle(PChar(AValue));
end;

{ TrlApplication }
constructor TrlApplication.Create;
begin

end;

destructor TrlApplication.Destroy;
begin
  inherited Destroy;
end;


procedure TrlApplication.Shutdown;
begin
  CloseWindow(); // Close window and OpenGL context
end;

procedure TrlApplication.Update;
begin
  if IsWindowResized then Resized;
end;

procedure TrlApplication.Render;
begin

end;

procedure TrlApplication.Resized;
begin

end;

procedure TrlApplication.Run;
begin
  while not WindowShouldClose() do
  begin
    Update;
    BeginDrawing;
    ClearBackground(FClearBackgroundColor);
    Render;
    EndDrawing;
  end;
  Shutdown;
end;

procedure TrlApplication.Terminate;
begin

end;

end.
