program Logo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

procedure ShowLogo;
begin
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
  Writeln('                 �����        �������      ���      ���      ������        ��       ��    ��������������');
  Writeln('                   ����       ��    ��      ���    ���      ��    ��       ��     ����    ��������������');
  Writeln('                     ����     ��     ��      ���  ���       ��    ��       ��    �� ��         ����     ');
  Writeln('                 ��������     ��    ��        �� ��         ��    ��       ��   ��  ��         ����     ');
  Writeln('                     ����     �������          ���          ��    ��       ��  ��   ��         ����     ');
  Writeln('                   ����       ��              ���          ����������      �� ��    ��         ����     ');
  Writeln('                 �����        ��             ���          ��        ��     ����     ��         ����     ');
  writeln;
  writeln;
  writeln;
  writeln;
  Sleep(1000);
  write('��� ����������� ������� ENTER...');
  readln;
end;
begin
  showlogo;
  readln;
end.
