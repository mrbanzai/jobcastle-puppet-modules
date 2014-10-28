class jobcastle::server {

    Exec { path => "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/kerberos/bin" }

    package { ['ntp', 'dstat']:
      ensure => latest
    }

    service { 'ntpd':
      enable => true,
      ensure => running,
      require => Package['ntp']
    }

}