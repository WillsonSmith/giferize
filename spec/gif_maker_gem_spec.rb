require "spec_helper"

RSpec.describe GifMakerGem do
  it "has a version number" do
    expect(GifMakerGem::VERSION).not_to be nil
  end

  it "returns movie url" do
    movie = GifMakerGem::GifMaker.new(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4"
    )
    expect(movie.path).to eq("#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4")
  end

  it "returns movie height" do
    gif_maker = GifMakerGem::GifMaker.new(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4"
    )
    expect(gif_maker.dimensions[:height]).to eq(362)
    expect(gif_maker.dimensions[:width]).to eq(362)
  end

  it "transcodes movie to gif" do
    gif_maker = GifMakerGem::GifMaker.new(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/demo-recording.mp4"
    )
    output = gif_maker.giferize(
      "#{Pathname.new(File.dirname __dir__)}/spec/test_files/output"
    )

    expect(output.width).to eq(362)
    expect(output.height).to eq(362)
  end
end
