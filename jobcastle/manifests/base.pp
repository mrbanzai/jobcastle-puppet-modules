class jobcastle::base {

    package { ['vim-enhanced', 'wget', 'curl']:
        ensure => latest
    }

}