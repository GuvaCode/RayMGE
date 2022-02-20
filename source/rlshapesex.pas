unit rlShapesEx;

{$mode ObjFPC}{$H+}

interface

uses
  raylib, rlgl ,Classes, SysUtils;

procedure DrawHex3D(center:TVector3; radius:single; rotation:single; color:Tcolor);
procedure DrawHex3DEx(center:TVector3; radius:single; rotation:single; lineThick:single; color:TColor);

implementation

procedure DrawHex3D(center:TVector3; radius:single; rotation:single; color:Tcolor);
var centralAngle: single;
    i: longint;
begin
  centralAngle:=0.0;
  rlCheckRenderBatchLimit(2*6);
  rlPushMatrix;
  rlTranslatef(center.x, center.y, center.z);
  rlRotatef(rotation, 0, 1, 0);
  rlBegin(RL_LINES);
  for i:=0 to 6-1 do
    begin
      rlColor4ub(color.r, color.g, color.b, color.a);
      rlVertex3f(sin(DEG2RAD*centralAngle)*radius, 0,cos(DEG2RAD*centralAngle)*radius);
      centralAngle += 360.0/6;
      rlVertex3f(sin(DEG2RAD*centralAngle)*radius, 0,cos(DEG2RAD*centralAngle)*radius);
    end;
   rlEnd();
   rlPopMatrix();
end;

procedure DrawHex3DEx(center: TVector3; radius: single; rotation: single;
  lineThick: single; color: TColor);
var centralAngle, exteriorAngle, innerRadius, nextAngle: single;
    i,sides:longint;
begin
  sides:=6;
  if sides < 3 then sides := 3;

  centralAngle := 0.0;
  exteriorAngle:= 360.0/sides;

  innerRadius := radius - (lineThick*cos(DEG2RAD*exteriorAngle/1.0));

  rlCheckRenderBatchLimit(8*sides);

  rlPushMatrix();
  rlTranslatef(center.x, center.y, center.z);
  rlRotatef(rotation, 1.0, 0.0, 1.0);

          rlBegin(RL_TRIANGLES);
            for i:=0 to sides -1 do //(int i = 0; i < sides; i++)
            begin
                rlColor4ub(color.r, color.g, color.b, color.a);
                nextAngle:= centralAngle + exteriorAngle;

                rlVertex3f(sin(DEG2RAD*centralAngle)*radius,0, cos(DEG2RAD*centralAngle)*radius);
                rlVertex3f(sin(DEG2RAD*centralAngle)*innerRadius,0, cos(DEG2RAD*centralAngle)*innerRadius);
                rlVertex3f(sin(DEG2RAD*nextAngle)*radius,0, cos(DEG2RAD*nextAngle)*radius);


                rlColor4ub(color.r, color.g, color.b, color.a);
                rlVertex3f(sin(DEG2RAD*centralAngle)*innerRadius,0, cos(DEG2RAD*centralAngle)*innerRadius);
                rlVertex3f(sin(DEG2RAD*nextAngle)*radius,0, cos(DEG2RAD*nextAngle)*radius);
                rlVertex3f(sin(DEG2RAD*nextAngle)*innerRadius,0, cos(DEG2RAD*nextAngle)*innerRadius);

                centralAngle := nextAngle;


            end;
        rlEnd();
    rlPopMatrix();
end;

end.

