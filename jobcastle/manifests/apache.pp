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
  $capistrano_root = undef,
  $capistrano_relative_docroot = undef
) {

  host { "${name}":
    ip => '127.0.0.1'
  }

  include apache
  include apache::mod::php

  if $for_capistrano {

    $actual_docroot = $docroot || "${capistrano_root}/current${capistrano_relative_docroot}"

    file { "${capistrano_root}":
      ensure => 'directory',
      owner => $docroot_owner,
      group => $docroot_group,
      recurse => true
    }

    file { "${capistrano_root}/releases":
      ensure => 'directory',
      owner => $docroot_owner,
      group => $docroot_group,
      recurse => true
    }

    mkdir_p { "${capistrano_root}/releases/initial{$capistrano_relative_docroot}":
      require => Package['httpd']
    }

    # Setup shared resources (which must be in the `shared`
    # folder) for Capistrano deployments

    file { "${capistrano_root}/shared":
      ensure => 'directory',
      owner => $docroot_owner,
      group => $docroot_group,
      require => File["${capistrano_root}"]
    }

    file { "${capistrano_root}/shared/db.ini":
      content => template('jobcastle/vhost/shared/db.ini.erb'),
      owner => $docroot_owner,
      group => $docroot_group,
      require => File["${capistrano_root}/shared"]
    }

    file { "${capistrano_root}/current":
      ensure => link,
      replace => false,
      target => 'releases/initial',
      require => Mkdir_p["${capistrano_root}/releases/initial${capistrano_relative_docroot}"]
    }

    file { "${capistrano_root}/releases_placeholder":
      path    => "${capistrano_root}/releases/initial${capistrano_relative_docroot}/index.html",
      content => '<h1>JobCastle Initial Install</h1>',
      require => Mkdir_p["${capistrano_root}/releases/initial${capistrano_relative_docroot}"]
    }

    apache::vhost { "${name}":
      priority            => $priority,
      port                => $port,
      docroot             => $actual_docroot,
      logroot             => $logroot,
      docroot_owner       => $docroot_owner,
      docroot_group       => $docroot_group,
      override           => 'All',
      environment_vars    => $environment_vars,
      require             => [ Host[$name], File["${capistrano_root}/current"] ],
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
      override           => 'All',
      environment_vars    => $environment_vars,
      require             => [ Host[$name] ],
      configure_firewall  => true,
    }

  }

}