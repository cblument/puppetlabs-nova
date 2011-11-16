require 'puppet/provider/parsedfile'

novaconf = "/etc/nova/nova.conf"

Puppet::Type.type(:nova_config).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => novaconf,
  :filetype => :flat
) do

  #confine :exists => novaconf
  text_line :comment, :match => /^\s*#/;
  text_line :blank, :match => /^\s*$/;

  record_line :parsed,
    :fields => %w{line}, 
    :match => /--(.*)/ ,
    :post_parse => proc { |hash|
      Puppet.debug("nova config line:#{hash[:line]} has been parsed") 
      if hash[:line] =~ /^\s*(\S+)\s*=\s*(\S+)\s*$/
        case $2
        when "true", true
          hash[:name] = $1
          hash[:value] = nil
        when "false", false
          hash[:name] = $1
          hash[:value] = nil
        else
          hash[:name] = $1
          hash[:value] = $2
        end
      elsif hash[:line] =~ /^\s*(\S+)\s*$/
        hash[:name] = $1
        hash[:value] = nil
      else
        raise Puppet::Error, "Invalid line: #{hash[:line]}"
      end
    }

  def self.to_line(hash)
    unless hash[:name].nil?
    if hash[:value].nil?
      "--#{hash[:name]}"
    elsif hash[:value] == true or hash[:value] == false
      "--#{hash[:name]}"
    elsif hash[:value] == 'true' or hash[:value] == 'false'
      "--#{hash[:name]}"
    else
      "--#{hash[:name]}=#{hash[:value]}"
    end
  end
  end

end
