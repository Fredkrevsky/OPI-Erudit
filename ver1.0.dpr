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

procedure ShowRules; //правила игры
begin
  Writeln;
  Writeln('=========================================================ЭРУДИТ========================================================');
  Writeln;
  Writeln('ПРАВИЛА');
  Writeln;
  Writeln('1. Перед началом игры участники могут выбрать язык (русский или английский)');
  Writeln('2. Количество игроков не может быть больше 10');
  Writeln('3. В начале игры создается банк букв, состоящий из увеличенного набора согласных'+#13#10+'   букв и в 8 раз гласных букв алфавита (русского либо латинского)');
  Writeln('4. Каждому игроку раздается по 10 выбранных случайным образом букв из банка букв.'+#13#10+'   Эти 10 букв образуют набор букв игрока. Все игроки по очереди составляют слова,'+#13#10+'   каждый из своего набора букв игрока');
  Writeln('5. Используются только строчные буквы алфавита (русского либо латинского)');
  Writeln('6. Если слово составлено верно, то игроки присуждаются очки. Если неверно, и игроки'+#13#10+'   отказываются занести данное слово в словарь возможный слов, то игрок теряет очки');
  Writeln('7. Игрок может пропустить ход. За пропуск ход очки не снимаются');
  Writeln('8. После хода игроку добавляется недостающее до 10-ти количество букв в наборе букв игрока');
  Writeln('9. За игру, каждый участник может воспользоваться двумя бонусами: "50-на-50" и "помощь друга"');
  Writeln('   1. "50-на-50": игрок может заменить любые 5 букв из своего набора. Из банка игроку'+#13#10+'      выдаются недостающие 5 букв, при этом замененные буквы считаются отыгравшими и'+#13#10+'      обратно в банк не заносятся, а сумма очков игрока уменьшается на 2');
  Writeln('   2. "помощь друга": игрок может заменить ненужную ему букву из своего набора на'+#13#10+'      понравившуюся ему букву из набора соперника. При этом согласие второго не требуется и'+#13#10+'      сумма очков не уменьшается');
  Writeln('10. Окончанием игры будет являтся пропуск хода всеми игроками. Выигрывает тот игрок, который'+#13#10+'   набрал большее число очков');
  Writeln;
  Writeln('Если вы ознакомились с правилами, нажмите ENTER...');
  Writeln;
  Readln;
end;

procedure Language; //выбор языка
begin
  repeat
    Writeln;
    Writeln('=== Выберите язык (eng - английский, rus - русский) ===');
    Writeln;
    Readln(Lang);
    Writeln;
    if Lang='eng' then Writeln('=== Выбран английский язык ===')
      else if Lang='rus' then Writeln('=== Выбран русский язык ===')
        else Writeln('=== Ошибка ввода (неверный язык) ===');
  until (Lang='eng') or (Lang='rus');
  Writeln;
  Writeln('Нажмите ENTER...');
  Readln;
end;

procedure NamePlayers; //ввод игроков
begin
  repeat
    Writeln;
    Writeln('=== Введите количество игроков ===');
    Writeln;
    Readln(N);
    Writeln;
    if (N>10) or (N<1) then Writeln('=== Ошибка ввода (неверное количество игроков ===')
      else Writeln('=== Учавствуют ',N,' игрока(-ов) ===');
  until (N<=10) and (N>=1);
  Writeln;
  Writeln('=== Введите свои имена ===');
  Writeln;
  for I := 1 to N do
  begin
    Write(I,'. ');
    Readln(NameTemp);
    Name[I] := NameTemp;
  end;
  Writeln;
  Writeln('Нажмите ENTER...');
  Readln;
end;

procedure Monitor; //интерфейс игрока
begin
  Writeln('=========================================================ИГРОК ',i,'=======================================================');
  Writeln;
  Writeln('=== Ваш набор букв ===');
  Writeln(' _______________________________________ ');
  for I := 1 to 10 do Write('| t ');
  Write('|');
  Writeln;
  Writeln('|___|___|___|___|___|___|___|___|___|___|');
  Writeln;
  Writeln('Нажмите ENTER...');
  Writeln;
  Readln;
end;

procedure clrscr; //очистка консоли
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