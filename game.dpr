program game;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  MaxPlayerCount = 10;
  WordsCount = 80000;

type
  TLanguage = (Russian, English);
  TDict = array [1..WordsCount] of string;
  TPlayersNames = array [1..MaxPlayerCount] of string;
  TPlayersScore = array [1..MaxPlayerCount] of integer;
  TLettersSets = array [1..MaxPlayerCount] of string;

var
  Language: TLanguage;
  Dictionary: text;
  Dict: TDict;
  FramePos: integer;

  PlayersCount: SmallInt = 5;
  PlayerName: TPlayersNames;
  PlayerScore: TPlayersScore;
  LettersSet: TLettersSets;

  Playfield: string;
  LettersCount: integer;

  i: integer;

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

procedure FillPlayfield(var Playfield: string; Language: TLanguage; var LettersCount: integer);
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
      LettersCount := Length(Playfield);
    end;
    English:
    begin
      for i := 1 to 4 do
        Playfield := Concat(Playfield, EngABCConsonants);
      for i := 1 to 8 do
        Playfield := Concat(Playfield, EngABCVowels);
      LettersCount := Length(Playfield);
    end;
  end;
end;

procedure FillLettersSet(var Playfield: string; var LettersSet: string);
const
  MaxLettersCount = 10;
var
  ltrPos: integer;

begin
  while (Length(Playfield) > 0) and (MaxLettersCount - length(LettersSet) > 0) do
  begin
    ltrPos := random(Length(Playfield)) + 1;
    Insert(Playfield[ltrPos], LettersSet, 1);
    Delete(Playfield, ltrPos, 1);
  end;

  Sleep(500);
  writeln('-----------------------------------------');
end;

begin
  Language := LangChoose();

  { choosing players here }

  { filling playfield of letters }
  LettersCount := 0;
  FillPlayfield(Playfield, Language, LettersCount);

  {reading a dictionary}
  case Language of
    Russian: AssignFile(Dictionary, '.\dictionaries\russian.txt');
    English: AssignFile(Dictionary, '.\dictionaries\english.txt');
  end;
  Reset(Dictionary);
  FramePos := 1;
  while not Eof(Dictionary) do
  begin
    readln(Dictionary, Dict[FramePos]);
    Inc(FramePos);
  end;

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
