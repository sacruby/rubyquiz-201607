require 'benchmark'

TASK = ARGV[0]
DIR_NAME = ARGV[1]

filename_list = []
Dir[File.dirname(__FILE__) + "/#{DIR_NAME}/*.txt"].each { |f|
  filename_list << f
}

if TASK == "1"


    # let's get the distribution of words
    letters = ('a'..'z').to_a
    letter_word_counter = {}
    letters.each do |l|
      letter_word_counter[l] = 0
    end

    filename_list.each do |f|
      File.open(f).readlines.each do |line|
        # break line on whitespaces and ignore numbers
        words = line.gsub(/[^a-zA-Z ]/,'').gsub(/ +/,' ').downcase.split

        words.each do |w|
          letter_word_counter[w[0]] += 1
        end
      end
    end

    p "Counters of words starting with each letter: \n"
    p letter_word_counter



end

if TASK == "2"
  # top ten words
  top_ten_words = {}

  filename_list.each do |f|
    File.open(f).readlines.each do |line|
      # break line on whitespaces and ignore numbers
      words = line.gsub(/[^a-zA-Z ]/,'').gsub(/ +/,' ').downcase.split

      words.each do |w|
        if top_ten_words[w].nil?
          top_ten_words[w] = 1
        else
          top_ten_words[w] += 1
        end
      end

    end
  end

  top_ten_purged = top_ten_words.sort_by {|k, v| v}.reverse!
  p top_ten_purged[0..9]

end

if TASK == "3"
  char_counters = {}

  filename_list.each do |f|
    lines = File.open(f).readlines().join
    onlychars = lines.gsub!(/\W+/, '').downcase
    curr_char = 0
    last_char = 2
    while last_char < onlychars.length
      this_sequence = onlychars[curr_char..last_char]

      if char_counters[this_sequence].nil?
        char_counters[this_sequence] = 1
      else
        char_counters[this_sequence] = char_counters[this_sequence] + 1
      end

      curr_char = curr_char + 1
      last_char = last_char + 1

    end

  end


  top_three_char = char_counters.sort_by {|k, v| v}.reverse!
  p top_three_char[0..2]
end
