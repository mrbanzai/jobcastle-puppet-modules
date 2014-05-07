class jobcastle::server {

    Exec { path => "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/kerberos/bin" }

    # Equivalent to /usr/bin/mysql_secure_installation without providing or setting a password
    exec { 'mysql_secure_installation':
      command => '/usr/bin/mysql -uroot -e "DELETE FROM mysql.user WHERE User=\'\'; DELETE FROM mysql.user WHERE User=\'root\' AND Host NOT IN (\'localhost\', \'127.0.0.1\', \'::1\'); DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;" mysql'
    }

    Class['mysql'] -> Exec['mysql_secure_installation']

    package { ['ntp', 'dstat']:
      ensure => latest
    }

    service { 'ntpd':
      enable => true,
      ensure => running,
      require => Package['ntp']
    }

}