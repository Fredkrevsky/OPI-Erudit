program EruditGame;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

const
  MaxPlayerCount = 10;
  MaxLettersCount = 10;
  ChangesCount = 5;

  WordsCount = 80000;

type
  TLanguage = (Russian, English);
  TDict = array [1 .. WordsCount] of string;
  TPlayersScore = array [1 .. MaxPlayerCount] of integer;
  TLettersSets = array [1 .. MaxPlayerCount] of string;
  TPlayersNames = array [1 .. MaxPlayerCount] of string;
  TSkip = array [1 .. MaxPlayerCount] of boolean;
  TChoiceHelp = array [1 .. MaxPlayerCount] of boolean;
  TChoiceFifByFif = array [1 .. MaxPlayerCount] of boolean;

var
  I, J, Choice, Position, Max, k : integer;
  ChoiceHelp : TChoiceHelp;
  ChoiceFifByFif : TChoiceFifByFif;
  Skip : TSkip;
  Dictionary: text;
  Dict: TDict;
  StartFramePos, FramePos: integer;
  LettersSet: TLettersSets;
  PlayerScore: TPlayersScore;
  PlayerName: TPlayersNames;
  PlayersCount: SmallInt = 5;
  Language: TLanguage;
  NameTemp, Playfield: string;
  fl, endgame : boolean;
  LastLetter: char;

procedure clrscr(var Position : integer); //������� �������
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

procedure ChoiceOfLanguage(var Language : TLanguage); //����� �����
var
  s : string;
  ChoiceLanguage, c : integer;
begin
  repeat
    repeat
      Writeln;
      Writeln('===*  �������� ���� (1 - �������, 2 - ����������)  *===');
      Writeln;
      Write('��� �������: ');
      Readln(s);
      s := trim(s);
      Writeln;
      val(s,ChoiceLanguage,c);
      if c <> 0 then Writeln('===*  ������ �����  *===');
    until c = 0;
    if ChoiceLanguage = 1 then
    begin
      Language := Russian;
      Writeln('===*  ������ ������� ����  *===');
    end
    else if ChoiceLanguage = 2 then
      begin
        Language := English;
        Writeln('===*  ������ ���������� ����  *===');
      end
      else Writeln('===*  ������ �����  *===');
  until (ChoiceLanguage = 1) or (ChoiceLanguage = 2);
  Writeln;
  Writeln('������� ENTER...');
  Readln;
end;

procedure NamePlayers(var PlayersCount: SmallInt; const MaxPlayerCount: SmallInt); //���� �������
var
  I, c : integer;
  s : string;
begin
  repeat
    repeat
      Writeln;
      Writeln('===*  ������� ���������� �������  *===');
      Writeln;
      Write('��� �������: ');
      Readln(s);
      s := trim(s);
      Writeln;
      val(s,PlayersCount,c);
      if c <> 0 then Writeln('===*  ������ �����  *===');
    until c = 0;
    if (PlayersCount <= 1) or (PlayersCount > MaxPlayerCount) then Writeln('===*  ������ �����  *===');
  until (PlayersCount<=MaxPlayerCount) and (PlayersCount>1);
  Writeln('===*  ��������� ',PlayersCount,' ������(-��)  *===');
  Writeln;
  Writeln('===*  ������� ���� �����  *===');
  Writeln;
  for I := 1 to PlayersCount do
  begin
    repeat
      repeat
        Write(I,'. ');
        Readln(NameTemp);
        NameTemp := Trim(NameTemp);
        if NameTemp<>'' then PlayerName[I] := NameTemp
        else Writeln('������� ���� ���-������');
      until NameTemp<>'';
      fl := true;
      J := 1;
      while (J<=I-1) and fl do
      begin
        if AnsiLowerCase(PlayerName[I])=AnsiLowerCase(PlayerName[J]) then fl := false;
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

procedure FillLettersSet(var Playfield, LettersSet: string);
const MaxLettersCount = 10;
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
  writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure FifByFif(var Playfield, LettersSet: string; const ChangesCount: byte; var PlayerScore: integer);
const
  Penalty = 2;
var
  EntSet, TempSet: string;
  i, counter, ltrPos: SmallInt;
  Ent, InputError: boolean;
begin
  writeln;
//  writeln('���� �����: ', LettersSet);
  write('������� 5 ����, ������� ������ ��������: ');
  TempSet := LettersSet;
  repeat
    readln(EntSet);
    EntSet := AnsiLowerCase(EntSet);                          // writeln(entset);
    counter := 0;
    LettersSet := TempSet;
    InputError := false;
    i := 1;
    while (InputError = false) and (i <= Length(EntSet)) do
    begin
      ltrPos := Pos(EntSet[i], LettersSet);
      if (counter <= ChangesCount) and (ltrPos <> 0) then
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
    else if Length(EntSet) < 1 then
    begin
      write('�� ������ �� �����. ������� ����� ��� ���: ');
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
//  writeln('����a� �������: ', EntSet);
//  writeln('���������� ������: ', LettersSet);
  Dec(PlayerScore, Penalty);
  writeln('���-�� ����� ����� ��������� �� ', Penalty, ' � ������ ���������� ', PlayerScore);
  FillLettersSet(Playfield, LettersSet);
  writeln('���� ����� �����: ', LettersSet);
  Sleep(500);
  writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure FriendHelp(var LettersSet: TLettersSets; PlayerNumber: SmallInt; const PlayerCount: SmallInt);
const
  ABC = '��������������������������������bcdfghjklmnpqrstvwxzaeiouy';
var
  Ent: boolean;
  FriendNumber, MyP, FrP: SmallInt;
  MyLetter, FriendLetter: string;
begin
  writeln;
 // writeln('���� �����: ', LettersSet[PlayerNumber]);
  write('�������� ����� ������, � �������� �� ������ �������� �����: ');

  Ent := false;
  repeat
    try
      readln(FriendNumber);
    except
      FriendNumber := 0;
    end;
    if (FriendNumber <= 0) or (FriendNumber > PlayerCount) then
      write('����������� ����� ������. ������� ����� ��� ���: ')
    else if FriendNumber = PlayerNumber then
      write('�� �� ������ ����� ����� � ������ ����. ������� ����� ��� ���: ')
    else if Length(LettersSet[FriendNumber]) = 0 then
      write('� ����� ������ ������ ��� ����. ������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;

 // writeln('��� �����: ', LettersSet[FriendNumber]);
  write('�������� ���� �����, ������� ������ ������: ');

  Ent := false;
  repeat
    readln(MyLetter);
    MyLetter := AnsiLowerCase(Trim(MyLetter));
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

  write('�������� ����� ���������, ������� ������ �������: ');
  Ent := false;
  repeat
    readln(FriendLetter);
    FriendLetter := AnsiLowerCase(Trim(FriendLetter));
    if Length(FriendLetter) > 1 then
      write('�� ����� ������, � �� �����. �������� ����� ��� ���: ')
    else if Length(FriendLetter) = 0 then
      write('�� �� ����� �� ����� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, ABC) = 0 then
      write('��� �� �����. �������� ����� ��� ���: ')
    else if Pos(FriendLetter, LettersSet[FriendNumber]) = 0 then
      write('����� ����� ��� ����� ���� ���������. �������� ����� ��� ���: ')
    else if MyLetter = FriendLetter then
      write('�� ��������� �� �� �����, ��� � ������. �������� ����� ��� ���: ')
    else
      Ent := true;
  until Ent;

  MyP := Pos(MyLetter, LettersSet[PlayerNumber]);
  FrP := Pos(FriendLetter, LettersSet[FriendNumber]);
  Insert(Myletter, LettersSet[FriendNumber], FrP);
  Insert(Friendletter, LettersSet[PlayerNumber], MyP);
  Delete(LettersSet[FriendNumber], FrP + 1, 1);
  Delete(LettersSet[PlayerNumber], MyP + 1, 1);
  Sleep(450);
  Writeln('-----------------------------------------------------------------------------------------------------------------------');
  writeln('������ ���� �����: ', LettersSet[PlayerNumber]);
  writeln('������ ��� �����: ', LettersSet[FriendNumber]);
  Sleep(450);
  Writeln('-----------------------------------------------------------------------------------------------------------------------');
end;

procedure PlayerTurn(Language: TLanguage; var Dict: TDict; var FramePos: integer; var Playfield: string; CurrPlayer: SmallInt; var LettersSet: string; var PlayerScore: integer; var Skip: boolean; const PlayersCount: SmallInt; var LastLetter: char);
const MaxLettersCount = 10;
var
  Alphabet, PlayerWord, AddWord, TempSet: string;
  i, ltrPos: integer;
  Points: byte;
  Ent, RightLetters, Found, Agree: boolean;
begin
  Writeln; 
  case Language of
    Russian:
      Alphabet := '��������������������������������';
    English:
      Alphabet := 'bcdfghjklmnpqrstvwxzaeiouy';
  end;

  write('������� ���� ����� (������ ��� �������� ����): ');
  repeat
    readln(PlayerWord);
    PlayerWord := AnsiLowerCase(Trim(PlayerWord));                                                          // writeln(playerword);
    i := 1;
    Ent := true;

    if Length(PlayerWord) = 0 then
    begin
      writeln('��� ��������.');
      Sleep(180);
      Writeln('-----------------------------------------------------------------------------------------------------------------------');
      Skip := true;
    end
    else 
    begin
      repeat
        if (Pos(PlayerWord[i], Alphabet) = 0) then
        begin
          write('������������ ����. ������� ����� ��� ���: ');
          Ent := false;
        end
        else
          Inc(i);
      until (Ent = false) or (i > length(PlayerWord));

      if Ent then
        if Length(PlayerWord) = 1 then
        begin
          write('������� �������� �����. ������� ����� ��� ���: ');
          Ent := false;
        end
        else if Length(PlayerWord) > MaxLettersCount then
        begin  
          write('������� ������� �����. ������� ����� ��� ���: ');
          Ent := false;
        end;
    end;    
  until Ent;

  if not Skip then
  begin
    Points := Length(PlayerWord);
    TempSet := LettersSet;

    i := 1;
    RightLetters := true;
    repeat
      ltrPos := Pos(PlayerWord[i], LettersSet);
      if ltrPos = 0 then
        RightLetters := false
      else
      begin
        Delete(LettersSet, ltrPos, 1);
        Inc(i);
      end;
    until (RightLetters = false) or (i > Length(PlayerWord));

    if not RightLetters then
    begin
      Dec(PlayerScore, Points);
      writeln('���� ����� �������. ���������� ����� ����� ����������� �� ', Points,' � ������ ���������� ', PlayerScore);
      LettersSet := TempSet;
      LastLetter := '0';
      Sleep(180);
      Writeln('-----------------------------------------------------------------------------------------------------------------------');
    end
    else
    begin
      Found := false;
      i := 1;
      while (not Found) and (i < FramePos) do
      begin
        if PlayerWord = Dict[i] then
          Found := true
        else
          Inc(i);
      end;
      if not Found then
      begin
        writeln('������ ����� ��� � �������. ���� �������� �������� ������� �� ���������� ��� � �������.');
        i := 1;
        repeat
          if i <> CurrPlayer then
          begin
            write(i, '-� ����� (��/���): ');
            Ent := false;
            repeat
              readln(AddWord);
              if (AddWord = '��') or (AddWord = 'yes') or (AddWord = 'y') or (AddWord = '�') then
              begin
                Ent := true;
                Agree := true;
              end
              else if (AddWord = '���') or (AddWord = 'no') or (AddWord = 'n') or (AddWord = '�') then
              begin
                Ent := true;
                Agree := false;
              end
              else
                write('������������ ����. ��������� ������� (��/���): ');
            until Ent;
          end
          else
            Agree := true;
          Inc(i);
        until (Agree = false) or (i > PlayersCount);

        if Agree then
        begin
          Dict[FramePos] := PlayerWord;
          Inc(FramePos);

          writeln('������ ���� ����� �����!');
          if PlayerWord[1] = LastLetter then
          begin
            Points := Points * 2;
            Writeln('�����! ���� ����� ���������� �� �� �� �����, �� ������� ������������� ��������� �����');
            Writeln('����������� ��� ���� ������������� � 2 ����');
          end;
          LastLetter := PlayerWord[Length(PlayerWord)];
          Inc(PlayerScore, Points);
          writeln('���������� ����� ����� ������������ �� ', Points, ' � ������ ���������� ', PlayerScore);
          FillLettersSet(Playfield, LettersSet);
        end
        else
        begin
          Dec(PlayerScore, Points);
          writeln('������, ���� ����� �������. ���������� ����� ����� ����������� �� ', Points, ' � ������ ���������� ', PlayerScore);
          LettersSet := TempSet;
          LastLetter := '0';
          Sleep(180);
          Writeln('-----------------------------------------------------------------------------------------------------------------------');
        end;
      end
      else
      begin
        writeln('���� ����� �����!');
        if PlayerWord[1] = LastLetter then
        begin
          Points := Points * 2;
          Writeln('�����! ���� ����� ���������� �� �� �� �����, �� ������� ������������� ��������� �����');
          Writeln('����������� ��� ���� ������������� � 2 ����');
        end;
        LastLetter := PlayerWord[Length(PlayerWord)];
        Inc(PlayerScore, Points);
        writeln('���������� ����� ����� ������������ �� ', Points, ' � ������ ���������� ', PlayerScore);
        FillLettersSet(Playfield, LettersSet);
      end;
    end;
  end;
  Sleep(400);
end;

procedure Monitor(var PlayersCount: SmallInt); //��������� ������
var
  s : string;
  ChoiceMove, c : integer;
  cursor : COORD;
begin
  Writeln('======================================================*  ����� ',i,'  *====================================================');
  Writeln;
  Skip[I] := false;
  repeat
    repeat
      Writeln('===*  ��� ������?  *===');
      Writeln;
      Writeln('---> ������ ����� (1)');
      Writeln('---> 50-��-50 (2)');
      Writeln('---> ������ ����� (3)');
      Writeln('---> ������� ���� (4)');
      Writeln;
      repeat
        repeat
          write('�������� ����� ����: ');
          Readln(s);
          s := trim(s);
          val(s,ChoiceMove,c);
          if c <> 0 then
          begin
            Writeln;
            Writeln('===*  ������ �����  *===');
            Writeln;
          end;
        until c = 0;
        if (ChoiceMove < 1) or (ChoiceMove > 4) then
        begin
          Writeln;
          Writeln('===*  ������ �����  *===');
          Writeln;
        end;
      until (ChoiceMove >= 1) and (ChoiceMove <= 4);
      Position := PlayersCount * 2 + 1;
      clrscr(Position);
      fl := true;
      case ChoiceMove of
          1 : begin
                PlayerTurn(Language,Dict,FramePos,Playfield, I, LettersSet[I],PlayerScore[I], Skip[i],PlayersCount, LastLetter);
                Position := 0;
              end;
          2 : begin
              if (length(PlayField) >= ChangesCount) and (Length(LettersSet[I]) >= ChangesCount) then
                if ChoiceFifByFif[I] then
                begin
                  FifByFif(Playfield,LettersSet[I], ChangesCount, PlayerScore[I]);
                  Writeln('������� Enter...');
                  Readln;
                  Position := 0;
                  clrscr(Position);
                  for J := 1 to PlayersCount do
                  begin
                    FillLettersSet(Playfield, LettersSet[J]);
                    writeln('������ ',J,'-��� ������ � ������ ',PlayerName[J],' : ', LettersSet[J],'. ������� ���������� �����: ',PlayerScore[J]);
                  end;
                  Writeln('======================================================*  ����� ',i,'  *====================================================');
                  Writeln;
                  Writeln('��� ��� ������������');
                  Writeln;
                  Position := 0;
                  ChoiceFifByFif[I] := false
                end
                else
                begin
                  Writeln;
                  Writeln('===*  ��������� ��� ���� ������������ ����  *===');
                  fl := false;
                  Writeln;
                end
              else
              begin
                Writeln;
                Writeln('===*  ���������� ���� � ��� ��� � ����� ���� ������, ��� ',ChangesCount,'  *===');
                Writeln;
              end;
              end;
          3 : begin
              if (Length(LettersSet[I]) > 0) then
                if ChoiceHelp[I] then
                begin
                  FriendHelp(LettersSet, i, PlayersCount);
                  Writeln('������� Enter...');
                  Readln;
                  Position := 0;
                  clrscr(Position);
                  for J := 1 to PlayersCount do
                  begin
                    FillLettersSet(Playfield, LettersSet[J]);
                    writeln('������ ',J,'-��� ������ � ������ ',PlayerName[J],' : ', LettersSet[J],'. ������� ���������� �����: ',PlayerScore[J]);
                  end;
                  Writeln('======================================================*  ����� ',i,'  *====================================================');
                  Writeln;
                  Writeln('===*  ��� ��� ������������  *===');
                  Writeln;
                  Position := 0;
                  ChoiceHelp[I] := false
                end
                else
                begin
                  Writeln;
                  Writeln('===*  ��������� ��� ���� ������������ ����  *===');
                  fl := false;
                  Writeln;
                end
              else
              begin
                Writeln;
                Writeln('===*  � ��� ��� ����  *===');
                Writeln;
              end;
              end;
          4 : begin
                Skip[I] := true;
                Position := 0;
              end;
          else
          fl := false;
          Writeln;
          Writeln('===*  ������ �����  *===');
          Writeln;
      end;
    until fl;
  until (ChoiceMove = 1) or (ChoiceMove = 4);
  Writeln;
  Writeln('������� ENTER...');
  Writeln;
  Readln;
end;

begin
  randomize;
  Position := 0;
  ShowLogo;
  clrscr(Position);
  ChoiceOfLanguage(Language);
  clrscr(Position);

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
  StartFramePos := FramePos;

  NamePlayers(PlayersCount, MaxPlayerCount);
  clrscr(Position);
  FillPlayfield(Playfield,Language);
  for I := 1 to PlayersCount do ChoiceHelp[I] := true;
  for I := 1 to PlayersCount do ChoiceFifByFif[I] := true;
  I := 1;
  repeat
    endgame := true;
    for J := 1 to PlayersCount do
    begin
      FillLettersSet(Playfield, LettersSet[J]);
      writeln('������ ',J,'-��� ������ � ������ ',PlayerName[J],' : ', LettersSet[J],'. ������� ���������� �����: ',PlayerScore[J]);
    end;
    Monitor(PlayersCount);
    clrscr(Position);

    for J := 1 to PlayersCount do
      if Skip[J] = false then endgame := false;
    inc(I);
    if I = PlayersCount + 1 then I := 1;
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
  k := 0;
  for I := 1 to PlayersCount do
    if PlayerScore[I] >= PlayerScore[Max] then Max := I;
  for I := 1 to PlayersCount do
    if PlayerScore[I] = PlayerScore[Max] then inc(k);
  Sleep(1000);
  Writeln;
  Writeln('-----------------------------------------------------------------------------------------------------------------------');
  Writeln;
  Sleep(1000);
  if k = 1 then Writeln('������� ',Max,'-� ����� � ������ ',PlayerName[Max],', �����������!')
    else
    begin
      Writeln('�����');
      Writeln;
      Writeln('������ � ���������� ����������� ����� (',PlayerScore[Max],') : ');
      for I := 1 to PlayersCount do
        if PlayerScore[I] = PlayerScore[Max] then Writeln(I,'-� ����� � ������ ',PlayerName[I]);
    end;

  Close(Dictionary);
  Append(Dictionary);
  for i := StartFramePos to FramePos - 1 do
  begin
  //  writeln('writed: ', Dict[i]);
    Writeln(Dictionary, Dict[i]);
  end;
  Close(Dictionary);

  Readln;
end.
