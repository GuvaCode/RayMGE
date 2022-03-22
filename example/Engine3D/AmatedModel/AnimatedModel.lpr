program AnimatedModel;

uses
    SysUtils, gameunit;


var Game: TGame;

begin
  Game:= TGame.Create;
  Game.Run;
  Game.Free;
end.
