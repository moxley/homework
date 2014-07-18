require 'json'

##
## How to use:
##
## echo '$4.99 TXT MESSAGING – 250 09/29 – 10/28 4.99' | ruby parse_charges.rb
##

pattern = /\$\d+\.\d+\s(.*)\s(\d\d\/\d\d – \d\d\/\d\d) (\d+\.\d+)/

while s = $stdin.gets
  m = s.match(pattern)
  data = {
    "feature"    => m[1],
    "date_range" => m[2],
    "price"     => m[3].to_f
  }
  puts JSON.pretty_generate(data)
end
