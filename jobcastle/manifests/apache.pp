import 'utilities.rb'

define jobcastle::apache (
  $port           = '80',
  $docroot        = undef,
  $logroot        = undef,
  $priority       = '10',
  $docroot_owner  = undef,
  $docroot_group  = undef,
  $environment_vars = {},
  $for_capistrano = false,
  $release_path   = undef,
  $current_release_path = undef
) {

  host { "${name}":
    ip => '127.0.0.1'
  }

  include apache
  include apache::mod::php

  if $for_capistrano {

    mkdir_p { "${release_path}/initial/public":
      require => Package['httpd']
    }

    file { "${current_release_path}":
      ensure => link,
      replace => false,
      path => "${current_release_path}",
      target => 'releases/initial',
      require => Mkdir_p["${release_path}/initial/public"]
    }

    file { "${release_path}_placeholder":
      path    => "${release_path}/initial/public/index.html",
      content => '<h1>JobCastle Initial Install</h1>',
      require => Mkdir_p["${release_path}/initial/public"]
    }

    apache::vhost { "${name}":
      priority            => $priority,
      port                => $port,
      docroot             => $docroot,
      logroot             => $logroot,
      docroot_owner       => $docroot_owner,
      docroot_group       => $docroot_group,
      overrides           => 'All',
      environment_vars    => $environment_vars,
      require             => [ Host[$name], File["${current_release_path}"] ],
      configure_firewall  => true,
    }

  } else {

    apache::vhost { "${name}":
      priority            => $priority,
      port                => $port,
      docroot             => $docroot,
      logroot             => $logroot,
      docroot_owner       => $docroot_owner,
      docroot_group       => $docroot_group,
      overrides           => 'All',
      environment_vars    => $environment_vars,
      require             => [ Host[$name] ],
      configure_firewall  => true,
    }

  }

}