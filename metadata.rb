maintainer        "Gerhard Lazu"
maintainer_email  "gerhard@lazu.co.uk"
license           "Apache 2.0"
description       "Installs and configures RabbitMQ server"
version           "1.6.0"

recipe            "rabbitmq", "Install and configure RabbitMQ"
recipe            "rabbitmq::cluster", "Set up RabbitMQ clustering."

depends           "apt", ">= 1.3.0" # https://github.com/gchef/apt-cookbook

supports "debian"
supports "ubuntu"
