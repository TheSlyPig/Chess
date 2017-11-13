class Employee
  attr_reader :salary
  def initialize(name, title, salary, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
    @boss.add_employee(self) unless boss.nil?
  end
  
  def bonus(multiplier)
    @salary * multiplier
  end
  
end

class Manager < Employee
  
  def initialize(name, title, salary, boss = nil)
    super
    @employees = []
  end
  
  def add_employee(employee)
    @employees << employee
  end
  
  def bonus(multiplier)
    @employees.map(&:salary).reduce(:+) * multiplier
  end
  
end