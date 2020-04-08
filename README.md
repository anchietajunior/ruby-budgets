# Ruby Budgets

Create Budgets with Ruby from Terminal

![Ruby Budgets](budget.gif)

## Show budget

Command: ruby budget.rb details month year

Example: 

```sh
ruby budget.rb details 03 2020
```

## List budgets

Command: ruby budget.rb list year

Example:

```sh
ruby budget.rb list 2020
```

## Add income

Command: ruby budget.rb income month year description(one word) value

Example:

```sh
ruby budget.rb income 03 2020 Salary 1.000,45
```

This will create a file in ***budgets/2020/03.txt***.

## Add expense

Command: ruby budget.rb expense month year description(one word) value

Example:

```sh
ruby budget.rb expense 03 2020 Internet 234,45
```

This will create a file in ***budgets/2020/03.txt***.
