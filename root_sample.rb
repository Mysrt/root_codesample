require 'pry'

class Driver
  attr_accessor :name, :trips

  def initialize(opts={})
    @trips = []
    @name = opts[:name]
  end

  #wouldn't ever use global variables in production code, and this is supposed to be
  #production level code, however global variable is the correct solution to this problem imo
  #with no database so I went with it.

  def self.drivers
    @@drivers ||= {}
    @@drivers
  end

  def self.sorted_drivers
    sorted_drivers = drivers.sort_by{|name, driver| -driver.total_distance.to_i }
    Hash[sorted_drivers]
  end

  def self.output_sorted_drivers
    sorted_drivers.each do |name, driver|
      print "#{name}: #{driver.total_distance.to_i || 0} miles"
      print " @ #{Trip.calculate_mph(driver.total_distance, driver.total_duration)} mph" unless driver.total_distance.to_i.zero?
      puts
    end
  end

  def self.import_drivers(commands)
    drivers = {}

    commands.each do |line|
      attr = line.split(' ')
      command = attr[0]

      case command
      when "Driver" then
        driver_name = attr[1]
        drivers[driver_name] = Driver.new(name: driver_name)
      when "Trip" then
        driver_name = attr[1]

        driver = drivers[driver_name]
        driver.trips << Trip.new(start_time: attr[2], end_time: attr[3], distance: attr[4].to_f)
      end
    end

    @@drivers = drivers
  end

  def total_duration
    trips.map(&:duration).inject(:+)
  end

  def total_distance
    trips.map(&:distance).inject(:+)
  end
end

class Trip
  attr_accessor :distance, :start_time, :end_time

  def initialize(opts={})
    @distance = opts[:distance].to_f
    @end_time = opts[:end_time]
    @start_time = opts[:start_time]
  end

  def self.calculate_mph(total_distance, total_time)
    return 0 if total_distance.to_f.zero? || total_time.to_f.zero?

    ((total_distance.to_f / total_time.to_f) * 60).round
  end

  def duration
    start_hours, start_minutes = start_time.split(":")
    end_hours, end_minutes = end_time.split(":")

    ((end_hours.to_i - start_hours.to_i) * 60) + (end_minutes.to_i - start_minutes.to_i)
  end
end


file_name = ARGV[0]
file = File.open(file_name)
Driver.import_drivers(file.readlines)
Driver.output_sorted_drivers

