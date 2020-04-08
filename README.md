# Ruby Budgets

Create Budgets with Ruby from Terminal

## Show budget

Command: ruby budget.rb -s month year

Example: 

```sh
ruby budget.rb -s 03 2020
```

## List budgets

Command: ruby budget.rb -l year

Example:

```sh
ruby budget.rb -l 2020
```

## Add income

Command: ruby budget.rb -i month year description(one word) value

Example:

```sh
ruby budget.rb -i 03 2020 Salary 1.000,45
```

This will create a file in ***budgets/2020/03.txt***.

## Add expense

Command: ruby budget.rb -e month year description(one word) value

Example:

```sh
ruby budget.rb -e 03 2020 Internet 234,45
```

This will create a file in ***budgets/2020/03.txt***.
