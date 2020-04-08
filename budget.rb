require 'rubygems'
require 'bundler/setup'
require 'terminal-table'

Bundler.require

def init(option)
  case option
  when "-c"
    create_budget(ARGV[1], ARGV[2])
  when "list"
    list_budgets(ARGV[1])
  when "details"
    show_budget
  when "income"
    add_income
  when "expense"
    add_expense
  else
    puts "Option not found, you can: "
    puts "Create (-c)"
    puts "List (-l)"
    puts "Add Income (-i)"
    puts "Add Expense (-e)"
  end
end

def add_income
  (puts "Month, year, description and value required" and return) unless ARGV[1] && ARGV[2] && ARGV[3] && ARGV[4]
  File.open("./budgets/#{ARGV[2]}/#{ARGV[1]}.txt", 'a') { |file| file.write("i #{ARGV[3]} #{ARGV[4]}\n") }
  p "Income added"
end

def add_expense
  (puts "Month, year, description and value required" and return) unless ARGV[1] && ARGV[2] && ARGV[3] && ARGV[4]
  File.open("./budgets/#{ARGV[2]}/#{ARGV[1]}.txt", 'a') { |file| file.write("e #{ARGV[3]} #{ARGV[4]}\n") }
  p "Expense added"
end

def show_budget
  (puts "Month and year required" and return) unless ARGV[1] && ARGV[2]
  budget_exists?(ARGV[1], ARGV[2]) ? mount_table_values(ARGV[1], ARGV[2]) : "Budget not found"
end

def mount_table_values(month, year)
  incomes = []
  expenses = []
  File.open("./budgets/#{year}/#{month}.txt", "r") do |file|
    file.each_line do |line|
      type, desc, value = line.split(" ")
      incomes   << ["#{desc}", value_to_float(value)] if type == "i"
      expenses  << ["#{desc}", value_to_float(value)] if type == "e"
    end
  end
  table("Budget of #{month}/#{year}", incomes, expenses)
end

def value_to_float(value)
  svalue = value.tr(".", "").tr(",", "")
  (svalue.to_i / 100.to_f).round(2)
end

def format_value(value)
  ("R$ %.2f" % value).gsub(".", ",")
end

def table(title, incomes, expenses)
  table = Terminal::Table.new :title => title do |t|
    t << ['Income', 'Value']
    t.add_separator
    incomes.each do |income|
      t << [income.first, format_value(income.last)]
    end
    t.add_separator
    t << ['Total Incomes', format_value(incomes.reduce(0) { |sum, obj| sum + obj.last })]
    t.add_separator
    t << ['Expense', 'Value']
    t.add_separator
    expenses.each do |expense|
      t << [expense.first, format_value(expense.last)]
    end
    t.add_separator
    t << ['Total Expenses', format_value(expenses.reduce(0) { |sum, obj| sum + obj.last })]
  end
  puts table
end

def create_budget(month, year)
  p "FILE Exists? #{budget_exists?(month, year)}"
  if month && year
    create_folder_and_file(month, year) unless budget_exists?(month, year)
    p "Budget created"
  else
    puts "Month and year required"
  end
end

def list_budgets(year)
  if year
    files = Dir["./budgets/#{year}/**/*.txt"]
    p files.count > 0 ? "Listing #{year} budgets" : "No Budgets"
    files.each do |file_name|
      if !File.directory?(file_name)
        p File.basename(file_name.to_s, ".*")
      end
    end
  else
    puts "Year required to list budgets"
  end
end

def create_folder_and_file(month, year)
  system 'mkdir', '-p', "budgets/#{year}"
  File.new("./budgets/#{year}/#{month}.txt", "w")
end

def budget_exists?(month, year)
  File.exists?("./budgets/#{year}/#{month}.txt")
end

init(ARGV[0])

