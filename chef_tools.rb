require 'open3'

def parse_kls_line(line)
  parts = line.split(' ')
  parsed = {
      instance:  parts.shift,
      driver:  parts.shift,
      provisioner:  parts.shift,
      verifier: parts.shift,
      transport: parts.shift,
      last_action:  parts.join(' ')
  }

  parsed
end


def more_kls()
  output = `kitchen list`

  if(output.length > 0)
    lines = output.split("\n")
    header = lines.shift

    for line in lines do
      p = parse_kls_line(line)
      p[:instance_id] = ''
      p[:hostname] = ''
      fname = "./.kitchen/#{p[:instance]}.yml"

      if(File.exist?(fname))
        File.readlines(fname).each do |fline|
          if(fline.start_with?('server_id'))
            p[:instance_id] = fline.split(' ')[1]
          elsif(fline.start_with?('hostname'))
            p[:hostname] = fline.split(' ')[1]
          end
        end
      end

      puts "#{p[:instance].ljust(35)}  #{p[:last_action].ljust(15)} #{p[:instance_id].ljust(20)} #{p[:hostname]}"
    end

  end

end



def main()
  if(ARGV[0] == 'kls')
    more_kls
  end
end


main()
