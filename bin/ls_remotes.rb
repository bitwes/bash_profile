#!/usr/bin/env ruby
require 'pp'
BASE_URL = 'https://github.build.ge.com/'

def get_remote_name(url)
  start_pos = url.index(BASE_URL)
  to_return = nil

  if(start_pos != nil)
    start_pos +=  BASE_URL.size()
    end_pos = url.index('/', start_pos)
    to_return = url.slice(start_pos, end_pos - start_pos)
  end

  return to_return
end

def get_remotes()
  to_return = {}
  count = 1
  num_dirs = Dir.glob('./*/').size()
  Dir.glob('./*/').each() do |dir|
    next if dir == '.' or dir == '..'

    print "Processing directories...#{count}/#{num_dirs}\r" #some wizardry to print on same line
    count += 1

    if(File.directory?(dir) and File.exists?(dir + '/.git'))
      Dir.chdir dir
      remotes = `git remote -v`.split("\n")

      remotes.each() do |remote|
        if(remote.index('(fetch)'))
          parts = remote.split("\t")

          remote_name = get_remote_name(parts[1])
          if(remote_name != nil)
            index = parts[0] + ' - ' + remote_name
            if(to_return[index] == nil)
              to_return[index] = Array.new()
            end
            to_return[index].push(dir)
          else
            puts "\nDon't know what to do with #{remote} in dir #{dir}"
            next
          end
        end
      end

      Dir.chdir '..'
    end
  end

  print "\n"
  return to_return
end

def print_remotes(remotes)
  puts "\n\nRemotes"
  sorted_keys = remotes.keys.sort
  sorted_keys.each do |key|
    puts "#{key} (#{remotes[key].size()})"
    if(remotes[key].size() < 15)
      pp remotes[key]
    end
  end
end

def main()
  remotes = get_remotes()
  print_remotes(remotes)
end

main()
