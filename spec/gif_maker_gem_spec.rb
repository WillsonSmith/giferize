require "spec_helper"

RSpec.describe Giferizer do

  before(:each) do
    @movie = Giferizer::Giferizer.new(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4"
    )
  end

  it "has a version number" do
    expect(Giferizer::VERSION).not_to be nil
  end

  it "returns movie url" do
    expect(@movie.path).to eq("#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4")
  end

  it "returns movie height" do
    expect(@movie.dimensions[:height]).to eq(362)
    expect(@movie.dimensions[:width]).to eq(362)
  end

  it "transcodes movie to gif" do
    output = @movie.giferize(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/output"
    )

    expect(output.width).to eq(362)
    expect(output.height).to eq(362)
  end

  it "scales gif" do
    output = @movie.giferize(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/output",
      scale: 100,
    )

    expect(output.width).to eq(100)
    expect(output.height).to eq(100)
  end
end
