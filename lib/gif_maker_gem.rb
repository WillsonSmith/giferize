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

    def giferize(dir, frame_rate: 25, scale: longest_edge, flags: 'lanczos')
      filters = "fps=#{frame_rate},scale=#{scale}:-1:flags=#{flags}"

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
      File.delete(gif) if File.exist?(gif)

      movie.transcode(palette, options_for_palette)
      movie.transcode(gif, options_for_final)
      File.delete(palette) if File.exist?(palette)
    end

    private

    def longest_edge
      dimensions.max_by(&:last)[1]
    end
  end
end
