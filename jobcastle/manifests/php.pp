class jobcastle::php {

  class { 'mysql::php': }

  # Yes, this is hardcoded for Fedora / Redhat packages
  package { ['php-tidy', 'php-pecl-apc', 'php-mbstring']:
    ensure => latest
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