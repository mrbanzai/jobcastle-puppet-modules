class jobcastle::base {

    package { ['vim-enhanced', 'wget', 'curl', 'git']:
        ensure => latest
    }

}