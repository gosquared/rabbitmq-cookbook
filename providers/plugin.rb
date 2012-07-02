action :enable do
  bash "Enabling RabbitMQ #{new_resource.name} plugin" do
    code "rabbitmq-plugins enable #{new_resource.name}"
    not_if { %x{rabbitmq-plugins list}.include? "[E] #{new_resource.name}" }
    notifies :restart, resources(:service => "rabbitmq"), :delayed
  end
end

action :disable do
  bash "Disabling RabbitMQ #{new_resource.name} plugin" do
    code "rabbitmq-plugins disable #{new_resource.name}"
    only_if { %x{rabbitmq-plugins list}.include? "[E] #{new_resource.name}" }
    notifies :restart, resources(:service => "rabbitmq"), :delayed
  end
end

def load_current_resource
  service "rabbitmq" do
    supports :start => true, :stop => true, :restart => true
    provider Chef::Provider::Service::Upstart
  end
end
