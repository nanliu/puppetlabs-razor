require 'puppet/type'

Puppet::Type.newtype(:rz_repo) do
  @doc = <<-EOT
    Manages razor Repo.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the repo."
    newvalues(/\w+/)
  end

  newparam(:url) do
    desc 'Url to use for repo'
  end

  newparam(:iso_url) do
    desc 'Location of iso to unpack for razor to serve'
  end

  validate do
    if self[:url] and self[:iso_url]
      raise(Exception, "Cannot specify both url and iso_url")
    end
  end

end
