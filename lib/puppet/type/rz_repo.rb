require 'uri'

Puppet::Type.newtype(:rz_repo) do
  @doc = <<-EOT
    Manages razor Repo.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the repo."
    newvalues(/\w+/)
  end

  newparam(:iso_url) do
    desc 'The iso url address (file:// or http://)'

    munge do |value|
      case value
      when /^http/
        raise(PuppetError, "Invalid iso_url: #{value}") unless value =~ /^#{URI::regexp}$/
        value
      when /^\//
        "file://#{value}"
      else
        raise PuppetError, "Invalid iso_url: #{value}"
      end
    end
  end
end
