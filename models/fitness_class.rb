require_relative('../db/sql_runner')

class FitnessClass

attr_accessor :name
attr_reader :id

def initialize(options)
  @id = options['id'].to_i if options['id']
  @name = options['name']
end

#define a function to create a new fitness class (the CREATE of CRUD)
def save()
  sql = "
  INSERT INTO fitness_classes
  (name)
  VALUES
  ($1)
  RETURNING *
  "
  values = [@name]
  fitness_class = SqlRunner.run(sql, values).first
  @id = fitness_class['id'].to_i
end

#define a function to view all fitness classes (the READ of CRUD)
def self.view_all()
  sql = "SELECT * FROM fitness_classes"
  fitness_classes_data = SqlRunner.run(sql)
  result = fitness_classes_data.map { |fitness_class| FitnessClass.new(fitness_class) }
  return result
end


#define a function to view a specific fitness class/set of fitness classes (the READ of CRUD).Version A
def self.view_class_by_id(id)
  sql = "
  SELECT * FROM fitness_classes
  WHERE id = $1"
  values = [id]
  result = SqlRunner.run(sql, values)[0]
  return result
end

#define a function to view a specific fitness class/set of fitness classes (the READ of CRUD).Version B
def view()
  sql = "
  SELECT * FROM fitness_classes"
  result = SqlRunner.run(sql)[0]
  return result
end

#define a function to update a fitness class (the UPDATE of CRUD)
def update()
  sql ="
  UPDATE fitness_classes
  SET name = $1
  WHERE id = $2
  "
  values = [@name, @id]
  SqlRunner.run(sql, values)
end

#define a function to delete all fitness classes (the DELETE of CRUD)
def self.delete_all()
  sql = "DELETE from fitness_classes"
  SqlRunner.run(sql)
end

#define a function to delete a specific fitness class (the DELETE of CRUD). Version A
def delete()
  sql ="
  DELETE FROM fitness_classes
  WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

#define a function to delete a specific fitness class (the DELETE of CRUD). Version B
def self.delete_fitness_class_by_id(id)
  sql = "
  DELETE FROM fitness_classes
  WHERE id = $1"
  values = [id]
  SqlRunner.run(sql, values)
end

#for the MVP: the app should show all members that are registered for a particular class. To do this: access the members table via an inner joint with bookings; this should produce a list of attendees, but I will need to map this.
def attendees()
  sql = "SELECT members.*
  FROM members
  INNER JOIN bookings
  ON bookings.member_id = members.id
  WHERE bookings.fitness_class_id = $1"
  values = [@id]
  attendee_data = SqlRunner.run(sql, values)
  attendees = attendee_data.map { |attendee|  Member.new(attendee) }
  return attendees
end




#final end
end
