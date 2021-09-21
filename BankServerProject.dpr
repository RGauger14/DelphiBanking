program BankServerProject;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  BankAccount in 'BankAccount.pas';

begin
  try
    WriteLn('Program is running');

    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

