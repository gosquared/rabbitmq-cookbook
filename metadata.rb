maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures RabbitMQ server"
version           "1.5.0"

recipe            "rabbitmq", "Install and configure RabbitMQ"
recipe            "rabbitmq::cluster", "Set up RabbitMQ clustering."

depends           "apt", ">= 1.2.2" # https://github.com/gchef/apt-cookbook

supports "debian"
supports "ubuntu"
