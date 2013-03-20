class jobcastle::php {

  class { 'mysql::php': }

  package { 'php-tidy':
    ensure => latest
  }

  file { '/etc/php_browscap.ini':
    source => 'puppet:///modules/jobcastle/etc/php_browscap.ini',
    require => File['/etc/php.d/browscap.ini'],
    notify => Service['httpd']
  }

  file { '/etc/php.d/browscap.ini':
    source => 'puppet:///modules/jobcastle/etc/php.d/browscap.ini',
    notify => Service['httpd'],
    require => Class['apache::mod::php']
  }

}