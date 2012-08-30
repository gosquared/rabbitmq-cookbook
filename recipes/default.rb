unless node[:rabbitmq][:deb]
  # If we're not installing from deb package,
  # use the RabbitMQ repository instead of Ubuntu or Debian's
  # because there are very useful features in the newer versions
  apt_repository "rabbitmq" do
    uri "http://www.rabbitmq.com/debian/"
    key "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
    distributions %w[testing]
    action :add
  end

  apt_package "rabbitmq-server" do
    version "#{node[:rabbitmq][:version]}*"
    options "--force-yes"
    action [:add, :hold]
    keep_conf true
    service "rabbitmq"
  end
end

service "rabbitmq" do
  supports :start => true, :stop => true, :restart => true
  provider Chef::Provider::Service::Upstart
end

directory node[:rabbitmq][:config] do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "#{node[:rabbitmq][:config]}/rabbitmq.config" do
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rabbitmq")
end

template "#{node[:rabbitmq][:config]}/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "rabbitmq"), :delayed
end

directory node[:rabbitmq][:mnesiadir] do
  owner "rabbitmq"
  group "rabbitmq"
  mode 0775
  recursive true
end

# Stop & Disable the default rabbitmq-server
#
bash "Stop & Disable the default rabbitmq-server init script" do
  code %{
    DAEMON=/etc/init.d/rabbitmq-server
    if [ -x $DAEMON ]; then
      pkill -u rabbitmq
      rm #{node.rabbitmq.logdir}/startup* #{node.rabbitmq.logdir}/shutdown*
      mv $DAEMON $DAEMON.dis
      chmod 600 $DAEMON.dis
    fi
  }
end

# New, upstart template
#
template "/etc/init/rabbitmq.conf" do
  cookbook "rabbitmq"
  source "rabbitmq.upstart.erb"
  mode 0644
  backup false
  notifies :restart, resources(:service => "rabbitmq"), :delayed
end

# RabbitMQ plugins
#
node[:rabbitmq][:plugins].each do |plugin, status|
  rabbitmq_plugin plugin do
    action status
  end
end

# RabbitMQ users
#
node[:rabbitmq][:users].each do |user, user_properties|
  rabbitmq_user user do
    password user_properties[:password]
    vhosts user_properties[:vhosts]
    permissions user_properties[:permissions]
    tags user_properties[:tags]
    action user_properties[:action] || [:add, :set_permissions]
  end
end

# Start and enable RabbitMQ
#
service "rabbitmq" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end
