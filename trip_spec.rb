
require './root_sample.rb'

describe "Trip" do

  describe "#initialize" do
    it "initializes start_time correctly" do
      start_time = "02:23"
      trip = Trip.new(start_time: "02:23")

      expect(trip.start_time).to eq(start_time)
 
    end
    it "initializes end_time correctly" do
      end_time = "02:23"
      trip = Trip.new(end_time: "02:23")

      expect(trip.end_time).to eq(end_time)
 
    end
    it "initializes distance correctly" do
      distance = 20
      trip = Trip.new(distance: distance)

      expect(trip.distance).to eq(distance.to_f)
    end
  end

  describe "#calculate_mph" do
    it 'returns 0 if either the distance or the duration is not given' do
      expect(Trip.calculate_mph(0, 20)).to be_zero
      expect(Trip.calculate_mph(20, 0)).to be_zero
    end

    context 'calculates the average mph of the trip given in distance (miles) and duration (minutes)' do
      it "calculates a fast trip" do
        expect(Trip.calculate_mph(60, 30)).to eq(120)
      end
      it "calculates a average trip" do
        expect(Trip.calculate_mph(60, 60)).to eq(60)
      end
      it "calculates a slow trip" do
        expect(Trip.calculate_mph(30, 60)).to eq(30)
      end

      it "calculates a really small trip" do
        #requirements want this printed as an integer so it should be zero even
        #though its really .1mph
        expect(Trip.calculate_mph(0.2, 60)).to eq(0)
      end
    end
  end

  describe "#duration" do
    it "calculates the duration (in minutes) of each trip in minutes based on a start an end time" do
      expect(Trip.new(start_time: "02:23", end_time: "02:45").duration).to eq(22)
    end

    it "calculates the duration correctly for trips that span multiple hours" do
      expect(Trip.new(start_time: "02:59", end_time: "03:15").duration).to eq(16)
    end
  end

end
