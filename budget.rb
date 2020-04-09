require 'rubygems'
require 'bundler/setup'
require 'terminal-table'

Bundler.require

def init(option)
  case option
  when "list"
    list_budgets(ARGV[1])
  when "details"
    show_budget(ARGV[1], ARGV[2])
  when "income"
    add_income
  when "expense"
    add_expense
  when "remove"
    remove_item
  else
    puts "Option not found, you can: "
    puts "List (list)"
    puts "Add Income (income)"
    puts "Add Expense (expense)"
    puts "Remove Item from Budget (remove)"
  end
end

def add_income
  return unless year_month_description_and_value?
  type, month, year, desc, value = ARGV
  create_folder_and_file unless budget_exists?(month, year)
  File.open("./budgets/#{year}/#{month}.txt", 'a') { |file| file.write("i #{desc} #{value}\n") }
  show_budget(month, year)
end

def add_expense
  return unless year_month_description_and_value?
  type, month, year, desc, value = ARGV
  create_folder_and_file unless budget_exists?(month, year)
  File.open("./budgets/#{year}/#{month}.txt", 'a') { |file| file.write("e #{desc} #{value}\n") }
  show_budget(month, year)
end

def remove_item
  return unless year_month_and_description? 

  file = "./budgets/#{ARGV[3]}/#{ARGV[2]}.txt"

  if File.zero?(file)
    puts "Empty Budget"
    return
  end

  file_lines = ''
  type = ARGV[1] == 'income' ? 'i' : 'e'

  File.open(file, "r") do |file|
    file.each_line do |line|
      if line == "\n"
        next
      end
      line_type, desc, value = line.split(" ")
      file_lines += line unless type == line_type && desc == ARGV[4]
    end
  end

  unless file_lines.empty?
    File.open(file, "w") do |file|
      file.puts file_lines
    end
  end
  show_budget(ARGV[2], ARGV[3])
end

def show_budget(month, year)
  if month && year 
    budget_exists?(month, year) ? mount_table_values(month, year) : "Budget not found"
  else
    puts "Month and Year Required"
  end
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
    t.add_separator
    t << ['Budget', 'Total']
    t.add_separator
    t << ['Total', format_value(
      incomes.reduce(0) { |sum, obj| sum + obj.last } - 
      expenses.reduce(0) { |sum, obj| sum + obj.last }
    )]
  end
  puts table
end

def list_budgets(year)
  (puts "Year required to list budgets" and return) unless year
  files = Dir["./budgets/#{year}/**/*.txt"]
  p files.count > 0 ? "Listing #{year} budgets" : "No Budgets"
  files.each do |file_name|
    if !File.directory?(file_name)
      p File.basename(file_name.to_s, ".*")
    end
  end
end

def create_folder_and_file
  system 'mkdir', '-p', "budgets/#{ARGV[2]}"
  File.new("./budgets/#{ARGV[2]}/#{ARGV[1]}.txt", "w")
end

def budget_exists?(month, year)
  File.exists?("./budgets/#{year}/#{month}.txt")
end

def year_month_and_description?
  if ARGV[1].nil? || ARGV[2].nil? || ARGV[3].nil?
    puts "Month, year and description required"
    false
  else
    true
  end
end

def year_month_description_and_value?
  if ARGV[1].nil? || ARGV[2].nil? || ARGV[3].nil? || ARGV[4].nil?
    puts "Month, year, description and value required"
    false
  else
    true
  end
end

init(ARGV[0])

