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
  RusABCConsonants = 'бвгджзйклмнпрстфхцчшщъь';
  RusABCVowels = 'аеёиоуыэюя';
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
  ABC = 'бвгджзйклмнпрстфхцчшщъьаеёиоуыэюяbcdfghjklmnpqrstvwxzaeiouy';
var 
  Ent: boolean;
  FriendNumber, j, MyP, FrP: SmallInt;
  MyLetter, FriendLetter, Temp: string;
begin
  writeln('Ваши буквы: ', LettersSet[PlayerNumber]);

  write('Выберите номер игрока, у которого Вы хотите обменять букву: ');
  repeat
    Ent := false;
    try
      readln(FriendNumber);
    except
      FriendNumber := 0;
    end;
    if (FriendNumber <= 0) or (FriendNumber > PlayerCount) then
        write('Некоррекный номер игрока. Введите номер ещё раз: ')
      else if FriendNumber = PlayerNumber then
        write('Вы не можете взять букву у самого себя. Введите номер ещё раз: ')
      else
        Ent := true;
  until Ent;

  writeln('Его буквы: ', LettersSet[FriendNumber]);

  write('Выберите свою букву, которую хотите отдать: ');
  repeat
    Ent := false;
    readln(MyLetter);
    MyLetter := LowerCase(Trim(MyLetter));

    if Length(MyLetter) > 1 then
      write('Вы ввели строку, а не букву. Выберите букву ещё раз: ')
    else if Length(MyLetter) = 0 then
      write('Вы не ввели ни одной буквы. Выберите букву ещё раз: ')
    else if Pos(MyLetter, ABC) = 0 then
      write('Это не буква. Выберите букву ещё раз: ')
    else if Pos(MyLetter, LettersSet[PlayerNumber]) = 0 then
      write('Такой буквы нет среди ваших букв. Выберите букву ещё раз: ')
    else
      Ent := true;
  until Ent;

  write('Выберите у друга букву, которую хотите забрать: ');
  repeat
    Ent := false;
    readln(FriendLetter);
    MyLetter := LowerCase(Trim(MyLetter));

    if Length(FriendLetter) > 1 then
      write('Вы ввели строку, а не букву. Выберите букву ещё раз: ')
    else if Length(FriendLetter) = 0 then
      write('Вы не ввели ни одной буквы. Выберите букву ещё раз: ')
    else if Pos(FriendLetter, ABC) = 0 then
      write('Это не буква. Выберите букву ещё раз: ')
    else if Pos(FriendLetter, LettersSet[FriendNumber]) = 0 then
      write('Такой буквы нет среди букв друга. Выберите букву ещё раз: ')
    else if MyLetter = FriendLetter then
      write('Вы хотите заменить свою букву на такую же букву. Выберите букву ещё раз: ')
    else
      Ent := true;
  until Ent;

  MyP := Pos(MyLetter, LettersSet[PlayerNumber]);
  FrP := Pos(FriendLetter, LettersSet[FriendNumber]);
  Insert(Myletter, LettersSet[FriendNumber], FrP);
  Insert(Friendletter, LettersSet[PlayerNumber], MyP);
  Delete(LettersSet[FriendNumber], FrP + 1, 1);
  Delete(LettersSet[PlayerNumber], MyP + 1, 1);

  writeln('Теперь Ваши буквы: ', LettersSet[PlayerNumber]);
  writeln('Теперь его буквы: ', LettersSet[FriendNumber]);

  Sleep(500);
  writeln('-----------------------------------------');
  writeln;

end;

begin
  Language := Russian;
  FillPlayfield(Playfield, Language);

  LettersSet[1] := 'кпокумиода'; LettersSet[2] := 'крьвфычиус';

  FriendHelp(LettersSet, 1, PlayersCount);

  writeln('здесь конец программы');
  readln;
end.
