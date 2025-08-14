require 'zip'

module RemoteInput
  class ZipExtractor
    def initialize(path)
      @path = path
    end

    def extract_first_file
      Zip::File.open(@path) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?

          entry.get_input_stream do |input|
            return yield(input)
          end
        end
      end
      nil
    end

    def extract_file(file_path)
      Zip::File.open(@path) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?
          next unless entry.name == file_path

          entry.get_input_stream do |input|
            return yield(input)
          end
        end
      end
      nil
    end

    def extract_files
      Zip::File.open(@path) do |zip_file|
        zip_file.each do |entry|
          next unless entry.file?

          entry.get_input_stream do |input|
            yield(input)
          end
        end
      end
    end
  end
end
