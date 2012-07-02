Installs RabbitMQ from the official debian repository. Used in
production on Ubuntu 10.04.04 LTS.

## LRWP

Comes with the following providers:

### plugin

To enable specific plugins, add the following to your role:

```ruby
:rabbitmq => {
  :plugins => {
    :rabbitmq_management => :enable # or :disable
  }
}
```

### vhost

In any chef cookbook:

```ruby
rabbitmq_vhost "vhost-name" do
  action :add # default action
end

rabbitmq_vhost "vhost-to-delete" do
  action :delete
end
```

### user

Remove the guest user, add a new admin one:

In your chef role:

```ruby
:rabbitmq => {
  :guest => {
    :action => :delete
  },
  :admin => {
    :vhosts => ["/", "my-vhost"],
    :password => "secret",
    :tags => "administrator"
  }
}
```

## Clustering

Supports HA clustering via `cluster_nodes` array:

```ruby
:rabbitmq => {
  :cluster_nodes => %w[rabbitmq-1 rabbitmq-2]
}
```
