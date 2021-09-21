unit BankingTests;

interface

uses
  SysUtils,
  DUnitX.TestFramework,
  BankAccount;

type

  [TestFixture]
  TBankingTests = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('Case 1', 'TestAccountName')]
    procedure CanSuccessfully_CreateBankAccount(const AccountName: string);

    [Test]
    [TestCase('Case 2', 'TestAccountName1, 2000')]
    procedure CanSuccessfully_Deposit(const AccountName: string;
      DepositAmmount: currency);

    [Test]
    [TestCase('Case 3', 'TestAccountName1, 1000, 100')]
    procedure CanSuccessfully_Withdraw(const AccountName: string;
      AccountBalance: currency; WithdrawAmmount: currency);

    [Test]
    [TestCase('Case 4', 'TestAccountName1, 25, 20')]
    procedure WillFail_OnOverdraw(const AccountName: string;
      AccountBalance: currency; WithdrawAmmount: currency);

    [Test]
    [TestCase('Case 5', 'TestAccountName1, -20')]
    procedure WillFail_OnNegativeDeposit(const AccountName: string;
      DepositAmmount: currency);

    // will need to ensure that the balance is greater than the withdraw amount

    [Test]
    [TestCase('Case 6', 'TestStatementAcconut')]
    procedure CanSuccessfully_PrintStatment_WithAllTransactions
      (const AccountName: string);
  end;

implementation

uses
  System.Classes,
  DUnitX.DUnitCompatibility;

procedure TBankingTests.Setup;
begin
end;

procedure TBankingTests.CanSuccessfully_CreateBankAccount
  (const AccountName: string);
begin
  // Arrange

  // Act
  var
  Account := TBankAccount.CreateAccount(AccountName);

  // Assert
  assert.AreEqual(AccountName, Account.GetAccountName);
  assert.IsTrue(Account.GetAccountBsb > 0);
  assert.IsTrue(Account.GetAccountBalance = 0);
end;

procedure TBankingTests.CanSuccessfully_Deposit(const AccountName: string;
  DepositAmmount: currency);
begin

  // Arrange
  var
    Account: TBankAccount := TBankAccount.CreateAccount(AccountName);
  var
    InitialBalance: currency := Account.GetAccountBalance;

    // Act
  var
  NewBalance := Account.Deposit(DepositAmmount);
  var
  ExpectedBalance := InitialBalance + DepositAmmount;

  // Assert
  assert.AreEqual<Extended>(Account.GetAccountBalance, ExpectedBalance);
  assert.AreEqual<Extended>(NewBalance, ExpectedBalance);
end;

procedure TBankingTests.CanSuccessfully_Withdraw(const AccountName: string;
  AccountBalance, WithdrawAmmount: currency);
begin
  // Arrange
  var
    Account: TBankAccount := TBankAccount.CreateAccount(AccountName);
    // make sure they have the funds to withdraw
  Account.Deposit(WithdrawAmmount);
  var
    InitialBalance: currency := Account.GetAccountBalance;

    // Act
  var
  NewBalance := Account.Withdraw(WithdrawAmmount);
  var
  ExpectedBalance := InitialBalance - WithdrawAmmount;

  // Assert
  assert.AreEqual<Extended>(Account.GetAccountBalance, ExpectedBalance);
  assert.AreEqual<Extended>(NewBalance, ExpectedBalance);
end;

procedure TBankingTests.WillFail_OnOverdraw(const AccountName: string;
  AccountBalance: currency; WithdrawAmmount: currency);
begin
  // Arrange
  var
    Account: TBankAccount := TBankAccount.CreateAccount(AccountName);

    // Act
  assert.WillRaise(
    procedure
    begin
      Account.Withdraw(WithdrawAmmount);
    end, Exception, 'Insufficient Funds')

end;

procedure TBankingTests.WillFail_OnNegativeDeposit(const AccountName: string;
DepositAmmount: currency);
begin
  // Arrange
  var
    Account: TBankAccount := TBankAccount.CreateAccount(AccountName);

    // Act
  assert.WillRaise(
    procedure
    begin
      Account.Deposit(DepositAmmount);
    end, Exception, 'Cannot Deposit a negative ammount')

end;

procedure TBankingTests.CanSuccessfully_PrintStatment_WithAllTransactions
  (const AccountName: string);
begin
  // Arrange
  var
    Account: TBankAccount := TBankAccount.CreateAccount(AccountName);
  Account.Deposit(15);
  Account.Withdraw(10);
  Account.Deposit(15);
  var
  ExpectedStatement := 'Balance: $0.00, Deposit: $15.00, New Balance: $15.00' +
    sLineBreak + 'Balance: $15.00, Withdraw: $10.00, New Balance: $5.00' +
    sLineBreak + 'Balance: $5.00, Deposit: $15.00, New Balance: $20.00' +
    sLineBreak;

  // Act
  var
  MiniStatement := Account.MiniStatement();

  // Assert
  assert.AreEqual(ExpectedStatement, MiniStatement);
  writeln(MiniStatement);
end;

procedure TBankingTests.TearDown;
begin
end;

initialization

TDUnitX.RegisterTestFixture(TBankingTests);

end.
