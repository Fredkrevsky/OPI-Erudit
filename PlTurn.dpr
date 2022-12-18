program PlTurn;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const
  MaxPlayerCount = 10;
  WordsCount = 80000;

type
  TLanguage = (Russian, English);
  TDict = array [1 .. WordsCount] of string;
  TPlayersNames = array [1 .. MaxPlayerCount] of string;
  TPlayersScore = array [1 .. MaxPlayerCount] of integer;
  TLettersSets = array [1 .. MaxPlayerCount] of string;

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

  i: integer;

function LangChoose(): TLanguage;
var
  Lang: SmallInt;
  Ent: boolean;
begin
  Ent := false;
  writeln('����������, �������� ���� ������������� ��������.');
  write('��� ����� ������� 1, ���� ������ ������� �������, ��� 2, ���� ������ ����������: ');
  repeat
    readln(Lang);
    case Lang of
      1:
        begin
          Result := Russian;
          Ent := true;
        end;
      2:
        begin
          Result := English;
          Ent := true;
        end;
    else
      write('������������ ����. ��������� �������: ');
    end;
  until Ent;

  { optional message
    can be removed }
  write('��������� �������: ');
  case Result of
    Russian:
      writeln('�������');
    English:
      writeln('����������');
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
  while (Length(Playfield) > 0) and
    (MaxLettersCount - Length(LettersSet) > 0) do
  begin
    ltrPos := random(Length(Playfield)) + 1;
    Insert(Playfield[ltrPos], LettersSet, 1);
    Delete(Playfield, ltrPos, 1);
  end;

  Sleep(500);
  writeln('-----------------------------------------');
end;

procedure PlayerTurn(Language: TLanguage; var Dict: TDict; var FramePos: integer; Playfield: string; LettersSet: string; PlayerScore: integer; const PlayersCount: SmallInt);
var
  Alphabet, PlayerWord, AddWord, TempSet: string;
  i: integer;
  Points: byte;
  Ent, RightLetters, Found, Agree: boolean;
begin
  case Language of
    Russian:
      Alphabet := '��������������������������������';
    English:
      Alphabet := 'bcdfghjklmnpqrstvwxzaeiouy';
  end;

  write('������� ���� �����: ');
  repeat
    readln(PlayerWord);

    PlayerWord := Trim(LowerCase(PlayerWord));
    Ent := true;
    i := 1;
    while Ent and (i <= Length(PlayerWord)) do
      if Pos(PlayerWord[i], Alphabet) = 0 then
      begin
        Ent := false;
        write('������������ ����. ������� ����� ��� ���: ');
      end
      else
        Inc(i);

  until Ent;

  Points := Length(PlayerWord);
  TempSet := LettersSet;

  i := 1;
  RightLetters := true;
  while RightLetters and (i <= Length(PlayerWord)) do
  begin                                             // writeln(i);
    if Pos(PlayerWord[i], LettersSet) = 0 then
      RightLetters := false
    else
    begin
      Delete(LettersSet, Pos(PlayerWord[i], LettersSet), 1);
      Inc(i);
    end;
  end;
                                                          // writeln(RightLetters);
  if not RightLetters then
  begin
    Dec(PlayerScore, Points);
    writeln('���� ����� �������. ���������� ����� ����� ����������� �� ', Points, ' � ������ ���������� ', PlayerScore);
    LettersSet := TempSet;
  end
  else
  begin
    Found := false;
    i := 1;
    while (not Found) and (i < FramePos) do
    begin
      // writeln('Word: ', CurrWord);
      if PlayerWord = Dict[i] then
        Found := true
      else
        Inc(i);
    end;

    if not Found then
    begin
      writeln('������ ����� ��� � �������. ���� �������� �������� ������� �� ���������� ��� � �������.');
      i := 1;
      while Agree and (i <= PlayersCount) do
      begin
        write(i, '-� ����� (��/���): ');
        repeat
          readln(AddWord);
          Ent := true;

          if (AddWord = '��') or (AddWord = 'yes') or (AddWord = 'y') or (AddWord = '�') then
            Inc(i)
          else if (AddWord = '���') or (AddWord = 'no') or (AddWord = 'n') or (AddWord = '�') then
            Agree := false
          else
          begin
            Ent := false;
            write('������������ ����. ��������� ������� (��/���): ');
          end;
        until Ent;
      end;

      if Agree then
      begin
        Dict[FramePos] := PlayerWord;
        Inc(FramePos);
        Inc(PlayerScore, Points);
        writeln('������ ���� ����� �����! ���������� ����� ����� ������������ �� ', Points, ' � ������ ���������� ', PlayerScore);

        FillLettersSet(Playfield, LettersSet);
      end
      else
      begin
        Dec(PlayerScore, Points);
        writeln('������, ���� ����� �������. ���������� ����� ����� ����������� �� ', Points, ' � ������ ���������� ', PlayerScore);
        LettersSet := TempSet;
      end;
    end
    else
    begin
      Inc(PlayerScore, Points);
      writeln('���� ����� �����! ���������� ����� ����� ������������ �� ', Points, ' � ������ ���������� ', PlayerScore);

      FillLettersSet(Playfield, LettersSet);
    end;

  end;

end;

begin
  Language := LangChoose();

  { choosing players here }

  { filling playfield of letters }
  FillPlayfield(Playfield, Language);

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
    writeln('������ ', i, '-�� ������: ', LettersSet[i]);
  end;

  PlayerTurn(Language, Dict, FramePos, Playfield, LettersSet[2], PlayerScore[2], PlayersCount);

  writeln('����� ����� ���������');
  readln;

end.
