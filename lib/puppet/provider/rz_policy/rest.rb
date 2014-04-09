begin
  require 'puppet/provider/razor'
rescue LoadError
  require_relative '../razor'
end

Puppet::Type.type(:rz_policy).provide(
  :rest,
  :parent => Puppet::Provider::Razor
) do

  def exists?
    get('policies', resource[:name])
  end

  def create

    args = {
      'name'          => resource[:name],
      'hostname'      => resource[:hostname],
      'root_password' => resource[:root_password],
      'max_count'     => resource[:max_count],
      'rule_number'   => resource[:rule_number],
      'tags'          => resource[:tags],
      'enabled'       => resource[:enabled]
    }
    [:repo, :installer, :broker].each do |attr|
      if resource[attr]
        args.merge!({attr.to_s => {'name' => resource[attr] }})
      end
    end

    post('create-policy', args)

  end

  def destroy
    raise(Exception, "Destroy is not implemented")
  end

  def tags
    #get('policies', resource[:name])['tags'].map{|x| x['name'] }
    # This property does not update it always thinks it is in sync.
    # I would have made it a parameters, but for some reason array_matching=>all
    # does not work for parameters
    resource[:tags]
  end

  def tags=(tags)
    raise(Exception, "Tags do not support updates")
  end

end
