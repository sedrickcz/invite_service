require '../invite_service'

RSpec.describe GeoLocator, type: :model do

  context "with invalid gps point" do
    it "raise exception" do
      expect { GeoLocator.new("a") }.to raise_error(ArgumentError, "GPS point is not valid")
    end
  end
end

RSpec.describe GeoLocator, "#is_in_range?" do
  let(:locator) { GeoLocator.new([53.3381985, -6.2592576]) }

  context "with invalid gps point" do
    it "raise exception" do
      expect { locator.is_in_range?("aaa", 100) }.to raise_error(ArgumentError, "GPS point is not valid")
    end
  end

  context "with invalid range" do
    it "raise exception" do
      expect { locator.is_in_range?([54.080556, -6.361944 ], "ffsd") }.to raise_error(ArgumentError, "Range is not valid number")
    end
  end

  context "with valid arguments" do
    it "gets true if user is in range" do
      expect(locator.is_in_range?([54.080556, -6.361944 ], 100)).to eq(true)
    end

    it "gets false if user is not in range" do
      expect(locator.is_in_range?([52.833502, -8.522366 ], 100)).to eq(false)
    end
  end
end


RSpec.describe GeoLocator, "#distance" do
  let(:locator) { GeoLocator.new([53.3381985, -6.2592576]) }

  context "with invalid gps point" do
    it "raises exception" do
      expect { locator.distance("aaa") }.to raise_error(ArgumentError, "GPS point is not valid")
    end
  end

  context "with valid arguments" do
    it "returns distance" do
      expect(locator.distance([54.080556, -6.361944 ])).to eq(82.82255431820599)
    end
  end
end

RSpec.describe GeoLocator, "#central_angle" do
  let(:locator) { GeoLocator.new([53.3381985, -6.2592576]) }

  context "with invalid gps point" do
    it "raises exception" do
      expect { locator.central_angle("aaa") }.to raise_error(ArgumentError, "GPS point is not valid")
    end
  end

  context "with valid arguments" do
    it "returns central angle" do
      expect(locator.central_angle([54.080556, -6.361944 ])).to eq(0.012999930045237166)
    end
  end
end

RSpec.describe GeoLocator, "#degrees_to_radians" do
  let(:locator) { GeoLocator.new([53.3381985, -6.2592576]) }

  context "with invalid angle" do
    it "raises exception" do
      expect { locator.degrees_to_radians("aaa") }.to raise_error(ArgumentError, "Angle is not valid number")
    end
  end

  context "with valid arguments" do
    it "converts degrees to radians" do
      expect(locator.degrees_to_radians(54.080556)).to eq(0.9438837635091746)
    end
  end
end
