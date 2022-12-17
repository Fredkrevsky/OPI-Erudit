program game;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  MaxPlayerCount = 10;

type
  TLanguage = (Russian, English);

  TPlayersNames = array [1..MaxPlayerCount] of string;
  TPlayersScore = array [1..MaxPlayerCount] of integer;
  TLettersSets = array [1..MaxPlayerCount] of string;

var
  Language: TLanguage;
  PlayersCount: SmallInt = 5;
  PlayerName: TPlayersNames;
  PlayerScore: TPlayersScore;
  LettersSet: TLettersSets;

  Playfield: string;

  i: integer;

procedure ShowLogo();
var
  Logo: text;
  LogoString: string;
begin
  AssignFile(Logo, 'D:\Users\pud70\Desktop\AAASSSDAASAAA\����\LAB8 GAME\dictionaries\logo.txt');
  Reset(Logo);
  while not Eof(Logo) do
  begin
    Readln(Logo, LogoString);
    Writeln(LogoString);
    Sleep(100);
  end;  
end;


function LangChoose(): TLanguage;
var Lang: SmallInt;
    Ent: boolean;
begin
  Ent := false;
  writeln('����������, �������� ���� ������������� ��������.');
    write('��� ����� ������� 1, ���� ������ ������� �������, ��� 2, ���� ������ ����������: ');
  repeat
    readln(Lang);
    case Lang of
    1: begin
         Result := Russian;
         Ent := true;
       end;
    2: begin
         Result := English;
         Ent := true;
       end;
    else
      write('������������ ����. ��������� �������: ');
    end;
  until Ent;

  {optional message
    can be removed}
  write('��������� �������: ');
  case Result of
    Russian: writeln('�������');
    English: writeln('����������');
  end;

  Sleep(500);
  writeln('-----------------------------------------');
  writeln;
end;

procedure FillPlayfield(var Playfield: string; Language: TLanguage);
const
  RusABCConsonants = '�����������������������';
  RusABCVowels = '���������';
  EngABCConsonants = 'bcdfghjklmnpqrstvwxz';
  EngABCVowels = 'aeiouy';
var
  i: byte;
begin
  case Language of
    Russian:
    begin
      for i := 1 to 4 do
        Playfield := Concat(Playfield, RusABCConsonants);
      for i := 1 to 8 do
        Playfield := Concat(Playfield, RusABCVowels);
    end;
    English:
    begin
      for i := 1 to 4 do
        Playfield := Concat(Playfield, EngABCConsonants);
      for i := 1 to 8 do
        Playfield := Concat(Playfield, EngABCVowels);
    end;
  end;
end;

procedure FillLettersSet(var Playfield: string; var LettersSet: string);
const
  MaxLettersCount = 10;
var
  ltrPos: integer;

begin
  while MaxLettersCount - length(LettersSet) > 0 do
  begin
    ltrPos := random(Length(Playfield)) + 1;
    Insert(Playfield[ltrPos], LettersSet, 1);
    Delete(Playfield, ltrPos, 1);
  end;

  Sleep(500);
  writeln('-----------------------------------------');
end;

begin
  ShowLogo();
  Language := LangChoose();

  { choosing players here }

  { filling playfield of letters }
  FillPlayfield(Playfield, Language);

  { giving a player a set of letters }
  for i := 1 to PlayersCount do
  begin
    FillLettersSet(Playfield, LettersSet[i]);
    writeln('������ ',i, '-�� ������: ', LettersSet[i]);
  end;

  { 50 by 50 }


  writeln('����� ����� ���������');
  readln;
end.
