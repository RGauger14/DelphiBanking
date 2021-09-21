unit BankAccount;

interface

uses
  DUnitX.TestFramework,
  SysUtils,
  Classes;

type
  TBankAccount = class(TObject)
  private
    AccountName: string;
    AccountNumber: integer;
    AccountBsb: integer;
    AccountBalance: currency;
    Transactions: TStringList;

  public

    constructor CreateAccount(AccountName: string);
    destructor Destroy; override;

    function GetAccountName: string;
    function GetAccountNumber: integer;
    function GetAccountBsb: integer;
    function GetAccountBalance: currency;

    function Deposit(DepositAmmount: currency): currency;
    function Withdraw(WithdrawAmmount: currency): currency;
    function MiniStatement: string;
  end;

implementation

var
  NextAccountNumber: integer;

  { TBankAccount }

constructor TBankAccount.CreateAccount(AccountName: string);
begin
  self.AccountName := AccountName;
  self.AccountNumber := NextAccountNumber;
  NextAccountNumber := NextAccountNumber + 1;
  self.AccountBsb := 123456;
  self.AccountBalance := 0;
  self.Transactions := TStringList.Create();
end;

destructor TBankAccount.Destroy;
begin

  FreeAndNil(Transactions);

end;

function TBankAccount.GetAccountBalance: currency;
begin
  result := AccountBalance;
end;

function TBankAccount.GetAccountBsb: integer;
begin
  result := AccountBsb;
end;

function TBankAccount.GetAccountName: string;
begin
  result := AccountName;
end;

function TBankAccount.GetAccountNumber: integer;
begin
  result := AccountNumber;
end;

function TBankAccount.Deposit(DepositAmmount: currency): currency;
begin
  if DepositAmmount < 0 then
    raise Exception.Create('Cannot Deposit a negative ammount.');
  var
    CurrentBalance: currency := AccountBalance;
  AccountBalance := AccountBalance + DepositAmmount;
  Transactions.Add('Balance: ' + CurrentBalance.ToString() + ', Deposit: ' +
    DepositAmmount.ToString() + ', New Balance: ' + AccountBalance.ToString());
  result := AccountBalance;
end;

function TBankAccount.Withdraw(WithdrawAmmount: currency): currency;
begin
  if WithdrawAmmount < 0 then
    raise Exception.Create('Cannot Withdraw a negative ammount.');

  if WithdrawAmmount > AccountBalance then
    raise Exception.Create('Insufficient Funds');

  var
    CurrentBalance: currency := AccountBalance;
  AccountBalance := AccountBalance - WithdrawAmmount;
  Transactions.Add('Balance: ' + CurrentBalance.ToString() + ', Withdraw: ' +
    WithdrawAmmount.ToString() + ', New Balance: ' + AccountBalance.ToString());
  result := AccountBalance;
end;

function TBankAccount.MiniStatement: string;
begin
  result := Transactions.Text;
end;

initialization

NextAccountNumber := 1000000

end.
