require './root_sample.rb'

describe "Driver" do
  before :each do
    @driver = Driver.new(name: "Don")
  end

  describe "#initialize" do
    it "initializes name correctly" do
      expect(@driver.name).to eq("Don")
    end
  end

  describe "#total_duration" do
    it "sums up the duration of just one trip in minutes" do
      @driver.trips << Trip.new(start_time: "07:59", end_time: "08:05")

      expect(@driver.total_duration).to eq(6)
    end

    it "sums up the duration of all of that drivers trips in minutes" do
      @driver.trips << Trip.new(start_time: "07:30", end_time: "07:45")
      @driver.trips << Trip.new(start_time: "06:45", end_time: "07:45")

      expect(@driver.total_duration).to eq(75)
    end
  end

  describe "#total_distance" do
    it "sums up the total distance that driver traveled in one trip" do
      @driver.trips << Trip.new(distance: "7.8")

      expect(@driver.total_distance).to eq(7.8)
    end

    it "sums up the total distance that driver travelled over all trips" do
      @driver.trips << Trip.new(distance: "7.8")
      @driver.trips << Trip.new(distance: "11.3")
      @driver.trips << Trip.new(distance: "230.6")


      expect(@driver.total_distance).to eq(249.7)
    end
  end

  describe "importing and displaying drivers" do
    before :each do
      @commands = [
        "Driver Dan",
        "Driver Alex",
        "Driver Bob",
        "Trip Dan 07:15 07:45 17.3",
        "Trip Dan 06:12 06:32 12.9",
        "Trip Alex 12:01 13:16 42.0",
      ]

      Driver.import_drivers(@commands)
    end

    describe "#sorted_drivers" do
      it "returns all of the drivers sorted by distance travelled" do
        puts Driver.sorted_drivers.inspect

        expect(Driver.drivers.first[1].name).not_to eq("Alex")
        expect(Driver.sorted_drivers.first[1].name).to eq("Alex")
      end
    end

    describe "#import" do
      it "imports the drivers into a hash with key being driver name" do
        ["Dan", "Alex", "Bob"].each do |name|
          expect(Driver.drivers.keys).to include(name)
        end
      end

      it "imports the drivers into a hash with value being a driver object" do
        ["Dan", "Alex", "Bob"].each do |name|
          expect(Driver.drivers[name].class.to_s).to eq("Driver")
          expect(Driver.drivers[name].name).to eq(name)
        end
      end

      it "creates a trip object for each trip command" do
        #this could probably be broken into two tests but I wasnt really sure what to do with it
        expect(Driver.drivers["Dan"].trips.size).to eq(2)
        first_trip = Driver.drivers["Dan"].trips.first
        last_trip = Driver.drivers["Dan"].trips.last

        expect(first_trip.distance).to eq(17.3)
        expect(first_trip.start_time).to eq("07:15")
        expect(first_trip.end_time).to eq("07:45")

        expect(last_trip.distance).to eq(12.9)
        expect(last_trip.start_time).to eq("06:12")
        expect(last_trip.end_time).to eq("06:32")
      end
    end

    describe "output_sorted_drivers" do
      it "outputs the drivers name and information about their trips if they have any; 0 miles if they dont" do
        #capture output so we can play it back for the test
        $stdout = StringIO.new
        Driver.output_sorted_drivers

        $stdout.rewind

        expect($stdout.gets.strip).to eq('Alex: 42 miles @ 34 mph')
        expect($stdout.gets.strip).to eq('Dan: 30 miles @ 36 mph')
        expect($stdout.gets.strip).to eq('Bob: 0 miles')
      end
    end

  end
end
