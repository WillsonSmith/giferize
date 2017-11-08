require "gif_maker_gem/version"
require 'streamio-ffmpeg'

module GifMakerGem
  class GifMaker
    attr_reader :movie
    def initialize(file)
      @movie = FFMPEG::Movie.new(file)
    end
    
    def path
      movie.path
    end

    def dimensions
      { 
        width: movie.width,
        height: movie.height,
      }
    end

    def giferize(dir, frame_rate: 25, scale: longest_edge, flags: 'lanczos', crop: {width: dimensions[:width], height: dimensions[:height], x: 0, y: 0})
      filters = [
        "fps=#{frame_rate}",
        "crop=#{crop[:width]}:#{crop[:height]}:#{crop[:x]}:#{crop[:y]}",
        "scale=#{scale}:-1:flags=#{flags}"
      ].join(',')

      gif = "#{dir}/movie.gif"
      palette = "#{dir}/palette.png"
      
      options_for_palette = {
        custom: %W(
          -v warning
          -vf #{filters},palettegen
        )
      }

      options_for_final = {
        custom: [
          "-v", "warning",
          "-i", "#{palette}",
          "-lavfi", "#{filters} [x]; [x][1:v] paletteuse"
        ]
      }

      movie.transcode(palette, options_for_palette)
      transcoded_gif = movie.transcode(gif, options_for_final)
      File.delete(palette) if File.exist?(palette)

      transcoded_gif
    end

    private

    def longest_edge
      dimensions.max_by(&:last)[1]
    end
  end
end
