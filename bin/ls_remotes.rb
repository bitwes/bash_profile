#!/usr/bin/env ruby
require 'pp'
require 'optparse'
$banner  = "\
Description:
------------
This will list all the remotes found in subdirectories of the current working directory.  \
This script only goes one level deep.  The remotes will be listed with a count next to them.  \
Use the -t option to specifiy a threshold.  Any directory with a remote found X number of times, where X is \
less than the value specified by -t, will be pritned.


Usage
-----
ls_remotes [options]\n\n"

BASE_URL = 'https://github.build.ge.com/'


# Parse command line options
def parse_options()
  options = { :threshold => 100 }

  optparse = OptionParser.new do|opts|
    opts.banner = $banner
    opts.on( '-t N', '--threshold VAL', Integer, "If a remote has <= theshold dirs, they will be listed. -1 to print all.  Default #{options[:threshold]}" ) do |value|
      options[:threshold] = value
    end

    opts.on( '-h', '--help', 'Display this screen' ) do
      puts opts
      exit
    end
  end
  optparse.parse!

  return options
rescue OptionParser::MissingArgument
  puts optparse
  raise
end


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


def print_remotes(remotes, threshold)
  puts "\n\nRemotes"
  sorted_keys = remotes.keys.sort
  sorted_keys.each do |key|
    puts "#{key} (#{remotes[key].size()})"
    if(remotes[key].size() <= threshold or threshold == -1)
      remotes[key].each do |value|
        puts "  * #{value}"
      end
    end
  end
end


def main()
  options = parse_options()
  remotes = get_remotes()
  print_remotes(remotes, options[:threshold])
rescue OptionParser::MissingArgument
  puts $!
end

main()