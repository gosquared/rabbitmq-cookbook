action :add do
  bash "Adding RabbitMQ #{new_resource.name}" do
    code %{
      for i in {0..10}; do
        if [ $(status rabbitmq | grep -c "start") > 0 ]; then
          rabbitmqctl add_vhost #{new_resource.name}
          exit 0
        fi
        sleep 1
      done
    }
  end
end

action :delete do
  bash "Deleting RabbitMQ #{new_resource.name}" do
    code %{
      for i in {0..10}; do
        if [ $(status rabbitmq | grep -c "start") > 0 ]; then
          rabbitmqctl delete_vhost #{new_resource.name}
          exit 0
        fi
        sleep 1
      done
    }
  end
end
