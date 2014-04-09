require 'rest_client'
require 'json'
require 'tempfile'

class Puppet::Provider::Razor < Puppet::Provider

  def get(type, name)
    begin
      response = RestClient.get(
        "http://localhost:8080/api/collections/#{type}/#{name}"
      )
    rescue RestClient::ResourceNotFound => e
      return false
    end
    if response.code == 200
      JSON.parse(response)
    else
      raise(Exception, "bad http code: #{response.code}:#{response.to_str}")
    end
  end

  def post(url, args)
    begin
      response = RestClient.post(
        "http://localhost:8080/api/commands/#{url}",
        args.to_json,
        {:content_type => :json, :accept => :json}
      )
    rescue Exception => e
      fail("Rest call failed: #{e.response}")
    end
    unless response.code == 202
      raise(Exception, "Bad response code: #{response.code}:#{response.to_str}")
    end
    response.code
  end

  # take a hash, and convert it into a temporary
  # json file that can be passed to the razor command
  def process_json_args(args = {})
    @tmp_json_file = Tempfile.new('razor_json')
    json = args.to_json
    @tmp_json_file.write(json)
    @tmp_json_file.close
    "--json #{@tmp_json_file.path}"
  end

end
