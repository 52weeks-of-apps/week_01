maintainer       "Example Com"
maintainer_email "ops@example.com"
license          "Apache 2.0"
description      "Installs/Configures scribble_mail"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
depends          %w( git passenger_apache2 rails )
