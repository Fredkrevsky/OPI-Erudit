program Game;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

const
  MaxPlayerCount = 10;

type
  TLanguage = (Russian, English);
  TPlayersScore = array [1 .. MaxPlayerCount] of integer;
  TLettersSets = array [1 .. MaxPlayerCount] of string;
  TPlayersNames = array [1 .. MaxPlayerCount] of string;
  TSkip = array [1 .. MaxPlayerCount] of boolean;

var
  I, J, Choice, Position, Max, Temp : integer;
  Skip : TSkip;
  LettersSet: TLettersSets;
  PlayerScore: TPlayersScore;
  PlayerName: TPlayersNames;
  PlayersCount: SmallInt = 5;
  Language: TLanguage;
  NameTemp, Playfield: string;
  fl, endgame : boolean;

procedure clrscr; //������� �������
var
  cursor: COORD;
  r: cardinal;
begin
  r := 120;       //120
  cursor.X := 0;
  cursor.Y := Position;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
  cursor.X := 0;
  cursor.Y := Position;
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

procedure ShowRules; //������� ����
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
  Sleep(3000);
end;

procedure ChoiceOfLanguage; //����� �����
begin
  repeat
    try
      Writeln;
      Writeln('===*  �������� ���� (1 - �������, 2 - ����������)  *===');
      Writeln;
      Readln(I);
      Writeln;
      if I=1 then
      begin
        Language := Russian;
        Writeln('===*  ������ ������� ����  *===');
      end
        else if I=2 then
        begin
          Language := English;
          Writeln('===*  ������ ���������� ����  *===');
        end
          else Writeln('===*  ������ �����  *===');
    except
      Writeln;
      Writeln('===*  ������ �����  *===');
    end;
    until (I=1) or (I=2);
  Writeln;
  Writeln('������� ENTER...');
  Readln;
end;

procedure NamePlayers; //���� �������
var
  I : integer;
begin
  Writeln;
  Writeln('===*  ������� ���������� �������  *===');
  Writeln;
  repeat
    try
      Readln(PlayersCount);
      if (PlayersCount>10) or (PlayersCount<=1) then
        begin
          Writeln;
          Writeln('===*  ������ �����  *===');
        end
        else
        begin
          Writeln;
          Writeln('===*  ���������� ',PlayersCount,' ������(-��)  *===');
        end;
      Writeln;
    except
      Writeln;
      Writeln('===*  ������ �����  *===');
      Writeln;
    end;
  until (PlayersCount<=10) and (PlayersCount>1);
  Writeln;
  Writeln('===*  ������� ���� �����  *===');
  Writeln;
  for I := 1 to PlayersCount do
  begin
    repeat
      Write(I,'. ');
      Readln(NameTemp);
      NameTemp := Trim(NameTemp);
      PlayerName[I] := NameTemp;
      fl := true;
      J := 1;
      while (J<=I-1) and fl do
      begin
        if PlayerName[I]=PlayerName[J] then fl := false;
        inc(J);
      end;
      if not fl then
      begin
        Writeln;
        Writeln('===*  ������ ��� ��� ������!  *===');
        Writeln;
      end;
    until fl;
  end;
  Writeln;
  Writeln('������� ENTER...');
  Readln;
end;

procedure FillPlayfield (var Playfield: string; Language: TLanguage);
const
  RusABCConsonants = '�����������������������';
  RusABCVowels = '���������';
  EngABCConsonants = 'bcdfghjklmnpqrstvwxz';
  EngABCVowels = 'aeiouy';
var
  i: integer;
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
  writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure FifByFif(var Playfield, LettersSet: string; var PlayerScore: integer);
const
  ChangesCount: SmallInt = 5;
  Penalty: SmallInt = 2;
var
  EntSet, TempSet: string;
  i, counter, ltrPos: SmallInt;
  Ent, InputError: boolean;
begin
  writeln;
  writeln('���� �����: ', LettersSet);
  write('������� �� �����, ������� ������ ��������: ');
  TempSet := LettersSet;
  repeat
    readln(EntSet);
    counter := 0;
    LettersSet := TempSet;
    InputError := false;
    i := 1;
    while (InputError = false) and (i <= Length(EntSet)) do
    begin
      ltrPos := Pos(EntSet[i], LettersSet, 1);
      if (counter < ChangesCount) and (ltrPos <> 0) then
      begin
        Inc(i);
        Delete(LettersSet, ltrPos, 1);
        Inc(counter);
      end
      else
        case EntSet[i] of
          ';', ',', ' ': inc(i);
          else
            InputError := true;
        end;
    end;
    if InputError then
    begin
      write('�� �������� ��� �����. ������� ����� ��� ���: ');
      Ent := false;
    end
    else if counter < ChangesCount then
    begin
      Ent := false;
      write('�� ����� ������������ ����. ������� ����� ��� ���: ');
    end
    else if counter > ChangesCount then
    begin
      Ent := false;
      write('�� ����� ������� ����� ����. ������� ����� ��� ���: ');
    end
    else
      Ent := true;
  until Ent;
  writeln('����a� �������: ', EntSet);
  writeln('���������� ������: ', LettersSet);
  Dec(PlayerScore, Penalty);
  writeln('���-�� ����� ����� ��������� �� ', Penalty, ' � ������ ���������� ', PlayerScore);
  FillLettersSet(Playfield, LettersSet);
  writeln('���� ����� ������: ', LettersSet);
  Sleep(500);
  writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure FriendHelp(LettersSet: TLettersSets; MyNumber: SmallInt; const MaxPlayerCount: SmallInt);
const
  ABC = '��������������������������������bcdfghjklmnpqrstvwxzaeiouy������������������������Ũ�������BCDFGHJKLMNPQRSTVWXZAEIOUY';
var
  Ent: boolean;
  FriendNumber, j, MyP, FrP: SmallInt;
  MyLetter, FriendLetter: string;
begin
  writeln;
  writeln('���� �����: ', LettersSet[MyNumber]);
  write('�������� ����� ������, � �������� �� ������ �������� �����: ');
  repeat
    Ent := false;
    readln(FriendNumber);
    if (FriendNumber <= 0) or (FriendNumber > MaxPlayerCount) then
      write('����������� ����� ������. ������� ����� ��� ���: ')
    else if FriendNumber = MyNumber then
      write('�� �� ������ ����� ����� � ������ ����. ������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;
  writeln('��� �����: ', LettersSet[FriendNumber]);
  write('�������� ���� �����, ������� ������ ������: ');
  repeat
    Ent := false;
    readln(MyLetter);
    j := 1;
    while j <= length(MyLetter) do
      if MyLetter[j] = ' ' then
        Delete(MyLetter, j, 1)
      else
        Inc(j);
    if Length(MyLetter) > 1 then
      write('�� ����� ������, � �� �����. �������� ����� ��� ���: ')
    else if Length(MyLetter) = 0 then
      write('�� �� ����� �� ����� �����. �������� ����� ��� ���: ')
    else if Pos(MyLetter, ABC) = 0 then
      write('��� �� �����. �������� ����� ��� ���: ')
    else if Pos(MyLetter, LettersSet[MyNumber]) = 0 then
      write('����� ����� ��� ����� ����� ����. �������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;
  write('�������� ����� �����, ������� ������ �������: ');
  repeat
    Ent := false;
    readln(FriendLetter);
    j := 1;
    while j <= length(FriendLetter) do
      if FriendLetter[j] = ' ' then
        Delete(FriendLetter, j, 1)
      else
        Inc(j);
    if Length(FriendLetter) > 1 then
      write('�� ����� ������, � �� �����. �������� ����� ��� ���: ')
    else if Length(FriendLetter) = 0 then
      write('�� �� ����� �� ����� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, ABC) = 0 then
      write('��� �� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, LettersSet[FriendNumber]) = 0 then
      write('����� ����� ��� ����� ���� �����. �������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;
  MyP := Pos(MyLetter, LettersSet[MyNumber]);
  FrP := Pos(FriendLetter, LettersSet[FriendNumber]);
  Insert(Myletter, LettersSet[FriendNumber], FrP);
  Insert(Friendletter, LettersSet[MyNumber], MyP);
  Delete(LettersSet[FriendNumber], FrP + 1, 1);
  Delete(LettersSet[MyNumber], MyP + 1, 1);
  writeln('������ ���� �����: ', LettersSet[MyNumber]);
  writeln('������ ��� �����: ', LettersSet[FriendNumber]);
  Sleep(500);
  Writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure PlayerTurn(Language: TLanguage; var Playfield: string; var LettersSet: string; var PlayerScore: integer);
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
  Writeln;
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
  i := 1;
  RightLetters := true;
  while RightLetters and (i <= length(PlayerWord)) do
  begin                                               //writeln(i);
    if Pos(PlayerWord[i], LettersSet) = 0 then
      RightLetters := false
    else
    begin
      Delete(LettersSet, Pos(PlayerWord[i], LettersSet), 1);
      Inc(i);
    end;
  end;
  if not RightLetters then
  begin
    Dec(PlayerScore, Points);
    writeln('���� ����� �������. ���������� ����� ����� ����������� �� ', Points,' � ������ ���������� ', PlayerScore);
    LettersSet := TempSet;
  end
  else
  begin
    if Language = Russian then
      AssignFile(Dictionary, 'D:\BSUIR\ERUDIT\dictionaries\russian.txt')
    else
      AssignFile(Dictionary, 'D:\BSUIR\ERUDIT\dictionaries\english.txt');
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
          Dict[FramePos] := PlayerWord;
          Inc(FramePos);
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

procedure Monitor; //��������� ������
begin
  Choice := 0;
  Writeln('======================================================*  ����� ',i,'  *====================================================');
  Writeln;
  Writeln('������� ���������� �����: ',PlayerScore[I]);
  Writeln;
  Skip[I] := false;
  repeat
    Writeln('===*  ��� ������?  *===');
    Writeln;
    Writeln('---> ������ ����� (1)');
    Writeln('---> 50-��-50 (2)');
    Writeln('---> ������ ����� (3)');
    Writeln('---> ������� ���� (4)');
    //Writeln('---> ����� �� ��������� (5) - ���� �� ��������');
    repeat
      try
        Writeln;
        Readln(Choice);
        Writeln;
        if (Choice<1) or (Choice>4) then
        begin
          Writeln;
          Writeln('===*  ������ �����  *===');
          Writeln;
        end;
      except
        Writeln;
        Writeln('===*  ������ �����  *===');
        Writeln;
      end;
    until (Choice>=1) and (Choice<=4);
    Position := 7;
    clrscr;
    fl := true;
    case Choice of
      1 : begin PlayerTurn(Language,Playfield,LettersSet[I],PlayerScore[I]);
          Position := 0; end;
      2 : begin FifByFif(Playfield,LettersSet[I],PlayerScore[I]);
          Position := 0; end;
      3 : begin FriendHelp(LettersSet, i, MaxPlayerCount);
          Position := 0; end;
      4 : begin Skip[I] := true;
          Position := 0; end;
      else
      fl := false;
      Writeln;
      Writeln('===*  ������ �����  *===');
      Writeln;
    end; //����� ����� ������������
  until fl;
  Writeln;
  Writeln('������� ENTER...');
  Writeln;
  Readln;
end;

begin
  randomize;
  Position := 0;
  ShowRules;
  clrscr;
  ChoiceOfLanguage;
  clrscr;
  NamePlayers;
  clrscr;
  FillPlayfield(Playfield,Language);
  I := 1;
  repeat
    endgame := true;
    for J := 1 to PlayersCount do
    begin
      FillLettersSet(Playfield, LettersSet[J]);
      writeln('������ ������ ',PlayerName[J],' : ', LettersSet[J]);
    end;
    Monitor;
    clrscr;
    for J := 1 to PlayersCount do
      if Skip[J]=false then endgame := false;
    inc(I);
    if I=PlayersCount+1 then I := 1;
  until endgame;
  Writeln('======================================================*  ������  *=====================================================');
  Writeln;
  Writeln('======================================================*  �����   *=====================================================');
  Writeln;
  for I := 1 to PlayersCount do
  begin
    Sleep(1000);
    Writeln(I,' ����� � ������ ', PlayerName[I],' ������� ',PlayerScore[I]);
  end;
  Max := 1;
  for I := 1 to PlayersCount do
    if PlayerScore[I] > PlayerScore[Max] then Max := I;
  Sleep(1000);
  Writeln;
  Writeln('-----------------------------------------------------------------------------------------------------------------------');
  Writeln;
  Sleep(1000);
  Writeln('������� ',Max,'-� ����� � ������ ',PlayerName[Max],', �����������!');
  Readln;
end.
