import 'utilities.rb'

class jobcastle::apache (
  $virtualhosts = {}
) {

  class { '::apache':
    manage_user => false
  }

  include ::apache::mod::php

  create_resources('jobcastle::apache::vhost', $virtualhosts)

}