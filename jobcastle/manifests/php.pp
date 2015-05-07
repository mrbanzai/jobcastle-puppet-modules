class jobcastle::php {

  class { 'mysql::bindings':
    php_enable => true
  }

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      package { 'epel-release':
        ensure => latest
      }
      package { 'remi-release':
        ensure => installed,
        provider => rpm,
        source => "http://rpms.famillecollet.com/enterprise/remi-release-$::operatingsystemmajrelease.rpm",
        require => Package['epel-release']
      }
      $package_reqs = [Package['remi-release']]
    }
    default: {
      $package_reqs = []
    }
  }

  # Yes, this is hardcoded for Fedora / Redhat packages
  package { ['php-tidy', 'php-mbstring', 'php-xml', 'php-pecl-ssh2', 'php-pecl-apcu']:
    ensure => latest,
    notify => Service['httpd'],
    require => $package_reqs
  }

  file { '/etc/php_browscap.ini':
    source => 'puppet:///modules/jobcastle/etc/php_browscap.ini',
    require => File['/etc/php.d/browscap.ini'],
    notify => Service['httpd']
  }

  # Also hardcoded to the Fedora / Redhat way
  file { '/etc/php.d/browscap.ini':
    source => 'puppet:///modules/jobcastle/etc/php.d/browscap.ini',
    notify => Service['httpd'],
    require => Class['apache::mod::php']
  }

}
