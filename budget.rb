require 'rubygems'
require 'bundler/setup'
require 'terminal-table'

Bundler.require

def init(option)
  case option
  when "-c"
    create_budget(ARGV[1], ARGV[2])
  when "-l"
    list_budgets(ARGV[1])
  when "-s"
    show_budget
  when "-i"
    add_income(ARGV[1], ARGV[2])
  when "-e"
    add_expense(ARGV[1], ARGV[2])
  else
    puts "Option not found, you can: "
    puts "Create (-c)"
    puts "List (-l)"
    puts "Add Income (-i)"
    puts "Add Expense (-e)"
  end
end

def show_budget
  (puts "Month and year required" and return) unless ARGV[1] && ARGV[2]
  budget_exists?(ARGV[1], ARGV[2]) ? mount_tables(ARGV[1], ARGV[2]) : "Budget not found"
end

def mount_tables(month, year)
  incomes = []
  expenses = []
  File.open("./budgets/#{year}/#{month}.txt", "r") do |file|
    file.each_line do |line|
      type, desc, value = line.split(" ")
      incomes   << ["#{desc}", value_to_float(value)] if type == "i"
      expenses  << ["#{desc}", value_to_float(value)] if type == "e"
    end
  end
  table("Incomes", incomes) unless incomes.empty?
  table("Expenses", expenses) unless expenses.empty?
end

def value_to_float(value)
  svalue = value.tr(".", "").tr(",", "")
  (svalue.to_i / 100.to_f).round(2)
end

def format_value(value)
  ("R$ %.2f" % value).gsub(".", ",")
end

def table(title, values)
  table = Terminal::Table.new :title => title, :headings => ['Description', 'Value'] do |t|
    values.each do |value|
      t << [value.first, format_value(value.last)]
    end
    t.add_separator
    t << ['Total', format_value(values.reduce(0) { |sum, obj| sum + obj.last })]
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

