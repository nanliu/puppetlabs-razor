require 'puppet/provider/razor'

Puppet::Type.type(:rz_broker).provide(
  :rest,
  :parent => Puppet::Provider::Razor
) do

  def exists?
    get('brokers', resource[:name])
  end

  def create

    args = {
      'name'          => resource[:name],
      'configuration' => resource[:configuration],
      'broker-type'   => resource[:broker_type]
    }

    post('create-broker', args)

  end

  def destroy
    raise(Exception, "destroy is not implemented")
  end

end
