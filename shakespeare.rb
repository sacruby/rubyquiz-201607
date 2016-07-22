FILE_PATH = ARGV[1]

def run
  beginning = Time.now
  case ARGV[0]
  when 'alpha'
    Shakespeare.new(FILE_PATH).alpha
  when 'ten'
    Shakespeare.new(FILE_PATH).ten
  when 'three'
    Shakespeare.new(FILE_PATH).three
  end
  puts "TOOK #{Time.now - beginning} seconds to run"
end

# A thing
class Shakespeare
  def initialize(dir_path)
    @dir_path = dir_path
    @count_hash = Hash.new(0)
  end

  def ten
    process_file { |word| count_hash[word] += 1 }
    display_ten_results
  end

  def alpha
    process_file { |word| count_hash[word[0]] += 1 }
    display_alpha_results
  end

  def three
    Dir.foreach(dir_path) do |file|
      next if file =~ /\.$|\..$/
      file = File.expand_path("#{FILE_PATH}/#{file}")
      new_file = preprocess_file(file)
      start = 0
      finish = 2
      open(new_file) do |line|
        text = line.read
        text.downcase
        until finish == text.length - 1
          count_hash[text[start..finish]] += 1
          start += 1
          finish += 1
        end
      end
      File.delete(new_file)
    end
    display_ten_results
  end

  def process_file(&block)
    Dir.foreach(dir_path) do |file|
      next if file =~ /\.$|\..$/
      file = File.expand_path("#{FILE_PATH}/#{file}")
      count_file(file, &block)
    end
  end

  private

  attr_reader :count_hash, :dir_path

  def count_file(file_path, &block)
    open(file_path).each do |line|
      line.gsub!(/[^\w\s]|[0-9]/, '')
      line.downcase!
      line.split(' ').each(&block)
    end
  end

  def display_alpha_results
    arr = count_hash.to_a
    arr.sort! { |first, second| first.first <=> second.first }
    arr.each { |(letter, count)| puts "#{letter} | #{count}" }
  end

  def display_ten_results
    maxes = count_hash.max_by(10) { |_, count| count }
    puts maxes.map { |(word, _)| word }
      .sort
      .join(',')
  end

  def preprocess_file(file)
    output_file = "#{file[0..-5]}_formatted.txt"
    system("tr -d '[:space:][:punct:]' <#{file} >#{output_file}")
    output_file
  end
end

run
