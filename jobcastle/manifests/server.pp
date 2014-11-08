class jobcastle::server {

    Exec { path => "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/kerberos/bin" }

    yumrepo { 'fedora-archives':
      ensure => present,
      baseurl => 'http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/$releasever/Everything/$basearch/os/',
      gpgkey => 'http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/$releasever/Everything/$basearch/os/RPM-GPG-KEY-fedora-$basearch',
      enabled => true,
      gpgcheck => true,
      require => File['/etc/yum.repos.d']
    }

    file { '/etc/yum.repos.d':
      ensure => directory,
      recurse => true,
      purge => true
    }

    package { ['ntp', 'dstat']:
      ensure => latest
    }

    service { 'ntpd':
      enable => true,
      ensure => running,
      require => Package['ntp']
    }

}