# from http://stackoverflow.com/questions/4894434/ansi-escape-code-with-html-tags-in-ruby
def escape_to_html(data)
  { 1 => :nothing,
    2 => :nothing,
    4 => :nothing,
    5 => :nothing,
    7 => :nothing,
    30 => :black,
    31 => :red,
    32 => :green,
    33 => :yellow,
    34 => :blue,
    35 => :magenta,
    36 => :cyan,
    37 => :white,
    40 => :nothing,
    41 => :nothing,
    43 => :nothing,
    44 => :nothing,
    45 => :nothing,
    46 => :nothing,
    47 => :nothing,
  }.each do |key, value|
    if value != :nothing
      data.gsub!(/\e\[#{key}m/,"<span style=\"color:#{value}\">")
    else
      data.gsub!(/\e\[#{key}m/,"<b>")
    end
  end
  data.gsub!(/^\e\[0m/,'')
  data.gsub!(/\e\[0m/,'</b></span>')
end
