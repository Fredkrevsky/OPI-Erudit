program PlTurn;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const
  MaxPlayerCount = 10;

type
  TLanguage = (Russian, English);

  TPlayersNames = array [1 .. MaxPlayerCount] of string;
  TPlayersScore = array [1 .. MaxPlayerCount] of integer;
  TLettersSets = array [1 .. MaxPlayerCount] of string;

var
  Language: TLanguage;
  PlayersCount: SmallInt = 5;
  PlayerName: TPlayersNames;
  PlayerScore: TPlayersScore;
  LettersSet: TLettersSets;

  Playfield: string;

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

procedure PlayerTurn(Language: TLanguage; Playfield: string; LettersSet: string; PlayerScore: integer);
const StrsCount = 80000;
type
  TDict = array [1..StrsCount] of string;
var
  Dictionary: text;
  Dict: TDict;

  PlayerWord, AddWord, TempSet: string;
  i, FramePos, CurrPos: integer;
  Points: byte;
  Ent, RightLetters, Found: boolean;

begin
  write('������� �����: ');
  repeat
    readln(PlayerWord);

    PlayerWord := Trim(PlayerWord);
    Ent := true;
    i := 1;
    while Ent and (i <= length(PlayerWord)) do
      if Pos(PlayerWord[i], Playfield) = 0 then
      begin
        Ent := false;
        write('������������ ����. ������� ����� ��� ���: ');
      end
      else  
        Inc(i);

  until Ent;

  Points := Length(PlayerWord);
  TempSet := LettersSet;

  i := 1; RightLetters := true;
  while RightLetters and (i <= length(PlayerWord)) do
  begin                                               writeln(i);
    if Pos(PlayerWord[i], LettersSet) = 0 then
      RightLetters := false
    else
    begin
      Delete(LettersSet, Pos(PlayerWord[i], LettersSet), 1);
      Inc(i);
    end;
  end;
                                              writeln(RightLetters);
  if not RightLetters then
  begin 
    Dec(PlayerScore, Points);
    writeln('���� ����� �������. ���������� ����� ����� ����������� �� ', Points,' � ������ ���������� ', PlayerScore);
    LettersSet := TempSet;
  end
  else
  begin
    if Language = Russian then
      AssignFile(Dictionary, '.\dictionaries\russian.txt')
    else 
      AssignFile(Dictionary, '.\dictionaries\english.txt');

    Reset(Dictionary);
    FramePos := 1;
    while not Eof(Dictionary) do
    begin
      readln(Dictionary, Dict[FramePos]);
      Inc(FramePos);
    end;                                                       //    writeln(FramePos);

    Found := false;
    i := 1;
    while (not Found) and (i < FramePos) do
    begin
    //  CurrWord := '';
                                                                     // writeln('Word: ', CurrWord);
      if PlayerWord = Dict[i] then 
        Found := true
      else
        Inc(i);
    end;
    
  
    if not Found then
    begin
      write('������ ����� ��� � �������. ������� �������� ��� � ������� (��/���)? ');
      repeat
        readln(AddWord);
        Ent := true;

        if AddWord = '��' then
        begin
          Dict[i] := PlayerWord;
          Inc(i); 
          Inc(PlayerScore, Points);
          writeln('������ ���� ����� �����! ���������� ����� ����� ������������ �� ', Points,' � ������ ���������� ', PlayerScore);

          FillLettersSet(Playfield, LettersSet);

          Close(Dictionary);
        end
        else if AddWord = '���' then
        begin
          Dec(PlayerScore, Points);
          writeln('������, ���� ����� �������. ���������� ����� ����� ����������� �� ', Points,' � ������ ���������� ', PlayerScore);
          LettersSet := TempSet;
        end
        else 
        begin
          Ent := false;
          write('������������ ����. ��������� ������� (��/���): ');
        end;
      until Ent;
    end
    else
    begin
      Inc(PlayerScore, Points);
      writeln('���� ����� �����! ���������� ����� ����� ������������ �� ', Points,' � ������ ���������� ', PlayerScore);

      FillLettersSet(Playfield, LettersSet);

    end;

  end;

end;

begin
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

  PlayerTurn(Language, Playfield, LettersSet[2], PlayerScore[2]);

  writeln('����� ����� ���������');
  readln;
end.
