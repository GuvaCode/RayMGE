{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit rlMge;

{$warn 5023 off : no warning about unused units}
interface

uses
  rlMge_desc, rlApplication, rlTimers, rlEngine, rlFPCamera, rlTPCamera, 
  rlights, rlShadersPack, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('rlMge_desc', @rlMge_desc.Register);
end;

initialization
  RegisterPackage('rlMge', @Register);
end.
