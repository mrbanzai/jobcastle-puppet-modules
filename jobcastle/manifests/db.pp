class jobcastle::db(
  $username     = $jobcastle::params::db_user,
  $password     = $jobcastle::params::db_password,
  $schema       = $jobcastle::params::db_name
) {

  class { 'mysql': }
  class { 'mysql::server': }

  file { '/tmp/jobcastle_db_init.sql':
    source      => 'puppet:///modules/jobcastle/db-init.sql'
  }

  mysql::db { $schema:
    user        => $username,
    password    => $password,
    sql         => '/tmp/jobcastle_db_init.sql',
    require     => File['/tmp/jobcastle_db_init.sql']
  }

}