#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Install Ruby latest stable and Rails
# https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-ubuntu-14-04-using-rvm
#
\curl -sSL https://get.rvm.io | bash -s stable --rails
source ~/.rvm/scripts/rvm
