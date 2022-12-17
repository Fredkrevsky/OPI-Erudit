program Logo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

procedure ShowLogo();
begin
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln('               ннннн        ааааааа      ггг      ггг      ФФФФФФ        ШШ       ШШ    ввввввввввввввв');
  writeln('                 нннн       аа    аа      ггг    ггг      ФФ    ФФ       ШШ     ШШШШ         вввв');
  writeln('                   нннн     аа     аа      ггг  ггг       ФФ    ФФ       ШШ    ШШ ШШ         вввв');
  writeln('               нннннннн     аа    аа        гг гг         ФФ    ФФ       ШШ   ШШ  ШШ         вввв');
  writeln('                   нннн     ааааааа          ггг          ФФ    ФФ       ШШ  ШШ   ШШ         вввв');
  writeln('                 нннн       аа              ггг          ФФФФФФФФФФ      ШШ ШШ    ШШ         вввв');
  writeln('               ннннн        аа             ггг          ФФ        ФФ     ШШШШ     ШШ         вввв');
end;
begin
  showlogo;
  readln;
end.
