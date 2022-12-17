program FIfByFifoption;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const
  MaxPlayerCount = 10;
  MaxLettersCount = 10;

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

  IsGameBeginning: boolean;

  i: integer;

procedure FillPlayfield(var Playfield: string; Language: TLanguage);
const
  RusABCConsonants = 'бвгджзйклмнпрстфхцчшщъь';
  RusABCVowels = 'аеёиоуыэюя';
  EngABCConsonants = 'bcdfghjklmnpqrstvwxz';
  EngABCVowels = 'aeiouy';
var
  i: SmallInt;
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
  writeln;
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
  writeln('Ваши буквы: ', LettersSet);
  write('Введите те буквы, которые хотите заменить: ');
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
      write('Вы ошиблись при вводе. Введите буквы ещё раз: ');
      Ent := false;
    end
    else if counter < ChangesCount then
    begin
      Ent := false;
      write('Вы ввели недостаточно букв. Введите буквы ещё раз: ');
    end
    else if counter > ChangesCount then
    begin
      Ent := false;
      write('Вы ввели слишком много букв. Введите буквы ещё раз: ');
    end
    else
      Ent := true;

  until Ent;
                                                writeln('Сейчaс введено: ', EntSet);
                                                writeln('Измененная строка: ', LettersSet);

  Dec(PlayerScore, Penalty);
  writeln('Кол-то Ваших очков уменьшено на ', Penalty, ' и теперь составляет ', PlayerScore);

  FillLettersSet(Playfield, LettersSet);
  writeln('Ваша новая строка: ', LettersSet);

  Sleep(500);
  writeln('-----------------------------------------');
  writeln;
end;


begin
  Language := Russian;
  FillPlayfield(Playfield, Language);

  LettersSet[1] := 'кпокумиода'; PlayerScore[1] := 100;

  FifByFif(Playfield, LettersSet[1], PlayerScore[1]);


  writeln('здесь конец программы');
  readln;
end.
