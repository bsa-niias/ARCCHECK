unit fm_logo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls,
  Registry, DateUtils;

type

  { TForm_ArcControl }

  TForm_ArcControl = class(TForm)
    lb_Logo: TListBox;
    lb_DelFiles: TListBox;
    sbHelper: TStatusBar;
    Timer_Search: TTimer;
    Timer_sb: TTimer;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer_sbTimer(Sender: TObject);
    procedure Timer_SearchTimer(Sender: TObject);
  private

  public

  end;

var
  Form_ArcControl: TForm_ArcControl;
  ArcPath1 : String;
  ArcPath2 : String;
  ArcLive  : Integer;

implementation

{$R *.lfm}

{ TForm_ArcControl }

procedure TForm_ArcControl.Timer_sbTimer(Sender: TObject);
var
  today : TDateTime;
  year, month, day : Word;
  hour, minute, second, ms : Word;
  str_now : String;
begin
  today := Now;

  DecodeDate (today, year, month, day);
  DecodeTime (today, hour, minute, second, ms);

  str_now := IntToStr (year) + '.';
  if (month <= 9)
      then str_now := str_now + '0' + IntToStr (month) + '.'
      else str_now := str_now +       IntToStr (month) + '.';
  if (day <= 9)
      then str_now := str_now + '0' + IntToStr (day) + '.'
      else str_now := str_now +       IntToStr (day);

  str_now := str_now + ' ';

  if (hour <= 9)
      then str_now := str_now + '0' + IntToStr (hour) + ':'
      else str_now := str_now +       IntToStr (hour) + ':';
  if (minute <= 9)
      then str_now := str_now + '0' + IntToStr (minute) + ':'
      else str_now := str_now +       IntToStr (minute) + ':';
  if (second <= 9)
      then str_now := str_now + '0' + IntToStr (second)
      else str_now := str_now +       IntToStr (second);

  str_now := str_now + ' (' + IntToStr (DayOfWeek (today)-1) + ')';

  sbHelper.Panels.items[0].text := str_now;
  sbHelper.Panels.items[2].text := IntToStr (lb_Logo.Items.Count);

  {очищаем окно сообщений}
  if (lb_Logo.Items.Count > 100)
      Then lb_Logo.Items.Clear
      Else;
end;

procedure TForm_ArcControl.Timer_SearchTimer(Sender: TObject);
var
  today : TDateTime;
  year, month, day : Word;
  hour, minute, second, ms : Word;
  SearchRes : TSearchRec;
  sysres : Integer;
  filemodify : TDateTime;
  sec : Int64;
  delfile : String;
  delres : Boolean;

function BoolToStr (b: Boolean) : string;
begin
  if (b = TRUE)
      Then Result := 'TRUE'
      Else Result := 'FALSE';
End;

begin
  lb_Logo.Items.Add ('-');
  lb_Logo.Items.Add ('!Time [' + sbHelper.Panels.items[0].text + ']');

  today := Now;
  DecodeDate (today, year, month, day);
  DecodeTime (today, hour, minute, second, ms);

  lb_Logo.Items.Add ('*');
  {ищем *.ard}
  sysres := FindFirst (ArcPath1+'*.ard', faAnyFile, SearchRes);
  if (sysres = 0)
      then begin
           lb_Logo.Items.Add ('FindFirst ("'+ArcPath1+'*.ard", ... ) is UP!');
           lb_Logo.Items.Add ('FILE : '+ ArcPath1+SearchRes.Name);

           while (sysres = 0) do
           begin
               {проверка файла}
               filemodify := FileDateToDateTime (SearchRes.Time);
               sec := SecondsBetween (today, filemodify);
               if (int64 (ArcLive)*24*60*60 < sec)
                  then begin
                       lb_Logo.Items.Add ('!CHECK [' + IntToStr (ArcLive*24*60*60) + ':' + IntToStr(sec) + '] - OLD FILE!');
                       delfile := ArcPath1+SearchRes.Name;
                       delres := DeleteFile (delfile);
                       lb_Logo.Items.Add ('!DELETE FILE [' + delfile + '] RES : ' + BoolToStr (delres));
                       lb_Logo.Items.Add ('!RET');
                       lb_DelFiles.Items.Add (delfile);
                       break;
                  end
                  else begin
                       lb_Logo.Items.Add ('!CHECK [' + IntToStr (ArcLive*24*60*60) + ':' + IntToStr(sec) + '] - NEW FILE!');
                  end;

               sysres := FindNext (SearchRes);
               if (sysres = 0)
                  then begin
                       lb_Logo.Items.Add ('FILE : '+ ArcPath1+SearchRes.Name);
                  end
                  else begin
                       lb_Logo.Items.Add ('FindNext ("'+ArcPath1+'*.ard", ... ) is EMPTY!');
                  end
           end;
           FindClose (SearchRes);
      end
      else begin
           lb_Logo.Items.Add ('FindFirst ("'+ArcPath1+'*.ard", ... ) is EMPTY!');
      end;
  {endif}

  today := Now;
  DecodeDate (today, year, month, day);
  DecodeTime (today, hour, minute, second, ms);

  lb_Logo.Items.Add ('*');
  {ищем result\*.ogo}
  sysres := FindFirst (ArcPath2+'*.ogo', faAnyFile, SearchRes);
  if (sysres = 0)
      then begin
           lb_Logo.Items.Add ('FindFirst ("'+ArcPath2+'*.ogo", ... ) is UP!');
           lb_Logo.Items.Add ('FILE : '+ ArcPath2+SearchRes.Name);

           while (sysres = 0) do
           begin
               {проверка файла}
               filemodify := FileDateToDateTime (SearchRes.Time);
               sec := SecondsBetween (today, filemodify);
               if (int64 (ArcLive)*24*60*60 < sec)
                  then begin
                       lb_Logo.Items.Add ('!CHECK [' + IntToStr (ArcLive*24*60*60) + ':' + IntToStr(sec) + '] - OLD FILE!');
                       delfile := ArcPath2+SearchRes.Name;
                       delres := DeleteFile (delfile);
                       lb_Logo.Items.Add ('!DELETE FILE [' + delfile + '] RES : ' + BoolToStr (delres));
                       lb_Logo.Items.Add ('!RET');
                       lb_DelFiles.Items.Add (delfile);
                       break;
                  end
                  else begin
                       lb_Logo.Items.Add ('!CHECK [' + IntToStr (ArcLive*24*60*60) + ':' + IntToStr(sec) + '] - NEW FILE!');
                  end;

               sysres := FindNext (SearchRes);
               if (sysres = 0)
                  then begin
                       lb_Logo.Items.Add ('FILE : '+ ArcPath2+SearchRes.Name);
                  end
                  else begin
                       lb_Logo.Items.Add ('FindNext ("'+ArcPath2+'*.ogo", ... ) is EMPTY!');
                  end
           end;
           FindClose (SearchRes);
      end
      else begin
           lb_Logo.Items.Add ('FindFirst ("'+ArcPath2+'*.ogo", ... ) is EMPTY!');
      end;
  {endif}
end;

procedure TForm_ArcControl.FormCreate(Sender: TObject);
var
   ArcPath0 : String;
   ArcReg   : TRegistry;
begin
   lb_Logo.Items.Add ('Program clear archive TUMS ... started !');
   lb_Logo.Items.Add ('Delete old "[HKLM\SOFTWARE\ARCRPCTUMS\ARCPATH]\*.ard" files !');
   lb_Logo.Items.Add ('Delete old "[HKLM\SOFTWARE\ARCRPCTUMS\ARCPATH]\RESULT\*.ogo" files !');
   Timer_sbTimer (NIL);
   lb_Logo.Items.Add (sbHelper.Panels.items[0].text);

   ArcReg := TRegistry.Create;
   try
       ArcReg.RootKey := HKEY_LOCAL_MACHINE;
       ArcReg.OpenKey('SOFTWARE\ARCRPCTUMS',FALSE);
       ArcPath0 := ArcReg.ReadString('arcpath');
       if (Trim (ArcPath0) = '')
          Then ArcPath0 := '.\'
          Else;
       if (ArcPath0 [Length (ArcPath0)]  <> '\')
          Then ArcPath0 := ArcPath0 + '\'
          Else;
       ArcPath1 := ArcPath0;
       ArcPath2 := ArcPath1 + 'result\';
       lb_Logo.Items.Add ('Archive directory : ' + ArcPath1);
       lb_Logo.Items.Add ('Archive directory : ' + ArcPath2);
       {lb_Logo.Items.Add (ArcPath);}

       ArcLive := ArcReg.ReadInteger('MaxLive');
       lb_Logo.Items.Add ('Archive live days : ' + IntToStr (ArcLive));
   finally
       ArcReg.CloseKey;
       ArcReg.Free;
   end;

   sbHelper.Panels.items[1].text := 'REGPATH : ' + ArcPath0;
   sbHelper.Panels.items[2].text := IntToStr (lb_Logo.Items.Count);

   Timer_SearchTimer (NIL);
end;

procedure TForm_ArcControl.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caMinimize;
end;

end.

