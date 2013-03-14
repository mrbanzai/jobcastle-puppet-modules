class jobcastle::base {

    package { ['vim-enhanced', 'wget', 'curl', 'git']:
        ensure => latest
    }

    package { ['rubygems', 'rubygem-net-ssh', 'rubygem-net-scp', 'rubygem-net-sftp']:
        ensure => latest
    }
}