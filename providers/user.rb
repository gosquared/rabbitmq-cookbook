action :add do
  bash "Adding RabbitMQ user '#{new_resource.user}'." do
    code %{
      for i in {0..10}; do
        if [ $(status rabbitmq | grep -c "start") > 0 ]; then
          rabbitmqctl add_user #{new_resource.user} #{new_resource.password}
          exit 0
        fi
        sleep 1
      done
    }
  end
end

action :delete do
  execute "rabbitmqctl delete_user #{new_resource.user}" do
    only_if "rabbitmqctl list_users | grep #{new_resource.user}"
    Chef::Log.info "Deleting RabbitMQ user '#{new_resource.user}'."
  end
end

action :set_permissions do
  new_resource.vhosts.each do |vhost|
    rabbitmq_vhost vhost

    bash "Setting RabbitMQ #{new_resource.user} user permissions for vhost #{vhost}" do
      code %{
        for i in {0..10}; do
          if [ $(status rabbitmq | grep -c "start") > 0 ]; then
            rabbitmqctl set_permissions -p #{vhost} #{new_resource.user} #{new_resource.permissions}
            exit 0
          fi
          sleep 1
        done
      }
    end
  end

  bash "Setting RabbitMQ #{new_resource.user} user tags" do
    code %{
      for i in {0..10}; do
        if [ $(status rabbitmq | grep -c "start") > 0 ]; then
          rabbitmqctl set_user_tags #{new_resource.user} #{new_resource.tags}
          exit 0
        fi
        sleep 1
      done
    }
  end
end

action :clear_permissions do
  new_resource.vhosts.each do |vhost|
    execute "rabbitmqctl clear_permissions -p #{vhost} #{new_resource.user}" do
      Chef::Log.info "Clearing RabbitMQ user permissions for '#{new_resource.user}' from vhost #{vhost}."
    end
  end
end
