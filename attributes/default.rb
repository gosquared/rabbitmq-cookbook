set[:rabbitmq][:version] = ""

# Allows you to overwrite the hostname
default[:rabbitmq][:hostname]  = (node[:host] or fqdn)
#
# The node name should be unique per erlang-node-and-machine combination. To
# run multiple nodes, see the clustering guide.
default[:rabbitmq][:nodename]  = "rabbit@#{node[:rabbitmq][:hostname]}"
#
# Defaults to the empty string - meaning bind to all network interfaces. This
# can be changed if you only want to bind to one network interface.
default[:rabbitmq][:address]   = false
#
default[:rabbitmq][:port]      = 5672

default[:rabbitmq][:pidpath]   = "/var/run"
default[:rabbitmq][:config]    = "/etc/rabbitmq"
default[:rabbitmq][:logdir]    = "/var/log/rabbitmq"
default[:rabbitmq][:basedir]   = "/var/lib/rabbitmq"
default[:rabbitmq][:mnesiadir] = "#{node[:rabbitmq][:basedir]}/mnesia"

# Flow Control
#
# The RabbitMQ server detects the total amount of RAM installed in the computer
# on startup and when rabbitmqctl set_vm_memory_high_watermark fraction is
# executed. By default, when the RabbitMQ server uses above 40% of the
# installed RAM, it raises a memory alarm and blocks all connections. Once the
# memory alarm has cleared (e.g. due to the server paging messages to disk or
# delivering them to clients) normal service resumes.  The default memory
# threshold is set to 40% of installed RAM. Note that this does not prevent the
# RabbitMQ server from using more than 40%, it is merely the point at which
# publishers are throttled. Erlang's garbage collector can, in the worst case,
# cause double the amount of memory to be used (by default, 80% of RAM). It is
# strongly recommended that OS swap or page files are enabled.
#
# DO NOT SET THE THRESHOLD ABOVE 0.5 OF AVAILABLE RAM
default[:rabbitmq][:vm_memory_high_watermark] = "0.4"
#
# RabbitMQ can also block producers when free disk space drops below a certain
# limit. This is a good idea since even transient messages can be paged to disk
# at any time, and running out of disk space can cause the server to crash. By
# default RabbitMQ will block producers when free disk space drops below 1GB.
# This will reduce but not completely eliminate the likelihood of a crash due
# to disk space being exhausted. A more conservative approach would be to set
# the limit to the same as the amount of memory installed on the system (see
# below).
#
# Global flow control will be triggered if the amount of free disk space drops
# below a configured limit. The free space of the drive or partition that the
# broker database uses will be monitored every minute to determine whether the
# alarm should be raised or cleared.
#
# The disk free space limit is configured with the disk_free_limit setting. By
# default 1GB is required to be free on the Mnesia partition
#
# It is also possible to set a free space limit relative to the RAM in the machine.
# This feels the most sensible option, hence it's the default for this cookbook.
default[:rabbitmq][:disk_free_limit] = "mem_relative, 1.0"

############################################################################# USERS #
#
# By default, we want the guest user disabled
# You really, really want to create your own user, with a password
# Leaving it around would be like leaving a MySQL root user with password 'root'
default[:rabbitmq][:users] = {}# {
  #:guest => {
    #:action => :delete
  #}
#}

########################################################################### PLUGINS #
#
# http://www.rabbitmq.com/man/rabbitmq-plugins.1.man.html
#
# RabbitMQ supports a variety of plugins. This page documents the plugins that
# ship with RabbitMQ 2.7.1.
#
# You can see a list of available plugins by running:
#     rabbitmq-plugins list
#
# To enable a plugin, add them as eg. :rabbitmq_management => :enable
default[:rabbitmq][:plugins] = {}
# To disable a plugin, add a :disable action, eg:
#
#   default[:rabbitmq][:plugins] = {
#     :rabbitmq_management => :disable
#   }

######################################################################## CLUSTERING #
#
# http://www.rabbitmq.com/clustering.html
#
# All data/state required for the operation of a RabbitMQ broker is replicated
# across all nodes, for reliability and scaling, with full ACID properties. An
# exception to this are message queues, which by default reside on the node that
# created them, though they are visible and reachable from all nodes.
#
# RabbitMQ clustering does not tolerate network partions well, so it should not
# be used over a WAN. The shovel or federation plugins are better solutions for
# connecting brokers across a WAN.
#
# The composition of a cluster can be altered dynamically. All RabbitMQ brokers
# start out as running on a single node. These nodes can be joined into
# clusters, and subsequently turned back into individual brokers again.
#
# A node can be a RAM node or a disk node. RAM nodes keep their state only in
# memory (with the exception of the persistent contents of durable queues which
# are still stored safely on disc). Disk nodes keep state in memory and on disk.
# As RAM nodes don't have to write to disk as much as disk nodes, they can
# perform better. Because state is replicated across all nodes in the cluster,
# it is sufficient to have just one disk node within a cluster, to store the
# state of the cluster safely. Beware, however, that RabbitMQ will not stop you
# from creating a cluster with only RAM nodes. Should you do this, and suffer a
# power failure to the entire cluster, the entire state of the cluster,
# including all messages, will be lost.
#
# Erlang nodes use a cookie to determine whether they are allowed to communicate
# with each other - for two nodes to be able to communicate they must have the
# same cookie.
#
# The cookie is just a string of alphanumeric characters. It can be as long or
# short as you like.
#
# Erlang will automatically create a random cookie file when the RabbitMQ server
# starts up. This will be typically located in /var/lib/rabbitmq/.erlang.cookie
# on Unix systems.
#
default[:rabbitmq][:cookie]         = false
default[:rabbitmq][:cluster_config] = "#{node[:rabbitmq][:config]}/rabbitmq_cluster.config"
default[:rabbitmq][:cluster_nodes]  = []
