include_recipe "rabbitmq"

unless node[:rabbitmq][:cookie]
  Chef::Log.fatal("rabbitmq cookie must be set when configuring a cluster, otherwise nodes in this cluster won't be able to communicate with one another")
  raise
end

file "#{node[:rabbitmq][:basedir]}/.erlang.cookie" do
  owner "rabbitmq"
  group "rabbitmq"
  mode 0400
  content node[:rabbitmq][:cookie]
  notifies :restart, resources(:service => "rabbitmq"), :delayed
end
