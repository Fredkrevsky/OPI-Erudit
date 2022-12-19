program FHelp;

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
  PlayersCount: word = 5;
  PlayerName: TPlayersNames;
  PlayerScore: TPlayersScore;
  LettersSet: TLettersSets;

  Playfield: string;

  i: integer;

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
  while (Length(Playfield) > 0) and (MaxLettersCount - length(LettersSet) > 0) do
  begin
    ltrPos := random(Length(Playfield)) + 1;
    Insert(Playfield[ltrPos], LettersSet, 1);
    Delete(Playfield, ltrPos, 1);
  end;

  Sleep(500);
  writeln('-----------------------------------------');
end;

procedure FriendHelp(LettersSet: TLettersSets; PlayerNumber: SmallInt; const PlayerCount: SmallInt);
const
  ABC = '��������������������������������bcdfghjklmnpqrstvwxzaeiouy';
var 
  Ent: boolean;
  FriendNumber, j, MyP, FrP: SmallInt;
  MyLetter, FriendLetter, Temp: string;
begin
  writeln('���� �����: ', LettersSet[PlayerNumber]);

  write('�������� ����� ������, � �������� �� ������ �������� �����: ');
  repeat
    Ent := false;
    try
      readln(FriendNumber);
    except
      FriendNumber := 0;
    end;
    if (FriendNumber <= 0) or (FriendNumber > PlayerCount) then
        write('����������� ����� ������. ������� ����� ��� ���: ')
      else if FriendNumber = PlayerNumber then
        write('�� �� ������ ����� ����� � ������ ����. ������� ����� ��� ���: ')
      else
        Ent := true;
  until Ent;

  writeln('��� �����: ', LettersSet[FriendNumber]);

  write('�������� ���� �����, ������� ������ ������: ');
  repeat
    Ent := false;
    readln(MyLetter);
    MyLetter := LowerCase(Trim(MyLetter));

    if Length(MyLetter) > 1 then
      write('�� ����� ������, � �� �����. �������� ����� ��� ���: ')
    else if Length(MyLetter) = 0 then
      write('�� �� ����� �� ����� �����. �������� ����� ��� ���: ')
    else if Pos(MyLetter, ABC) = 0 then
      write('��� �� �����. �������� ����� ��� ���: ')
    else if Pos(MyLetter, LettersSet[PlayerNumber]) = 0 then
      write('����� ����� ��� ����� ����� ����. �������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;

  write('�������� � ����� �����, ������� ������ �������: ');
  repeat
    Ent := false;
    readln(FriendLetter);
    MyLetter := LowerCase(Trim(MyLetter));

    if Length(FriendLetter) > 1 then
      write('�� ����� ������, � �� �����. �������� ����� ��� ���: ')
    else if Length(FriendLetter) = 0 then
      write('�� �� ����� �� ����� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, ABC) = 0 then
      write('��� �� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, LettersSet[FriendNumber]) = 0 then
      write('����� ����� ��� ����� ���� �����. �������� ����� ��� ���: ')
    else if MyLetter = FriendLetter then
      write('�� ������ �������� ���� ����� �� ����� �� �����. �������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;

  MyP := Pos(MyLetter, LettersSet[PlayerNumber]);
  FrP := Pos(FriendLetter, LettersSet[FriendNumber]);
  Insert(Myletter, LettersSet[FriendNumber], FrP);
  Insert(Friendletter, LettersSet[PlayerNumber], MyP);
  Delete(LettersSet[FriendNumber], FrP + 1, 1);
  Delete(LettersSet[PlayerNumber], MyP + 1, 1);

  writeln('������ ���� �����: ', LettersSet[PlayerNumber]);
  writeln('������ ��� �����: ', LettersSet[FriendNumber]);

  Sleep(500);
  writeln('-----------------------------------------');
  writeln;

end;

begin
  Language := Russian;
  FillPlayfield(Playfield, Language);

  LettersSet[1] := '����������'; LettersSet[2] := '����������';

  FriendHelp(LettersSet, 1, PlayersCount);

  writeln('����� ����� ���������');
  readln;
end.
