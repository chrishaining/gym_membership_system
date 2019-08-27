require_relative('../db/sql_runner')

class Booking

  attr_reader :id
  attr_accessor :member_id, :fitness_class_id

def initialize(options)
  @id = options['id'].to_i if options['id']
  @member_id = options['member_id'].to_i
  @fitness_class_id = options['fitness_class_id'].to_i
end

#define a function to create a new booking (the CREATE of CRUD)
def save()
  sql = "
  INSERT INTO bookings
  (member_id, fitness_class_id)
  VALUES
  ($1, $2)
  RETURNING *
  "
  values = [@member_id, @fitness_class_id]
  booking = SqlRunner.run(sql, values).first
  @id = booking['id'].to_i
end

#define a function to view all bookings (the READ of CRUD)
def self.view_all()
 sql = "SELECT * FROM bookings"
 bookings_data = SqlRunner.run(sql)
 result = bookings_data.map { |booking| Booking.new(booking) }
 return result
end

#define a function to view a specific booking/set of bookings (the READ of CRUD). Version A
def self.view_booking_by_id(id)
  sql = "
  SELECT * FROM bookings
  WHERE id = $1"
  values = [id]
  booking_info = SqlRunner.run(sql, values)
  return Booking.new(booking_info.first)
  return result
end

#define a function to view a specific booking/set of bookings (the READ of CRUD). Version B
def view()
  sql = "
  SELECT * FROM bookings"
  result = SqlRunner.run(sql)[0]
  return result
end

#show the name of the member who holds the specific booking. the READ of CRUD). At the moment, it seems to return an array, which could be a problem
def view_member()
 sql = "
    SELECT * FROM members
    where members.id = $1
 "
 values = [@member_id]
 member = SqlRunner.run(sql, values)
 result = Member.new(member.first)
 # result = member.map { |member| Member.new(member).pretty_name}
 return result
end

#show the name of the fitness_class for the specific booking. the READ of CRUD)
# def show_fitness_class_name()
#
# end

#define a function to update a booking (the UPDATE of CRUD)
def update()
  sql ="
  UPDATE bookings
  SET member_id = $1, fitness_class_id = $2
  WHERE id = $3
  "
  values = [@member_id, @fitness_class_id, @id]
  SqlRunner.run(sql, values)
end

#define a function to delete all bookings (the DELETE of CRUD)
def self.delete_all()
sql = "DELETE FROM bookings"
SqlRunner.run(sql)
end

#define a function to delete a specific booking (the DELETE of CRUD). version A
def delete()
  sql ="
  DELETE FROM bookings
  WHERE id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

#define a function to delete a specific booking (the DELETE of CRUD). version B
def self.delete_booking_by_id(id)
  sql = "
  DELETE FROM bookings
  WHERE id = $1"
  values = [id]
  SqlRunner.run(sql, values)
end

#method to delete a booking using the member's ID as the argument. Call it on an instance of the class. Also, there may be a possibility to delete all the bookings a particular member has (e.g. because they are off sick, and it would be easier to delete all their classes together)
# def self.delete_by_member_id(member_id)
#   sql = "
#   DELETE FROM bookings
#   WHERE member_id = $1"
#   values = [member_id]
#   SqlRunner.run(sql, values)
# end



#Final end
end
