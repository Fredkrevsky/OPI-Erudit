program Game;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

type
  TPlayers = array [1 .. 10] of integer;
  TName = array [ 1 .. 10] of string;

var
  N, I : integer;
  Name : TName;
  Players : TPlayers;
  NameTemp : string;
  Lang : string[5];

procedure ShowRules; //������� ����
begin
  Writeln;
  Writeln('=========================================================������========================================================');
  Writeln;
  Writeln('�������');
  Writeln;
  Writeln('1. ����� ������� ���� ��������� ����� ������� ���� (������� ��� ����������)');
  Writeln('2. ���������� ������� �� ����� ���� ������ 10');
  Writeln('3. � ������ ���� ��������� ���� ����, ��������� �� ������������ ������ ���������'+#13#10+'   ���� � � 8 ��� ������� ���� �������� (�������� ���� ����������)');
  Writeln('4. ������� ������ ��������� �� 10 ��������� ��������� ������� ���� �� ����� ����.'+#13#10+'   ��� 10 ���� �������� ����� ���� ������. ��� ������ �� ������� ���������� �����,'+#13#10+'   ������ �� ������ ������ ���� ������');
  Writeln('5. ������������ ������ �������� ����� �������� (�������� ���� ����������)');
  Writeln('6. ���� ����� ���������� �����, �� ������ ������������ ����. ���� �������, � ������'+#13#10+'   ������������ ������� ������ ����� � ������� ��������� ����, �� ����� ������ ����');
  Writeln('7. ����� ����� ���������� ���. �� ������� ��� ���� �� ���������');
  Writeln('8. ����� ���� ������ ����������� ����������� �� 10-�� ���������� ���� � ������ ���� ������');
  Writeln('9. �� ����, ������ �������� ����� ��������������� ����� ��������: "50-��-50" � "������ �����"');
  Writeln('   1. "50-��-50": ����� ����� �������� ����� 5 ���� �� ������ ������. �� ����� ������'+#13#10+'      �������� ����������� 5 ����, ��� ���� ���������� ����� ��������� ����������� �'+#13#10+'      ������� � ���� �� ���������, � ����� ����� ������ ����������� �� 2');
  Writeln('   2. "������ �����": ����� ����� �������� �������� ��� ����� �� ������ ������ ��'+#13#10+'      ������������� ��� ����� �� ������ ���������. ��� ���� �������� ������� �� ��������� �'+#13#10+'      ����� ����� �� �����������');
  Writeln('10. ���������� ���� ����� ������� ������� ���� ����� ��������. ���������� ��� �����, �������'+#13#10+'   ������ ������� ����� �����');
  Writeln;
  Writeln('���� �� ������������ � ���������, ������� ENTER...');
  Writeln;
  Readln;
end;

procedure Language; //����� �����
begin
  repeat
    Writeln;
    Writeln('=== �������� ���� (eng - ����������, rus - �������) ===');
    Writeln;
    Readln(Lang);
    Writeln;
    if Lang='eng' then Writeln('=== ������ ���������� ���� ===')
      else if Lang='rus' then Writeln('=== ������ ������� ���� ===')
        else Writeln('=== ������ ����� (�������� ����) ===');
  until (Lang='eng') or (Lang='rus');
  Writeln;
  Writeln('������� ENTER...');
  Readln;
end;

procedure NamePlayers; //���� �������
begin
  repeat
    Writeln;
    Writeln('=== ������� ���������� ������� ===');
    Writeln;
    Readln(N);
    Writeln;
    if (N>10) or (N<1) then Writeln('=== ������ ����� (�������� ���������� ������� ===')
      else Writeln('=== ���������� ',N,' ������(-��) ===');
  until (N<=10) and (N>=1);
  Writeln;
  Writeln('=== ������� ���� ����� ===');
  Writeln;
  for I := 1 to N do
  begin
    Write(I,'. ');
    Readln(NameTemp);
    Name[I] := NameTemp;
  end;
  Writeln;
  Writeln('������� ENTER...');
  Readln;
end;

procedure Monitor; //��������� ������
begin
  Writeln('=========================================================����� ',i,'=======================================================');
  Writeln;
  Writeln('=== ��� ����� ���� ===');
  Writeln(' _______________________________________ ');
  for I := 1 to 10 do Write('| t ');
  Write('|');
  Writeln;
  Writeln('|___|___|___|___|___|___|___|___|___|___|');
  Writeln;
  Writeln('������� ENTER...');
  Writeln;
  Readln;
end;

procedure clrscr; //������� �������
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

begin
  ShowRules;
  clrscr;
  Language;
  clrscr;
  NamePlayers;
  clrscr;
  Monitor;
  clrscr;
  Readln;
end.