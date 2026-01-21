CREATE TABLE Program (
    Program_Id INT PRIMARY KEY,
    Program_Name VARCHAR(100),
    Description VARCHAR(255),
    Start_Date DATE,
    End_Date DATE
);

CREATE TABLE Campaign (
    Campaign_Id INT PRIMARY KEY,
    Program_Id INT,
    Campaign_Name VARCHAR(100),
    Budget_Amount DECIMAL(10,2),
    FOREIGN KEY (Program_Id) REFERENCES Program(Program_Id)
);

CREATE TABLE Activity (
    Activity_Id INT PRIMARY KEY,
    Campaign_Id INT,
    Activity_Name VARCHAR(100),
    FOREIGN KEY (Campaign_Id) REFERENCES Campaign(Campaign_Id)
);

CREATE TABLE Expenses (
    Expense_Id INT PRIMARY KEY,
    Activity_Id INT,
    Expense_Amount DECIMAL(10,2),
    Expense_Date DATE,
    FOREIGN KEY (Activity_Id) REFERENCES Activity(Activity_Id)
);
