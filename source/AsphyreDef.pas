unit AsphyreDef;
//---------------------------------------------------------------------------
// Add const, function          by DraculaLin           Modified: 12-Feb-2006
//---------------------------------------------------------------------------
// fxAddX, fxSrcColorAdd, fxInvert, fxSrcBright, fxDestBright, fxInvSrcBright
// fxInvDestBright, fxMultiplyX, fxMultiplyAlpha, fxInvMultiplyX, fxAdd2X
// fxLight, fxLightAdd, fxBright, fxBrightAdd, fxGrayScale, fxOneColor
// pBounds4s2, pBounds4sc2, pRotate42, pRotate4c2, RGB, RGB1, RGB4
// OverlapQuadrangle, Cos8, Sin8, Cos16, Sin16, Cos32, Sin32, Cos64, Sin64,
// Cos128, Sin128, Cos256, Sin256, Cos512, Sin512,
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// AsphyreDef.pas                                       Modified: 01-Jan-2006
// Asphyre General Definitions                                    Version 2.0
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, SysUtils;

//---------------------------------------------------------------------------
const
//---------------------------------------------------------------------------
// Bitmap Loading parameters
//---------------------------------------------------------------------------
 // flags for Targa files
 fsTargaCompressed = $00000001; // the pixel data is RLE-compressed
 fsTargaFlipped    = $00000002; // the pixel data is flipped
 fsTargaMirrored   = $00000004; // the pixel data is mirrored
 // flags for Jpeg files
 fsJpegProgressive = $00000008; // progressive encode jpeg
 fsJpegGrayscale   = $00000010; // separate luminocity channel (optimizes previews)
 // misc flags

//---------------------------------------------------------------------------
type
 TImageFormat = (ifBMP, ifTGA, ifJPEG, ifPNG, ifAuto);

//---------------------------------------------------------------------------
 TAsphyreQuality = (aqLow, aqMedium, aqHigh);

//---------------------------------------------------------------------------
 TAlphaLevel = (alNone, alMask, alFull, alExclusive);

//---------------------------------------------------------------------------
 TColorFormat = (COLOR_R3G3B2, COLOR_R5G6B5, COLOR_X8R8G8B8, COLOR_X1R5G5B5,
  COLOR_X4R4G4B4, COLOR_A8R8G8B8, COLOR_A1R5G5B5, COLOR_A4R4G4B4,
  COLOR_A8R3G3B2, COLOR_A2R2G2B2, COLOR_A8, COLOR_UNKNOWN);

//---------------------------------------------------------------------------
 PPoint2 = ^TPoint2;
 TPoint2 = record
  x, y: Single;
 end;

//---------------------------------------------------------------------------
 TBlendCoef = (bcZero, bcOne, bcSrcColor, bcInvSrcColor, bcSrcAlpha,
  bcInvSrcAlpha, bcDestAlpha, bcInvDestAlpha, bcDestColor, bcInvDestColor,
  bcSrcAlphaSat);

//---------------------------------------------------------------------------
 TBlendOp = (boAdd, boSub, boRevSub, boMin, boMax);

//---------------------------------------------------------------------------
 PPoint4 = ^TPoint4;
 TPoint4 = array[0..3] of TPoint2;

//---------------------------------------------------------------------------
 PColor4 = ^TColor4;
 TColor4 = array[0..3] of Cardinal;

//---------------------------------------------------------------------------
 PTexCoord = ^TTexCoord;
 TTexCoord = record
  Pattern: Integer;
  x, y, w, h: Integer;
  Flip   : Boolean;
  Mirror : Boolean;
 end;

//---------------------------------------------------------------------------
const
 Format2Bytes: array[TColorFormat] of Integer = (1, 2, 4, 2, 2, 4, 2, 2, 2, 1,
  1, 0);

 Format2Bits: array[TColorFormat] of Cardinal = ($0233, $0565, $0888, $0555,
  $0444, $8888, $1555, $4444, $8233, $2222, $8000, $0000);

 clWhite4  : TColor4 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
 clBlack4  : TColor4 = ($FF000000, $FF000000, $FF000000, $FF000000);
 clMaroon4 : TColor4 = ($FF000080, $FF000080, $FF000080, $FF000080);
 clGreen4  : TColor4 = ($FF008000, $FF008000, $FF008000, $FF008000);
 clOlive4  : TColor4 = ($FF008080, $FF008080, $FF008080, $FF008080);
 clNavy4   : TColor4 = ($FF800000, $FF800000, $FF800000, $FF800000);
 clPurple4 : TColor4 = ($FF800080, $FF800080, $FF800080, $FF800080);
 clTeal4   : TColor4 = ($FF808000, $FF808000, $FF808000, $FF808000);
 clGray4   : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clSilver4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clRed4    : TColor4 = ($FF0000FF, $FF0000FF, $FF0000FF, $FF0000FF);
 clLime4   : TColor4 = ($FF00FF00, $FF00FF00, $FF00FF00, $FF00FF00);
 clYellow4 : TColor4 = ($FF00FFFF, $FF00FFFF, $FF00FFFF, $FF00FFFF);
 clBlue4   : TColor4 = ($FFFF0000, $FFFF0000, $FFFF0000, $FFFF0000);
 clFuchsia4: TColor4 = ($FFFF00FF, $FFFF00FF, $FFFF00FF, $FFFF00FF);

 clAqua4   : TColor4 = ($FFFFFF00, $FFFFFF00, $FFFFFF00, $FFFFFF00);
 clLtGray4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clDkGray4 : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clOpaque4 : TColor4 = ($00FFFFFF, $00FFFFFF, $00FFFFFF, $00FFFFFF);

 tcNull    : TTexCoord = (Pattern: 0; x: 0; y: 0; w: 0; h: 0; Flip: False;
  Mirror: False);

 ZeroCoord4: TPoint4 = ((x: 0.0; y: 0.0), (x: 0.0; y: 0.0), (x: 0.0; y: 0.0),
  (x: 0.0; y: 0.0));

 fxNone             = $00000001;
 fxAdd              = $00000104;
 fxBlend            = $00000504;
 fxShadow           = $00000500;
 fxMultiply         = $00000200;
 fxInvMultiply      = $00000300;
 fxBlendNA          = $00000302;
 fxSub              = $00010104;
 fxRevSub           = $00020104;
 fxMax              = $00040101;
 fxMin              = $00030101;

 fxAddX             = $00000101;
 fxSrcColorAdd      = $00000102;
 fxInvert           = $00000009;
 fxSrcBright        = $00000202;
 fxDestBright       = $00000808;
 fxInvSrcBright     = $00000303;
 fxInvDestBright    = $00000909;
 fxMultiplyX        = $00000800;
 fxMultiplyAlpha    = $00000600;
 fxInvMultiplyX     = $00000900;

 fxAdd2X            = $7FFFFFF0;
 fxLight            = $7FFFFFF1;
 fxLightAdd         = $7FFFFFF2;
 fxBright           = $7FFFFFF3;
 fxBrightAdd        = $7FFFFFF4;
 fxGrayScale        = $7FFFFFF5;
 fxOneColor         = $7FFFFFF6;

//---------------------------------------------------------------------------
function Blend2Fx(SrcBlend, DestBlend: TBlendCoef; BlendOp: TBlendOp): Cardinal;
procedure Fx2Blend(Effect: Cardinal; out SrcBlend, DestBlend: TBlendCoef;
 out BlendOp: TBlendOp);

//---------------------------------------------------------------------------
function Point2(x, y: Real): TPoint2;
//---------------------------------------------------------------------------
// Point4 helper routines
//---------------------------------------------------------------------------
// point values -> TPoint4
function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4;
// rectangle coordinates -> TPoint4
function pRect4(const Rect: TRect): TPoint4;
// rectangle coordinates -> TPoint4
function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
// rectangle coordinates, scaled -> TPoint4
function pBounds4s(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
function pBounds4s2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
// rectangle coordinates, scaled / centered -> TPoint4
function pBounds4sc(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
function pBounds4sc2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
// mirrors the coordinates
function pMirror4(const Point4: TPoint4): TPoint4;
// flips the coordinates
function pFlip4(const Point4: TPoint4): TPoint4;
// shift the given points by the specified amount
function pShift4(const Points: TPoint4; const ShiftBy: TPoint2): TPoint4;
// rotated rectangle (Origin + Size) around (Middle) with Angle and Scale
function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real;
 Scale: Real=1.0): TPoint4;
function pRotate42(const Origin, Size, Middle: TPoint2; Angle: Real;
 ScaleX, ScaleY: Real ): TPoint4;
function pRotate4c(const Origin, Size: TPoint2; Angle: Real;
 Scale: Real=1.0): TPoint4;
function pRotate4c2(const Origin, Size: TPoint2; Angle,
 ScaleX, ScaleY: Real): TPoint4;
function pRotateTransForm(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle: Real; Scale: Real = 1.0): TPoint4;
function pRotateTransForm2(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle, ScaleX, ScaleY: Real): TPoint4;

//---------------------------------------------------------------------------
// Color helper routines
//---------------------------------------------------------------------------
function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4; overload;
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4; overload;
function cColor4(Color: Cardinal): TColor4; overload;
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4; overload;
function cGray4(Gray: Cardinal): TColor4; overload;
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4; overload;
function cAlpha4(Alpha: Cardinal): TColor4; overload;
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4; overload;
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;

function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
function cGray1(Gray: Cardinal): Cardinal;
function cAlpha1(Alpha: Cardinal): Cardinal;

function tPattern(Pattern: Integer): TTexCoord;
function tPatternEx(Pattern: Integer; Mirror, Flip: Boolean): TTexCoord;

//---------------------------------------------------------------------------
// returns True if the given point is within the specified rectangle
//---------------------------------------------------------------------------
function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the given rectangle is within the specified rectangle
//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the specified rectangles overlap
//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the point4  Quadrangle overlap
//---------------------------------------------------------------------------
function OverlapQuadrangle(Q1, Q2: TPoint4): Boolean;

//---------------------------------------------------------------------------
// Returns the next power of two of the specified value.
//---------------------------------------------------------------------------
//function NextPowerOfTwo(Value: Integer): Integer;

//---------------------------------------------------------------------------
// The routines 'IsPowerOfTwo', 'CeilPowerOfTwo' and 'FloorPowerOfTwo' are
// converted from published code on FlipCode.com by Sebastian Schuberth.
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Determines whether the specified value is a power of two.
//---------------------------------------------------------------------------
function IsPowerOfTwo(Value: Integer): Boolean;

//---------------------------------------------------------------------------
// The least power of two greater than or equal to the specified value.
// Note that for Value = 0 and for Value > 2147483648 the result is 0.
//---------------------------------------------------------------------------
//function CeilPowerOfTwo(Value: Integer): Integer;

//---------------------------------------------------------------------------
// The greatest power of two less than or equal to the specified value.
// Note that for Value = 0 the result is 0.
//---------------------------------------------------------------------------
//function FloorPowerOfTwo(Value: Integer): Integer;

//---------------------------------------------------------------------------
// Loads a text file from disk, handling exceptions.
//---------------------------------------------------------------------------
function LoadTextFile(const FileName: string; out Text: string): Boolean;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
//  precalculate   Sin Table, Cos Table
//---------------------------------------------------------------------------
function Cos8(i: Integer): Double;
function Sin8(i: Integer): Double;
function Cos16(i: Integer): Double;
function Sin16(i: Integer): Double;
function Cos32(i: Integer): Double;
function Sin32(i: Integer): Double;
function Cos64(i: Integer): Double;
function Sin64(i: Integer): Double;
function Cos128(i: Integer):Double;
function Sin128(i: Integer):Double;
function Cos256(i: Integer):Double;
function Sin256(i: Integer):Double;
function Cos512(i: Integer):Double;
function Sin512(i: Integer):Double;

//---------------------------------------------------------------------------

implementation

//---------------------------------------------------------------------------
function Blend2Fx(SrcBlend, DestBlend: TBlendCoef; BlendOp: TBlendOp): Cardinal;
begin
 Result:= Byte(SrcBlend) or (Word(Byte(DestBlend)) shl 8) or
  (Cardinal(Byte(BlendOp)) shl 16);
end;

//---------------------------------------------------------------------------
procedure Fx2Blend(Effect: Cardinal; out SrcBlend, DestBlend: TBlendCoef;
 out BlendOp: TBlendOp);
begin
 SrcBlend := TBlendCoef(Effect and $FF);
 DestBlend:= TBlendCoef((Effect shr 8) and $FF);
 BlendOp  := TBlendOp((Effect shr 16) and $FF);
end;

//---------------------------------------------------------------------------
{function NextPowerOfTwo(Value: Integer): Integer;
begin
 Result:= 1;
 asm
  xor ecx, ecx
  bsr ecx, Value
  inc ecx
  shl Result, cl
 end;
end; }

//---------------------------------------------------------------------------
function IsPowerOfTwo(Value: Integer): Boolean;
begin
 Result:= (Value >= 1)and((Value and (Value - 1)) = 0);
end;

//---------------------------------------------------------------------------
{function CeilPowerOfTwo(Value: Integer): Integer; register;
asm
 xor eax, eax
 dec ecx
 bsr ecx, ecx
 cmovz ecx, eax
 setnz al
 inc eax
 shl eax, cl
end; }

//---------------------------------------------------------------------------
{function FloorPowerOfTwo(Value: Integer): Integer;
asm
 xor eax, eax
 bsr ecx, ecx
 setnz al
 shl eax, cl
end;  }

//---------------------------------------------------------------------------
function Point2(x, y: Real): TPoint2;
begin
 Result.x:= x;
 Result.y:= y;
end;

//---------------------------------------------------------------------------
function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4;
begin
 Result[0].x:= x1;
 Result[0].y:= y1;
 Result[1].x:= x2;
 Result[1].y:= y2;
 Result[2].x:= x3;
 Result[2].y:= y3;
 Result[3].x:= x4;
 Result[3].y:= y4;
end;

//---------------------------------------------------------------------------
function pRect4(const Rect: TRect): TPoint4;
begin
 Result[0].x:= Rect.Left;
 Result[0].y:= Rect.Top;
 Result[1].x:= Rect.Right;
 Result[1].y:= Rect.Top;
 Result[2].x:= Rect.Right;
 Result[2].y:= Rect.Bottom;
 Result[3].x:= Rect.Left;
 Result[3].y:= Rect.Bottom;
end;

//---------------------------------------------------------------------------
function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
begin
 Result[0].X:= _Left;
 Result[0].Y:= _Top;
 Result[1].X:= _Left + _Width;
 Result[1].Y:= _Top;
 Result[2].X:= _Left + _Width;
 Result[2].Y:= _Top + _Height;
 Result[3].X:= _Left;
 Result[3].Y:= _Top + _Height;
end;

//---------------------------------------------------------------------------
function pBounds4s(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
begin
 Result:= pBounds4(_Left, _Top, Round(_Width * Scale), Round(_Height * Scale));
end;

//---------------------------------------------------------------------------
function pBounds4s2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
begin
 Result:= pBounds4(_Left, _Top, Round(_Width * ScaleX), Round(_Height * ScaleY));
end;

//---------------------------------------------------------------------------
function pBounds4sc(_Left, _Top, _Width, _Height, Scale: Real): TPoint4;
var
 Left, Top: Real;
 Width, Height: Real;
begin
 if (Scale = 1.0) then
  Result:= pBounds4(_Left, _Top, _Width, _Height)
 else
  begin
   Width := _Width * Scale;
   Height:= _Height * Scale;
   Left  := _Left + ((_Width - Width) * 0.5);
   Top   := _Top + ((_Height - Height) * 0.5);
   Result:= pBounds4(Left, Top, Round(Width), Round(Height));
  end;
end;

//---------------------------------------------------------------------------
function pBounds4sc2(_Left, _Top, _Width, _Height, ScaleX, ScaleY: Real): TPoint4;
var
 Left, Top: Real;
 Width, Height: Real;
begin
 if (ScaleX = 1.0) and (ScaleY=1.0) then
  Result:= pBounds4(_Left, _Top, _Width, _Height)
 else
  begin
   Width := _Width * ScaleX;
   Height:= _Height * ScaleY;
   Left  := _Left + Round((_Width - Width) * 0.5);
   Top   := _Top + Round((_Height - Height) * 0.5);
   Result:= pBounds4(Left, Top, Round(Width), Round(Height));
  end;
end;

//---------------------------------------------------------------------------
function pMirror4(const Point4: TPoint4): TPoint4;
begin
 Result[0].X:= Point4[1].X;
 Result[0].Y:= Point4[0].Y;
 Result[1].X:= Point4[0].X;
 Result[1].Y:= Point4[1].Y;
 Result[2].X:= Point4[3].X;
 Result[2].Y:= Point4[2].Y;
 Result[3].X:= Point4[2].X;
 Result[3].Y:= Point4[3].Y;
end;

//---------------------------------------------------------------------------
function pFlip4(const Point4: TPoint4): TPoint4;
begin
 Result[0].X:= Point4[0].X;
 Result[0].Y:= Point4[2].Y;
 Result[1].X:= Point4[1].X;
 Result[1].Y:= Point4[3].Y;
 Result[2].X:= Point4[2].X;
 Result[2].Y:= Point4[0].Y;
 Result[3].X:= Point4[3].X;
 Result[3].Y:= Point4[1].Y;
end;

//---------------------------------------------------------------------------
function pShift4(const Points: TPoint4; const ShiftBy: TPoint2): TPoint4;
begin
 Result[0].x:= Points[0].x + ShiftBy.x;
 Result[0].y:= Points[0].y + ShiftBy.y;
 Result[1].x:= Points[1].x + ShiftBy.x;
 Result[1].y:= Points[1].y + ShiftBy.y;
 Result[2].x:= Points[2].x + ShiftBy.x;
 Result[2].y:= Points[2].y + ShiftBy.y;
 Result[3].x:= Points[3].x + ShiftBy.x;
 Result[3].y:= Points[3].y + ShiftBy.y;
end;

//---------------------------------------------------------------------------
function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real;
 Scale: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.x, -Middle.y, Size.x, Size.y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * Scale;
   Points[Index].y:= Points[Index].y * Scale;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x;
   Points[Index].y:= Point.y + Origin.y;
  end;

 Result:= Points; 
end;
//---------------------------------------------------------------------------
function pRotate42(const Origin, Size, Middle: TPoint2; Angle: Real;
 ScaleX, ScaleY: Real ): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.X, -Middle.Y, Size.X, Size.Y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * ScaleX;
   Points[Index].y:= Points[Index].y * ScaleY;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x;
   Points[Index].y:= Point.y + Origin.y;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------
function pRotate4c(const Origin, Size: TPoint2; Angle: Real;
 Scale: Real): TPoint4;
begin
 Result:= pRotate4(Origin, Size, Point2(Size.x * 0.5, Size.y * 0.5), Angle,
  Scale);
end;

//---------------------------------------------------------------------------
function pRotate4c2(const Origin, Size: TPoint2; Angle,
 ScaleX, ScaleY: Real): TPoint4;
begin
 Result:= pRotate42(Origin, Size, Point2(Size.x * 0.5, Size.y * 0.5), Angle, ScaleX, ScaleY);
end;

//---------------------------------------------------------------------------
function pRotateTransForm(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle: Real; Scale: Real = 1.0): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= Point4(X1-CenterX, Y1-CenterY, X2-CenterX, Y2-CenterY,
                  X3-CenterX, Y3-CenterY, X4-CenterX, Y4-CenterY);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].X:= Points[Index].X * Scale;
   Points[Index].Y:= Points[Index].Y * Scale;

   // rotate the point around Phi
   Point.x:= (Points[Index].X * CosPhi) - (Points[Index].Y * SinPhi);
   Point.y:= (Points[Index].Y * CosPhi) + (Points[Index].X * SinPhi);

   // translate the point to (Origin)
   Points[Index].X:= Point.X + X ;
   Points[Index].Y:= Point.Y + Y ;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------
function pRotateTransForm2(const X, Y, X1, Y1, X2, Y2, X3, Y3, X4, Y4 ,
 CenterX, CenterY, Angle, ScaleX, ScaleY: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= Point4(X1-CenterX, Y1-CenterY, X2-CenterX, Y2-CenterY,
                  X3-CenterX, Y3-CenterY, X4-CenterX, Y4-CenterY);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].X:= Points[Index].X * ScaleX;
   Points[Index].Y:= Points[Index].Y * ScaleY;

   // rotate the point around Phi
   Point.x:= (Points[Index].X * CosPhi) - (Points[Index].Y * SinPhi);
   Point.y:= (Points[Index].Y * CosPhi) + (Points[Index].X * SinPhi);

   // translate the point to (Origin)
   Points[Index].X:= Point.X + X ;
   Points[Index].Y:= Point.Y + Y ;
  end;

 Result:= Points;
end;


//---------------------------------------------------------------------------
function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
begin
 Result:= r or (g shl 8) or (b shl 16) or (a shl 24);
end;

//---------------------------------------------------------------------------
function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4;
begin
 Result:= cColor4(cRGB1(r, g, b, a));
end;

//---------------------------------------------------------------------------
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4;
begin
 Result[0]:= cRGB1(r1, g1, b1, a1);
 Result[1]:= Result[0];
 Result[2]:= cRGB1(r2, g2, b2, a2);
 Result[3]:= Result[2];
end;

//---------------------------------------------------------------------------
function cColor4(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

//---------------------------------------------------------------------------
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4;
begin
 Result[0]:= Color1;
 Result[1]:= Color2;
 Result[2]:= Color3;
 Result[3]:= Color4;
end;

//---------------------------------------------------------------------------
function cGray4(Gray: Cardinal): TColor4;
begin
 Result:= cColor4(((Gray and $FF) or ((Gray and $FF) shl 8) or
  ((Gray and $FF) shl 16)) or $FF000000);
end;

//---------------------------------------------------------------------------
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4;
begin
 Result[0]:= ((Gray1 and $FF) or ((Gray1 and $FF) shl 8) or ((Gray1 and $FF) shl 16)) or $FF000000;
 Result[1]:= ((Gray2 and $FF) or ((Gray2 and $FF) shl 8) or ((Gray2 and $FF) shl 16)) or $FF000000;
 Result[2]:= ((Gray3 and $FF) or ((Gray3 and $FF) shl 8) or ((Gray3 and $FF) shl 16)) or $FF000000;
 Result[3]:= ((Gray4 and $FF) or ((Gray4 and $FF) shl 8) or ((Gray4 and $FF) shl 16)) or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha4(Alpha: Cardinal): TColor4;
begin
 Result:= cColor4($FFFFFF or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4;
begin
 Result[0]:= $FFFFFF or ((Alpha1 and $FF) shl 24);
 Result[1]:= $FFFFFF or ((Alpha2 and $FF) shl 24);
 Result[2]:= $FFFFFF or ((Alpha3 and $FF) shl 24);
 Result[3]:= $FFFFFF or ((Alpha4 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
begin
 Result:= cColor4((Color and $FFFFFF) or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4;
begin
 Result[0]:= (Color1 and $FFFFFF) or ((Alpha1 and $FF) shl 24);
 Result[1]:= (Color2 and $FFFFFF) or ((Alpha2 and $FF) shl 24);
 Result[2]:= (Color3 and $FFFFFF) or ((Alpha3 and $FF) shl 24);
 Result[3]:= (Color4 and $FFFFFF) or ((Alpha4 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColor1(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

//---------------------------------------------------------------------------
function cGray1(Gray: Cardinal): Cardinal;
begin
 Result:= ((Gray and $FF) or ((Gray and $FF) shl 8) or ((Gray and $FF) shl 16))
  or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha1(Alpha: Cardinal): Cardinal;
begin
 Result:= $FFFFFF or ((Alpha and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function tPattern(Pattern: Integer): TTexCoord;
begin
 FillChar(Result, SizeOf(TTexCoord), 0);
 Result.Pattern:= Pattern;
end;

//---------------------------------------------------------------------------
function tPatternEx(Pattern: Integer; Mirror, Flip: Boolean): TTexCoord;
begin
 FillChar(Result, SizeOf(TTexCoord), 0);
 
 Result.Pattern:= Pattern;
 Result.Flip   := Flip;
 Result.Mirror := Mirror;
end;

//---------------------------------------------------------------------------
function PointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
 Result:= (Point.X >= Rect.Left)and(Point.X <= Rect.Right)and
  (Point.Y >= Rect.Top)and(Point.Y <= Rect.Bottom);
end;

//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left >= Rect2.Left)and(Rect1.Right <= Rect2.Right)and
  (Rect1.Top >= Rect2.Top)and(Rect1.Bottom <= Rect2.Bottom);
end;

//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left < Rect2.Right)and(Rect1.Right > Rect2.Left)and
  (Rect1.Top < Rect2.Bottom)and(Rect1.Bottom > Rect2.Top);
end;

//---------------------------------------------------------------------------
function LoadTextFile(const FileName: string; out Text: string): Boolean;
var
 Strings: TStrings;
begin
 Result:= True;

 Strings:= TStringList.Create();
 try
  Strings.LoadFromFile(FileName);
 except
  Result:= False;
 end;

 Text:= Strings.Text;
 Strings.Free();
end;

//---------------------------------------------------------------------------
function OverlapQuadrangle(Q1, Q2: TPoint4): Boolean;
var
 d1, d2, d3, d4: Single;
begin

 d1 := (Q1[2].X - Q1[1].X) * (Q2[0].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) * (Q2[0].Y - Q1[0].Y);
 d2 := (Q1[3].X - Q1[2].X) * (Q2[0].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) * (Q2[0].Y - Q1[1].Y);
 d3 := (Q1[0].X - Q1[3].X) * (Q2[0].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) * (Q2[0].Y - Q1[2].Y);
 d4 := (Q1[1].X - Q1[0].X) * (Q2[0].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) * (Q2[0].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result := True;
  Exit;
 end;

 d1 := (Q1[2].X - Q1[1].X) * (Q2[1].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) * (Q2[1].Y - Q1[0].Y);
 d2 := (Q1[3].X - Q1[2].X) * (Q2[1].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) * (Q2[1].Y - Q1[1].Y);
 d3 := (Q1[0].X - Q1[3].X) * (Q2[1].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) * (Q2[1].Y - Q1[2].Y);
 d4 := (Q1[1].X - Q1[0].X) * (Q2[1].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) * (Q2[1].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result := True;
  Exit;
 end;

 d1 := (Q1[2].X - Q1[1].X) * (Q2[2].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) * (Q2[2].Y - Q1[0].Y);
 d2 := (Q1[3].X - Q1[2].X) * (Q2[2].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) * (Q2[2].Y - Q1[1].Y);
 d3 := (Q1[0].X - Q1[3].X) * (Q2[2].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) * (Q2[2].Y - Q1[2].Y);
 d4 := (Q1[1].X - Q1[0].X) * (Q2[2].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) * (Q2[2].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result := True;
  Exit;
 end;

 d1 := (Q1[2].X - Q1[1].X) * (Q2[3].X - Q1[0].X) + (Q1[2].Y - Q1[1].Y) * (Q2[3].Y - Q1[0].Y);
 d2 := (Q1[3].X - Q1[2].X) * (Q2[3].X - Q1[1].X) + (Q1[3].Y - Q1[2].Y) * (Q2[3].Y - Q1[1].Y);
 d3 := (Q1[0].X - Q1[3].X) * (Q2[3].X - Q1[2].X) + (Q1[0].Y - Q1[3].Y) * (Q2[3].Y - Q1[2].Y);
 d4 := (Q1[1].X - Q1[0].X) * (Q2[3].X - Q1[3].X) + (Q1[1].Y - Q1[0].Y) * (Q2[3].Y - Q1[3].Y);
 if (d1 >= 0) and (d2 >= 0) and (d3 >= 0) and (d4 >= 0) then
 begin
  Result := True;
  Exit;
 end;

 Result := False;
end;


//---------------------------------------------------------------------------
//precalculated fixed  point  cosines for a full circle
var
  CosTable8  : array[0..7]   of Double;
  CosTable16 : array[0..15]  of Double;
  CosTable32 : array[0..31]  of Double;
  CosTable64 : array[0..63]  of Double;
  CosTable128: array[0..127] of Double;
  CosTable256: array[0..255] of Double;
  CosTable512: array[0..511] of Double;

procedure InitCosTable;
var
  i: Integer;
begin
   for i:=0 to 7 do
    CosTable8[i] := Cos((i/8)*2*PI);

   for i:=0 to 15 do
    CosTable16[i] := Cos((i/16)*2*PI);

   for i:=0 to 31 do
    CosTable32[i] := Cos((i/32)*2*PI);

   for i:=0 to 63 do
    CosTable64[i] := Cos((i/64)*2*PI);

   for i:=0 to 127 do
    CosTable128[i] := Cos((i/128)*2*PI);

   for i:=0 to 255 do
    CosTable256[i] := Cos((i/256)*2*PI);

   for i:=0 to 511 do
    CosTable512[i] := Cos((i/512)*2*PI);
end;

function Cos8(i: Integer): Double;
begin
  Result := CosTable8[i and 7];
end;

function Sin8(i: Integer): Double;
begin
  Result := CosTable8[(i+6) and 7];
end;

function Cos16(i: Integer): Double;
begin
  Result := CosTable16[i and 15];
end;

function Sin16(i: Integer): Double;
begin
  Result := CosTable16[(i+12) and 15];
end;

function Cos32(i: Integer): Double;
begin
  Result := CosTable32[i and 31];
end;

function Sin32(i: Integer): Double;
begin
  Result := CosTable32[(i+24) and 31];
end;

function Cos64(i: Integer): Double;
begin
  Result := CosTable64[i and 63];
end;

function Sin64(i: Integer): Double;
begin
  Result := CosTable64[(i+48) and 63];
end;

function Cos128(i: Integer): Double;
begin
  Result := CosTable128[i and 127];
end;

function Sin128(i: Integer): Double;
begin
  Result := CosTable128[(i+96) and 127];
end;

function Cos256(i: Integer): Double;
begin
  Result := CosTable256[i and 255];
end;

function Sin256(i: Integer): Double;
begin
  Result := CosTable256[(i+192) and 255];
end;

function Cos512(i: Integer): Double;
begin
  Result := CosTable512[i and 511];
end;

function Sin512(i: Integer): Double;
begin
  Result := CosTable512[(i+384) and 511];
end;

initialization
  InitCosTable;

//---------------------------------------------------------------------------
end.
